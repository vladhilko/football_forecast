import { Clock3, History, LogOut, Settings, ShieldCheck, WalletCards } from 'lucide-react'
import type { PropsWithChildren } from 'react'
import { NavLink, useNavigate } from 'react-router-dom'
import type { Player, Wallet } from '../lib/api'
import { api } from '../lib/api'
import { creditsFromMinor } from '../lib/money'
import { queryClient } from '../lib/query'

interface Props extends PropsWithChildren {
  player: Player
  wallet: Wallet
}

export function AppShell({ player, wallet, children }: Props) {
  const navigate = useNavigate()
  const logout = async () => {
    await api.logout()
    queryClient.clear()
    navigate('/login')
  }

  return (
    <div className="app-shell">
      <header className="topbar">
        <NavLink to="/" className="brand" aria-label="ChronoBet home">
          <span className="brand-mark"><Clock3 size={21} /></span>
          <span><strong>CHRONO</strong>BET</span>
          <span className="play-badge">PLAY</span>
        </NavLink>

        <nav className="main-nav" aria-label="Primary navigation">
          <NavLink to="/" end><Clock3 size={17} /> Sportsbook</NavLink>
          <NavLink to="/history"><History size={17} /> History</NavLink>
          <NavLink to="/settings"><Settings size={17} /> Settings</NavLink>
        </nav>

        <div className="account-cluster">
          <div className="wallet-pill" aria-label={`${creditsFromMinor(wallet.balance_minor)} play credits`}>
            <WalletCards size={17} />
            <span><small>Balance</small>{creditsFromMinor(wallet.balance_minor)} <em>CR</em></span>
          </div>
          <div className="player-chip"><ShieldCheck size={16} /><span>{player.display_name}</span></div>
          <button className="icon-button" onClick={logout} aria-label="Sign out"><LogOut size={18} /></button>
        </div>
      </header>
      <main>{children}</main>
    </div>
  )
}
