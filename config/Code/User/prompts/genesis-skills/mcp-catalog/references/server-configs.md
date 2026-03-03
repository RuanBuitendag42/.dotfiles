# MCP Server Configurations

Ready-to-paste configurations for common MCP servers. Copy the relevant block into your `mcp.json` `servers` object.

## Web & Fetch

### Fetch (Web Pages & APIs)
```json
"fetch": {
  "command": "uvx",
  "args": ["mcp-server-fetch"],
  "env": {
    "PYTHONIOENCODING": "utf-8"
  }
}
```

## Documentation

### Context7 (Library Documentation)
```json
"context7": {
  "type": "stdio",
  "command": "npx",
  "args": ["@upstash/context7-mcp@latest"],
  "env": {
    "CONTEXT7_API_KEY": "${input:context7ApiKey}"
  }
}
```

## Source Control

### GitHub (Official Copilot MCP)
```json
"github": {
  "type": "http",
  "url": "https://api.githubcopilot.com/mcp/"
}
```

### GitLab
```json
"gitlab": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-gitlab"],
  "env": {
    "GITLAB_TOKEN": "${input:gitlabToken}",
    "GITLAB_URL": "https://gitlab.com"
  }
}
```

## Databases

### PostgreSQL
```json
"postgres": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-postgres"],
  "env": {
    "DATABASE_URL": "${input:databaseUrl}"
  }
}
```

### SQLite
```json
"sqlite": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-sqlite", "${input:sqlitePath}"]
}
```

### Redis
```json
"redis": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-redis"],
  "env": {
    "REDIS_URL": "${input:redisUrl}"
  }
}
```

### Neo4j (Graph Database)
```json
"neo4j": {
  "command": "npx",
  "args": ["-y", "@neo4j/mcp-neo4j"],
  "env": {
    "NEO4J_URI": "${input:neo4jUri}",
    "NEO4J_USERNAME": "${input:neo4jUser}",
    "NEO4J_PASSWORD": "${input:neo4jPassword}"
  }
}
```

## Infrastructure

### Docker
```json
"docker": {
  "command": "docker",
  "args": ["run", "-i", "--rm", "mcp/docker"]
}
```

### Terraform
```json
"terraform": {
  "command": "npx",
  "args": ["-y", "@hashicorp/terraform-mcp-server"],
  "env": {
    "TF_TOKEN": "${input:terraformToken}"
  }
}
```

### Kubernetes
```json
"kubernetes": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-kubernetes"],
  "env": {
    "KUBECONFIG": "${input:kubeconfig}"
  }
}
```

## Filesystem

### Filesystem (Local)
```json
"filesystem": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-filesystem", "${workspaceFolder}"]
}
```

## Browser & Testing

### Playwright (Browser Automation)
```json
"playwright": {
  "command": "npx",
  "args": ["-y", "@playwright/mcp-server"]
}
```

## Monitoring & Observability

### Dynatrace
```json
"dynatrace": {
  "command": "npx",
  "args": ["-y", "@dynatrace/mcp-server"],
  "env": {
    "DT_ENVIRONMENT_URL": "${input:dtEnvironmentUrl}",
    "DT_API_TOKEN": "${input:dtApiToken}"
  }
}
```

### PagerDuty
```json
"pagerduty": {
  "command": "npx",
  "args": ["-y", "@pagerduty/mcp-server"],
  "env": {
    "PAGERDUTY_API_KEY": "${input:pagerdutyKey}"
  }
}
```

## Analytics

### Amplitude
```json
"amplitude": {
  "command": "npx",
  "args": ["-y", "@amplitude/mcp-server"],
  "env": {
    "AMPLITUDE_API_KEY": "${input:amplitudeKey}"
  }
}
```

## Feature Flags

### LaunchDarkly
```json
"launchdarkly": {
  "command": "npx",
  "args": ["-y", "@launchdarkly/mcp-server"],
  "env": {
    "LD_SDK_KEY": "${input:ldSdkKey}"
  }
}
```

## Deployment

### Octopus Deploy
```json
"octopus": {
  "command": "npx",
  "args": ["-y", "@octopusdeploy/mcp-server"],
  "env": {
    "OCTOPUS_URL": "${input:octopusUrl}",
    "OCTOPUS_API_KEY": "${input:octopusApiKey}"
  }
}
```

## Search & Knowledge

### Elastic
```json
"elastic": {
  "command": "npx",
  "args": ["-y", "@elastic/mcp-server"],
  "env": {
    "ELASTICSEARCH_URL": "${input:elasticUrl}",
    "ELASTICSEARCH_API_KEY": "${input:elasticApiKey}"
  }
}
```

## Awesome-Copilot (Meta)

### Awesome-Copilot MCP Server
```json
"awesome-copilot": {
  "command": "docker",
  "args": ["run", "-i", "--rm", "ghcr.io/github/awesome-copilot-mcp"]
}
```
