---
name: codebase-analysis
description: "Comprehensive codebase analysis methodology covering project structure, architecture patterns, dependencies, DevOps, testing, and documentation. Use when analyzing a codebase to understand its shape before generating implementation teams."
---

# Codebase Analysis

You have expert knowledge of how to perform comprehensive codebase analysis across 6 dimensions: structure, architecture, dependencies, DevOps, testing, and documentation. Follow this methodology to produce a complete **Codebase Profile** that informs agent team generation.

---

## 1. Analysis Overview

Codebase analysis follows a **3-phase approach**:

### Phase 1: Quick Reconnaissance (Always First)

Spend minimal time to orient yourself before going deep:

1. **List top-level directories** — `list_dir` on the repo root
2. **Find key files** — package.json, pom.xml, requirements.txt, go.mod, Cargo.toml, Makefile, Dockerfile
3. **Identify the stack** — Language(s), framework(s), runtime(s)
4. **Check README** — Quick scan for project description and setup instructions

> **Goal:** Within 30 seconds of tool calls, know what kind of project this is.

### Phase 2: Deep Analysis (6 Dimensions in Parallel)

Once oriented, analyze all 6 dimensions. These are independent and can run in parallel:

| Dimension | Section | Key Question |
|-----------|---------|--------------|
| Structure | §2 | How is the code organized? |
| Architecture | §3 | What patterns and layers exist? |
| Dependencies | §4 | What frameworks and libraries are used? |
| DevOps | §5 | How is it built, tested, and deployed? |
| Testing | §6 | What test strategy is in place? |
| Documentation | §7 | What context is available? |

### Phase 3: Consolidation into Codebase Profile

Merge findings into the standardized **Codebase Profile** template (§8). This profile becomes the input for team generation decisions.

---

## 2. Structure Analysis

Analyze how source code is physically organized.

### What to Look For

| Aspect | Details |
|--------|---------|
| **Top-level dirs** | src/, lib/, app/, packages/, services/, cmd/ |
| **Module boundaries** | Where one concern ends and another begins |
| **Entry points** | main.ts, index.js, App.java, main.py, main.go |
| **Naming conventions** | kebab-case, camelCase, PascalCase for files/dirs |
| **Assets** | Static files, public/, assets/ |

### Package Organization

| Type | Indicators |
|------|------------|
| **Monorepo** | packages/, apps/, workspace config in root manifest |
| **Single package** | One package.json / pom.xml at root |
| **Multi-module** | settings.gradle, pom.xml with modules |

**Workspace Tools:**

| Tool | Config |
|------|--------|
| pnpm | `pnpm-workspace.yaml` |
| Yarn | `workspaces` in package.json |
| Lerna | `lerna.json` |
| Nx | `nx.json`, `project.json` |
| Turborepo | `turbo.json` |

### Key Files to Find

- [ ] `package.json` / `pom.xml` / `requirements.txt` / `go.mod` / `Cargo.toml`
- [ ] `Dockerfile` / `docker-compose.yml`
- [ ] `Makefile` / build scripts
- [ ] `tsconfig.json` / `jsconfig.json`
- [ ] `.eslintrc` / `.prettierrc` / linting config
- [ ] `README.md`

### Scanning Process

1. **List root directory** — Get top-level structure
2. **Identify package type** — Look for workspace configs
3. **Map source directories** — Find where code lives (depth 3–4 is usually sufficient)
4. **Find entry points** — Main files, handlers, routes
5. **Catalog key files** — Config, build, deploy files
6. **Determine naming conventions** — File and directory patterns

### Output Template

```markdown
## Structure
- **Type:** [monorepo | single-package | multi-module]
- **Workspace Tool:** [pnpm | yarn | lerna | nx | none]
- **Source Layout:**
  ```
  [root]/
  ├── src/
  │   ├── [module1]/
  │   └── [module2]/
  ├── tests/
  └── config/
  ```
- **Entry Points:** [list main entry files]
- **Naming Conventions:** [files: kebab-case, dirs: lowercase, components: PascalCase]
- **Key Files:** [list found config/build files]
```

---

## 3. Architecture Analysis

Detect architectural patterns, design principles, layers, and boundaries.

### Pattern Detection

