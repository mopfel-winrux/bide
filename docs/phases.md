# Development Phases

## Completed

### Phase 1 — Skeleton & Infrastructure
Gall agent with `=<` helper core pattern, Eyre HTTP binding, Behn 1-second timer loop, scry endpoints (`/x/state`, `/x/defs`), `state-0` versioned state, type definitions in `sur/bide.hoon`.

### Phase 2 — Woodcutting & Bank
First skill (Woodcutting, 9 tree types), XP system with 99-level RuneScape table (`lib/bide-xp.hoon`), bank with item storage, sell and sell-all for GP, React frontend with Vite, polling-based state sync.

### Phase 3 — Gathering Skills
Added Fishing (12 actions), Mining (12 actions), Thieving (9 NPCs). Introduced data-driven skill/item registries so new skills require only data additions.

### Phase 4 — Processing/Artisan Skills
Added Firemaking, Cooking, Smithing, Fletching, Crafting, Runecrafting, Herblore (7 skills, ~80 actions). Engine extended to consume input items and auto-stop when inputs run out.

### UI Overhaul
Dark theme, smooth client-side timers, optimistic XP/item updates via pending refs, XP drop animations, level-up toast notifications, responsive layout.

---

### Phase 5 — Combat System
Equipment system (4 slots: helmet, platebody, weapon, shield) with stat bonuses. Combat engine with two independent Behn timers (player + enemy), hit/miss/damage calculations, PRNG-based rolls. 13 monsters across 6 areas with loot tables and GP drops. Food consumption with auto-eat threshold. 3 combat styles (melee/ranged/magic) validated against weapon type. 6 combat skills: Attack, Strength, Defence, Hitpoints, Ranged, Magic. Frontend: attack timer bars, damage splats via monotonic counters, HP bars, kill tracking.

### Phase 6 — Advanced Combat
Combat potions (8 potions — attack/strength/defence boosts at 10-15%, instant heal, prayer restore; timed buffs last 50 player attacks, consumed from bank during combat). Prayer system (8 prayers from Thick Skin to Protect from Magic, level 1-43 requirements, drain points per attack, auto-deactivate at 0 points, toggleable during combat). Special attacks (4 weapon specials on ranged bows with energy bar 0-100, +10 per attack, damage/accuracy multipliers). Slayer tasks (task assignment from slayer master based on slayer level, kill tracking with progress bar). Dungeons (3 multi-room dungeons — Goblin Lair/Dark Fortress/Dragons Den, level 10-80, room-by-room progression with reward loot tables rolled on completion). State extracted to `lib/bide-state.hoon` with `versioned-state` union. Debug `%noun` poke for state injection via MCP.

### Phase 7 — Passive Skills
Four new skills providing passive bonuses computed on-the-fly from levels/mastery. Farming (15 seeds — allotment and herb — planted in plots that grow in real-time, 2-8 plots unlocked by farming level, yield RNG with agility/familiar bonuses). Agility (10 obstacle courses, level-based milestones granting XP bonuses to specific skills, action speed reduction at 50/80, farming yield bonus at 70). Astrology (12 constellations each linked to a skill, mastery-based XP bonuses at 100/500/2000 mastery XP, global level bonuses at 25/50/75/99). Summoning (8 tablet recipes crafted from charcoal + materials, familiars with charges providing XP bonuses, combat stat boosts, and farming yield bonuses; charges decrement per action/attack, auto-dismiss at 0). ~30 new items (seeds, crops, tablets), 7 new food items from farming. Seed drops added to thieving NPCs. Eat food and drink instant potions outside combat. Frontend: dedicated FarmingPage with plot grid and timers, milestone/bonus panels on Agility/Astrology/Summoning skill pages, familiar management on Equipment page, Eat/Drink buttons in bank, ingredient/output counts on action cards, notifications moved to bottom-center.

---

## Planned

### Phase 8 — Economy & Polish
- Shop: buy items with GP, stock limits
- Township: idle town-builder minigame
- Alt Magic: crafting spells that consume runes for utility effects
- Pets: rare drops that give small bonuses
- Modifier engine: equipment/prayer/potion/mastery bonuses applied uniformly
- Completion log: track total progress percentage

### Phase 9 — Content Population
- Full item/monster/action data to match content depth
- Balance tuning: XP rates, sell prices, drop rates, combat stats

### Phase 10 — Graphics
- Use MCP skill to generate assets for the game
- Work with the user to capture consistent graphics for all assets

### Phase 11 — Multiplayer
- Peer-to-peer features leveraging Urbit networking
- Guilds: shared goals, group challenges
- Trading between ships
- Leaderboards via scry
