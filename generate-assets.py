#!/home/amadeo/git/bide/.venv/bin/python3
"""
Batch asset generator for Bide.
Reads items.txt and assets.txt, generates images via the FLUX MCP server.

Usage:
    ./generate-assets.py                        # generate all
    ./generate-assets.py --only items           # only item icons
    ./generate-assets.py --only assets          # only non-item assets
    ./generate-assets.py --filter "sword"       # only entries matching filter
    ./generate-assets.py --skip-existing        # skip already generated files
    ./generate-assets.py --dry-run              # print prompts without generating

Requires: pip install mcp (installed in .venv)
"""

import argparse
import asyncio
import os
import re
import time

SERVER_URL = "http://192.168.0.156:8000"
OUTPUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "assets", "generated")
DOCS_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "docs")

STYLE_PREFIX = (
    "cel-shaded fantasy game {kind}, bold black outlines, "
    "flat color fills with cel-shading highlights, "
    "dark slate background, clean and stylized, "
)

# Image dimensions by asset type
DIMENSIONS = {
    "item": (512, 512),
    "skill-icon": (512, 512),
    "monster": (512, 512),
    "prayer": (512, 512),
    "pet": (512, 512),
    "spell": (512, 512),
    "agility": (512, 512),
    "constellation": (512, 512),
    "cape": (512, 512),
    "area-bg": (1024, 256),
    "dungeon-bg": (1024, 256),
    "ui": (512, 512),
}


async def generate_image(session, prompt: str, save_path: str, width: int = 512, height: int = 512, seed: int = -1):
    """Call the FLUX MCP server via MCP protocol."""
    try:
        result = await session.call_tool(
            "generate_image",
            arguments={
                "prompt": prompt,
                "width": width,
                "height": height,
                "steps": 4,
                "seed": seed,
                "save_path": save_path,
            },
        )
        return True
    except Exception as e:
        print(f"  ERROR: {e}")
        return False


def parse_items_txt(filepath: str) -> list:
    """Parse items.txt into a list of (item_id, display_name, visual_notes) tuples."""
    entries = []
    with open(filepath) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#") or line.startswith("=") or line.startswith("Style") or line.startswith("Metal") or line.startswith("Wood") or line.startswith("  "):
                continue
            parts = [p.strip() for p in line.split("|")]
            if len(parts) >= 4:
                item_id, name, _desc, visual = parts[0], parts[1], parts[2], parts[3]
                entries.append((item_id, name, visual))
    return entries


def parse_assets_txt(filepath: str) -> list:
    """Parse assets.txt into a list of (asset_type, asset_id, name, visual_notes) tuples."""
    entries = []
    current_section = None
    section_map = {
        "Skill Icons": "skill-icon",
        "Monster Portraits": "monster",
        "Combat Area Backgrounds": "area-bg",
        "Dungeon Backgrounds": "dungeon-bg",
        "Prayer Icons": "prayer",
        "Pet Icons": "pet",
        "Spell Icons": "spell",
        "Agility Obstacles": "agility",
        "Constellation Icons": "constellation",
        "Cape Icons": "cape",
    }

    with open(filepath) as f:
        for line in f:
            line = line.rstrip()

            # Detect section headers
            if line.startswith("## "):
                header = line[3:].strip()
                current_section = None
                for key, val in section_map.items():
                    if header.startswith(key):
                        current_section = val
                        break
                # Stop at UI Assets — those need manual handling
                if header.startswith("UI Assets") or header.startswith("Summary"):
                    current_section = None
                continue

            if current_section is None:
                continue

            # Parse numbered entries like:  1. %item-id — "Name" — Visual description
            # or cape entries like:  1. %item-id — Visual description
            m = re.match(r'\s*\d+\.\s+%?([\w-]+)\s+—\s+"([^"]+)"\s+—\s+(.*)', line)
            if m:
                asset_id = m.group(1)
                name = m.group(2)
                visual = m.group(3).strip()
                entries.append((current_section, asset_id, name, visual))
                continue

            # Constellation format:  1. Name   (%action-id)   — Visual description
            m3 = re.match(r'\s*\d+\.\s+(\w+)\s+\(%?([\w-]+)\)\s+—\s+(.*)', line)
            if m3:
                name = m3.group(1)
                asset_id = m3.group(2)
                visual = m3.group(3).strip()
                entries.append((current_section, asset_id, name, visual))
                continue

            # Cape format:  1. %item-id — Visual description (no quoted name)
            m2 = re.match(r'\s*\d+\.\s+%?([\w-]+)\s+—\s+(.*)', line)
            if m2:
                asset_id = m2.group(1)
                visual = m2.group(2).strip()
                name = asset_id.replace("-", " ").title()
                entries.append((current_section, asset_id, name, visual))
                continue

    return entries


def build_item_prompt(name: str, visual: str) -> str:
    """Build a generation prompt for an item icon."""
    kind = "item icon"
    return STYLE_PREFIX.format(kind=kind) + f"{name}, {visual}, RPG inventory icon"


