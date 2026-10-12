import json
from openai import OpenAI
import os
import sqlite3
from time import time

print("Running db_bot.py!")

fdir = os.path.dirname(__file__)
def getPath(fname):
    return os.path.join(fdir, fname)

# SQLITE
sqliteDbPath = getPath("hikes.sqlite")
setupSqlPath = getPath("setup.sql")
setupSqlDataPath = getPath("setupData.sql")

# Erase previous db
if os.path.exists(sqliteDbPath):
    os.remove(sqliteDbPath)

# create new db
sqliteCon = sqlite3.connect(sqliteDbPath) 
sqliteCursor = sqliteCon.cursor()

# read in setup files
with (
        open(setupSqlPath) as setupSqlFile,
        open(setupSqlDataPath) as setupSqlDataFile
    ):

    setupSqlScript = setupSqlFile.read()
    setupSQlDataScript = setupSqlDataFile.read()

# execute setup files
sqliteCursor.executescript(setupSqlScript) # setup tables and keys
sqliteCursor.executescript(setupSQlDataScript) # setup tables and keys

def runSql(query):
    result = sqliteCursor.execute(query).fetchall()
    return result

# OPENAI
configPath = getPath("config.json")
print(configPath)
with open(configPath) as configFile:
    config = json.load(configFile)

openAiClient = OpenAI(api_key = config["openaiKey"])
openAiClient.models.list() # check if the key is valid (update in config.json)
chosen_model = "gpt-4o"

def getChatGptResponse(content):
    stream = openAiClient.chat.completions.create(
        model=chosen_model,
        messages=[{"role": "user", "content": content}],
        stream=True,
    )

    responseList = []
    for chunk in stream:
        if chunk.choices[0].delta.content is not None:
            responseList.append(chunk.choices[0].delta.content)

    result = "".join(responseList)
    return result


# strategies
from datetime import date
commonSqlOnlyRequest = f" Today's date is {date.today()}. Give me a sqlite select statement that answers the question. Only respond with sqlite syntax. If there is an error do not explain it!"

strategies = {
    "zero_shot": setupSqlScript + commonSqlOnlyRequest,

    "single_domain_double_shot": (setupSqlScript +
        " Which hikers have never been on a hike? " +
        "\nSELECT h.hiker_id, h.name\nFROM hiker h\nLEFT JOIN hike_participant hp ON h.hiker_id = hp.hiker_id\nWHERE hp.hike_id IS NULL;\n " +
        commonSqlOnlyRequest),

    "cross_domain": (
        "Here is an example from a different database. Schema: "
        "CREATE TABLE person (person_id INTEGER PRIMARY KEY, name TEXT); "
        "CREATE TABLE phone (phone_id INTEGER PRIMARY KEY, person_id INTEGER, can_recieve_sms INTEGER); "
        "Question: Who doesn't have a way for us to text them? "
        "\nSELECT p.person_id, p.name\nFROM person p\nLEFT JOIN phone ph ON p.person_id = ph.person_id AND ph.can_recieve_sms = 1\nWHERE ph.phone_id IS NULL;\n"
        "Now here is my actual database: " + setupSqlScript + commonSqlOnlyRequest),
}

questions = [
    "Who has gone on the most hikes?",
    "Which trails in Zion are rated strenuous?",
    "What is the average rating for each park?",
    "Which hikes happened in the rain?",
    "Did anyone bring rain gear on a rainy hike?",
    "Whose gear went on a hike they didn't go on?",
    "Did anyone see a bear, and did they have bear spray?",
    "What gear has never been used on a hike?",
    "What is the hardest trail?",
    "Which trail has nobody hiked yet?",
]


# use the markdown for the sql syntax to find the SQL query
def sanitizeForJustSql(value):
    gptStartSqlMarker = "```"
    gptEndSqlMarker = "```"
    if gptStartSqlMarker in value:
        # Split at the first ``` and take everything after it
        value = value.split(gptStartSqlMarker, 1)[1]
        # Find the newline after the language identifier (sql, sqlite, etc.)
        newline_index = value.find("\n")
        if newline_index != -1:
            value = value[newline_index + 1:]
    if gptEndSqlMarker in value:
        # Split at the closing ``` and take everything before it
        value = value.split(gptEndSqlMarker, 1)[0]

    return value.strip()

allResults = {q: [] for q in questions}   # question -> results from each strategy

for strategy in strategies:
    responses = {"strategy": strategy, "prompt_prefix": strategies[strategy]}
    questionResults = []
    print(f"\n=== {strategy} ===")
    for question in questions:
        error = "None"
        sqlSyntaxResponse = ""
        queryRawResponse = ""
        friendlyResponse = ""
        try:
            getSqlFromQuestionEngineeredPrompt = strategies[strategy] + " " + question
            sqlSyntaxResponse = getChatGptResponse(getSqlFromQuestionEngineeredPrompt)
            sqlSyntaxResponse = sanitizeForJustSql(sqlSyntaxResponse)
            queryRawResponse = str(runSql(sqlSyntaxResponse))

            # TODO this prompt is insufficient. ChatGPT doesn't have all the context that it needs.
            # What context would help the friendly response be more successful? Can you fix it?
            friendlyResultsPrompt = (
                "I asked: \"" + question + "\"\n"
                "This SQL was run: " + sqlSyntaxResponse + "\n"
                "It returned these rows: " + queryRawResponse + "\n"
                "Answer my question in one or two friendly sentences using only this data. "
                "If the result is empty, say so plainly."
            )
            friendlyResponse = getChatGptResponse(friendlyResultsPrompt)
        except Exception as err:
            error = str(err)

        questionResults.append({
            "question": question,
            "sql": sqlSyntaxResponse,
            "queryRawResponse": queryRawResponse,
            "friendlyResponse": friendlyResponse,
            "error": error
        })
        allResults[question].append({
            "strategy": strategy,
            "sql": sqlSyntaxResponse,
            "rows": queryRawResponse,
            "answer": friendlyResponse,
            "error": error,
        })
        status = "OK   " if error == "None" else "ERROR"
        print(f"  [{status}] {question}")

    responses["questionResults"] = questionResults

    with open(getPath(f"response_{strategy}_{time()}.json"), "w") as outFile:
        json.dump(responses, outFile, indent = 2)


# readable report grouped by question, so strategies can be compared side by side
reportPath = getPath("results.md")
with open(reportPath, "w", encoding="utf-8") as f:
    f.write(f"# Hike Tracker Results\n\nModel: `{chosen_model}`\n\n")
    for i, (question, runs) in enumerate(allResults.items(), start=1):
        f.write(f"## {i}. {question}\n\n")
        for r in runs:
            f.write(f"### {r['strategy']}\n\n")
            f.write(f"```sql\n{r['sql']}\n```\n\n")
            if r["error"] != "None":
                f.write(f"**Error:** `{r['error']}`\n\n")
            else:
                f.write(f"**Rows:** `{r['rows']}`\n\n")
                f.write(f"**Answer:** {r['answer']}\n\n")
        f.write("---\n\n")

print(f"\nReport written to {reportPath}")

sqliteCursor.close()
sqliteCon.close()
print("Done!")