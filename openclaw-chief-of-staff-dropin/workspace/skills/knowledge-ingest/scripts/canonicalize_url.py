#!/usr/bin/env python3
import sys
from urllib.parse import urlparse, urlunparse, parse_qsl, urlencode

# Minimal URL canonicalizer:
# - lowercases scheme and hostname
# - removes fragment
# - strips common tracking params
# - sorts query params
TRACKING_KEYS = {
    "utm_source","utm_medium","utm_campaign","utm_term","utm_content",
    "gclid","fbclid","mc_cid","mc_eid","igshid","si"
}

def canonicalize(url: str) -> str:
    p = urlparse(url.strip())
    scheme = (p.scheme or "https").lower()
    netloc = p.netloc.lower()
    path = p.path or "/"

    # Normalize query params
    q = []
    for k, v in parse_qsl(p.query, keep_blank_values=True):
        if k in TRACKING_KEYS:
            continue
        q.append((k, v))
    q.sort()
    query = urlencode(q, doseq=True)

    return urlunparse((scheme, netloc, path, "", query, ""))

def main() -> int:
    if len(sys.argv) != 2:
        print("usage: canonicalize_url.py URL", file=sys.stderr)
        return 2
    print(canonicalize(sys.argv[1]))
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
