import { useGame } from '../../context/GameContext';
import { fmtGP, fmt } from '../../shared/format';

export function TopBar() {
  const { state, defs } = useGame();

  let statusText = '';
  let isActive = false;
  if (state?.activeAction) {
    isActive = true;
    const aa = state.activeAction;
    if (aa.type === 'skilling') {
      const skillName = defs?.skills[aa.skill]?.name ?? aa.skill;
      const actionName = defs?.skills[aa.skill]?.actions.find((a) => a.id === aa.target)?.name ?? aa.target;
      statusText = `${skillName}: ${actionName}`;
    } else if (aa.type === 'combat') {
      const monsterName = defs?.monsters[aa.monster]?.name ?? aa.monster;
      statusText = `Fighting ${monsterName}`;
    } else if (aa.type === 'dungeon') {
      const dungeonName = defs?.dungeons?.[aa.dungeon]?.name ?? aa.dungeon;
      statusText = `Dungeon: ${dungeonName}`;
    }
  }

  return (
    <div className="fixed top-0 left-0 right-0 h-14 bg-[#0d1117]/95 backdrop-blur-sm border-b border-[#1e293b] z-[100]">
      <div className="flex items-center h-full px-6 gap-6">
        {/* Brand */}
        <div className="shrink-0 flex items-center gap-2">
          <span className="text-[18px] font-bold tracking-[0.12em] uppercase text-amber-500">Bide</span>
        </div>

        {/* Status */}
        <div className="flex-1 min-w-0">
          {isActive ? (
            <div className="flex items-center gap-2 text-[13px] text-gray-400">
              <span className="w-1.5 h-1.5 rounded-full bg-amber-500 animate-[status-pulse_2s_ease-in-out_infinite] shrink-0" />
              <span className="truncate">{statusText}</span>
            </div>
          ) : (
            <span className="text-[13px] text-gray-600">Idle</span>
          )}
        </div>

        {/* Stats */}
        {state && (
          <div className="flex items-center gap-4 shrink-0">
            <div className="flex items-center gap-1.5 text-[13px]">
              <span className="text-yellow-500/80 font-medium">{fmtGP(state.gp)}</span>
              <span className="text-gray-600 text-[11px]">GP</span>
            </div>
            <div className="w-px h-4 bg-[#1e293b]" />
            <div className="flex items-center gap-1.5 text-[13px]">
              <span className="text-gray-300 font-medium">{fmt(state.hp)}</span>
              <span className="text-gray-600">/</span>
              <span className="text-gray-500">{fmt(state.hpMax)}</span>
              <span className="text-gray-600 text-[11px]">HP</span>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
