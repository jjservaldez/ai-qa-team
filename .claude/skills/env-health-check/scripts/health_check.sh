#!/usr/bin/env bash
# Read-only health check for restful-booker-platform before a test run.
# Usage: health_check.sh [BASE_URL]   (default http://localhost:3003)
set -u
BASE="${1:-http://localhost:3003}"
BASE="${BASE%/}"
fail=0
ts="$(date '+%Y-%m-%d %H:%M:%S %Z')"

code() { curl -s -o /dev/null -w '%{http_code}' --max-time 15 "$BASE$1"; }
body() { curl -s --max-time 15 "$BASE$1"; }

echo "Health check · $ts · $BASE"
printf '%-24s %s\n' "ENDPOINT" "STATUS"

c=$(code /api/room)
rooms=$(body /api/room | grep -o '"roomid":[0-9]*' | wc -l | tr -d ' ')
printf '%-24s %s (rooms: %s)\n' "/api/room" "$c" "$rooms"
[ "$c" = "200" ] && [ "${rooms:-0}" -ge 3 ] || fail=1

failing=""
for p in /api/room/1 /api/room/2 /api/room/3 /api/report/room/1 /api/branding; do
  c=$(code "$p"); printf '%-24s %s\n' "$p" "$c"
  if [ "$c" != "200" ]; then fail=1; failing="$failing $p=$c"; fi
done

bookings=0
for id in 1 2 3; do
  n=$(body "/api/report/room/$id" | grep -o '"start"' | wc -l | tr -d ' ')
  bookings=$((bookings + ${n:-0}))
done
echo "bookings (rooms 1-3): $bookings  (fresh local start = 3 seeded)"

if [ "$fail" -eq 0 ]; then
  echo "VERDICT: READY"
else
  echo "VERDICT: NOT READY ->${failing:- room list missing or under 3 rooms}"
  exit 1
fi
