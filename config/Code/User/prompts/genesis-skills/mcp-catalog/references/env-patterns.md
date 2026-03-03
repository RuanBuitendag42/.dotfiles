# Environment Variable Patterns

How to handle secrets, configuration, and dynamic values in MCP server configurations.

## The `${input:variableName}` Pattern

VS Code prompts the user at runtime for values marked with `${input:variableName}`.

### Defining Inputs

In `mcp.json`, add an `inputs` array:

```json
{
  "servers": {
    "my-server": {
      "command": "npx",
      "args": ["-y", "my-server"],
      "env": {
        "API_KEY": "${input:myApiKey}",
        "API_URL": "${input:myApiUrl}"
      }
    }
  },
  "inputs": [
    {
      "id": "myApiKey",
      "type": "promptString",
      "description": "API key for My Server",
      "password": true
    },
    {
      "id": "myApiUrl",
      "type": "promptString",
      "description": "API URL for My Server",
      "password": false
    }
  ]
}
```

### Input Types

| Type | Behavior |
|------|----------|
| `promptString` | Text input dialog |
| `password: true` | Masked text input (for secrets) |
| `password: false` | Normal text input (for URLs, paths) |

## Environment Variable Sources

### 1. Hardcoded (Non-Secret)
```json
"env": {
  "NODE_ENV": "production",
  "LOG_LEVEL": "info"
}
```

### 2. User Input (Secrets)
```json
"env": {
  "API_KEY": "${input:apiKey}"
}
```

### 3. Workspace Variables
```json
"args": ["${workspaceFolder}/data"]
```

### 4. Agent-Level Secrets (Org/Enterprise)
```yaml
mcp-servers:
  my-server:
    env:
      API_KEY: ${{ secrets.MY_API_KEY }}
```

## Security Best Practices

1. **NEVER hardcode secrets** in `mcp.json` — always use `${input:}` or `${{ secrets. }}`
2. **Use `password: true`** for all secrets, tokens, API keys
3. **Commit `mcp.json`** to version control (it contains no secrets when using `${input:}`)
4. **Don't create `.env` files** for MCP — use the input mechanism instead
5. **Rotate secrets regularly** — input values are not cached permanently
6. **Use read-only tokens** where possible — limit blast radius
7. **Document required inputs** — add comments or a README explaining what each input is for

## Common Patterns

### Database Connection String
```json
"env": {
  "DATABASE_URL": "${input:databaseUrl}"
}
```
Input: `postgresql://user:pass@host:5432/dbname`

### API with Base URL + Token
```json
"env": {
  "API_BASE_URL": "${input:apiBaseUrl}",
  "API_TOKEN": "${input:apiToken}"
}
```

### Cloud Provider Authentication
```json
"env": {
  "AWS_ACCESS_KEY_ID": "${input:awsAccessKey}",
  "AWS_SECRET_ACCESS_KEY": "${input:awsSecretKey}",
  "AWS_REGION": "us-east-1"
}
```
