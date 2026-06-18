#!/usr/bin/env python3
"""1D Kalman filter anomaly detector for time series (pure Python, no required deps).

Reads CSV with columns: timestamp,value (header optional) or stdin.
Outputs lines with anomaly flag when normalized residual exceeds threshold.

Inspired by: Mehmet Bahçeci — Kalman Filter + AI Agents (Medium, Oct 2025).
"""

from __future__ import annotations

import argparse
import csv
import math
import sys
from pathlib import Path
from typing import Iterable, List, Tuple


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(
        description="1D Kalman anomaly detection on timestamp,value series"
    )
    p.add_argument("--file", "-f", type=Path, help="CSV file (timestamp,value)")
    p.add_argument(
        "--threshold",
        "-t",
        type=float,
        default=3.0,
        help="Anomaly if |residual|/sqrt(S) exceeds this (default: 3.0)",
    )
    p.add_argument(
        "--q",
        type=float,
        default=0.01,
        help="Process noise Q (default: 0.01)",
    )
    p.add_argument(
        "--r",
        type=float,
        default=1.0,
        help="Measurement noise R (default: 1.0)",
    )
    p.add_argument(
        "--initial-p",
        type=float,
        default=1.0,
        help="Initial covariance P (default: 1.0)",
    )
    return p.parse_args()


def read_series(path: Path | None) -> List[Tuple[str, float]]:
    rows: List[Tuple[str, float]] = []
    src = path.open(encoding="utf-8") if path else sys.stdin
    try:
        reader = csv.reader(src)
        for row in reader:
            if not row or row[0].startswith("#"):
                continue
            if row[0].lower() in ("timestamp", "time", "ts"):
                continue
            if len(row) < 2:
                continue
            ts, val = row[0].strip(), row[1].strip()
            try:
                rows.append((ts, float(val)))
            except ValueError:
                continue
    finally:
        if path:
            src.close()
    return rows


class Kalman1D:
    """Random-walk 1D Kalman: F=1, H=1."""

    def __init__(self, q: float, r: float, initial_p: float) -> None:
        self.q = q
        self.r = r
        self.x = 0.0
        self.p = initial_p
        self._initialized = False

    def step(self, z: float) -> Tuple[float, float, float]:
        if not self._initialized:
            self.x = z
            self._initialized = True
            return 0.0, 0.0, 0.0

        # Predict
        x_pred = self.x
        p_pred = self.p + self.q

        # Update
        innovation = z - x_pred
        s = p_pred + self.r
        k = p_pred / s if s > 0 else 0.0
        self.x = x_pred + k * innovation
        self.p = (1.0 - k) * p_pred

        residual = z - self.x
        norm = residual / math.sqrt(s) if s > 0 else 0.0
        return residual, s, norm


def run(
    series: Iterable[Tuple[str, float]],
    threshold: float,
    q: float,
    r: float,
    initial_p: float,
) -> int:
    kf = Kalman1D(q=q, r=r, initial_p=initial_p)
    anomaly_count = 0
    print("timestamp,value,estimate,residual,norm_residual,anomaly")
    for ts, val in series:
        residual, s, norm = kf.step(val)
        is_anomaly = abs(norm) > threshold and s > 0
        if is_anomaly:
            anomaly_count += 1
        flag = "YES" if is_anomaly else "NO"
        print(
            f"{ts},{val:.4f},{kf.x:.4f},{residual:.4f},{norm:.4f},{flag}"
        )
    return anomaly_count


def main() -> None:
    args = parse_args()
    series = read_series(args.file)
    if not series:
        print("No data rows found.", file=sys.stderr)
        sys.exit(1)
    count = run(series, args.threshold, args.q, args.r, args.initial_p)
    if count == 0:
        sys.exit(0)
    print(f"# anomalies: {count}", file=sys.stderr)


if __name__ == "__main__":
    main()
