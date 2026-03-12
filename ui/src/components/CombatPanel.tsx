import { useRef, useEffect } from 'react';
import type { ActiveCombatAction, MonsterDef } from '../shared/types';
import { fmt } from '../shared/format';

interface CombatPanelProps {
  combatAction: ActiveCombatAction;
  monsterDef: MonsterDef;
  playerHp: number;
  playerHpMax: number;
}

export function CombatPanel({ combatAction, monsterDef, playerHp, playerHpMax }: CombatPanelProps) {
  const prevEnemyHpRef = useRef(combatAction.enemyHp);
  const prevPlayerHpRef = useRef(playerHp);
  const enemyDmgRef = useRef<HTMLDivElement | null>(null);
  const playerDmgRef = useRef<HTMLDivElement | null>(null);

  // Detect HP changes for damage splats
  useEffect(() => {
    const prevEHp = prevEnemyHpRef.current;
    if (combatAction.enemyHp < prevEHp) {
      const dmg = prevEHp - combatAction.enemyHp;
      showSplat(enemyDmgRef.current, dmg, '#f59e0b');
    }
    prevEnemyHpRef.current = combatAction.enemyHp;
  }, [combatAction.enemyHp]);

  useEffect(() => {
    const prevPHp = prevPlayerHpRef.current;
    if (playerHp < prevPHp) {
      const dmg = prevPHp - playerHp;
      showSplat(playerDmgRef.current, dmg, '#ef4444');
    }
    prevPlayerHpRef.current = playerHp;
  }, [playerHp]);

  const enemyHpPct = monsterDef
    ? Math.max(0, Math.min(100, (combatAction.enemyHp / combatAction.enemyMaxHp) * 100))
    : 0;
  const playerHpPct = playerHpMax > 0 ? Math.max(0, Math.min(100, (playerHp / playerHpMax) * 100)) : 100;

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
      {/* Player */}
      <div className="bg-[#111827] border border-[#374151] rounded-lg p-5">
        <div className="text-sm font-semibold text-gray-400 mb-1">You</div>
        <div className="relative">
          <div className="flex items-center justify-between text-sm mb-1">
            <span className="text-gray-400">HP</span>
            <span className="text-gray-200">{fmt(playerHp)} / {fmt(playerHpMax)}</span>
          </div>
          <div className="h-4 bg-[#1f2937] rounded-full overflow-hidden">
            <div
              className="h-full rounded-full transition-all duration-300"
              style={{
                width: playerHpPct + '%',
                background: playerHpPct > 50 ? '#22c55e' : playerHpPct > 25 ? '#f59e0b' : '#ef4444',
              }}
            />
          </div>
          <div ref={playerDmgRef} className="absolute -top-2 right-0 text-sm font-bold opacity-0 pointer-events-none" />
        </div>
        <div className="mt-3 text-xs text-gray-500">
          Style: <span className="text-gray-400">{formatStyle(combatAction.style)}</span>
        </div>
      </div>

      {/* Enemy */}
      <div className="bg-[#111827] border border-[#374151] rounded-lg p-5">
        <div className="text-sm font-semibold text-red-400 mb-1">{monsterDef?.name ?? combatAction.monster}</div>
        <div className="relative">
          <div className="flex items-center justify-between text-sm mb-1">
            <span className="text-gray-400">HP</span>
            <span className="text-gray-200">{fmt(combatAction.enemyHp)} / {fmt(combatAction.enemyMaxHp)}</span>
          </div>
          <div className="h-4 bg-[#1f2937] rounded-full overflow-hidden">
            <div
              className="h-full bg-red-500 rounded-full transition-all duration-300"
              style={{ width: enemyHpPct + '%' }}
            />
          </div>
          <div ref={enemyDmgRef} className="absolute -top-2 right-0 text-sm font-bold opacity-0 pointer-events-none" />
        </div>
      </div>

      {/* Kill count */}
      <div className="md:col-span-2 bg-[#111827] border border-[#374151] rounded-lg px-5 py-3">
        <div className="flex items-center justify-between">
          <span className="text-sm text-gray-400">Kills</span>
          <span className="text-lg font-semibold text-amber-500">{fmt(combatAction.kills)}</span>
        </div>
      </div>
    </div>
  );
}

function formatStyle(style: string): string {
  return style
    .split('-')
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
    .join(' ');
}

function showSplat(el: HTMLDivElement | null, dmg: number, color: string) {
  if (!el) return;
  el.textContent = '-' + dmg;
  el.style.color = color;
  el.style.opacity = '1';
  el.style.transform = 'translateY(0)';
  el.style.transition = 'none';
  // Force reflow
  void el.offsetHeight;
  el.style.transition = 'all 0.8s ease-out';
  el.style.opacity = '0';
  el.style.transform = 'translateY(-20px)';
}
