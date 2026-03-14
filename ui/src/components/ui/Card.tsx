interface Props {
  children: React.ReactNode;
  active?: boolean;
  locked?: boolean;
  onClick?: () => void;
  className?: string;
}

export function Card({ children, active, locked, onClick, className = '' }: Props) {
  return (
    <div
      onClick={onClick}
      className={`bg-gradient-to-b from-[#111827] to-[#0f1520] border rounded-lg p-5 transition-all duration-200 ${
        active
          ? 'border-amber-600/60 shadow-[0_0_20px_rgba(217,119,6,0.08)] animate-[active-pulse_2.5s_ease-in-out_infinite]'
          : locked
            ? 'border-[#1e293b] opacity-40'
            : 'border-[#1e293b] hover:border-[#475569] hover:bg-[#151d2e] hover:shadow-lg hover:shadow-black/20'
      } ${onClick ? 'cursor-pointer' : ''} ${className}`}
    >
      {children}
    </div>
  );
}
