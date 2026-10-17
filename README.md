# Chrome-Environment V5.0 (Bypass Protected)

A persistent, cloud-hosted Chrome desktop environment running inside GitHub Codespaces. Designed to bypass restrictive network filters over secure HTTPS tunneling.

---

## 🚀 What's New in V5.0

* **Zero-502 Gateway Architecture:** Expanded shared memory (`--shm-size=2gb`) and privileged execution (`--security-opt seccomp=unconfined`) prevent X11 display server crashes.
* **Auto-Launch & Crash Suppression:** Configured with clean startup flags (`--no-sandbox`, `--disable-dev-shm-usage`, `--hide-crash-restore-bubble`) to open straight into the browser without error popups.
* **Hot-Reload Updates (`update-version`):** Terminal helper pulls from `main` and restarts the container instantly without rebuilding the entire Codespace.
* **HTTPS Network Bypass:** Port `8080` is routed through GitHub's standard public HTTPS domain (`*.app.github.dev`), hiding traffic from local network firewalls.

---

## 🛠️ Quick Start

1. Launch this repository in **GitHub Codespaces**.
2. Run the deployment script in your terminal:
   ```bash
   bash .devcontainer/launch-chrome.sh
