---
name: executing-plans
description: Use when you have a written implementation plan. Load, review critically, execute task-by-task with verification checkpoints.
---

# Executing Plans

**Announce at start:** "I am using the executing-plans skill to implement this plan."

## Process

### Step 1: Load and Review
1. Read plan file
2. Review critically -- raise concerns with Diretor before starting
3. If clear: proceed

### Step 2: Execute Tasks
1. Mark task in_progress
2. Follow each step exactly
3. Run verifications as specified
4. Commit with [RESOLVE: keyword] if closes PENDENTES item
5. Mark completed

### Step 3: Complete
- git log --oneline -10 (verify commits)
- verification-before-completion checks
- Report: tasks done, what changed, blockers

## When to Stop
STOP when: blocker, test fails, unclear instruction, repeated verification failure.
ASK -- never guess.

## Integration
writing-plans creates plan -> executing-plans runs it -> verification-before-completion confirms done