def build_asset_prompt(asset_type: str, name: str, visual: str) -> str:
    """Build a generation prompt for a non-item asset."""
    kind_map = {
        "skill-icon": "skill icon",
        "monster": "monster portrait, front-facing RPG bestiary style",
        "area-bg": "wide landscape scene, atmospheric",
        "dungeon-bg": "wide landscape scene, atmospheric underground",
        "prayer": "prayer icon, holy symbol with soft glow",
        "pet": "pet companion icon, cute chibi proportions, friendly expression",
        "spell": "spell icon, elemental magic burst",
        "agility": "obstacle icon, action-oriented side view",
        "constellation": "constellation icon, star pattern on deep navy night sky connected by faint golden lines",
        "cape": "cape icon, flowing shoulder cape seen from behind",
    }
    kind = kind_map.get(asset_type, "icon")
    return STYLE_PREFIX.format(kind=kind) + f"{name}, {visual}"


def build_task_list(args):
    """Build the list of (save_path, prompt, width, height) tasks."""
    tasks = []

    if args.only != "assets":
        items_path = os.path.join(DOCS_DIR, "items.txt")
        if os.path.exists(items_path):
            items = parse_items_txt(items_path)
            items_dir = os.path.join(OUTPUT_DIR, "items")
            os.makedirs(items_dir, exist_ok=True)
            for item_id, name, visual in items:
                save_path = os.path.join(items_dir, f"{item_id}.png")
                prompt = build_item_prompt(name, visual)
                w, h = DIMENSIONS["item"]
                tasks.append((save_path, prompt, w, h))

    if args.only != "items":
        assets_path = os.path.join(DOCS_DIR, "assets.txt")
        if os.path.exists(assets_path):
            assets = parse_assets_txt(assets_path)
            for asset_type, asset_id, name, visual in assets:
                subdir = os.path.join(OUTPUT_DIR, asset_type)
                os.makedirs(subdir, exist_ok=True)
                save_path = os.path.join(subdir, f"{asset_id}.png")
                prompt = build_asset_prompt(asset_type, name, visual)
                w, h = DIMENSIONS.get(asset_type, (512, 512))
                tasks.append((save_path, prompt, w, h))

    if args.filter:
        tasks = [(p, pr, w, h) for p, pr, w, h in tasks if args.filter.lower() in p.lower() or args.filter.lower() in pr.lower()]

    if args.skip_existing:
        tasks = [(p, pr, w, h) for p, pr, w, h in tasks if not os.path.exists(p)]

    return tasks


async def run(args, tasks):
    """Connect to MCP server and generate all assets."""
    from mcp.client.sse import sse_client
    from mcp import ClientSession

    print(f"Connecting to {SERVER_URL}/sse ...")
    async with sse_client(f"{SERVER_URL}/sse") as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()
            print("Connected.\n")

            success = 0
            failed = 0
            start_time = time.time()
            offset = args.start

            for i, (save_path, prompt, w, h) in enumerate(tasks):
                num = i + offset
                rel = os.path.relpath(save_path, OUTPUT_DIR)
                print(f"[{num}] {rel} ...", end=" ", flush=True)

                ok = await generate_image(session, prompt, save_path, width=w, height=h, seed=args.seed)
                if ok:
                    success += 1
                    print("OK")
                else:
                    failed += 1
                    print("FAILED")

            elapsed = time.time() - start_time
            print()
            print(f"Done in {elapsed:.0f}s — {success} generated, {failed} failed")


def main():
    parser = argparse.ArgumentParser(description="Generate Bide game assets via FLUX")
    parser.add_argument("--only", choices=["items", "assets"], help="Only generate items or non-item assets")
    parser.add_argument("--filter", type=str, default="", help="Only generate entries matching this substring")
    parser.add_argument("--skip-existing", action="store_true", help="Skip files that already exist")
    parser.add_argument("--start", type=int, default=1, help="Start at this asset number (1-indexed)")
    parser.add_argument("--dry-run", action="store_true", help="Print prompts without generating")
    parser.add_argument("--seed", type=int, default=42, help="Random seed for reproducibility")
    args = parser.parse_args()

    os.makedirs(OUTPUT_DIR, exist_ok=True)
    tasks = build_task_list(args)

    if args.start > 1:
        tasks = tasks[args.start - 1:]
        print(f"Starting from asset #{args.start}")

    print(f"Total assets to generate: {len(tasks)}")
    print()

    if args.dry_run:
        for i, (save_path, prompt, w, h) in enumerate(tasks):
            num = i + args.start
            rel = os.path.relpath(save_path, OUTPUT_DIR)
            print(f"[{num}] [{w}x{h}] {rel}")
            print(f"  {prompt[:120]}...")
            print()
        return

    asyncio.run(run(args, tasks))


if __name__ == "__main__":
    main()
