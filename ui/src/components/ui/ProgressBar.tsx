interface Props {
  ref?: React.RefObject<HTMLDivElement | null>;
  className?: string;
}

export function ProgressBar({ ref, className = '' }: Props) {
  return (
    <div className={`relative h-2.5 bg-[#0d1117] rounded-full overflow-hidden border border-[#1e293b] ${className}`}>
      <div
        ref={ref}
        className="h-full bg-gradient-to-r from-amber-600 to-amber-400 rounded-full relative"
        style={{ width: '0%', transition: 'none' }}
      >
        <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/15 to-transparent animate-[shimmer_2s_ease-in-out_infinite]" />
      </div>
    </div>
  );
}
