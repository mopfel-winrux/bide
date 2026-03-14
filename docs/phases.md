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

### Phase 8 — Economy & Polish
Unified modifier engine (`lib/bide-modifiers.hoon`) replacing scattered bonus calls in `process-skill-tick` and `process-combat-events` with a single `compute-modifiers` gate collecting all sources (agility, astrology, summoning, potions, prayers, pets) into a `modifier-set`. GP Shop (`lib/bide-shop.hoon`) with ~43 buyable items across raw materials, runes, seeds, food, and starter gear. Pet system (`lib/bide-pets.hoon`) with 12 pets as rare drops from skilling and combat (1/1000-1/5000 chance), each providing passive bonuses (+2-3% skill XP, +1-2% global XP, +3% GP, +5% farming yield); pets managed on Equipment page. Completion Log tracking overall progress across skills (99 count), mastery levels, monsters killed, dungeons cleared, and pets found with per-category progress bars and aggregate statistics (total XP/GP/kills/actions/max hit). Alt Magic adding 11 utility spells to the Magic skill — 3 alchemy (convert items to GP via `gp-per-action` field), 4 superheat (smelt without furnace), 4 enchant (upgrade bars to enchanted versions); 4 new enchanted bar items. Mastery tracking visible on SkillPage (pool XP + total levels) and ActionCard (per-action mastery bar). New frontend pages: ShopPage, CompletionPage. New routes: `/shop`, `/completion`, `/skill/magic` (Alt Magic in artisan sidebar section).

### Phase 9 — Combat Spells
Combat magic system allowing spellcasting without a magic weapon. 12 combat spells across 4 tiers (Strike, Bolt, Blast, Surge) defined in `lib/bide-spells.hoon`. `player-spell-attack` arm in `lib/bide-combat.hoon` uses the spell's fixed max hit with magic level for accuracy. Runes consumed per attack from bank; combat auto-stops when runes run out. Spell-based attacks use fixed 3000ms attack speed. Frontend: magic style always available in CombatStyleSelector regardless of weapon; spell selection panel on CombatPage shows rune inventory, castable spells with level/rune requirements, max hit display; fight/dungeon buttons require spell selection when magic is active.

---

### Phase 10 — Balance & Polish
XP rebalance to match Melvor Idle values across all skills (~10x reduction in XP per action, action times adjusted to Melvor standards). Smithing/fletching/crafting/runecrafting/herblore/summoning standardized to uniform action times (2-5s). Mining times scaled to Melvor (5s copper through 120s dragonite). Combat XP scaled to monster HP × 0.4 (10-480 XP range). Farming XP scaled down (8-92 XP) and now multiplied by harvest yield.

Output chance system wired — skill outputs with `chance < 100` are now properly rolled using the `og` PRNG door with `eny.bowl` kernel entropy. All game RNG (`rng-next` in combat, pet drops, farming yield, output rolls) migrated from `mug`-based hashing to stdlib `og` door. Combat seeds mixed with `eny.bowl` at each event for fresh entropy.

Welcome Back modal — frontend localStorage diff shows GP earned, XP/levels gained, monsters killed, items gained/consumed, dungeons completed, and new pets found when returning after >30s away.

Farming fixes: `plantedAt` timestamp converted to Unix epoch (was Urbit epoch, breaking client-side countdown); harvest button shows live countdown timer. Alt Magic sidebar entry now shows magic skill icon.

Frontend optimistic updates fixed to only show guaranteed drops (chance=100) in XP drop animations.

---

## Planned

### Phase 11 — Graphics
- Use MCP skill to generate assets for the game
- Work with the user to capture consistent graphics for all assets

---

## Future Work

### Township
- Idle town-builder minigame with buildings, resources, and upgrades

### Multiplayer
- Peer-to-peer features leveraging Urbit networking
- Guilds: shared goals, group challenges
- Trading between ships
- Leaderboards via scry