| Pattern | Directory/Code Indicators |
|---------|---------------------------|
| **MVC** | controllers/, models/, views/ |
| **Clean Architecture** | domain/, application/, infrastructure/, presentation/ |
| **Hexagonal (Ports & Adapters)** | ports/, adapters/, core/ |
| **DDD** | entities/, aggregates/, repositories/, services/, value-objects/ |
| **Microservices** | Multiple service directories, separate deployables, API gateways |
| **Serverless** | Lambda handlers, function-based organization, serverless.yml |
| **Monolith** | Single deployable, shared database layer |
| **Modular Monolith** | Bounded contexts within single deployable, internal module APIs |
| **MVVM** | viewmodels/, models/, views/ |
| **Event-Driven** | events/, handlers/, listeners/, queues/ |

### Layer Detection

| Layer | Typical Locations | Responsibility |
|-------|-------------------|----------------|
| **Presentation** | controllers/, handlers/, routes/, pages/, components/ | HTTP/UI handling |
| **Application** | services/, use-cases/, orchestrators/ | Business orchestration |
| **Domain** | models/, entities/, domain/, core/ | Business rules and logic |
| **Infrastructure** | repositories/, adapters/, clients/, db/ | External system integration |

### Boundary Analysis

- **Module boundaries** — Distinct folders with clear single responsibility
- **Service boundaries** — Separately deployable units with own configs
- **API boundaries** — REST endpoints, GraphQL schemas, gRPC protos
- **Shared kernel** — Common utilities, shared types, base classes

### Design Pattern Indicators

| Pattern | What to Look For |
|---------|-----------------|
| **Dependency Injection** | DI containers (Spring, NestJS, tsyringe), constructor injection, `@Injectable` |
| **Repository** | `*Repository` classes, data access abstraction layer |
| **Factory** | `*Factory` classes, creational patterns |
| **Event-Driven** | Event bus, message queues, `@EventHandler`, publish/subscribe |
| **CQRS** | Separate read/write models, command handlers, query handlers |
| **Strategy** | Interchangeable algorithms, strategy interfaces |
| **Observer** | Event emitters, listeners, subscribers |

### Detection Process

1. **Scan directory names** — Architecture is often explicit in naming
2. **Look for import patterns** — Dependencies between modules reveal layers
3. **Identify entry points** — How requests flow in (controllers, handlers, resolvers)
4. **Trace data flow** — Controller → Service → Repository
5. **Check for DI containers** — Spring, NestJS, FastAPI Depends, etc.
6. **Look for event buses** — Kafka, RabbitMQ, EventEmitter, SNS/SQS
7. **Analyze API structure** — REST, GraphQL, gRPC definitions

### Output Template

```markdown
## Architecture
- **Primary Pattern:** [pattern name] (Confidence: High|Medium|Low)
- **Evidence:** [list specific indicators found]
- **Secondary Patterns:** [additional patterns detected]
- **Layers:**
  | Layer | Location | Responsibility |
  |-------|----------|----------------|
  | Presentation | src/controllers/ | HTTP handlers |
  | Application | src/services/ | Orchestration |
  | Domain | src/models/ | Business logic |
  | Infrastructure | src/repositories/ | Data access |
- **Boundaries:** [module, service, and API boundaries]
- **Design Patterns:** [DI, Repository, Factory, Event-driven, etc.]
- **Coupling Assessment:** [tight/loose areas]
```

---

## 4. Dependency Analysis

Analyze package manifests, dependency graphs, version strategies, and framework identification.

### Package Manifest Files by Language

| Language | Manifest Files |
|----------|---------------|
| **JavaScript/TypeScript** | `package.json`, `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml` |
| **Java** | `pom.xml`, `build.gradle`, `build.gradle.kts` |
| **Python** | `requirements.txt`, `pyproject.toml`, `setup.py`, `Pipfile`, `poetry.lock` |
| **Go** | `go.mod`, `go.sum` |
| **Rust** | `Cargo.toml`, `Cargo.lock` |
| **.NET** | `*.csproj`, `packages.config`, `*.sln` |
| **Ruby** | `Gemfile`, `Gemfile.lock` |

### Dependency Types

| Type | Description |
|------|-------------|
| **Runtime** | Required for execution (dependencies, install_requires) |
| **Dev** | Build and test tools (devDependencies, dev-dependencies) |
| **Peer** | Expected in consuming environment (peerDependencies) |
| **Optional** | Feature-gated (optionalDependencies, extras_require) |

