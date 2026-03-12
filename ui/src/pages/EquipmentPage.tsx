import { useGame } from '../context/GameContext';
import { EquipmentSlotGrid } from '../components/EquipmentSlotGrid';
import { AutoEatConfig } from '../components/AutoEatConfig';
import type { EquipmentSlot, ItemId } from '../shared/types';

const EQUIPPABLE_SLOTS: EquipmentSlot[] = ['helmet', 'platebody', 'weapon', 'shield'];
const SLOT_LABELS: Record<EquipmentSlot, string> = {
  helmet: 'Helmet',
  platebody: 'Platebody',
  weapon: 'Weapon',
  shield: 'Shield',
};

export function EquipmentPage() {
  const { defs, state, equip, unequip } = useGame();

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
          <div className="mt-4 bg-[#111827] border border-[#374151] rounded-lg p-4">
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
                  <div key={item} className="flex items-center justify-between bg-[#111827] border border-[#374151] rounded-lg px-4 py-2">
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
        </div>
      </div>
    </div>
  );
}
