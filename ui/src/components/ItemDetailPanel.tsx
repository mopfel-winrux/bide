import { useState } from 'react';
import { useGame } from '../context/GameContext';
import { GameIcon } from './ui/GameIcon';
import { Button } from './ui/Button';
import { fmt } from '../shared/format';
import { fmtTime } from '../shared/format';
import { CATEGORY_LABELS, CATEGORY_COLORS } from '../shared/constants';
import type { ItemId, ItemCategory } from '../shared/types';

interface Props {
  itemId: ItemId;
  qty: number;
}

const STAT_LABELS: [string, string][] = [
  ['attackBonus', 'Atk'],
  ['strengthBonus', 'Str'],
  ['rangedAttackBonus', 'RAtk'],
  ['rangedStrengthBonus', 'RStr'],
  ['magicAttackBonus', 'MAtk'],
  ['magicStrengthBonus', 'MStr'],
  ['defenceBonus', 'Def'],
];

const FAMILIAR_LABELS: [string, string][] = [
  ['gatheringXp', 'Gathering XP'],
  ['artisanXp', 'Artisan XP'],
  ['thievingXp', 'Thieving XP'],
  ['herbloreXp', 'Herblore XP'],
  ['combatXp', 'Combat XP'],
  ['allXp', 'All XP'],
  ['atkBoost', 'Atk Boost'],
  ['strBoost', 'Str Boost'],
  ['defBoost', 'Def Boost'],
  ['farmingYield', 'Farming Yield'],
];

const CAPE_TYPE_LABELS: Record<string, string> = {
  'xp-skill': 'XP',
  'xp-global': 'Global XP',
  'speed-bonus': 'Speed',
  'atk-boost': 'Attack',
  'str-boost': 'Strength',
  'def-boost': 'Defence',
  'ranged-boost': 'Ranged',
  'magic-boost': 'Magic',
  'farming-yield': 'Farming Yield',
  'gp-bonus': 'GP',
  'protect-all': 'Protection',
};

