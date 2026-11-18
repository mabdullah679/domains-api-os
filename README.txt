DOMAINS-API-OS

This is a tiny server that speaks MCP (Model Context Protocol), the way AI assistants discover and call tools. It is built with Spring Boot and Spring AI. It offers exactly one tool, called domains-latest-videos. When called, that tool just returns a fixed bit of text containing two YouTube links. It does not look up domains and does not call any outside service, despite the repo name.

What you need: Java 25 or newer. Maven is not needed because the project includes the Maven wrapper (./mvnw). Optional: Node.js to use the MCP Inspector, and curl for the smoke test. Building downloads libraries from Maven Central.

How to run it:
1. Run "./mvnw clean package". This runs the one test and builds the jar.
2. Run "java -jar target/domains.ai.2.0-0.0.1-SNAPSHOT.jar". It listens on port 8080.
3. In another terminal run "npx @modelcontextprotocol/inspector", connect to http://localhost:8080/mcp, click List Tools, and look for domains-latest-videos. Or run scripts/mcp-smoke.sh instead.
If port 8080 is busy, add --server.port=9090 to the java command and use port 9090.

What it does: initialize replies with the server name domains-api-os, version 0.1.1 and a session id. tools/list shows the one tool. tools/call on it returns the two YouTube links. The only web address is POST /mcp. There is no login, so do not put it on the public internet as it is.

Tests: "./mvnw test" runs 1 test that only checks the app starts. The script scripts/mcp-smoke.sh makes 4 curl checks against a running server (initialize, session id, tool list, tool call). The GitHub workflow runs both plus a secret scan. Nothing external is needed.

Where things are: DomainsTool.java is the tool, Application.java starts the app, application.properties holds the server name and settings, commands.txt has the manual Inspector steps, pom.xml lists the versions (Spring Boot 3.5.13 and Spring AI 1.1.0-M3, which is a milestone release and may change).

Small fixes made in this clean-up: commands.txt said to look for "DomainTools" but the real tool name is domains-latest-videos; the mvnw file is now marked executable.
