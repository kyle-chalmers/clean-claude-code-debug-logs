#!/bin/bash
# Claude Code Debug Log Cleanup Hook
# Runs on SessionEnd to clean up debug log files

DEBUG_DIR="$HOME/.claude/debug"

# =============================================================================
# CONFIGURATION - Adjust this value to your preference
# =============================================================================
# Set a size threshold like "500M", "1G", "100M" to only delete large files
# Or set to "all" to delete all debug logs
CLEANUP_MODE="1G"
# =============================================================================

# Only run if debug directory exists
if [ -d "$DEBUG_DIR" ]; then
    if [ "$CLEANUP_MODE" = "all" ]; then
        # Delete all debug log files
        rm -rf "$DEBUG_DIR"/* 2>/dev/null
    else
        # Delete files >= threshold size
        find "$DEBUG_DIR" -type f -size +${CLEANUP_MODE} -delete 2>/dev/null
    fi
fi
