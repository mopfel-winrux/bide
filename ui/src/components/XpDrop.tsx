import { useGame } from '../context/GameContext';

export function XpDropContainer() {
  const { xpDrops } = useGame();

  if (xpDrops.length === 0) return null;

  return (
    <div className="fixed bottom-16 left-1/2 -translate-x-1/2 z-[199] flex flex-col-reverse items-center pointer-events-none">
      {xpDrops.map((drop) => (
        <span
          key={drop.id}
          className={`text-sm font-bold animate-[xp-float_1.2s_ease-out_forwards] pointer-events-none whitespace-nowrap ${
            drop.isItem
              ? 'text-amber-500 [text-shadow:0_0_6px_rgba(217,119,6,0.5)]'
              : 'text-green-500 [text-shadow:0_0_6px_rgba(34,197,94,0.5)]'
          }`}
        >
          {drop.text}
        </span>
      ))}
    </div>
  );
}
