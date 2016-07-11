#!/usr/bin/env python

import sqlite3
import os

print("how many words did you write?")
words = input("words: ")

if not words:
    words = 0

if words.__class__ is not int:
    words = int(words)

print("\ndid you meet your goal?")
goal = input("goal ({unmet}/met): ")

if not goal:
    goal = "\"unmet\""
else:
    goal = "\"{}\"".format(goal)

print("\nwhat project was this for?")
project = input("project ({general}): ")

if not project:
    project = "\"general\""
else:
    project = "\"{}\"".format(project)

print("\nany comments?")
comments = input("comments: ")

if not comments:
    comments = "\"\""
else:
    comments = "\"{}\"".format(comments)

print("words: {}".format(words))
print("goal: {}".format(goal))
print("project: {}".format(project))
print("comments: {}".format(comments))

print("\npress enter if satisfied, C-c otherwise")
satisfied = input("enter>")

db = sqlite3.connect(os.path.expanduser("~/journal/tracking.db"))

statement = "INSERT INTO {table_name} ({column_spec}) VALUES ({table_spec})".format(
    table_name = "writing",
    column_spec = "words, goal, project, comments",
    table_spec = ",".join([str(words), goal, project, comments])
)

db.execute(statement)
db.commit()
db.close()
