import { useGame } from '../context/GameContext';

export function XpDropContainer() {
  const { xpDrops } = useGame();

  return (
    <div className="relative h-0 overflow-visible pointer-events-none">
      {xpDrops.map((drop) => (
        <span
          key={drop.id}
          className={`absolute bottom-1 text-sm font-bold animate-[xp-float_1.2s_ease-out_forwards] pointer-events-none whitespace-nowrap ${
            drop.isItem
              ? 'left-3 text-amber-500 [text-shadow:0_0_6px_rgba(217,119,6,0.5)]'
              : 'right-3 text-green-500 [text-shadow:0_0_6px_rgba(34,197,94,0.5)]'
          }`}
        >
          {drop.text}
        </span>
      ))}
    </div>
  );
}
