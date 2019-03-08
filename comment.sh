#!/bin/bash

PR_NR=$TRAVIS_PULL_REQUEST

function performQuery() {
    NEW_QUERY_STR="{\"query\":\"$1\"}"
    echo $NEW_QUERY_STR
    curl -s -H "Authorization: bearer $COMMENT_TOKEN" -X POST -d "$NEW_QUERY_STR" https://api.github.com/graphql
}

RESULT=$(performQuery "{repository(owner:\\\"ZeusWPI\\\",name:\\\"zeus.ugent.be\\\"){pullRequest(number:$PR_NR){id,comments(first:10){nodes{author{login}}}}}}")

if [ $? -ne 0 ]; then
    echo "QUERY FAILED, RESULT: $RESULT"
    exit 1
fi

# Get the GraphQL ID
PR_ID=$(echo $RESULT | sed 's/.*"id":"\([^"]*\)".*/\1/')

if [[ $RESULT == *"zeuswpi-bot"* ]]; then
    echo "User has already commented"
else
    ADD_COMMENT_STR="mutation{addComment(input:{subjectId:\\\"$PR_ID\\\",body:\\\"Check out the preview on https://$PR_NR.pr.zeus.gent/\\\"}){clientMutationId}}"
    performQuery "$ADD_COMMENT_STR"
fi


