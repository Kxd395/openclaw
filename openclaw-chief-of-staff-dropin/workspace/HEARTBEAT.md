# HEARTBEAT.md

Goal: proactive ops without burning money or doing risky things.

Rules:
- If there is no new signal, do nothing.
- Do not perform external side effects on heartbeat.
- Do not run shell commands on heartbeat unless Kevin approved the heartbeat toolset.
- Prefer a short Telegram or Slack ping only when there is a real alert.

## On every heartbeat

1) Queue hygiene
- If there are pending tasks waiting on Kevin, send a single short reminder and stop.
- If there is a backlog spike, send a short "triage needed" note with top 5 items.

2) Calendar lookahead
- Check the next 4 hours.
- If there is a meeting in the next 30 minutes with no prep notes, generate a 3 bullet prep and send it.

3) Inbox alerts (only if email integration is enabled)
- Look for urgent threads since the last heartbeat.
- If any require a reply, draft a response but do not send.

4) Security posture
- If the gateway is not bound to loopback or allowlists are open, alert Kevin.

## Weekly (Sunday) memory review

- Propose small diffs to MEMORY.md.
- Only apply diffs after Kevin approval.
