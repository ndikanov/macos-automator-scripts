#!/bin/zsh

if [[ -z "$1" || "$1" =~ ^[[:space:]]*$ ]]; then
  input_text=$(pbpaste)
else
  input_text="$1"
fi

regex="^https:\/\/([a-zA-Z0-9-]+)\.atlassian\.net\/browse\/([a-zA-Z0-9-]+)$"

if [[ $input_text =~ $regex ]]; then
  subdomain="${match[1]}"
  issue_key="${match[2]}"
else
  echo "Error: Invalid URL format. Input text: $input_text" >&2
  exit 1
fi

# Retrieving a Jira Token from Keychain
BASE64_JIRA_TOKEN=$(security find-generic-password -a "JiraAccount" -s "JiraApiAuthString" -w)

if [[ -z "$BASE64_JIRA_TOKEN" ]]; then
  echo "Warning: Failed to retrieve the API key from Keychain." >&2
fi

response=$(curl -s -X GET \
  -H "Authorization: Basic $BASE64_JIRA_TOKEN" \
  -H "Content-Type: application/json" \
  "https://$subdomain.atlassian.net/rest/api/3/issue/$issue_key")

if [[ $? -ne 0 ]]; then
  echo "Warning: Failed to fetch issue from Jira API." >&2
fi

JQ_PATH="/opt/homebrew/bin/jq"

if [[ ! -x "$JQ_PATH" ]]; then
  echo "Warning: jq is not installed at $JQ_PATH" >&2
fi

summary=$(echo "$response" | $JQ_PATH -r '.fields.summary')

if [[ $? -ne 0 ]]; then
  echo "Warning: Failed to parse JSON response." >&2
fi

issue_url="https://$subdomain.atlassian.net/browse/$issue_key"

if [[ -z $summary || $summary == "null" ]]; then
  output="[$issue_key]($issue_url)"
else 
  output="[$issue_key $summary]($issue_url)"
fi

echo $output