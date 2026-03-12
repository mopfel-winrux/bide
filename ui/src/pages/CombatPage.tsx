import { useState, useEffect } from 'react';
import { useGame } from '../context/GameContext';
import { MonsterCard } from '../components/MonsterCard';
import { CombatPanel } from '../components/CombatPanel';
import { CombatStyleSelector, type WeaponType } from '../components/CombatStyleSelector';
import type { AreaId, MonsterId, CombatStyle, GameDefs, EquipmentState } from '../shared/types';

const DEFAULT_STYLE: Record<WeaponType, CombatStyle> = {
  melee: 'melee-attack',
  ranged: 'ranged',
  magic: 'magic',
};

function getWeaponType(equipment: EquipmentState | undefined, defs: GameDefs): WeaponType {
  const weaponId = equipment?.slots?.weapon;
  if (!weaponId) return 'melee';
  const stats = defs.equipmentStats[weaponId];
  if (!stats) return 'melee';
  if (stats.rangedAttackBonus > 0) return 'ranged';
  if (stats.magicAttackBonus > 0) return 'magic';
  return 'melee';
}

export function CombatPage() {
  const { defs, state, startCombat, stopCombat } = useGame();
  const [selectedArea, setSelectedArea] = useState<AreaId | null>(null);
  const [selectedMonster, setSelectedMonster] = useState<MonsterId | null>(null);
  const [selectedStyle, setSelectedStyle] = useState<CombatStyle>('melee-attack');

  const weaponType = defs && state ? getWeaponType(state.equipment, defs) : 'melee';

  // Auto-select a valid style when weapon type changes
  useEffect(() => {
    setSelectedStyle((prev) => {
      const melee: CombatStyle[] = ['melee-attack', 'melee-strength', 'melee-defence'];
      if (weaponType === 'melee' && melee.includes(prev)) return prev;
      if (weaponType === 'ranged' && prev === 'ranged') return prev;
      if (weaponType === 'magic' && prev === 'magic') return prev;
      return DEFAULT_STYLE[weaponType];
    });
  }, [weaponType]);

  if (!defs || !state) return null;

  const isCombatActive = state.activeAction?.type === 'combat';
  const combatAction = isCombatActive ? state.activeAction : null;

  const areas = Object.entries(defs.areas).sort((a, b) => a[1].levelReq - b[1].levelReq);

  const handleFight = () => {
    if (selectedArea && selectedMonster) {
      startCombat(selectedArea, selectedMonster, selectedStyle);
    }
  };

  // Compute player weapon speed for attack timer bar
  const getWeaponSpeed = (): number => {
    const weaponId = state.equipment?.slots?.weapon;
    if (!weaponId) return 2400; // unarmed kick
    const stats = defs.equipmentStats[weaponId];
    return stats?.attackSpeed || 2400;
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
          weaponSpeed={getWeaponSpeed()}
        />
      </div>
    );
  }

  return (
    <div className="p-6 max-w-4xl">
      <h1 className="text-xl font-semibold text-gray-100 mb-6">Combat</h1>

      {/* Combat style selector */}
      <div className="mb-6">
        <CombatStyleSelector selected={selectedStyle} onSelect={setSelectedStyle} weaponType={weaponType} />
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
