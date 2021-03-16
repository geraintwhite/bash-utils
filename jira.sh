#!/bin/bash

JIRA_URL="https://jira.example.com"
CURL="curl -k -sS"

jiraAuth() {
  CURL="$CURL -u $1:$2"
}

getSummary() {
  while read -r ID; do
    SUMMARY=$($CURL "$JIRA_URL/rest/api/2/issue/$ID?fields=summary" | jq -r '.fields.summary')
    echo "[$ID] - $SUMMARY"
  done
}

leaveComment() {
  COMMENT="$1"

  while read -r ID; do
    $CURL -X POST \
      -H "Content-Type: application/json" \
      -d '{ "body": "'"$COMMENT"'" }' \
      "$JIRA_URL/rest/api/2/issue/$ID/comment" > /dev/null

    echo "$ID"
  done
}

performTransition() {
  TRANSITION="$1"
  COMMENT="$2"

  UPDATE_BODY='"update": { "comment": [{ "add": { "body": "'"$COMMENT"'" }}] }'
  TRANSITION_BODY='"transition": { "id": "'"$TRANSITION"'" }'

  BODY=$([[ -z "$COMMENT" ]] && echo "{ $TRANSITION_BODY }" || echo "{ $UPDATE_BODY, $TRANSITION_BODY }")

  while read -r ID; do
    $CURL -X POST \
      -H "Content-Type: application/json" \
      -d "$BODY" \
      "$JIRA_URL/rest/api/2/issue/$ID/transitions" > /dev/null

    echo "$ID"
  done
}

#
# Example Usage
#
# jiraAuth "$JIRA_USERNAME" "$JIRA_PASSWORD"
#
# echo "EXMP-1234" | getSummary
#
# echo "EXMP-1234" | leaveComment "Released in version 1.2.3"
#
# echo "EXMP-1234" | performTransition 731 "Released in version 1.2.3"
#
