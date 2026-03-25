import { useGame } from '../context/GameContext';
import { EquipmentSlotGrid } from '../components/EquipmentSlotGrid';
import { AutoEatConfig } from '../components/AutoEatConfig';
import type { EquipmentSlot, ItemId } from '../shared/types';

const EQUIPPABLE_SLOTS: EquipmentSlot[] = ['helmet', 'platebody', 'weapon', 'shield', 'cape', 'ammo'];
const SLOT_LABELS: Record<EquipmentSlot, string> = {
  helmet: 'Helmet',
  platebody: 'Platebody',
  weapon: 'Weapon',
  shield: 'Shield',
  cape: 'Cape',
  ammo: 'Ammo',
};

export function EquipmentPage() {
  const { defs, state, equip, unequip, summonFamiliar, dismissFamiliar } = useGame();

  if (!defs || !state) return null;

  // Find equippable items in bank
  const bankEquippable: { item: ItemId; qty: number; slot: EquipmentSlot }[] = [];
  for (const itemId in state.bank) {
    const stats = defs.equipmentStats[itemId];
    if (stats) {
      bankEquippable.push({ item: itemId, qty: state.bank[itemId], slot: stats.slot });
    }
  }

  // Compute total stats from equipment
  let totalAtk = 0, totalStr = 0, totalDef = 0;
  let totalRAtk = 0, totalRStr = 0, totalMAtk = 0, totalMStr = 0;
  for (const slot of EQUIPPABLE_SLOTS) {
    const itemId = state.equipment.slots[slot];
    if (!itemId) continue;
    const stats = defs.equipmentStats[itemId];
    if (!stats) continue;
    totalAtk += stats.attackBonus;
    totalStr += stats.strengthBonus;
    totalDef += stats.defenceBonus;
    totalRAtk += stats.rangedAttackBonus;
    totalRStr += stats.rangedStrengthBonus;
    totalMAtk += stats.magicAttackBonus;
    totalMStr += stats.magicStrengthBonus;
  }

  return (
    <div className="p-6 max-w-4xl">
      <h1 className="text-xl font-semibold text-gray-100 mb-6">Equipment</h1>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Equipped slots */}
        <div>
          <h2 className="text-sm font-semibold uppercase tracking-wider text-gray-500 mb-3">Equipped</h2>
          <EquipmentSlotGrid
            slots={state.equipment.slots}
            defs={defs}
            onUnequip={unequip}
          />

          {/* Stat totals */}
          <div className="mt-4 bg-[#111827] border border-[#1e293b] rounded-lg p-4">
            <h3 className="text-sm font-semibold text-gray-400 mb-2">Total Bonuses</h3>
            <div className="grid grid-cols-2 gap-1 text-sm">
              {totalAtk > 0 && <div className="text-gray-400">Melee Attack: <span className="text-gray-200">+{totalAtk}</span></div>}
              {totalStr > 0 && <div className="text-gray-400">Melee Strength: <span className="text-gray-200">+{totalStr}</span></div>}
              {totalRAtk > 0 && <div className="text-gray-400">Ranged Attack: <span className="text-gray-200">+{totalRAtk}</span></div>}
              {totalRStr > 0 && <div className="text-gray-400">Ranged Strength: <span className="text-gray-200">+{totalRStr}</span></div>}
              {totalMAtk > 0 && <div className="text-gray-400">Magic Attack: <span className="text-gray-200">+{totalMAtk}</span></div>}
              {totalMStr > 0 && <div className="text-gray-400">Magic Strength: <span className="text-gray-200">+{totalMStr}</span></div>}
              <div className="text-gray-400">Defence: <span className="text-gray-200">+{totalDef}</span></div>
            </div>
          </div>
        </div>

        {/* Bank equipment + auto-eat */}
        <div>
          <h2 className="text-sm font-semibold uppercase tracking-wider text-gray-500 mb-3">Bank Equipment</h2>
          {bankEquippable.length === 0 ? (
            <div className="text-sm text-gray-500">No equippable items in bank</div>
          ) : (
            <div className="space-y-2">
              {bankEquippable.map(({ item, qty }) => {
                const itemDef = defs.items[item];
                const stats = defs.equipmentStats[item];
                if (!itemDef || !stats) return null;

                // Check level requirements
                let meetsReqs = true;
                for (const sid in stats.levelReqs) {
                  const needed = stats.levelReqs[sid];
                  const have = state.skills[sid]?.level ?? 1;
                  if (have < needed) meetsReqs = false;
                }

                return (
                  <div key={item} className="flex items-center justify-between bg-[#111827] border border-[#1e293b] rounded-lg px-4 py-2">
                    <div>
                      <div className="text-sm text-gray-200">{itemDef.name} <span className="text-gray-500">x{qty}</span></div>
                      <div className="text-xs text-gray-500">
                        {SLOT_LABELS[stats.slot]}
                        {stats.attackBonus > 0 && ` | Atk +${stats.attackBonus}`}
                        {stats.strengthBonus > 0 && ` | Str +${stats.strengthBonus}`}
                        {stats.rangedAttackBonus > 0 && ` | RAtk +${stats.rangedAttackBonus}`}
                        {stats.rangedStrengthBonus > 0 && ` | RStr +${stats.rangedStrengthBonus}`}
                        {stats.defenceBonus > 0 && ` | Def +${stats.defenceBonus}`}
                      </div>
                    </div>
                    <button
                      onClick={() => equip(item)}
                      disabled={!meetsReqs}
                      className={`px-3 py-1 rounded text-xs font-medium transition-colors ${
                        meetsReqs
                          ? 'bg-amber-600 hover:bg-amber-500 text-gray-100 cursor-pointer'
                          : 'bg-gray-700 text-gray-500 cursor-not-allowed'
                      }`}
                    >
                      Equip
                    </button>
                  </div>
                );
              })}
            </div>
          )}

          <div className="mt-6">
            <AutoEatConfig />
          </div>

          {/* Active Familiar */}
          <div className="mt-6">
            <h2 className="text-sm font-semibold uppercase tracking-wider text-gray-500 mb-3">Familiar</h2>
            {state.activeFamiliar ? (
              <div className="bg-[#111827] border border-[#1e293b] rounded-lg p-4">
                <div className="flex items-center justify-between mb-2">
                  <div className="text-sm text-gray-200">
                    {defs.items[state.activeFamiliar.tablet]?.name ?? state.activeFamiliar.tablet}
                  </div>
                  <button
                    onClick={() => dismissFamiliar()}
                    className="px-3 py-1 rounded text-xs font-medium bg-red-900/50 hover:bg-red-800/50 text-red-300 cursor-pointer transition-colors"
                  >
                    Dismiss
                  </button>
                </div>
                <div className="text-xs text-gray-400">
                  Charges: {state.activeFamiliar.charges}
                </div>
                {defs.familiars[state.activeFamiliar.tablet] && (() => {
                  const f = defs.familiars[state.activeFamiliar.tablet];
                  const bonuses: string[] = [];
                  if (f.gatheringXp > 0) bonuses.push(`+${f.gatheringXp}% Gathering XP`);
                  if (f.artisanXp > 0) bonuses.push(`+${f.artisanXp}% Artisan XP`);
                  if (f.thievingXp > 0) bonuses.push(`+${f.thievingXp}% Thieving XP`);
                  if (f.herbloreXp > 0) bonuses.push(`+${f.herbloreXp}% Herblore XP`);
                  if (f.combatXp > 0) bonuses.push(`+${f.combatXp}% Combat XP`);
                  if (f.allXp > 0) bonuses.push(`+${f.allXp}% All XP`);
                  if (f.atkBoost > 0) bonuses.push(`+${f.atkBoost}% Attack`);
                  if (f.strBoost > 0) bonuses.push(`+${f.strBoost}% Strength`);
                  if (f.defBoost > 0) bonuses.push(`+${f.defBoost}% Defence`);
                  if (f.farmingYield > 0) bonuses.push(`+${f.farmingYield}% Farming Yield`);
                  return (
                    <div className="text-xs text-green-400 mt-1">
                      {bonuses.join(' | ')}
                    </div>
                  );
                })()}
              </div>
            ) : (
              <div className="space-y-2">
                {Object.entries(state.bank)
                  .filter(([id]) => defs.familiars[id])
                  .map(([id, qty]) => (
                    <div key={id} className="flex items-center justify-between bg-[#111827] border border-[#1e293b] rounded-lg px-4 py-2">
                      <div className="text-sm text-gray-200">
                        {defs.items[id]?.name ?? id} <span className="text-gray-500">x{qty}</span>
                      </div>
                      <button
                        onClick={() => summonFamiliar(id)}
                        className="px-3 py-1 rounded text-xs font-medium bg-amber-600 hover:bg-amber-500 text-gray-100 cursor-pointer transition-colors"
                      >
                        Summon
                      </button>
                    </div>
                  ))}
                {Object.entries(state.bank).filter(([id]) => defs.familiars[id]).length === 0 && (
                  <div className="text-sm text-gray-500">No tablets in bank</div>
                )}
              </div>
            )}
          </div>

          {/* Pets — all found pets are always active */}
          <div className="mt-6">
            <h2 className="text-sm font-semibold uppercase tracking-wider text-gray-500 mb-3">Pets</h2>
            {defs.pets && Object.keys(defs.pets).length > 0 ? (
              <div className="space-y-2">
                <div className="grid grid-cols-2 gap-2">
                  {Object.entries(defs.pets).map(([pid, pdef]) => {
                    const found = state.petsFound?.includes(pid);
                    return (
                      <div
                        key={pid}
                        className={`bg-[#111827] border rounded-lg px-3 py-2 ${
                          found ? 'border-green-800/50' : 'border-[#1e293b] opacity-40'
                        }`}
                      >
                        <div className="text-sm text-gray-200">
                          {found ? pdef.name : '???'}
                          {found && <span className="text-green-500 text-xs ml-2">Active</span>}
                        </div>
                        {found && (
                          <div className="text-[11px] text-green-400/70 mt-1">
                            {pdef.effects.map((e) => {
                              if (e.type === 'xp-skill') return `+${e.pct}% ${e.skill} XP`;
                              if (e.type === 'xp-global') return `+${e.pct}% All XP`;
                              if (e.type === 'gp-bonus') return `+${e.pct}% GP`;
                              if (e.type === 'speed-bonus') return `+${e.pct}% Speed`;
                              if (e.type === 'farming-yield') return `+${e.pct}% Yield`;
                              return '';
                            }).filter(Boolean).join(', ')}
                          </div>
                        )}
                      </div>
                    );
                  })}
                </div>
                <div className="text-xs text-gray-500 mt-2">
                  Found: {state.petsFound?.length ?? 0} / {Object.keys(defs.pets).length}
                </div>
              </div>
            ) : (
              <div className="text-sm text-gray-500">No pets available</div>
            )}
          </div>
        </div>
      </div>
      {/* Active Modifiers */}
      <div className="mt-8">
        <h2 className="text-sm font-semibold uppercase tracking-wider text-gray-500 mb-3">Active Modifiers</h2>
        {state.modifiers && (() => {
          const m = state.modifiers;

          // Compute agility penalties from obstacle defs (backend uses unsigned so can't send negatives)
          const pen: Record<string, number> = {};
          const course = state.agilityCourse ?? {};
          const obstacles = defs.obstacles ?? {};
          let chain = 0;
          for (let s = 1; s <= 10; s++) {
            if (course[String(s)]) chain = s; else break;
          }
          for (let s = 1; s <= chain; s++) {
            const od = obstacles[course[String(s)] ?? ''];
            if (!od) continue;
            for (const p of od.penalties) {
              const key = p.type === 'xp-skill' ? `xp-${p.skill}` : p.type;
              pen[key] = (pen[key] ?? 0) + p.pct;
            }
          }

          // Build combined net modifier map: backend value minus agility penalties
          const net: Record<string, number> = {};
          const add = (label: string, category: string, val: number, penKey?: string) => {
            const netVal = val - (penKey ? (pen[penKey] ?? 0) : 0);
            if (netVal !== 0) net[`${category}|${label}`] = netVal;
            // If penalty exists but backend value is 0, show the negative
            if (val === 0 && penKey && (pen[penKey] ?? 0) > 0) {
              net[`${category}|${label}`] = -(pen[penKey]);
            }
          };

          // XP
          add('Global XP', 'xp', m.xpGlobal, 'xp-global');
          add('Gathering XP', 'xp', m.xpGathering);
          add('Artisan XP', 'xp', m.xpArtisan);
          add('Combat XP', 'xp', m.xpCombat);
          // Per-skill XP: merge backend values + penalty keys
          const allXpSkills = new Set([
            ...Object.keys(m.xpPerSkill),
            ...Object.keys(pen).filter(k => k.startsWith('xp-')).map(k => k.slice(3)),
          ]);
          for (const sid of allXpSkills) {
            if (sid === 'global') continue;
            const skillName = defs.skills[sid]?.name ?? sid;
            add(`${skillName} XP`, 'xp', m.xpPerSkill[sid] ?? 0, `xp-${sid}`);
          }

          // Combat
          add('Melee Attack', 'combat', m.atkBoost, 'atk-boost');
          add('Melee Strength', 'combat', m.strBoost, 'str-boost');
          add('Defence', 'combat', m.defBoost, 'def-boost');
          add('Ranged', 'combat', m.rangedBoost, 'ranged-boost');
          add('Magic', 'combat', m.magicBoost, 'magic-boost');

          // Other
          add('Action Speed', 'other', m.speedBonus, 'speed-bonus');
          add('Farming Yield', 'other', m.farmingYield, 'farming-yield');
          add('GP Bonus', 'other', m.gpBonus, 'gp-bonus');
          add('Preservation', 'other', 0, 'preservation');
          add('HP Bonus', 'other', 0, 'hp-bonus');

          // Protection (no penalties apply)
          if (m.protectMelee > 0) net['prot|Melee Protection'] = m.protectMelee;
          if (m.protectRanged > 0) net['prot|Ranged Protection'] = m.protectRanged;
          if (m.protectMagic > 0) net['prot|Magic Protection'] = m.protectMagic;

          const categories = ['xp', 'combat', 'other', 'prot'] as const;
          const catLabels: Record<string, string> = { xp: 'XP', combat: 'Combat', other: 'Other', prot: 'Protection' };
          const entries = Object.entries(net);
          if (entries.length === 0) return <div className="text-sm text-gray-500">No active modifiers</div>;

          return (
            <div className="bg-[#111827] border border-[#1e293b] rounded-lg p-4">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-x-8 gap-y-4">
                {categories.map(cat => {
                  const lines = entries.filter(([k]) => k.startsWith(cat + '|'));
                  if (lines.length === 0) return null;
                  return (
                    <div key={cat}>
                      <h3 className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">{catLabels[cat]}</h3>
                      <div className="space-y-1">
                        {lines.map(([key, val]) => {
                          const label = key.split('|')[1];
                          return (
                            <div key={key} className="flex justify-between text-sm">
                              <span className="text-gray-400">{label}</span>
                              <span className={`font-medium ${val > 0 ? 'text-green-400' : 'text-red-400'}`}>
                                {val > 0 ? '+' : ''}{val}%
                              </span>
                            </div>
                          );
                        })}
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          );
        })()}
      </div>
    </div>
  );
}
