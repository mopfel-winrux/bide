interface Props {
  children: React.ReactNode;
  active?: boolean;
  className?: string;
}

export function Badge({ children, active, className = '' }: Props) {
  return (
    <span className={`inline-flex items-center justify-center min-w-[22px] h-5 px-1.5 text-[11px] font-semibold rounded-[10px] ${active ? 'bg-amber-600 text-[#0a0e17]' : 'bg-[#374151] text-gray-400'} ${className}`}>
      {children}
    </span>
  );
}