export function ItemDetailPanel({ itemId, qty }: Props) {
  const { defs, state, sell, sellAll, equip, eatFood, drinkPotion, buryBones, summonFamiliar } = useGame();
  const [sellQty, setSellQty] = useState(1);

  if (!defs || !state) return null;

  const idef = defs.items[itemId];
  if (!idef) return null;

  const name = idef.name;
  const price = idef.sellPrice;
  const category = idef.category as ItemCategory;
  const borderColor = CATEGORY_COLORS[category];

  const eqStats = defs.equipmentStats[itemId];
  const foodHeal = defs.foodHealing[itemId];
  const potionDef = defs.potions[itemId];
  const seedDef = defs.farmSeeds[itemId];
  const familiarDef = defs.familiars[itemId];
  const capeDef = defs.capes[itemId];
  const specialDef = defs.specials[itemId];

  // Check equipment level requirements
  const meetsReqs = eqStats
    ? Object.entries(eqStats.levelReqs).every(([skill, lvl]) => (state.skills[skill]?.level ?? 1) >= lvl)
    : true;

  const clampQty = (n: number) => Math.max(1, Math.min(n, qty));

  return (
    <div className="bg-[#111827] border border-[#1e293b] rounded-lg p-5 flex flex-col gap-4">
      {/* Header */}
      <div className="flex items-start gap-4">
        <div className="shrink-0 rounded-lg bg-[#0d1117] p-2" style={{ borderLeft: `3px solid ${borderColor}` }}>
          <GameIcon category="items" id={itemId} size={72} />
        </div>
        <div className="min-w-0 flex-1">
          <h3 className="text-lg font-bold text-gray-100 leading-tight">{name}</h3>
          <span
            className="inline-block mt-1 px-2 py-0.5 text-[11px] font-medium rounded"
            style={{ backgroundColor: borderColor + '20', color: borderColor }}
          >
            {CATEGORY_LABELS[category]}
          </span>
          <div className="mt-1.5 text-sm text-gray-400">
            Owned: <span className="text-gray-200 font-medium">{fmt(qty)}</span>
          </div>
        </div>
      </div>

      {/* Sell value */}
      {price > 0 && (
        <div className="text-[13px] text-gray-400 flex justify-between border-t border-[#1e293b] pt-3">
          <span>Sell price: <span className="text-yellow-500">{fmt(price)} GP</span></span>
          <span>Total: <span className="text-yellow-500">{fmt(price * qty)} GP</span></span>
        </div>
      )}

      {/* Equipment Stats */}
      {eqStats && (
        <div className="border-t border-[#1e293b] pt-3">
          <h4 className="text-[12px] font-semibold text-gray-500 uppercase tracking-wider mb-2">Equipment</h4>
          <div className="text-[13px] text-gray-400 mb-2">
            Slot: <span className="text-gray-200 capitalize">{eqStats.slot}</span>
          </div>

          {/* Level requirements */}
          {Object.keys(eqStats.levelReqs).length > 0 && (
            <div className="flex flex-wrap gap-x-3 gap-y-1 mb-2 text-[12px]">
              {Object.entries(eqStats.levelReqs).map(([skill, lvl]) => {
                const met = (state.skills[skill]?.level ?? 1) >= lvl;
                return (
                  <span key={skill} className={met ? 'text-gray-400' : 'text-red-400'}>
                    {skill} {lvl}
                  </span>
                );
              })}
            </div>
          )}

          {/* Stats grid */}
          <div className="grid grid-cols-2 gap-x-4 gap-y-1 text-[12px]">
            {STAT_LABELS.map(([key, label]) => {
              const val = (eqStats as any)[key] as number;
              if (val === 0) return null;
              return (
                <div key={key} className="flex justify-between">
                  <span className="text-gray-500">{label}</span>
                  <span className={val > 0 ? 'text-green-400' : 'text-red-400'}>
                    {val > 0 ? '+' : ''}{val}
                  </span>
                </div>
              );
            })}
          </div>

          {/* Attack speed */}
          {eqStats.slot === 'weapon' && eqStats.attackSpeed > 0 && (
            <div className="text-[12px] text-gray-400 mt-1">
              Attack speed: <span className="text-gray-200">{(eqStats.attackSpeed / 1000).toFixed(1)}s</span>
            </div>
          )}

          {/* Special attack */}
          {specialDef && (
            <div className="mt-2 text-[12px] bg-[#0d1117] rounded p-2">
              <span className="text-purple-400 font-medium">{specialDef.name}</span>
              <span className="text-gray-500 ml-2">
                {specialDef.energyCost}% energy · {specialDef.damageMult}x dmg · {specialDef.accuracyMult}x acc
              </span>
            </div>
          )}
        </div>
      )}

      {/* Food */}
      {foodHeal !== undefined && (
        <div className="border-t border-[#1e293b] pt-3">
          <h4 className="text-[12px] font-semibold text-gray-500 uppercase tracking-wider mb-1">Food</h4>
          <div className="text-[13px] text-gray-400">
            Heals <span className="text-emerald-400 font-medium">{fmt(foodHeal)} HP</span>
          </div>
        </div>
      )}

      {/* Potion */}
      {potionDef && (
        <div className="border-t border-[#1e293b] pt-3">
          <h4 className="text-[12px] font-semibold text-gray-500 uppercase tracking-wider mb-1">Potion</h4>
          <div className="text-[13px] text-gray-400 space-y-0.5">
            <div>Effect: <span className="text-teal-400">{potionDef.effectType.replace(/-/g, ' ')}</span></div>
            <div>Magnitude: <span className="text-gray-200">{potionDef.magnitude}</span></div>
            <div>
              {potionDef.duration === 0
                ? <span className="text-teal-400">Instant</span>
                : <span>Duration: <span className="text-gray-200">{potionDef.duration} combat turns</span></span>
              }
            </div>
          </div>
        </div>
      )}

      {/* Seed */}
      {seedDef && (
        <div className="border-t border-[#1e293b] pt-3">
          <h4 className="text-[12px] font-semibold text-gray-500 uppercase tracking-wider mb-1">Seed</h4>
          <div className="text-[13px] text-gray-400 space-y-0.5">
            <div>Farming level: <span className="text-gray-200">{seedDef.level}</span></div>
            <div>Growth time: <span className="text-gray-200">{fmtTime(seedDef.growthTime)}</span></div>
            <div>Crop: <span className="text-gray-200">{defs.items[seedDef.crop]?.name ?? seedDef.crop}</span></div>
            <div>Yield: <span className="text-gray-200">{seedDef.minYield}–{seedDef.maxYield}</span></div>
          </div>
        </div>
      )}

      {/* Familiar */}
      {familiarDef && (
        <div className="border-t border-[#1e293b] pt-3">
          <h4 className="text-[12px] font-semibold text-gray-500 uppercase tracking-wider mb-1">Familiar</h4>
          <div className="text-[13px] text-gray-400 space-y-0.5">
            <div>Charges: <span className="text-gray-200">{familiarDef.charges}</span></div>
            {FAMILIAR_LABELS.map(([key, label]) => {
              const val = (familiarDef as any)[key] as number;
              if (val === 0) return null;
              return (
                <div key={key}>
                  {label}: <span className="text-amber-400">+{val}%</span>
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* Cape */}
      {capeDef && (
        <div className="border-t border-[#1e293b] pt-3">
          <h4 className="text-[12px] font-semibold text-gray-500 uppercase tracking-wider mb-1">Cape</h4>
          <div className="text-[13px] text-gray-400 space-y-0.5">
            <div>Skill: <span className="text-gray-200 capitalize">{capeDef.skill}</span></div>
            {capeDef.bonuses.map((b, i) => (
              <div key={i}>
                {CAPE_TYPE_LABELS[b.type] ?? b.type}
                {b.skill ? ` (${b.skill})` : ''}:
                <span className="text-amber-400 ml-1">+{b.pct}%</span>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Actions */}
      <div className="border-t border-[#1e293b] pt-3 flex flex-col gap-2">
        {/* Context actions */}
        {eqStats && (
          <Button variant="primary" onClick={() => equip(itemId)} disabled={!meetsReqs}>
            {meetsReqs ? 'Equip' : 'Reqs not met'}
          </Button>
        )}
        {foodHeal !== undefined && (
          <Button onClick={() => eatFood(itemId)} className="!bg-emerald-800/50 !text-emerald-300 hover:!bg-emerald-700/50 !border-emerald-700/50">
            Eat
          </Button>
        )}
        {potionDef && potionDef.duration === 0 && (
          <Button onClick={() => drinkPotion(itemId)} className="!bg-teal-800/50 !text-teal-300 hover:!bg-teal-700/50 !border-teal-700/50">
            Drink
          </Button>
        )}
        {potionDef && potionDef.duration > 0 && (
          <div className="text-[12px] text-gray-600 text-center py-1">Use during combat</div>
        )}
        {idef.category === 'bones' && (
          <Button onClick={() => buryBones(itemId)} className="!bg-gray-700/50 !text-gray-300 hover:!bg-gray-600/50 !border-gray-600/50">
            Bury
          </Button>
        )}
        {familiarDef && (
          <Button onClick={() => summonFamiliar(itemId)} className="!bg-amber-800/50 !text-amber-300 hover:!bg-amber-700/50 !border-amber-700/50">
            Summon
          </Button>
        )}

        {/* Sell controls */}
        {price > 0 && (
          <div className="mt-1 space-y-2">
            {/* Variable sell */}
            <div className="flex gap-2">
              <input
                type="number"
                min={1}
                max={qty}
                value={sellQty}
                onChange={(e) => setSellQty(clampQty(Number(e.target.value) || 1))}
                className="w-20 bg-[#0d1117] border border-[#1e293b] rounded px-2 py-1.5 text-[12px] text-gray-200 text-center tabular-nums focus:outline-none focus:border-gray-500"
              />
              <Button className="flex-1" onClick={() => sell(itemId, sellQty)}>
                Sell {fmt(sellQty)} ({fmt(price * sellQty)} GP)
              </Button>
            </div>
            {/* Quick set */}
            <div className="flex gap-1">
              {[1, 10, 100].map((n) => (
                <button
                  key={n}
                  onClick={() => setSellQty(clampQty(n))}
                  className="flex-1 px-1 py-1 text-[11px] text-gray-500 hover:text-gray-300 bg-[#0d1117] rounded border border-[#1e293b] hover:border-[#374151] cursor-pointer transition-colors"
                >
                  {n}
                </button>
              ))}
              <button
                onClick={() => setSellQty(qty)}
                className="flex-1 px-1 py-1 text-[11px] text-gray-500 hover:text-gray-300 bg-[#0d1117] rounded border border-[#1e293b] hover:border-[#374151] cursor-pointer transition-colors"
              >
                All
              </button>
              {qty > 1 && (
                <button
                  onClick={() => setSellQty(qty - 1)}
                  className="flex-1 px-1 py-1 text-[11px] text-gray-500 hover:text-gray-300 bg-[#0d1117] rounded border border-[#1e293b] hover:border-[#374151] cursor-pointer transition-colors"
                >
                  All-1
                </button>
              )}
            </div>
            {/* Sell All / Sell All But 1 */}
            <div className="flex gap-2">
              <Button className="flex-1" onClick={() => sellAll(itemId)}>
                Sell All ({fmt(price * qty)} GP)
              </Button>
              {qty > 1 && (
                <Button className="flex-1" onClick={() => sell(itemId, qty - 1)}>
                  Sell All But 1
                </Button>
              )}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
