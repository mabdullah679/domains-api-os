# domains-api-os

A minimal Spring AI MCP (Model Context Protocol) server over streamable HTTP with a single tool, `domains-latest-videos`. The tool returns a fixed text block of two YouTube links; it does not call any domain or external API.

```
MCP client / Inspector --HTTP POST /mcp--> Spring Boot (Tomcat :8080) --> DomainsTool.getLatestVideos() --> static text
```

Not local/contained: nothing at runtime (no network calls). Building downloads dependencies from Maven Central.

## Prerequisites
- JDK 25+ (`java.version` in [pom.xml](pom.xml); built here with JDK 27). The Maven wrapper downloads Maven 3.9.14, so Maven is not required.
- Optional: Node.js for `npx @modelcontextprotocol/inspector`; curl for the smoke test.

## Run it
1. `./mvnw clean package` (runs the test, builds `target/domains.ai.2.0-0.0.1-SNAPSHOT.jar`).
2. `java -jar target/domains.ai.2.0-0.0.1-SNAPSHOT.jar`
3. In another terminal: `npx @modelcontextprotocol/inspector`, connect to `http://localhost:8080/mcp`, click "List Tools" and look for `domains-latest-videos` (steps from [commands.txt](commands.txt)). Or run `scripts/mcp-smoke.sh`.

If port 8080 is taken, start with `--server.port=9090` and use `http://localhost:9090/mcp`. During development `./mvnw spring-boot:run` also works.

## What it does
| Action | Result |
|---|---|
| MCP `initialize` | server `domains-api-os` v0.1.1, tools capability, a `Mcp-Session-Id` header |
| MCP `tools/list` | one tool: `domains-latest-videos` |
| MCP `tools/call` `domains-latest-videos` | two YouTube links as text (hard-coded) |

## Interface
| Method | Path | Auth |
|---|---|---|
| POST | `/mcp` (streamable MCP; send `Accept: application/json, text/event-stream`) | none |

Server settings are in [application.properties](src/main/resources/application.properties); stdio is off. There is no authentication, so do not expose it publicly as is.

## Tests
- `./mvnw test`: 1 test ([ApplicationTests](src/test/java/domains/ai/domains/ai20/ApplicationTests.java)) that the Spring context starts. It does not call the tool.
- [scripts/mcp-smoke.sh](scripts/mcp-smoke.sh): 4 curl checks (initialize, session id, tools/list, tools/call) against a running server.
- CI: [ci.yml](.github/workflows/ci.yml) runs both plus a gitleaks scan. No external services needed.

## Layout
| Path | Role |
|---|---|
| [DomainsTool.java](src/main/java/domains/ai/domains/ai20/DomainsTool.java) | the single `@McpTool` |
| [Application.java](src/main/java/domains/ai/domains/ai20/Application.java) | Spring Boot entry point |
| [application.properties](src/main/resources/application.properties) | MCP server name, version, protocol |
| [scripts/mcp-smoke.sh](scripts/mcp-smoke.sh) | MCP smoke test |
| [commands.txt](commands.txt) | manual Inspector steps |
| [pom.xml](pom.xml) | Spring Boot 3.5.13, Spring AI 1.1.0-M3 |

## Design notes
- Streamable HTTP rather than stdio: lets any HTTP-capable client connect and keeps logs on stdout.
- Spring AI is a milestone release (1.1.0-M3); API names may change before GA.
