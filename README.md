# Bide

An idle RPG for [Urbit](https://urbit.org), inspired by [Melvor Idle](https://melvoridle.com).

Train skills, gather resources, craft equipment, and fight monsters — all running as a Gall agent on your Urbit ship. Your game state lives on your ship, ticking forward even when the UI is closed.

## Features

**17 skills** across four categories:

- **Gathering** — Woodcutting, Fishing, Mining, Thieving
- **Artisan** — Firemaking, Cooking, Smithing, Fletching, Crafting, Runecrafting, Herblore
- **Combat** — Attack, Strength, Defence, Hitpoints, Ranged, Magic

**~120 items** — raw materials, processed goods, equipment, food, runes, potions, gems

**Combat system** — 13 monsters across 6 areas, equipment with stat bonuses, auto-eat, and loot tables

**Mastery** — per-action mastery XP tracking with a mastery pool

## Architecture

```
desk/           Urbit desk (Hoon backend)
  app/bide.hoon   Gall agent — HTTP API, game tick engine, state management
  sur/bide.hoon   Type definitions
  lib/            Data registries (skills, items, monsters, equipment, combat math)
  www/            Built frontend assets

ui/             React frontend
  src/pages/      Overview, Skill, Bank, Combat, Equipment pages
  src/context/    GameContext — state polling, optimistic updates
  src/hooks/      Action timer, toast notifications
  src/components/ UI components
```

The agent runs a 1-second Behn timer loop. Each tick processes the active action — awarding XP, consuming/producing items, or advancing combat. The frontend polls `/state` every second and renders the current game state. Artisan actions use optimistic UI for responsiveness; combat state comes purely from the server.

## Prerequisites

- A running Urbit ship (fakezod works fine)
- Node.js 18+

## Development

### Frontend

```bash
cd ui
npm install
npm run dev
```

This starts Vite on `localhost:5173`. You'll need to proxy API requests to your running ship, or build and serve from the desk.

### Building & deploying to a ship

```bash
# Build the frontend (outputs to desk/www/)
cd ui
npm run build

# Copy the desk to your ship's mount point
cp -r desk/* /path/to/zod/bide/

# In your ship's dojo:
|commit %bide
```

### Project structure

| Path | Purpose |
|------|---------|
| `desk/app/bide.hoon` | Main agent: HTTP routes, game tick, state versioning |
| `desk/sur/bide.hoon` | All type definitions (game-state, actions, monsters, etc.) |
| `desk/lib/bide-skills.hoon` | Skill & action registry (11 non-combat skills, 6 combat) |
| `desk/lib/bide-items.hoon` | Item registry (~120 items) |
| `desk/lib/bide-xp.hoon` | XP-to-level table (99 levels, RuneScape curve) |
| `desk/lib/bide-combat.hoon` | Combat math: PRNG, accuracy, damage, loot rolling |
| `desk/lib/bide-equipment.hoon` | Equipment stats for 28 items |
| `desk/lib/bide-monsters.hoon` | 13 monster definitions with loot tables |
| `desk/lib/bide-areas.hoon` | 6 combat areas grouping monsters by difficulty |
| `desk/lib/bide-food.hoon` | Food healing amounts (11 cooked foods) |
| `ui/src/context/GameContext.tsx` | Central state management, API calls, optimistic updates |
| `ui/src/hooks/useActionTimer.ts` | Client-side action progress bar with RAF |

## API

All endpoints are under `/apps/bide/api/` and require Urbit authentication.

| Method | Path | Description |
|--------|------|-------------|
| GET | `/state` | Full game state (JSON) |
| GET | `/defs` | Static definitions — skills, items, monsters, areas, equipment |
| POST | `/start/<skill>/<action>` | Start a skilling action |
| POST | `/stop` | Stop current action |
| POST | `/sell/<item>/<qty>` | Sell items for GP |
| POST | `/sell-all/<item>` | Sell all of an item |
| POST | `/equip/<item>` | Equip an item from bank |
| POST | `/unequip/<slot>` | Unequip a slot (helmet, platebody, weapon, shield) |
| POST | `/start-combat/<area>/<monster>/<style>` | Start combat |
| POST | `/stop-combat` | Stop combat |
| POST | `/set-auto-eat/<threshold>/<food-or-none>` | Configure auto-eat |

## Tech stack

- **Backend** — Hoon (Gall agent on Urbit)
- **Frontend** — React 19, TypeScript, Tailwind CSS 4, React Router 6, Vite

## License

MIT
