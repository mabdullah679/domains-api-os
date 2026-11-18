# domains-api-os

Spring Boot 3.5 + Spring AI 1.1.0-M3 MCP server (streamable HTTP, `/mcp`) exposing one tool, `domains-latest-videos`, which returns hard-coded text. Global rules: `~/.claude/CLAUDE.md`.

## Commands
- Test: `./mvnw -B test` (1 test: Spring context loads). Needs JDK 25+ (`java.version` is 25).
- Build: `./mvnw -B clean package` -> `target/domains.ai.2.0-0.0.1-SNAPSHOT.jar`
- Run: `java -jar target/domains.ai.2.0-0.0.1-SNAPSHOT.jar [--server.port=N]` (default 8080)
- MCP smoke (4 curl checks, server must be up): `scripts/mcp-smoke.sh [base-url]`
- Manual inspector flow: `commands.txt`

## Layout
`src/main/java/domains/ai/domains/ai20/` -> `Application`, `DomainsTool` (the only `@McpTool`). Server name/version/protocol come from `src/main/resources/application.properties`.

## Conventions / don't
- The tool returns static strings; there is no domain-lookup API behind the repo name. Don't claim otherwise.
- Spring AI is a milestone (M3) pulled from Maven Central at build time; check before bumping.
- `pom.xml` has empty `<name/>`, `<license/>`, `<developer/>` template stubs: owner decision, left as-is.
- Branch + PR only; never push to `main`.
