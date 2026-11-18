#!/usr/bin/env bash
# MCP smoke test over streamable HTTP against a running server.
# Usage: scripts/mcp-smoke.sh [base-url]   (default http://localhost:8080)
# Needs: bash, curl.
set -u
B="${1:-http://localhost:8080}/mcp"
pass=0; fail=0
check() { if [ "$2" = "$3" ]; then pass=$((pass+1)); echo "ok   $1"; else fail=$((fail+1)); echo "FAIL $1 (expected '$2', got '$3')"; fi; }
H=(-H 'Content-Type: application/json' -H 'Accept: application/json, text/event-stream')

hdrs=$(curl -s -D - -o /tmp/mcp-init.$$ "${H[@]}" "$B" -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"smoke","version":"1"}}}')
SID=$(printf '%s' "$hdrs" | awk -F': ' 'tolower($1)=="mcp-session-id"{print $2}' | tr -d '\r')
check "initialize returns server name"  1 "$(grep -c '"name":"domains-api-os"' /tmp/mcp-init.$$)"
check "initialize returns a session id" 1 "$([ -n "$SID" ] && echo 1 || echo 0)"
rm -f /tmp/mcp-init.$$

curl -s -o /dev/null "${H[@]}" -H "Mcp-Session-Id: $SID" "$B" -d '{"jsonrpc":"2.0","method":"notifications/initialized"}'
tools=$(curl -s "${H[@]}" -H "Mcp-Session-Id: $SID" "$B" -d '{"jsonrpc":"2.0","id":2,"method":"tools/list"}')
check "tools/list has domains-latest-videos" 1 "$(printf '%s' "$tools" | grep -c '"name":"domains-latest-videos"')"
call=$(curl -s "${H[@]}" -H "Mcp-Session-Id: $SID" "$B" -d '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"domains-latest-videos","arguments":{}}}')
check "tools/call returns video links"      1 "$(printf '%s' "$call" | grep -c 'youtube.com/watch')"

echo "passed=$pass failed=$fail"
[ "$fail" -eq 0 ]
