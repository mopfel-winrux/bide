import { NavLink } from 'react-router-dom';
import { useGame } from '../../context/GameContext';
import { Badge } from '../ui/Badge';
import { GameIcon } from '../ui/GameIcon';
import { SKILL_TYPE_ORDER, SKILL_TYPE_LABELS, SKILL_TYPE_COLORS } from '../../shared/constants';
import type { SkillType } from '../../shared/types';

const COMBAT_SKILLS = new Set(['attack', 'strength', 'defence', 'hitpoints', 'ranged', 'magic']);
const CUSTOM_ROUTES: Record<string, string> = { farming: '/farming' };

export function Sidebar() {
  const { defs, state, getDisplaySkill } = useGame();
  const hasReadyPlots = state?.farmPlots?.some(p => p?.ready) ?? false;

  if (!defs) return null;

  const groups: Record<string, string[]> = {};
  for (const type of SKILL_TYPE_ORDER) {
    groups[type] = [];
  }
  for (const sid in defs.skills) {
    const type = defs.skills[sid].type;
    if (!groups[type]) groups[type] = [];
    groups[type].push(sid);
  }

  const linkClass = ({ isActive }: { isActive: boolean }) =>
    `flex items-center justify-between px-5 py-2.5 text-[13px] gap-2.5 border-l-2 transition-all duration-150 cursor-pointer ${
      isActive
        ? 'bg-[#131b2e] text-gray-100 border-l-amber-500'
        : 'text-gray-500 border-l-transparent hover:bg-[#0d1117] hover:text-gray-300'
    }`;

  return (
    <nav className="bg-[#0d1117] border-r border-[#1e293b] overflow-y-auto py-4 hidden md:block w-[220px] shrink-0">
      <div className="flex flex-col">
        <NavLink to="/" end className={linkClass}>
          <span>Overview</span>
        </NavLink>

        {SKILL_TYPE_ORDER.map((type) => {
          const sids = groups[type];
          if (!sids || sids.length === 0) return null;
          const typeColor = SKILL_TYPE_COLORS[type as SkillType];

          return (
            <div key={type} className="mt-4">
              <div className="flex items-center gap-2 px-5 py-1.5 mb-0.5">
                <div className="w-1 h-1 rounded-full" style={{ backgroundColor: typeColor }} />
                <span className="text-[10px] font-semibold uppercase tracking-[0.1em] text-gray-600">
                  {SKILL_TYPE_LABELS[type as SkillType]}
                </span>
              </div>
              {sids.map((sid) => {
                const sd = defs.skills[sid];
                const ds = getDisplaySkill(sid);
                const isCombatSkill = COMBAT_SKILLS.has(sid);
                const linkTo = CUSTOM_ROUTES[sid] ?? (isCombatSkill ? '/combat' : `/skill/${sid}`);
                return (
                  <NavLink key={sid} to={linkTo} className={linkClass}>
                    {({ isActive }) => (
                      <>
                        <GameIcon category="skill-icon" id={sid} size={24} className="shrink-0" />
                        <span className="flex-1">{sd.name}</span>
                        <Badge active={isActive}>{ds.level}</Badge>
                        {sid === 'farming' && hasReadyPlots && (
                          <span className="w-2 h-2 rounded-full bg-green-500 animate-[status-pulse_2s_ease-in-out_infinite]" />
                        )}
                      </>
                    )}
                  </NavLink>
                );
              })}
              {type === 'artisan' && (
                <NavLink to="/skill/magic" className={linkClass}>
                  {({ isActive }) => (
                    <>
                      <GameIcon category="skill-icon" id="magic" size={24} className="shrink-0" />
                      <span className="flex-1">Alt Magic</span>
                      <Badge active={isActive}>{getDisplaySkill('magic').level}</Badge>
                    </>
                  )}
                </NavLink>
              )}
            </div>
          );
        })}

        <div className="mt-4">
          <div className="flex items-center gap-2 px-5 py-1.5 mb-0.5">
            <div className="w-1 h-1 rounded-full bg-gray-600" />
            <span className="text-[10px] font-semibold uppercase tracking-[0.1em] text-gray-600">
              Other
            </span>
          </div>
          <NavLink to="/equipment" className={linkClass}>
            <span>Equipment</span>
          </NavLink>
          <NavLink to="/bank" className={linkClass}>
            <span>Bank</span>
          </NavLink>
          <NavLink to="/shop" className={linkClass}>
            <span>Shop</span>
          </NavLink>
          <NavLink to="/completion" className={linkClass}>
            <span>Completion</span>
          </NavLink>
        </div>
      </div>
    </nav>
  );
}
