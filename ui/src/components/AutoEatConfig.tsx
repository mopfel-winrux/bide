import { useState, useEffect } from 'react';
import { useGame } from '../context/GameContext';
import type { ItemId } from '../shared/types';

export function AutoEatConfig() {
  const { defs, state, setAutoEat } = useGame();

  const [threshold, setThreshold] = useState(50);
  const [food, setFood] = useState<ItemId | null>(null);

  // Sync from server state
  useEffect(() => {
    if (state?.equipment) {
      setThreshold(state.equipment.autoEatThreshold);
      setFood(state.equipment.selectedFood);
    }
  }, [state?.equipment?.autoEatThreshold, state?.equipment?.selectedFood]);

  if (!defs || !state) return null;

  // Find food items in bank
  const foodItems: { id: ItemId; name: string; heal: number; qty: number }[] = [];
  for (const itemId in state.bank) {
    const heal = defs.foodHealing[itemId];
    if (heal) {
      foodItems.push({
        id: itemId,
        name: defs.items[itemId]?.name ?? itemId,
        heal,
        qty: state.bank[itemId],
      });
    }
  }
  foodItems.sort((a, b) => a.heal - b.heal);

  const handleSave = () => {
    setAutoEat(threshold, food);
  };

  return (
    <div className="bg-[#111827] border border-[#374151] rounded-lg p-4">
      <h3 className="text-sm font-semibold text-gray-400 mb-3">Auto-Eat</h3>

      <div className="space-y-3">
        <div>
          <label className="text-xs text-gray-500 block mb-1">
            Eat when HP below {threshold}%
          </label>
          <input
            type="range"
            min={0}
            max={100}
            step={5}
            value={threshold}
            onChange={(e) => setThreshold(Number(e.target.value))}
            className="w-full accent-amber-600"
          />
        </div>

        <div>
          <label className="text-xs text-gray-500 block mb-1">Food</label>
          <select
            value={food ?? ''}
            onChange={(e) => setFood(e.target.value || null)}
            className="w-full bg-[#1f2937] border border-[#374151] rounded px-2 py-1.5 text-sm text-gray-300"
          >
            <option value="">None</option>
            {foodItems.map((f) => (
              <option key={f.id} value={f.id}>
                {f.name} (heals {f.heal}, x{f.qty})
              </option>
            ))}
          </select>
        </div>

        <button
          onClick={handleSave}
          className="w-full py-1.5 rounded text-xs font-medium bg-amber-600 hover:bg-amber-500 text-gray-100 transition-colors cursor-pointer"
        >
          Save
        </button>
      </div>
    </div>
  );
}
