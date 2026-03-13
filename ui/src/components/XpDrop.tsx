import { useGame } from '../context/GameContext';

export function XpDropContainer() {
  const { xpDrops } = useGame();

  if (xpDrops.length === 0) return null;

  return (
    <div className="fixed bottom-16 left-1/2 -translate-x-1/2 z-[199] flex flex-col-reverse items-center gap-0.5 pointer-events-none">
      {xpDrops.map((drop) => (
        <span
          key={drop.id}
          className={`text-[13px] font-bold animate-[xp-float_1.4s_ease-out_forwards] pointer-events-none whitespace-nowrap ${
            drop.isItem
              ? 'text-amber-400 [text-shadow:0_0_8px_rgba(245,158,11,0.4)]'
              : 'text-emerald-400 [text-shadow:0_0_8px_rgba(16,185,129,0.4)]'
          }`}
        >
          {drop.text}
        </span>
      ))}
    </div>
  );
}
