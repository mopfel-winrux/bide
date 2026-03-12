interface Props {
  ref?: React.RefObject<HTMLDivElement | null>;
  className?: string;
}

export function ProgressBar({ ref, className = '' }: Props) {
  return (
    <div className={`relative h-3 bg-[#1f2937] rounded-full overflow-hidden ${className}`}>
      <div
        ref={ref}
        className="h-full bg-gradient-to-r from-amber-700 to-amber-500 rounded-full"
        style={{ width: '0%', transition: 'none' }}
      />
    </div>
  );
}
