import { useState } from 'react';
import { useGame } from '../context/GameContext';
import { MonsterCard } from '../components/MonsterCard';
import { CombatPanel } from '../components/CombatPanel';
import { CombatStyleSelector } from '../components/CombatStyleSelector';
import type { AreaId, MonsterId, CombatStyle } from '../shared/types';

export function CombatPage() {
  const { defs, state, startCombat, stopCombat } = useGame();
  const [selectedArea, setSelectedArea] = useState<AreaId | null>(null);
  const [selectedMonster, setSelectedMonster] = useState<MonsterId | null>(null);
  const [selectedStyle, setSelectedStyle] = useState<CombatStyle>('melee-attack');

  if (!defs || !state) return null;

  const isCombatActive = state.activeAction?.type === 'combat';
  const combatAction = isCombatActive ? state.activeAction : null;

  const areas = Object.entries(defs.areas).sort((a, b) => a[1].levelReq - b[1].levelReq);

  const handleFight = () => {
    if (selectedArea && selectedMonster) {
      startCombat(selectedArea, selectedMonster, selectedStyle);
    }
  };

  // If combat is active, show the combat panel
  if (isCombatActive && combatAction && combatAction.type === 'combat') {
    const monsterDef = defs.monsters[combatAction.monster];
    return (
      <div className="p-6 max-w-4xl">
        <div className="flex items-center justify-between mb-6">
          <h1 className="text-xl font-semibold text-gray-100">Combat</h1>
          <button
            onClick={stopCombat}
            className="px-4 py-2 rounded-lg text-sm font-medium border border-red-500/40 text-red-400 hover:bg-red-500/10 transition-colors cursor-pointer"
          >
            Flee
          </button>
        </div>
        <CombatPanel
          combatAction={combatAction}
          monsterDef={monsterDef}
          playerHp={state.hp}
          playerHpMax={state.hpMax}
        />
      </div>
    );
  }

  return (
    <div className="p-6 max-w-4xl">
      <h1 className="text-xl font-semibold text-gray-100 mb-6">Combat</h1>

      {/* Combat style selector */}
      <div className="mb-6">
        <CombatStyleSelector selected={selectedStyle} onSelect={setSelectedStyle} />
      </div>

      {/* Area selector */}
      <div className="space-y-6">
        {areas.map(([areaId, area]) => {
          const isSelected = selectedArea === areaId;
          return (
            <div key={areaId}>
              <button
                onClick={() => {
                  setSelectedArea(isSelected ? null : areaId);
                  setSelectedMonster(null);
                }}
                className={`w-full text-left px-4 py-3 rounded-lg border transition-colors cursor-pointer ${
                  isSelected
                    ? 'bg-[#1f2937] border-amber-600/50 text-gray-100'
                    : 'bg-[#111827] border-[#374151] text-gray-300 hover:border-gray-500'
                }`}
              >
                <div className="flex items-center justify-between">
                  <span className="font-medium">{area.name}</span>
                  <span className="text-xs text-gray-500">Level {area.levelReq}+</span>
                </div>
              </button>

              {isSelected && (
                <div className="mt-3 grid grid-cols-1 sm:grid-cols-2 gap-3 pl-2">
                  {area.monsters.map((monsterId) => {
                    const monster = defs.monsters[monsterId];
                    if (!monster) return null;
                    const isMonsterSelected = selectedMonster === monsterId;
                    return (
                      <MonsterCard
                        key={monsterId}
                        monsterId={monsterId}
                        monster={monster}
                        selected={isMonsterSelected}
                        onSelect={() => setSelectedMonster(isMonsterSelected ? null : monsterId)}
                        defs={defs}
                      />
                    );
                  })}
                </div>
              )}
            </div>
          );
        })}
      </div>

      {/* Fight button */}
      {selectedArea && selectedMonster && (
        <div className="mt-6">
          <button
            onClick={handleFight}
            className="w-full py-3 rounded-lg bg-amber-600 hover:bg-amber-500 text-gray-100 font-semibold text-sm transition-colors shadow-lg shadow-amber-600/25 cursor-pointer"
          >
            Fight {defs.monsters[selectedMonster]?.name ?? selectedMonster}
          </button>
        </div>
      )}
    </div>
  );
}
