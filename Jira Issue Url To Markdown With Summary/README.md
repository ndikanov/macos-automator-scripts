# Jira Issue URL to Markdown with Summary
This script is designed to extract the issue key from a Jira issue URL, retrieve the issue summary via the Jira API, and format the output as a Markdown link with the issue key and summary.

## Features

- Handles both selected text or clipboard content for input. To use clipboard content, select any whitespace ([#1](https://github.com/ndikanov/macos-automator-scripts/issues/1)).
- Supports Jira issue URLs in the format: `https://{subdomain}.atlassian.net/browse/{issue-key}`.
- Extracts the issue key and fetches the summary using the Jira REST API.
- Outputs the result as a Markdown link: `[issue-key summary](url)` or `[issue-key](url)` if the summary couldn’t be retrieved.
- Uses macOS Keychain to securely retrieve the Jira API key.

## Example Output

If the issue summary is retrieved successfully, the output will look like this:

```markdown
[KEY-2345 Implement new feature](https://yoursubdomainhere.atlassian.net/browse/KEY-2345)
```
Otherwise:
```markdown
[KEY-2345](https://yoursubdomainhere.atlassian.net/browse/KEY-2345)
```

## Configuring Data for Jira Connection

1. [Generate Jira API Token](https://id.atlassian.com/manage-profile/security/api-tokens)
2. Open your terminal and run the following command to generate a Base64-encoded authentication string:

    ```bash
    echo -n "your-email@example.com:your-api-token" | base64
    ```

3. Copy the output from the previous command and replace `your-base64-string` in the following command with your actual Base64-encoded string. Then, run this command in your Terminal to store the API key in your Keychain:

    ```bash
    security add-generic-password -a "JiraAccount" -s "JiraApiAuthString" -w "your-base64-string"
    ```
