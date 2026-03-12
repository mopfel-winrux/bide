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
      className={`bg-[#111827] border rounded-[10px] p-5 transition-all duration-200 ${
        active
          ? 'border-amber-600 shadow-[0_0_18px_rgba(217,119,6,0.12)] animate-[active-pulse_2s_ease-in-out_infinite]'
          : locked
            ? 'border-[#374151] opacity-45'
            : 'border-[#374151] hover:border-gray-500 hover:shadow-[0_0_12px_rgba(255,255,255,0.03)]'
      } ${onClick ? 'cursor-pointer' : ''} ${className}`}
    >
      {children}
    </div>
  );
}
