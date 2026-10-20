#!/usr/bin/env python3
"""Export readable MATLAB code embedded in App Designer .mlapp files."""

from __future__ import annotations

import argparse
import html
import sys
import zipfile
from pathlib import Path
from xml.etree import ElementTree


def extract_code(mlapp: Path) -> str:
    with zipfile.ZipFile(mlapp) as archive:
        document = archive.read("matlab/document.xml")

    root = ElementTree.fromstring(document)
    chunks = [node.text or "" for node in root.iter() if node.tag.endswith("}t")]
    code = html.unescape("\n".join(chunks)).replace("\r\n", "\n")
    if "classdef" not in code:
        raise ValueError("No MATLAB class definition found")
    return code.rstrip() + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Export MATLAB source code from App Designer .mlapp files."
    )
    parser.add_argument("input_dir", type=Path, help="Directory containing .mlapp files")
    parser.add_argument("output_dir", type=Path, help="Directory for exported .m files")
    args = parser.parse_args()

    args.output_dir.mkdir(parents=True, exist_ok=True)
    files = sorted(args.input_dir.glob("*.mlapp"))
    if not files:
        print(f"No .mlapp files found in {args.input_dir}", file=sys.stderr)
        return 1

    failed = False
    for mlapp in files:
        output = args.output_dir / f"{mlapp.stem}.m"
        try:
            with output.open("w", encoding="utf-8", newline="\n") as stream:
                stream.write(extract_code(mlapp))
            print(f"Exported {mlapp} -> {output}")
        except (KeyError, ValueError, zipfile.BadZipFile, ElementTree.ParseError) as exc:
            failed = True
            print(f"Failed to export {mlapp}: {exc}", file=sys.stderr)

    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())

