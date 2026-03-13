interface Props {
  children: React.ReactNode;
  active?: boolean;
  className?: string;
}

export function Badge({ children, active, className = '' }: Props) {
  return (
    <span className={`inline-flex items-center justify-center min-w-[24px] h-[22px] px-2 text-[11px] font-bold rounded-md tabular-nums ${active ? 'bg-amber-600 text-[#0a0e17]' : 'bg-[#1e293b] text-gray-400'} ${className}`}>
      {children}
    </span>
  );
}
