# Ingest Policy

This file defines how to store sources so they remain searchable and safe.

## Quarantine first

Before writing anything durable:
- produce a short summary
- list key claims and mark uncertainty
- extract dates, names, and numeric facts
- note what is missing

## Storage layout

- knowledge/sources/
  Raw or lightly processed content and metadata.

- knowledge/notes/
  Human-oriented notes, summaries, and retrieval-friendly chunks.

## Canonicalization

For URLs, canonicalize by:
- removing fragments
- removing tracking params (utm_*, gclid, fbclid)
- sorting query params

You can use:
- scripts/canonicalize_url.py

## Chunking

When creating notes:
- keep each chunk to one idea
- include a title line
- include source pointer at top
- include date captured

## Citation

When answering later:
- cite by file path and section header
- quote only short spans
- do not claim certainty if the source is ambiguous
