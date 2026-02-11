---
name: priority-heartbeat
description: Heartbeat decision rules: choose the single most overdue task, avoid collisions, and prevent starvation with fairness and rate limits.
---

## Goal

Make heartbeats predictable and safe.

## Core rule

On each heartbeat, do at most one meaningful unit of work.

## How to choose the one task

Compute an overdue score for candidate tasks:

score = (urgency * 2) + impact - effort - risk

Where each dimension is 1 to 5.

Tie breakers:
1) tasks blocked by upcoming calendar time win
2) tasks waiting on Kevin lose (send reminder instead)

## Avoid starvation

If the same task wins more than 3 heartbeats in a row:
- run it once more only if progress was made
- otherwise, pick the next task

## Collision avoidance

- Never run two tasks that hit the same external API in the same heartbeat window.
- If a task requires email or calendar tools, prefer it only once per N heartbeats.

## Output

If you take action, send Kevin:
- what you did
- what changed
- what is next
If you do nothing, stay quiet.
