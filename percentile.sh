#!/bin/bash
set -euo pipefail

# Percentile calculator using the nearest-rank method.
# Usage: ./percentile.sh <percentile> <n1> <n2> ...
# Example: ./percentile.sh 90 1 2 3 4 5

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <percentile> <n1> <n2> ..." >&2
  exit 1
fi

p="$1"
shift

# Validate percentile: allow 0..100 (integers only for nearest-rank)
if ! [[ "$p" =~ ^[0-9]+$ ]]; then
  echo "Error: percentile must be an integer between 0 and 100." >&2
  exit 1
fi
if [ "$p" -lt 0 ] || [ "$p" -gt 100 ]; then
  echo "Error: percentile must be between 0 and 100." >&2
  exit 1
fi

# Copy args, validate they are numbers, and sort ascending.
arr=()
for x in "$@"; do
  if ! [[ "$x" =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
    echo "Error: all values must be numeric. Bad value: $x" >&2
    exit 1
  fi
  arr+=("$x")
done

if [ "${#arr[@]}" -eq 0 ]; then
  echo "Error: provide at least one numeric value." >&2
  exit 1
fi

# nearest-rank definition (common):
# index = ceil(p/100 * N), clamped to [1..N]
# Output = value at that 1-based rank in the sorted list.
N=${#arr[@]}

# Compute ceil(p/100 * N) using integer arithmetic where possible.
# We treat p as integer percent.
# rank = ceil(p*N/100) => (p*N + 100 - 1)/100
rank=$(( (p * N + 100 - 1) / 100 ))

# Clamp rank (just in case p=0 gives 0 with formula)
if [ "$rank" -lt 1 ]; then rank=1; fi
if [ "$rank" -gt "$N" ]; then rank="$N"; fi

# Sort numerically; support decimals.
# printf lines then sort.
sorted=$(printf '%s\n' "${arr[@]}" | sort -n)

# Select (rank-1)th line (0-based) from sorted.
result=$(printf '%s\n' "$sorted" | sed -n "${rank}p")

echo "$result"
