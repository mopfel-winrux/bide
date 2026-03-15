import { useGame } from '../context/GameContext';
import { EquipmentSlotGrid } from '../components/EquipmentSlotGrid';
import { AutoEatConfig } from '../components/AutoEatConfig';
import type { EquipmentSlot, ItemId } from '../shared/types';

const EQUIPPABLE_SLOTS: EquipmentSlot[] = ['helmet', 'platebody', 'weapon', 'shield', 'cape'];
const SLOT_LABELS: Record<EquipmentSlot, string> = {
  helmet: 'Helmet',
  platebody: 'Platebody',
  weapon: 'Weapon',
  shield: 'Shield',
  cape: 'Cape',
};

export function EquipmentPage() {
  const { defs, state, equip, unequip, summonFamiliar, dismissFamiliar, setPet } = useGame();

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

          {/* Pets */}
          <div className="mt-6">
            <h2 className="text-sm font-semibold uppercase tracking-wider text-gray-500 mb-3">Pets</h2>
            {defs.pets && Object.keys(defs.pets).length > 0 ? (
              <div className="space-y-2">
                {state.activePet && defs.pets[state.activePet] && (
                  <div className="bg-[#111827] border border-amber-600/50 rounded-lg p-4 mb-3">
                    <div className="flex items-center justify-between mb-1">
                      <div className="text-sm text-gray-200 font-medium">
                        {defs.pets[state.activePet].name}
                        <span className="text-amber-500 text-xs ml-2">Active</span>
                      </div>
                      <button
                        onClick={() => setPet(null)}
                        className="px-3 py-1 rounded text-xs font-medium bg-red-900/50 hover:bg-red-800/50 text-red-300 cursor-pointer transition-colors"
                      >
                        Remove
                      </button>
                    </div>
                    <div className="text-xs text-green-400">
                      {defs.pets[state.activePet].effects.map((e) => {
                        if (e.type === 'xp-skill') return `+${e.pct}% ${e.skill} XP`;
                        if (e.type === 'xp-global') return `+${e.pct}% All XP`;
                        if (e.type === 'gp-bonus') return `+${e.pct}% GP`;
                        if (e.type === 'speed-bonus') return `+${e.pct}% Speed`;
                        if (e.type === 'farming-yield') return `+${e.pct}% Farming Yield`;
                        return '';
                      }).filter(Boolean).join(' | ')}
                    </div>
                  </div>
                )}
                <div className="grid grid-cols-2 gap-2">
                  {Object.entries(defs.pets).map(([pid, pdef]) => {
                    const found = state.petsFound?.includes(pid);
                    const isActive = state.activePet === pid;
                    return (
                      <div
                        key={pid}
                        className={`bg-[#111827] border rounded-lg px-3 py-2 ${
                          found ? 'border-[#1e293b]' : 'border-[#1e293b] opacity-40'
                        } ${isActive ? 'ring-1 ring-amber-600' : ''}`}
                      >
                        <div className="text-sm text-gray-200">{found ? pdef.name : '???'}</div>
                        {found && !isActive && (
                          <button
                            onClick={() => setPet(pid)}
                            className="mt-1 px-2 py-0.5 rounded text-xs font-medium bg-amber-600 hover:bg-amber-500 text-gray-100 cursor-pointer transition-colors"
                          >
                            Set Active
                          </button>
                        )}
                        {found && (
                          <div className="text-[11px] text-gray-500 mt-1">
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
          const xpLines: [string, number][] = [];
          if (m.xpGlobal > 0) xpLines.push(['Global XP', m.xpGlobal]);
          if (m.xpGathering > 0) xpLines.push(['Gathering XP', m.xpGathering]);
          if (m.xpArtisan > 0) xpLines.push(['Artisan XP', m.xpArtisan]);
          if (m.xpCombat > 0) xpLines.push(['Combat XP', m.xpCombat]);
          for (const [sid, pct] of Object.entries(m.xpPerSkill)) {
            if (pct > 0) {
              const skillName = defs.skills[sid]?.name ?? sid;
              xpLines.push([`${skillName} XP`, pct]);
            }
          }

          const combatLines: [string, number][] = [];
          if (m.atkBoost > 0) combatLines.push(['Melee Attack', m.atkBoost]);
          if (m.strBoost > 0) combatLines.push(['Melee Strength', m.strBoost]);
          if (m.defBoost > 0) combatLines.push(['Defence', m.defBoost]);
          if (m.rangedBoost > 0) combatLines.push(['Ranged', m.rangedBoost]);
          if (m.magicBoost > 0) combatLines.push(['Magic', m.magicBoost]);

          const otherLines: [string, number][] = [];
          if (m.speedBonus > 0) otherLines.push(['Action Speed', m.speedBonus]);
          if (m.farmingYield > 0) otherLines.push(['Farming Yield', m.farmingYield]);
          if (m.gpBonus > 0) otherLines.push(['GP Bonus', m.gpBonus]);

          const protLines: [string, number][] = [];
          if (m.protectMelee > 0) protLines.push(['Melee Protection', m.protectMelee]);
          if (m.protectRanged > 0) protLines.push(['Ranged Protection', m.protectRanged]);
          if (m.protectMagic > 0) protLines.push(['Magic Protection', m.protectMagic]);

          const hasAny = xpLines.length > 0 || combatLines.length > 0 || otherLines.length > 0 || protLines.length > 0;

          if (!hasAny) {
            return <div className="text-sm text-gray-500">No active modifiers</div>;
          }

          return (
            <div className="bg-[#111827] border border-[#1e293b] rounded-lg p-4">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-x-8 gap-y-4">
                {xpLines.length > 0 && (
                  <div>
                    <h3 className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">XP Bonuses</h3>
                    <div className="space-y-1">
                      {xpLines.map(([label, pct]) => (
                        <div key={label} className="flex justify-between text-sm">
                          <span className="text-gray-400">{label}</span>
                          <span className="text-emerald-400 font-medium">+{pct}%</span>
                        </div>
                      ))}
                    </div>
                  </div>
                )}
                {combatLines.length > 0 && (
                  <div>
                    <h3 className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">Combat Boosts</h3>
                    <div className="space-y-1">
                      {combatLines.map(([label, pct]) => (
                        <div key={label} className="flex justify-between text-sm">
                          <span className="text-gray-400">{label}</span>
                          <span className="text-red-400 font-medium">+{pct}%</span>
                        </div>
                      ))}
                    </div>
                  </div>
                )}
                {otherLines.length > 0 && (
                  <div>
                    <h3 className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">Other</h3>
                    <div className="space-y-1">
                      {otherLines.map(([label, pct]) => (
                        <div key={label} className="flex justify-between text-sm">
                          <span className="text-gray-400">{label}</span>
                          <span className="text-amber-400 font-medium">+{pct}%</span>
                        </div>
                      ))}
                    </div>
                  </div>
                )}
                {protLines.length > 0 && (
                  <div>
                    <h3 className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">Protection</h3>
                    <div className="space-y-1">
                      {protLines.map(([label, pct]) => (
                        <div key={label} className="flex justify-between text-sm">
                          <span className="text-gray-400">{label}</span>
                          <span className="text-blue-400 font-medium">-{pct}%</span>
                        </div>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            </div>
          );
        })()}
      </div>
    </div>
  );
}
