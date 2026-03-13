import { useState, useEffect } from 'react';
import { useGame } from '../context/GameContext';
import type { ItemId } from '../shared/types';
import { Button } from '../components/ui/Button';
import { XpBar } from '../components/ui/XpBar';

function formatTime(ms: number): string {
  if (ms <= 0) return 'Ready!';
  const totalSecs = Math.ceil(ms / 1000);
  const mins = Math.floor(totalSecs / 60);
  const secs = totalSecs % 60;
  if (mins > 0) return `${mins}m ${secs}s`;
  return `${secs}s`;
}

export function FarmingPage() {
  const { defs, state, plantSeed, harvestPlot, getDisplaySkill } = useGame();
  const [selectedSeed, setSelectedSeed] = useState<ItemId | null>(null);
  const [, setTick] = useState(0);

  // Tick every second for countdown timers
  useEffect(() => {
    const interval = setInterval(() => setTick((t) => t + 1), 1000);
    return () => clearInterval(interval);
  }, []);

  if (!defs || !state) return null;

  const farmingSkill = getDisplaySkill('farming');
  const farmSeeds = defs.farmSeeds;

  // All seed defs sorted by level
  const allSeeds = Object.entries(farmSeeds)
    .map(([id, def]) => ({ id, ...def }))
    .sort((a, b) => a.level - b.level);

  const now = Date.now();

  return (
    <div className="p-6 max-w-4xl">
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-xl font-semibold text-gray-100">Farming</h1>
        <div className="text-sm text-gray-400">Level {farmingSkill.level}</div>
      </div>

      <div className="mb-6">
        <XpBar xp={farmingSkill.xp} level={farmingSkill.level} />
      </div>

      {/* Farm Plots */}
      <h2 className="text-sm font-semibold uppercase tracking-wider text-gray-500 mb-3">
        Farm Plots
      </h2>
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-8">
        {state.farmPlots.map((plot, idx) => {
          if (!plot) {
            // Empty plot
            return (
              <div
                key={idx}
                className="bg-[#111827] border border-[#374151] rounded-lg p-4 flex flex-col items-center justify-center min-h-[120px]"
              >
                <div className="text-sm text-gray-500 mb-2">Empty Plot</div>
                {selectedSeed && farmSeeds[selectedSeed] && (state.bank[selectedSeed] ?? 0) > 0 && (
                  <Button
                    size="sm"
                    variant="primary"
                    onClick={() => { plantSeed(idx, selectedSeed); }}
                  >
                    Plant
                  </Button>
                )}
              </div>
            );
          }

          // Plot with crop
          const seedDef = farmSeeds[plot.seed];
          const seedName = defs.items[plot.seed]?.name ?? plot.seed;
          const cropName = seedDef ? (defs.items[seedDef.crop]?.name ?? seedDef.crop) : '???';

          // Compute time remaining client-side
          const readyTime = plot.plantedAt + plot.growthTime;
          const remaining = readyTime - now;
          const isReady = plot.ready || remaining <= 0;
          const growthPct = isReady ? 100 : Math.min(100, Math.max(0, ((now - plot.plantedAt) / plot.growthTime) * 100));

          return (
            <div
              key={idx}
              className={`bg-[#111827] border rounded-lg p-4 flex flex-col min-h-[120px] ${
                isReady ? 'border-green-600' : 'border-[#374151]'
              }`}
            >
              <div className="text-sm text-gray-200 mb-1">{seedName}</div>
              <div className="text-xs text-gray-500 mb-2">
                {isReady ? cropName : `Growing ${cropName}...`}
              </div>
              <div className="mt-auto">
                <div className="relative h-3 bg-[#1f2937] rounded-full overflow-hidden mb-2">
                  <div
                    className={`h-full rounded-full transition-[width] duration-1000 ${isReady ? 'bg-green-500' : 'bg-gradient-to-r from-green-700 to-green-500'}`}
                    style={{ width: `${growthPct}%` }}
                  />
                </div>
                {isReady ? (
                  <Button
                    size="sm"
                    variant="start"
                    onClick={() => harvestPlot(idx)}
                    className="w-full"
                  >
                    Harvest
                  </Button>
                ) : (
                  <button
                    disabled
                    className="w-full px-2 py-1.5 rounded text-xs font-medium bg-[#1f2937] text-gray-500 cursor-not-allowed"
                  >
                    {formatTime(remaining)}
                  </button>
                )}
              </div>
            </div>
          );
        })}
      </div>

      {/* Seed Selection */}
      <h2 className="text-sm font-semibold uppercase tracking-wider text-gray-500 mb-3">
        Seeds {selectedSeed && <span className="text-amber-500 normal-case font-normal ml-2">— click an empty plot to plant</span>}
      </h2>
      <div className="space-y-2">
        {allSeeds.map((seed) => {
          const itemDef = defs.items[seed.id];
          const cropName = defs.items[seed.crop]?.name ?? seed.crop;
          const bankQty = state.bank[seed.id] ?? 0;
          const locked = farmingSkill.level < seed.level;
          const isSelected = selectedSeed === seed.id;

          return (
            <div
              key={seed.id}
              className={`flex items-center justify-between bg-[#111827] border rounded-lg px-4 py-3 transition-colors ${
                locked
                  ? 'border-[#374151] opacity-50 cursor-not-allowed'
                  : bankQty === 0
                  ? 'border-[#374151] opacity-60 cursor-not-allowed'
                  : isSelected
                  ? 'border-amber-600 bg-[#1a1f2e] cursor-pointer'
                  : 'border-[#374151] hover:border-gray-500 cursor-pointer'
              }`}
              onClick={() => !locked && bankQty > 0 && setSelectedSeed(isSelected ? null : seed.id)}
            >
              <div className="flex-1">
                <div className="text-sm text-gray-200">
                  {itemDef?.name ?? seed.id}
                  {locked && <span className="text-gray-500 ml-2">(Lvl {seed.level})</span>}
                </div>
                <div className="text-xs text-gray-500">
                  {cropName} | {formatTime(seed.growthTime)} | {seed.xp} XP | Yield {seed.minYield}-{seed.maxYield}
                </div>
              </div>
              <div className="text-sm text-gray-400 ml-4">
                {bankQty > 0 ? `x${bankQty}` : <span className="text-gray-600">0</span>}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