### Version Strategies

| Strategy | Example | Meaning |
|----------|---------|---------|
| Exact | `1.2.3` | Pinned version |
| Caret | `^1.2.0` | Compatible with 1.x.x |
| Tilde | `~1.2.0` | Compatible with 1.2.x |
| Range | `>=1.0.0 <2.0.0` | Explicit range |
| Latest | `*`, `latest` | Always newest |
| Lock file | package-lock.json | Reproducible installs |

### Key Framework Identification

| Category | Frameworks |
|----------|------------|
| **Backend** | Express, NestJS, Fastify, Koa, FastAPI, Flask, Django, Spring Boot, Quarkus, Gin, Fiber |
| **Frontend** | React, Angular, Vue, Svelte, Solid |
| **Full-Stack** | Next.js, Nuxt, SvelteKit, Remix, Astro |
| **Mobile** | React Native, Flutter, Expo |
| **ORM/Database** | TypeORM, Prisma, Sequelize, Hibernate, SQLAlchemy, GORM |
| **Testing** | Jest, Vitest, Mocha, Playwright, Cypress, JUnit, pytest |
| **Infrastructure** | Terraform CDK, AWS CDK, Pulumi |

### Useful Commands

```bash
# JavaScript/TypeScript
npm ls --depth=0                              # List direct deps
npm outdated                                  # Check for updates
npm audit --json                              # Security audit
cat package.json | jq '.dependencies'         # Parse deps

# Python
pip list                                      # List installed
pip check                                     # Verify deps
pip-audit                                     # Security audit

# Java/Maven
mvn dependency:tree                           # Dependency tree
mvn versions:display-dependency-updates       # Check updates

# Go
go mod graph                                  # Dependency graph
go list -m -u all                             # Check updates

# Rust
cargo tree                                    # Dependency tree
cargo outdated                                # Check updates
```

### Output Template

```markdown
## Dependencies
- **Package Manager:** [npm | yarn | pnpm | maven | gradle | pip | poetry | cargo]
- **Lock File:** [present | missing]
- **Key Frameworks:**
  | Framework | Version | Category |
  |-----------|---------|----------|
  | [name] | [ver] | [backend/frontend/orm/etc.] |
- **Dependency Counts:** Runtime: X, Dev: Y, Peer: Z
- **Version Strategy:** [mostly exact | mostly ranges | mixed]
- **Security Concerns:** [any known vulnerabilities or deprecated packages]
```

---

## 5. DevOps Analysis

Analyze CI/CD pipelines, containerization, infrastructure-as-code, and deployment patterns.

### CI/CD Detection

| Platform | Config Files |
|----------|-------------|
| **GitHub Actions** | `.github/workflows/*.yml` |
| **GitLab CI** | `.gitlab-ci.yml` |
| **Jenkins** | `Jenkinsfile`, `jenkins/` |
| **Azure DevOps** | `azure-pipelines.yml` |
| **CircleCI** | `.circleci/config.yml` |
| **Bitbucket** | `bitbucket-pipelines.yml` |
| **AWS CodePipeline** | `buildspec.yml` |

### Containerization

| Tool | Config Files |
|------|-------------|
| **Docker** | `Dockerfile`, `docker-compose.yml`, `.dockerignore` |
| **Podman** | `Containerfile` |
| **Kubernetes** | `k8s/`, manifests with `kind:`, `kustomization.yaml` |
| **Helm** | `Chart.yaml`, `values.yaml`, `templates/` |
| **Skaffold** | `skaffold.yaml` |

### Infrastructure as Code

| Tool | Config Files |
|------|-------------|
| **Terraform** | `*.tf`, `*.tfvars`, `.terraform/`, `terraform.tfstate` |
| **AWS CDK** | `cdk.json`, `lib/*.ts`, `bin/*.ts` |
| **Pulumi** | `Pulumi.yaml`, `Pulumi.*.yaml` |
| **CloudFormation** | `template.yaml`, `*.cfn.yml`, `*.cfn.json` |
| **Ansible** | `playbook.yml`, `ansible.cfg`, `roles/` |
| **Serverless** | `serverless.yml`, `serverless.ts` |

### Environment Configuration

