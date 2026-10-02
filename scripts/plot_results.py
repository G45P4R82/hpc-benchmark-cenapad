#!/usr/bin/env python3
"""Generate host/container OSU comparison plots from summary.csv."""
import argparse
import csv
from pathlib import Path


def load(path, benchmark):
    data = {"native": [], "container": []}
    with path.open(newline="") as stream:
        for row in csv.DictReader(stream):
            if row["benchmark"] != benchmark:
                continue
            data[row["scenario"]].append({key: float(row[key]) for key in ("message_bytes", "mean", "stdev")})
    for values in data.values():
        values.sort(key=lambda item: item["message_bytes"])
    return data


def plot(summary, output, benchmark, ylabel, title):
    try:
        import matplotlib.pyplot as plt
    except ImportError as error:
        raise SystemExit("Instale matplotlib para gerar os graficos: python -m pip install matplotlib") from error
    data = load(summary, benchmark)
    figure, axis = plt.subplots(figsize=(8, 5))
    for scenario, values in data.items():
        if not values:
            continue
        x = [item["message_bytes"] for item in values]
        y = [item["mean"] for item in values]
        error = [item["stdev"] for item in values]
        axis.errorbar(x, y, yerr=error, marker="o", capsize=3, label=scenario)
    axis.set_xscale("log", base=2)
    axis.set_xlabel("Tamanho da mensagem (bytes)")
    axis.set_ylabel(ylabel)
    axis.set_title(title)
    axis.grid(True, which="both", alpha=0.25)
    axis.legend()
    figure.tight_layout()
    output.parent.mkdir(parents=True, exist_ok=True)
    figure.savefig(output, dpi=180)
    plt.close(figure)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--summary", type=Path, default=Path("results/processed/summary.csv"))
    parser.add_argument("--output-dir", type=Path, default=Path("results/plots"))
    args = parser.parse_args()
    plot(args.summary, args.output_dir / "bandwidth_comparison.png", "osu_bw", "Largura de banda (MB/s)", "OSU bandwidth: host versus contêiner")
    plot(args.summary, args.output_dir / "latency_comparison.png", "osu_latency", "Latência (us)", "OSU latency: host versus contêiner")


if __name__ == "__main__":
    main()
