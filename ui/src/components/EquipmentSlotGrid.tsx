import type { EquipmentSlot, ItemId, GameDefs } from '../shared/types';
import { GameIcon } from './ui/GameIcon';

const SLOTS: { slot: EquipmentSlot; label: string }[] = [
  { slot: 'helmet', label: 'Helmet' },
  { slot: 'platebody', label: 'Platebody' },
  { slot: 'weapon', label: 'Weapon' },
  { slot: 'shield', label: 'Shield' },
  { slot: 'cape', label: 'Cape' },
];

interface EquipmentSlotGridProps {
  slots: Partial<Record<EquipmentSlot, ItemId>>;
  defs: GameDefs;
  onUnequip: (slot: EquipmentSlot) => void;
}

export function EquipmentSlotGrid({ slots, defs, onUnequip }: EquipmentSlotGridProps) {
  return (
    <div className="grid grid-cols-2 gap-3">
      {SLOTS.map(({ slot, label }) => {
        const itemId = slots[slot];
        const itemDef = itemId ? defs.items[itemId] : null;
        const stats = itemId ? defs.equipmentStats[itemId] : null;

        return (
          <div
            key={slot}
            className={`border rounded-lg p-3 min-h-[80px] flex flex-col ${
              itemId
                ? 'bg-[#1a2332] border-amber-600/30'
                : 'bg-[#111827] border-[#1e293b] border-dashed'
            }`}
          >
            <div className="text-[10px] uppercase tracking-wider text-gray-500 mb-1">{label}</div>
            {itemDef ? (
              <>
                <GameIcon category="items" id={itemId!} size={36} className="mb-1" />
                <div className="text-sm text-gray-200 flex-1">{itemDef.name}</div>
                {stats && (
                  <div className="text-[10px] text-gray-500 mt-1">
                    {stats.attackBonus > 0 && `Atk +${stats.attackBonus} `}
                    {stats.strengthBonus > 0 && `Str +${stats.strengthBonus} `}
                    {stats.rangedAttackBonus > 0 && `RAtk +${stats.rangedAttackBonus} `}
                    {stats.defenceBonus > 0 && `Def +${stats.defenceBonus}`}
                  </div>
                )}
                <button
                  onClick={() => onUnequip(slot)}
                  className="mt-2 text-[10px] text-red-400 hover:text-red-300 cursor-pointer"
                >
                  Unequip
                </button>
              </>
            ) : (
              <div className="text-xs text-gray-600 flex-1 flex items-center">Empty</div>
            )}
          </div>
        );
      })}
    </div>
  );
}