- `.env` / `.env.example` / `.env.local` — Environment variables
- AWS Secrets Manager / HashiCorp Vault / SOPS — Secrets management
- Config per environment — Separate configs for each stage

### Environment Mapping

| Environment | Typical Purpose | Deployment |
|-------------|-----------------|------------|
| **dev** | Local development | docker-compose, localhost |
| **tst** | Automated testing | CI/CD auto-deploy |
| **qa** | QA validation | CI/CD or manual trigger |
| **sta** (staging) | Pre-production | CI/CD with approval |
| **prod** | Production | Manual approval + CI/CD |

### Output Template

```markdown
## DevOps
- **CI/CD Platform:** [platform name]
- **Pipeline Stages:** [build → test → deploy]
- **Containerization:** [Docker | Podman | none]
- **Orchestration:** [Kubernetes | ECS | none]
- **IaC Tool:** [Terraform | CDK | Pulumi | none]
- **Cloud Provider:** [AWS | Azure | GCP | hybrid]
- **Environments:** [dev, tst, qa, sta, prod]
- **Secrets Management:** [pattern used]
- **Build Commands:**
  | Command | Purpose |
  |---------|---------|
  | `make build` | Build |
  | `make test` | Test |
  | `make deploy` | Deploy |
```

---

## 6. Testing Analysis

Analyze test frameworks, organization, coverage, and quality gates.

### Test Framework Detection

| Language | Frameworks |
|----------|------------|
| **JavaScript/TypeScript** | Jest, Vitest, Mocha, Jasmine, Playwright, Cypress, Testing Library |
| **Java** | JUnit 4/5, TestNG, Mockito, Cucumber, RestAssured |
| **Python** | pytest, unittest, nose2, behave, hypothesis |
| **Go** | testing (stdlib), testify, gomock, goconvey |
| **Rust** | cargo test (built-in), mockall, proptest |
| **.NET** | xUnit, NUnit, MSTest, Moq |

### Test Organization Patterns

| Pattern | Example | When Used |
|---------|---------|-----------|
| **Colocated** | `src/Button.tsx` + `src/Button.test.tsx` | Common in React, component libs |
| **Separate directory** | `src/` + `tests/` | Common in Python, Java, Go |
| **By type** | `tests/unit/`, `tests/integration/`, `tests/e2e/` | Larger projects |
| **Mirror structure** | `src/services/auth.ts` → `tests/services/auth.test.ts` | Medium projects |

### Coverage Tools

| Language | Tool | Config |
|----------|------|--------|
| JS/TS | Istanbul / nyc / c8 | jest.config coverage settings |
| Java | JaCoCo | pom.xml / build.gradle plugin |
| Python | coverage.py / pytest-cov | .coveragerc, pyproject.toml |
| Go | go test -cover | Built-in |
| Rust | cargo-tarpaulin / llvm-cov | Cargo config |

### Quality Gates

Checks that must pass before merge:

- [ ] All tests pass in CI
- [ ] Coverage minimum met (e.g., 80% statements)
- [ ] Linting passes (ESLint, Pylint, golangci-lint)
- [ ] Type checking passes (tsc --noEmit, mypy)
- [ ] No security vulnerabilities (npm audit, safety)
- [ ] PR approval required

### Useful Commands

```bash
# Count test files
find . -name "*.test.ts" -o -name "*.spec.ts" | wc -l
find . -name "*.test.js" -o -name "*.spec.js" | wc -l
find . -path "*/tests/*" -name "*.py" | wc -l
find . -name "*_test.go" | wc -l

# Check test configuration
cat jest.config.js 2>/dev/null || cat jest.config.ts 2>/dev/null
cat pytest.ini 2>/dev/null || grep -A 20 "\[tool.pytest" pyproject.toml 2>/dev/null

# List tests without running
npx jest --listTests 2>/dev/null
pytest --collect-only 2>/dev/null
go test ./... -list '.*' 2>/dev/null
```

### Output Template

```markdown
## Testing
- **Framework:** [primary test framework]
- **Runner:** [test runner if different]
- **Organization:** [colocated | separate | by-type]
- **Test Inventory:**
  | Type | Count | Location |
  |------|-------|----------|
  | Unit | ~N | [path pattern] |
  | Integration | ~N | [path pattern] |
  | E2E | ~N | [path pattern] |
- **Coverage:** [tool, threshold if configured]
- **Quality Gates:** [what must pass in CI]
- **Test Commands:**
  | Command | Purpose |
  |---------|---------|
  | `npm test` | All tests |
  | `npm run test:cov` | With coverage |
```

