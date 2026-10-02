#!/usr/bin/env python3
"""Parse standard two-column OSU point-to-point output into CSV files."""
import argparse
import csv
import re
from pathlib import Path

NUMBER = re.compile(r"^\s*([0-9]+(?:\.[0-9]+)?(?:[Ee][+-]?[0-9]+)?)\s+([0-9]+(?:\.[0-9]+)?(?:[Ee][+-]?[0-9]+)?)")


def parse_file(path):
    match = re.search(r"(native|container)_(bw|latency)_rep(\d+)", path.name)
    if not match:
        return []
    scenario, benchmark, repetition = match.groups()
    rows = []
    for line in path.read_text(errors="replace").splitlines():
        parsed = NUMBER.match(line)
        if not parsed or line.lstrip().startswith("#"):
            continue
        message_bytes = int(float(parsed.group(1)))
        value = float(parsed.group(2))
        rows.append({
            "scenario": scenario,
            "benchmark": f"osu_{benchmark}",
            "repetition": int(repetition),
            "message_bytes": message_bytes,
            "value": value,
            "unit": "MB/s" if benchmark == "bw" else "us",
            "source": str(path),
        })
    return rows


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--raw-dir", type=Path, default=Path("results/raw"))
    parser.add_argument("--processed-dir", type=Path, default=Path("results/processed"))
    args = parser.parse_args()
    args.processed_dir.mkdir(parents=True, exist_ok=True)
    rows = []
    for path in sorted(args.raw_dir.rglob("*.out")):
        rows.extend(parse_file(path))
    if not rows:
        raise SystemExit(f"Nenhum arquivo OSU reconhecido em {args.raw_dir}")

    fields = ["scenario", "benchmark", "repetition", "message_bytes", "value", "unit", "source"]
    with (args.processed_dir / "measurements.csv").open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=fields)
        writer.writeheader()
        writer.writerows(rows)

    groups = {}
    for row in rows:
        key = (row["scenario"], row["benchmark"], row["message_bytes"], row["unit"])
        groups.setdefault(key, []).append(row["value"])
    summary_fields = ["scenario", "benchmark", "message_bytes", "unit", "n", "mean", "stdev", "minimum", "maximum"]
    with (args.processed_dir / "summary.csv").open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=summary_fields)
        writer.writeheader()
        for (scenario, benchmark, message, unit), values in sorted(groups.items()):
            mean = sum(values) / len(values)
            variance = sum((value - mean) ** 2 for value in values) / (len(values) - 1) if len(values) > 1 else 0.0
            writer.writerow({
                "scenario": scenario,
                "benchmark": benchmark,
                "message_bytes": message,
                "unit": unit,
                "n": len(values),
                "mean": mean,
                "stdev": variance ** 0.5,
                "minimum": min(values),
                "maximum": max(values),
            })
    print(f"Parsed {len(rows)} measurements into {args.processed_dir}")


if __name__ == "__main__":
    main()
