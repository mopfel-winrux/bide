import { useState } from 'react';
import { assetUrl, type AssetCategory } from '../../shared/asset-paths';

interface GameIconProps {
  category: AssetCategory;
  id: string;
  size?: number;
  fallback?: string;
  className?: string;
}

export function GameIcon({ category, id, size = 48, fallback, className = '' }: GameIconProps) {
  const [failed, setFailed] = useState(false);
  const src = assetUrl(category, id);

  if (failed) {
    return (
      <div
        className={`bg-[#0d1117] rounded-md flex items-center justify-center text-gray-600 shrink-0 ${className}`}
        style={{ width: size, height: size, fontSize: size * 0.4 }}
      >
        {fallback ?? id.charAt(0).toUpperCase()}
      </div>
    );
  }

  return (
    <img
      src={src}
      alt={id}
      loading="lazy"
      onError={() => setFailed(true)}
      className={`object-contain shrink-0 ${className}`}
      style={{ width: size, height: size }}
    />
  );
}
