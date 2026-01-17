# Cleanup Claude Code Debug Logs

Cleans up accumulated debug logs from `~/.claude/debug/` that can consume hundreds of gigabytes over time.

## Arguments: $ARGUMENTS

Optional size threshold (e.g., `500M`, `1G`, `all`). Default: `1G`

## Instructions

1. **Parse arguments** to determine cleanup mode:
   - If `$ARGUMENTS` is empty or not provided: use default threshold of `1G`
   - If `$ARGUMENTS` is `all`: delete all debug logs
   - Otherwise: use `$ARGUMENTS` as size threshold (e.g., `500M`, `2G`)

2. **Check current size** of the debug logs directory:
   ```bash
   du -sh ~/.claude/debug 2>/dev/null || echo "Debug directory not found"
   ```

3. **List files that match the criteria**:
   - If cleaning all: show total file count
   - If using size threshold: list files >= threshold
   ```bash
   find ~/.claude/debug -type f -size +1G -exec ls -lh {} \; 2>/dev/null | head -10
   ```

4. **Report findings** to user:
   - Current total size
   - Number of files that will be deleted
   - Space that will be recovered

5. **Ask for confirmation** before deleting:
   - Show cleanup mode (all vs size-based)
   - Confirm user wants to proceed

6. **If confirmed**, execute cleanup:
   - For `all`: `rm -rf ~/.claude/debug/*`
   - For size threshold: `find ~/.claude/debug -type f -size +[THRESHOLD] -delete`

7. **Verify and report results**:
   ```bash
   du -sh ~/.claude/debug
   ```

## Examples

- `/cleanup-debug-logs` - Delete files >= 1GB (default)
- `/cleanup-debug-logs 500M` - Delete files >= 500MB
- `/cleanup-debug-logs all` - Delete all debug logs

## Context

Debug logs capture full session transcripts including:
- All conversation history
- Tool call inputs and outputs
- File contents that were read
- MCP query results (Snowflake, Confluence, Jira, etc.)

These are safe to delete and do not affect Claude Code functionality.

## Automation Note

A `SessionEnd` hook is configured at `~/.claude/hooks/cleanup-debug-logs.sh` that automatically deletes files >= 1GB when sessions end. Edit the `MIN_SIZE_TO_DELETE` variable in that file to adjust the threshold.
