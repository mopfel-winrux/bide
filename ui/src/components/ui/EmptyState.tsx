interface Props {
  children: React.ReactNode;
}

export function EmptyState({ children }: Props) {
  return (
    <div className="flex flex-col items-center justify-center py-16 px-8 text-gray-500 text-center">
      <div className="text-base max-w-[280px]">{children}</div>
    </div>
  );
}
