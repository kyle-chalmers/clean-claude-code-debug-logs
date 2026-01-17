# Research: Claude Code Debug Log Bug

Deep research into the Claude Code debug log exponential growth bug.

## Bug Summary

Claude Code debug logs in `~/.claude/debug/` can grow to hundreds of gigabytes due to an infinite loop in the debug logging mechanism. This happens during normal usage, particularly with MCP tools that return large payloads.

## Technical Analysis

### Debug Log System

Claude Code maintains debug logs for each session:
- Location: `~/.claude/debug/`
- Format: Plain text files with session IDs as filenames
- Contents: Full transcript including tool calls, outputs, and conversation history

### The Bug Mechanism

1. **Large Tool Output**: An MCP tool (Snowflake query, Confluence fetch, etc.) returns a large payload
2. **Debug Capture**: The debug log captures this output in full
3. **Feedback Loop**: Under certain conditions, the debug file content gets included in subsequent logging
4. **Exponential Growth**: Each iteration doubles (or more) the log size
5. **Result**: Files can grow from kilobytes to hundreds of gigabytes in a single session

### Trigger Conditions

The bug appears to be triggered when:
- MCP tools return large results (>1MB)
- Multiple tool calls happen in succession
- Sessions run for extended periods
- Context includes references to file system paths

### Evidence

Observed in practice:
- Single session files reaching 200GB+
- Growth rate appearing exponential (doubling every few iterations)
- Files growing even when no active work is happening
- Correlation with MCP-heavy workflows (Snowflake, Confluence, Jira)

## Impact

### Disk Space

- Individual files can exceed 100GB
- Multiple large files can accumulate
- Users may not notice until disk is full
- macOS and other systems may become unstable when disk is full

### Performance

- Large log files slow down I/O operations
- System may become sluggish as disk fills
- Claude Code itself may be affected if logs are processed

### User Experience

- Unexpected disk space consumption
- Difficult to diagnose (logs are hidden in `~/.claude/`)
- No warning or size limits in Claude Code
- Requires manual intervention to clean up

## Workarounds

### Manual Cleanup

```bash
# Check current size
du -sh ~/.claude/debug

# List large files
find ~/.claude/debug -type f -size +1G -exec ls -lh {} \;

# Delete all debug logs
rm -rf ~/.claude/debug/*

# Delete only files over 1GB
find ~/.claude/debug -type f -size +1G -delete
```

### Automated Cleanup

SessionEnd hook to automatically clean up after each session:

```bash
#!/bin/bash
DEBUG_DIR="$HOME/.claude/debug"
CLEANUP_MODE="1G"  # or "all"

if [ -d "$DEBUG_DIR" ]; then
    if [ "$CLEANUP_MODE" = "all" ]; then
        rm -rf "$DEBUG_DIR"/* 2>/dev/null
    else
        find "$DEBUG_DIR" -type f -size +${CLEANUP_MODE} -delete 2>/dev/null
    fi
fi
```

### Prevention

Until the bug is fixed:
- Regular monitoring of `~/.claude/debug` size
- Automated cleanup via hooks
- End sessions when not actively using Claude Code
- Be aware when using MCP tools with large outputs

## Status

- **Reported**: Bug has been observed and documented by users
- **Workaround**: Cleanup scripts and hooks available
- **Fix Status**: Awaiting fix from Anthropic

## Related Issues

- GitHub: Check claude-code repository for related issues
- Community discussions on Discord and forums

## References

- Claude Code documentation: https://docs.anthropic.com/claude-code
- Hooks documentation: https://docs.anthropic.com/claude-code/hooks
- User reports in Claude Code community channels
