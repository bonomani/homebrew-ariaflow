# homebrew-ariaflow

Tap for installing ariaflow components with Homebrew.

```bash
brew tap bonomani/ariaflow
```

Install everything:

```bash
brew install ariaflow
```

Or install individually:

```bash
brew install ariaflow-server      # engine/API only
brew install ariaflow-dashboard   # web UI only (can connect to a remote server)
```

Run as services:

```bash
brew services start ariaflow-server
brew services start ariaflow-dashboard
```

Update:

```bash
brew upgrade ariaflow-server
brew upgrade ariaflow-dashboard
```
