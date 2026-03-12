import { Outlet } from 'react-router-dom';
import { TopBar } from './TopBar';
import { Sidebar } from './Sidebar';
import { MobileNav } from './MobileNav';
import { ToastContainer } from '../ui/ToastContainer';

export function AppShell() {
  return (
    <div className="h-screen overflow-hidden bg-[#0a0e17] text-gray-100">
      <TopBar />
      <div className="flex h-[calc(100vh-3.5rem)] mt-14">
        <Sidebar />
        <main className="flex-1 overflow-auto min-w-0 p-8 pt-10 md:px-12 pb-20 md:pb-10">
          <Outlet />
        </main>
      </div>
      <MobileNav />
      <ToastContainer />
    </div>
  );
}
