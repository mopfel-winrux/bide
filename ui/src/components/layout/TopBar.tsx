import { useGame } from '../../context/GameContext';
import { fmtGP, fmt } from '../../shared/format';

export function TopBar() {
  const { state, defs } = useGame();

  let statusText = 'Idle';
  if (state?.activeAction) {
    const aa = state.activeAction;
    const skillName = defs?.skills[aa.skill]?.name ?? aa.skill;
    const actionName = defs?.skills[aa.skill]?.actions.find((a) => a.id === aa.target)?.name ?? aa.target;
    statusText = `${skillName}: ${actionName}`;
  }

  return (
    <div className="fixed top-0 left-0 right-0 h-14 bg-[#111827] border-b border-[#374151] z-[100]">
      <div className="flex items-center h-full px-6 gap-8">
        <div className="font-bold text-lg tracking-wide text-amber-600 shrink-0">Bide</div>
        <div className="flex gap-6 flex-1">
          {state && (
            <>
              <span className="inline-flex items-center gap-1.5 text-sm text-gray-400">
                <span className="text-gray-500">GP</span>
                <span className="font-semibold text-yellow-500">{fmtGP(state.gp)}</span>
              </span>
              <span className="inline-flex items-center gap-1.5 text-sm text-gray-400">
                <span className="text-gray-500">HP</span>
                <span className="font-semibold text-gray-100">{fmt(state.hp)}/{fmt(state.hpMax)}</span>
              </span>
            </>
          )}
        </div>
        <div className="shrink-0 text-[13px] text-gray-500">{statusText}</div>
      </div>
    </div>
  );
}