---

## 7. Documentation Analysis

Catalog and assess documentation completeness and quality.

### In-Repo Documentation

| Type | Common Locations |
|------|------------------|
| **README** | `README.md`, `docs/README.md` |
| **Changelog** | `CHANGELOG.md`, `HISTORY.md`, `RELEASES.md` |
| **Contributing** | `CONTRIBUTING.md`, `docs/contributing.md` |
| **Architecture** | `docs/architecture/`, `ARCHITECTURE.md` |
| **API Docs** | `docs/api/`, `openapi.yaml`, `swagger.json`, `schema.graphql` |
| **Guides** | `docs/`, `docs/guides/` |

### Architecture Decision Records (ADRs)

| Aspect | Details |
|--------|---------|
| **Locations** | `docs/adr/`, `docs/decisions/`, `doc/architecture/decisions/` |
| **Formats** | MADR (Markdown Any Decision Records), Y-template, Nygard template |
| **Status values** | proposed, accepted, deprecated, superseded |

Look for numbered files like `0001-use-typescript.md`, `0002-choose-nestjs.md`.

### API Documentation

| Type | Files | Tools |
|------|-------|-------|
| **OpenAPI/Swagger** | `openapi.yaml`, `swagger.json`, `api-spec.yml` | Swagger UI, Redoc |
| **GraphQL** | `schema.graphql`, `*.graphqls`, introspection | GraphQL Playground |
| **gRPC** | `*.proto` | protoc, buf |
| **AsyncAPI** | `asyncapi.yaml` | AsyncAPI Studio |

### Inline Documentation

| Language | Style | Example |
|----------|-------|---------|
| JS/TS | JSDoc | `/** @param {string} name */` |
| Java | Javadoc | `/** @param name the user name */` |
| Python | Docstrings | `"""Describe the function."""` |
| Go | Doc comments | `// FuncName does something.` |
| Rust | Doc comments | `/// Description` |

### External Documentation

- **Confluence** — Use `mcp-atlassian` tools to search for related spaces/pages
- **Wiki** — GitHub Wiki, GitLab Wiki
- **Doc sites** — Docusaurus, MkDocs, Sphinx, GitBook, VuePress
- **Storybook** — Component documentation for UI libraries

### Documentation Quality Assessment

| Criteria | Poor | Adequate | Good | Excellent |
|----------|------|----------|------|-----------|
| README | Missing or empty | Has description | Setup + usage | Full guide with examples |
| API docs | None | Partial endpoints | All endpoints | Examples + error codes |
| ADRs | None | Few, informal | Regular practice | Comprehensive with status |
| Inline | None | Sparse | Key functions | Thorough JSDoc/Javadoc |
| Guides | None | README only | Setup guide | Onboarding + contribution |

### Output Template

```markdown
## Documentation
- **README Quality:** [excellent | good | adequate | poor | missing]
- **Documentation Inventory:**
  | Type | Location | Quality |
  |------|----------|---------|
  | README | ./README.md | ⭐⭐⭐ |
  | ADRs | docs/adr/ | ⭐⭐⭐⭐ |
  | API Docs | openapi.yaml | ⭐⭐ |
- **ADRs:** [count and format if found]
- **API Docs:** [OpenAPI | GraphQL | gRPC | none]
- **Inline Docs:** [JSDoc | Javadoc | docstrings | sparse | none]
- **External Docs:** [Confluence space, wiki links]
- **Gaps:** [what's missing or outdated]
```

---

## 8. Codebase Profile Template

After completing all 6 dimensions, consolidate into this standardized profile:

