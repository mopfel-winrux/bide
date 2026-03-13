import { Routes, Route } from 'react-router-dom';
import { GameProvider, useGame } from './context/GameContext';
import { AppShell } from './components/layout/AppShell';
import { OverviewPage } from './pages/OverviewPage';
import { SkillPage } from './pages/SkillPage';
import { BankPage } from './pages/BankPage';
import { CombatPage } from './pages/CombatPage';
import { EquipmentPage } from './pages/EquipmentPage';
import { FarmingPage } from './pages/FarmingPage';
import { NotFoundPage } from './pages/NotFoundPage';

function ErrorScreen() {
  const { error } = useGame();
  if (!error) return null;
  return (
    <div className="flex items-center justify-center h-screen bg-[#0a0e17] text-gray-100">
      <div className="text-center">
        <p className="text-gray-400">{error}</p>
      </div>
    </div>
  );
}

function LoadingScreen() {
  const { defs, state, error } = useGame();
  if (error || (defs && state)) return null;
  return (
    <div className="flex items-center justify-center h-screen bg-[#0a0e17] text-gray-100">
      <div className="text-gray-500 text-sm">Loading game...</div>
    </div>
  );
}

function AppRoutes() {
  const { defs, state, error } = useGame();

  if (error) return <ErrorScreen />;
  if (!defs || !state) return <LoadingScreen />;

  return (
    <Routes>
      <Route element={<AppShell />}>
        <Route index element={<OverviewPage />} />
        <Route path="skill/:skillId" element={<SkillPage />} />
        <Route path="bank" element={<BankPage />} />
        <Route path="combat" element={<CombatPage />} />
        <Route path="equipment" element={<EquipmentPage />} />
        <Route path="farming" element={<FarmingPage />} />
        <Route path="*" element={<NotFoundPage />} />
      </Route>
    </Routes>
  );
}

export default function App() {
  return (
    <GameProvider>
      <AppRoutes />
    </GameProvider>
  );
}
