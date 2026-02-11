---
name: approval-gate
description: Two-step commit protocol for any action that changes external state (send email, send chat messages, create calendar events, write files outside workspace, run shell commands that write or install).
---

## Purpose

Prevent accidental or malicious side effects.

## What counts as an external side effect

- sending email or chat messages
- creating, editing, or deleting calendar events
- creating, editing, or deleting CRM or tickets
- writing files outside the OpenClaw workspace
- running shell commands that write, install, or modify settings
- exposing the gateway on the public internet

## The protocol

### Step A: Propose (mandatory)

Present a "proposal block" with:

1) Intent
One sentence describing what you are trying to accomplish.

2) Exact action
- For messages: exact text to be sent, including recipients
- For calendar: exact title, time, attendees, location, and description
- For files: exact file path and the diff summary
- For shell: exact command line

3) Rollback
How to undo it.

4) Risk
One sentence.

### Step B: Execute (only after approval)

Only execute when Kevin replies with a clear approval in the same thread, such as:
- approve
- approved
- do it

If approval is ambiguous, do not execute.

## After execution

- Confirm what was done.
- Record an audit entry in today's log: workspace/memory/YYYY-MM-DD.md
