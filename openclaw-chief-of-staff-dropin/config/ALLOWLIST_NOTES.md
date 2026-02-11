# Allowlist Notes (no placeholders)

OpenClaw uses allowlists to decide who can DM the bot and which groups or channels can trigger it.

General rules:
- Prefer allowlist over open.
- Keep groupPolicy to allowlist.
- In groups, require mentions.

## Telegram

- Use Telegram numeric user ids or handles, depending on your setup.
- Configure:
  - channels.telegram.allowFrom
  - channels.telegram.groupAllowFrom

## Slack

- Slack group allowlisting is done per channel:
  - channels.slack.channels["#channel-name"] = { allow: true, requireMention: true }

- For Slack DMs, allowlisting can be applied in:
  - channels.slack.dm.allowFrom

If you are unsure what identifier format OpenClaw expects for a channel, run onboarding and inspect the generated config, then copy the patterns.
