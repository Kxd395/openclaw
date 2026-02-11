---
name: relational-intelligence
description: Maintain a lightweight personal CRM by scanning recent email and calendar activity to identify high-density relationships, last-touch dates, and suggested follow ups.
---

## Goal

Build a short list of relationships to maintain, without turning the user into a full-time CRM operator.

## Data sources (only if integrations are enabled)

- Email: last 60 days
- Calendar: last 60 days
- Messaging: last 30 days (if available)

If these tools are not enabled, do not guess. Ask Kevin to enable email and calendar integrations.

## Extraction rules

For each person, extract:
- name (best available)
- primary email or handle
- last touch date
- touch type: email sent, email received, meeting, message
- relationship density: count of touches in the window

## Human vs bot filter

Flag as likely bot or automated sender if:
- no personal name and a role account pattern
- high volume but no replies
- bulk newsletter markers
- noreply or automated labels

Do not delete. Just tag.

## Output format

Return:
1) Top 10 people by density
2) Top 10 people by time since last touch (that still matter)
3) 5 suggested follow ups with a one sentence rationale each

## Storage

Write a single artifact in the workspace:
- workspace/contacts/relational-intel.json

Do not write this file without approval (Approval Gate applies).
