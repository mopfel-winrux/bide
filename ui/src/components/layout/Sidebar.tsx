import { NavLink } from 'react-router-dom';
import { useGame } from '../../context/GameContext';
import { Badge } from '../ui/Badge';
import { SKILL_TYPE_ORDER, SKILL_TYPE_LABELS } from '../../shared/constants';
import type { SkillType } from '../../shared/types';

export function Sidebar() {
  const { defs, getDisplaySkill } = useGame();

  if (!defs) return null;

  // Group skills by type
  const groups: Record<string, string[]> = {};
  for (const type of SKILL_TYPE_ORDER) {
    groups[type] = [];
  }
  for (const sid in defs.skills) {
    const type = defs.skills[sid].type;
    if (!groups[type]) groups[type] = [];
    groups[type].push(sid);
  }

  return (
    <nav className="bg-[#111827] border-r border-[#374151] overflow-y-auto py-6 hidden md:block w-[240px] shrink-0">
      <div className="flex flex-col">
        <NavLink
          to="/"
          end
          className={({ isActive }) =>
            `flex items-center justify-between px-6 py-2.5 text-sm border-l-[3px] transition-all duration-150 cursor-pointer ${
              isActive
                ? 'bg-[#1f2937] text-gray-100 border-l-amber-600'
                : 'text-gray-400 border-l-transparent hover:bg-[#1f2937] hover:text-gray-100'
            }`
          }
        >
          <span>Overview</span>
        </NavLink>

        {SKILL_TYPE_ORDER.map((type) => {
          const sids = groups[type];
          if (!sids || sids.length === 0) return null;
          return (
            <div key={type} className="mb-4">
              <div className="px-6 pt-5 pb-2 text-[11px] font-semibold uppercase tracking-wider text-gray-500">
                {SKILL_TYPE_LABELS[type as SkillType]}
              </div>
              {sids.map((sid) => {
                const sd = defs.skills[sid];
                const ds = getDisplaySkill(sid);
                return (
                  <NavLink
                    key={sid}
                    to={`/skill/${sid}`}
                    className={({ isActive }) =>
                      `flex items-center justify-between px-6 py-2.5 text-sm border-l-[3px] transition-all duration-150 cursor-pointer ${
                        isActive
                          ? 'bg-[#1f2937] text-gray-100 border-l-amber-600'
                          : 'text-gray-400 border-l-transparent hover:bg-[#1f2937] hover:text-gray-100'
                      }`
                    }
                  >
                    {({ isActive }) => (
                      <>
                        <span className="flex-1">{sd.name}</span>
                        <Badge active={isActive}>{ds.level}</Badge>
                      </>
                    )}
                  </NavLink>
                );
              })}
            </div>
          );
        })}

        <div className="mb-4">
          <div className="px-6 pt-5 pb-2 text-[11px] font-semibold uppercase tracking-wider text-gray-500">
            Other
          </div>
          <NavLink
            to="/bank"
            className={({ isActive }) =>
              `flex items-center justify-between px-6 py-2.5 text-sm border-l-[3px] transition-all duration-150 cursor-pointer ${
                isActive
                  ? 'bg-[#1f2937] text-gray-100 border-l-amber-600'
                  : 'text-gray-400 border-l-transparent hover:bg-[#1f2937] hover:text-gray-100'
              }`
            }
          >
            <span>Bank</span>
          </NavLink>
        </div>
      </div>
    </nav>
  );
}
