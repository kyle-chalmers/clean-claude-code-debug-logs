# Video: Clean Claude Code Debug Logs

Video tutorial explaining the debug log problem and demonstrating the cleanup solution.

## Video Details

- **Title**: "Claude Code Ate 200GB of My Disk - Here's the Fix"
- **Target Audience**: Intermediate Claude Code users (familiar with slash commands, may not know hooks)
- **Length**: Under 10 minutes
- **Format**: Problem explanation + Solution tutorial

## Script Outline

### 1. Hook / Problem Intro (1-2 min)

- "Ever wonder why your disk is suddenly full after using Claude Code?"
- Show `du -sh ~/.claude/debug` revealing massive size
- Quick explanation: Claude Code keeps debug logs of every session
- The bug: Under certain conditions, logs can grow exponentially in a single session
- Real example: 200GB+ files from infinite logging loop

### 2. Why This Happens (2-3 min)

- Debug logs capture everything: conversations, tool outputs, file contents
- MCP tools (Snowflake, Confluence, Jira) return large payloads
- The bug: log file can get included in its own logging, creating feedback loop
- Show example of a large debug file

### 3. Manual Cleanup: Slash Command (2-3 min)

**Demo the command:**
```
/cleanup-debug-logs
```

- Show it checking current size
- Show file listing
- Demonstrate confirmation prompt
- Show cleanup results

**Explain options:**
- Default 1GB threshold
- Custom threshold: `/cleanup-debug-logs 500M`
- Nuclear option: `/cleanup-debug-logs all`

### 4. Automatic Cleanup: SessionEnd Hook (3-4 min)

**Explain hooks:**
- Claude Code can run scripts on certain events
- SessionEnd fires when you close a session
- Perfect for cleanup tasks

**Show the hook script:**
- Walk through `cleanup-debug-logs.sh`
- Explain the CLEANUP_MODE configuration
- Show how to adjust threshold

**Show settings.json configuration:**
- Where to put the hook config
- Global vs project-level settings

**Demo the hook:**
- Start a session, do some work
- End session (show hook running via terminal output or after-the-fact)
- Show that large files were cleaned

### 5. Installation Recap (1 min)

- Point to repository
- Two-step install: copy files, add hook config
- Or just ask Claude Code to install it

### 6. Outro

- "Never lose disk space to debug logs again"
- Link to repo in description
- Call to action: subscribe, like, etc.

## B-Roll / Visuals Needed

1. Terminal showing `du -sh ~/.claude/debug` with large size
2. Finder/file browser showing massive debug file
3. Claude Code session running `/cleanup-debug-logs`
4. Text editor with `settings.json` hook configuration
5. Terminal showing hook script contents
6. Before/after disk space comparison

## Key Points to Emphasize

1. **This is a known bug** - not user error
2. **Debug logs are safe to delete** - no functionality impact
3. **The hook is set-and-forget** - runs automatically
4. **Configurable thresholds** - delete large files only or everything

## Links for Description

- Repository: https://github.com/kyle-chalmers/clean-claude-code-debug-logs
- Claude Code documentation: https://docs.anthropic.com/claude-code
- Hooks documentation: https://docs.anthropic.com/claude-code/hooks

## Thumbnail Ideas

- "200GB BUG" with Claude Code logo
- Disk space warning icon with "FIX" badge
- Terminal screenshot with dramatic "rm -rf" command
