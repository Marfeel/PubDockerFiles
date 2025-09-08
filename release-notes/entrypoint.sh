#!/bin/bash
export CLAUDE_CODE_OAUTH_TOKEN="$CLAUDE_CODE_OAUTH_TOKEN"

curl -s GET "https://community.marfeel.com/posts/270736.json" \
        -H "Api-Key: $COMMUNITY_TOKEN" \
        -H "Api-Username: system" \
    | jq -r .raw \
    > /etc/.claude/commands/release-notes.md

PROMPT="run the /release-notes command, it is a custom command placed in /etc/.claude/commands/"

jq -n \
    --arg title "$(git remote get-url origin | xargs basename -s .git)" \
    --rawfile raw <(claude --dangerously-skip-permissions --allowedTools "/release-notes" -p "$PROMPT") \
    --argjson category 925 \
    '{title: $title, raw: $raw, category: $category}' \
| curl -s --fail -o /dev/null -w "%{http_code}\n" \
    -X POST https://community.marfeel.com/posts.json \
    -H "Content-Type: application/json" \
    -H "Api-Key: $COMMUNITY_TOKEN" \
    -H "Api-Username: system" \
    -d @-
