import { NavLink, useParams } from 'react-router-dom';
import { useGame } from '../../context/GameContext';

export function MobileNav() {
  const { defs, state } = useGame();
  const params = useParams<{ skillId: string }>();

  // Show the current skill if we're on a skill page, otherwise show active skill
  const activeSkill = state?.activeAction?.type === 'skilling' ? state.activeAction.skill : null;
  const currentSkill = params.skillId
    ?? activeSkill
    ?? null;

  const currentSkillName = currentSkill && defs?.skills[currentSkill]
    ? defs.skills[currentSkill].name
    : 'Skills';

  return (
    <div className="md:hidden fixed bottom-0 left-0 right-0 h-16 bg-[#0d1117]/95 backdrop-blur-sm border-t border-[#1e293b] z-[100] flex items-center justify-around">
      <NavLink
        to="/"
        end
        className={({ isActive }) =>
          `flex flex-col items-center gap-1 text-xs py-2 px-4 ${
            isActive ? 'text-amber-500' : 'text-gray-500'
          }`
        }
      >
        <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
          <path d="M10 2L2 9h3v7h4v-4h2v4h4V9h3L10 2z" />
        </svg>
        Overview
      </NavLink>

      {currentSkill ? (
        <NavLink
          to={`/skill/${currentSkill}`}
          className={({ isActive }) =>
            `flex flex-col items-center gap-1 text-xs py-2 px-4 ${
              isActive ? 'text-amber-500' : 'text-gray-500'
            }`
          }
        >
          <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
            <path d="M10 1l2.5 5.5L18 7.5l-4 4 1 5.5L10 14.5 4.5 17l1-5.5-4-4 5.5-1z" />
          </svg>
          {currentSkillName}
        </NavLink>
      ) : (
        <div className="flex flex-col items-center gap-1 text-xs py-2 px-4 text-gray-600">
          <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
            <path d="M10 1l2.5 5.5L18 7.5l-4 4 1 5.5L10 14.5 4.5 17l1-5.5-4-4 5.5-1z" />
          </svg>
          Skills
        </div>
      )}

      <NavLink
        to="/bank"
        className={({ isActive }) =>
          `flex flex-col items-center gap-1 text-xs py-2 px-4 ${
            isActive ? 'text-amber-500' : 'text-gray-500'
          }`
        }
      >
        <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
          <path d="M3 3h14a1 1 0 011 1v12a1 1 0 01-1 1H3a1 1 0 01-1-1V4a1 1 0 011-1zm1 4v8h12V7H4z" />
        </svg>
        Bank
      </NavLink>
    </div>
  );
}