```markdown
# Codebase Profile: [Project Name]

## Overview
- **Repository:** [path or URL]
- **Type:** [monorepo | single-service | library | CLI | full-stack app]
- **Primary Languages:** [e.g., TypeScript 80%, Python 15%, Shell 5%]
- **Architecture Pattern:** [e.g., Clean Architecture, Microservices, MVC]
- **Framework Stack:** [e.g., NestJS + React + PostgreSQL]

## Structure
[Paste structure findings from §2]

## Architecture
[Paste architecture findings from §3]

## Dependencies
[Paste dependency findings from §4]

## DevOps
[Paste DevOps findings from §5]

## Testing
[Paste testing findings from §6]

## Documentation
[Paste documentation findings from §7]

## Recommended Team Structure

Based on the analysis above, here are recommended agent team structures:

### Option A: [Structure Name — e.g., "Domain-Aligned Team"]
- **Agents:** [list with roles, e.g., Captain, Implementer, Tester, Deployer, Documenter]
- **Why:** [reasoning based on architecture, e.g., "Clean architecture layers map naturally to specialized agents"]
- **Considerations:** [any caveats]

### Option B: [Alternative — e.g., "Feature-Based Team"]
- **Agents:** [list with roles]
- **Why:** [reasoning]
- **Considerations:** [any caveats]

### Team Size Guidance
| Project Size | Recommended Agents | Rationale |
|-------------|-------------------|-----------|
| Small (1 service, <10k LOC) | 4–5 | Captain, Implementer, Tester, Docs |
| Medium (2–5 services, 10k–50k LOC) | 6–8 | + Deployer, Researcher, specialized Implementers |
| Large (monorepo, >50k LOC) | 8–12 | + per-domain Implementers, Architect, Releaser |
```

---

## 9. Quick Reference Commands

Consolidated terminal commands for rapid codebase analysis:

### File & Directory Discovery

```bash
# Top-level structure
ls -la
find . -maxdepth 1 -type f -name "*.json" -o -name "*.yaml" -o -name "*.yml" -o -name "*.toml" -o -name "Makefile" -o -name "Dockerfile" | sort

# Source file counts by extension
find . -type f -name "*.ts" -not -path "*/node_modules/*" | wc -l
find . -type f -name "*.py" -not -path "*/.venv/*" | wc -l
find . -type f -name "*.java" -not -path "*/target/*" | wc -l
find . -type f -name "*.go" -not -path "*/vendor/*" | wc -l

# Directory tree (limited depth)
find . -maxdepth 3 -type d -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/target/*" | sort
```

### Package & Dependency Commands

```bash
# JavaScript/TypeScript
cat package.json | jq '{name, version, dependencies: (.dependencies | keys), devDependencies: (.devDependencies | keys)}'
npm ls --depth=0 2>/dev/null
npm outdated 2>/dev/null

# Python
cat requirements.txt 2>/dev/null || cat pyproject.toml 2>/dev/null
pip list --format=columns 2>/dev/null

# Java
mvn dependency:tree 2>/dev/null
cat pom.xml 2>/dev/null | head -50

# Go
cat go.mod 2>/dev/null
go list -m all 2>/dev/null
```

### Test Discovery

```bash
# Count test files by type
echo "=== Test files ===" && \
find . -name "*.test.*" -o -name "*.spec.*" -o -name "*_test.*" | grep -v node_modules | wc -l

# Find test directories
find . -type d -name "test" -o -name "tests" -o -name "__tests__" -o -name "e2e" -o -name "cypress" | grep -v node_modules

# Test config files
find . -maxdepth 2 -name "jest.config.*" -o -name "vitest.config.*" -o -name "playwright.config.*" -o -name "cypress.config.*" -o -name "pytest.ini" -o -name ".coveragerc" 2>/dev/null
```

### CI/CD & DevOps Discovery

```bash
# CI/CD config files
ls -la .github/workflows/ 2>/dev/null
cat .gitlab-ci.yml 2>/dev/null | head -30
cat Jenkinsfile 2>/dev/null | head -30

# Docker
cat Dockerfile 2>/dev/null | head -20
cat docker-compose.yml 2>/dev/null | head -30

# IaC
find . -name "*.tf" -not -path "*/.terraform/*" 2>/dev/null | head -20
cat cdk.json 2>/dev/null
```

### Git Statistics

```bash
# Repository age and activity
git log --oneline --reverse | head -1          # First commit
git log --oneline -1                            # Latest commit
git shortlog -sn --no-merges | head -10        # Top contributors

# File change frequency (hot spots)
git log --pretty=format: --name-only --since="6 months ago" | sort | uniq -c | sort -rn | head -20

# Lines of code (rough)
find . -name "*.ts" -not -path "*/node_modules/*" | xargs wc -l 2>/dev/null | tail -1
```
