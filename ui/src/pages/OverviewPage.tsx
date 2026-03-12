import { useGame } from '../context/GameContext';
import { ActiveAction } from '../components/ActiveAction';
import { SkillCard } from '../components/SkillCard';
import { fmt } from '../shared/format';
import { SKILL_TYPE_ORDER } from '../shared/constants';

export function OverviewPage() {
  const { defs, state } = useGame();

  if (!defs || !state) return null;

  // Get total level
  const totalLevel = Object.keys(defs.skills).reduce((sum, sid) => {
    const ss = state.skills[sid];
    return sum + (ss?.level ?? 1);
  }, 0);

  const itemCount = state.bank ? Object.keys(state.bank).length : 0;

  // Sort skills by type order
  const skillIds = Object.keys(defs.skills).sort((a, b) => {
    const ta = SKILL_TYPE_ORDER.indexOf(defs.skills[a].type as never);
    const tb = SKILL_TYPE_ORDER.indexOf(defs.skills[b].type as never);
    return ta - tb;
  });

  return (
    <div>
      <h1 className="text-xl font-semibold mb-6">Welcome to Bide</h1>
      <ActiveAction />

      <div className="mb-8">
        <h2 className="text-lg font-semibold mb-5">Skills</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-5">
          {skillIds.map((sid) => (
            <SkillCard key={sid} skillId={sid} />
          ))}
        </div>
      </div>

      <div className="flex flex-wrap gap-8 text-sm text-gray-400">
        <span>Total Level: <span className="font-semibold text-gray-100">{totalLevel}</span></span>
        <span>Gold: <span className="font-semibold text-yellow-500">{fmt(state.gp)} GP</span></span>
        <span>Bank: <span className="font-semibold text-gray-100">{itemCount} / {state.slotsMax} slots</span></span>
      </div>
    </div>
  );
}
