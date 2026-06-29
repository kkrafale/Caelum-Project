<div align="center">

<h1>🌊 LakeOS</h1>

<p><strong>A clean, curated Linux experience — built on Debian, shaped by the community.</strong></p>

<p>
  <img src="https://img.shields.io/badge/base-Debian-red?style=flat-square&logo=debian" />
  <img src="https://img.shields.io/badge/status-in%20development-yellow?style=flat-square" />
  <img src="https://img.shields.io/badge/license-MIT-blue?style=flat-square" />
  <img src="https://img.shields.io/badge/contributions-welcome-brightgreen?style=flat-square" />
</p>

</div>

---

## 🗺️ What is LakeOS?

LakeOS is a community-driven Linux distribution based on **Debian**, designed to be stable, approachable, and ready to use right out of the box. We take Debian's rock-solid foundation and layer a curated desktop experience on top of it — with the rough edges smoothed out and the important defaults set right.

Think of it as Debian, but already configured the way a power user would set it up.

*Built by the **Caelum** team.*

---

## ✨ Features (Planned & In Progress)

- 🏗️ **Debian base** — stability and a massive ecosystem of packages
- 🖥️ **Pre-configured Desktop Environment** — clean, fast, and ready to use
- 🔧 **Sane defaults out of the box** — less time configuring, more time computing
- 🐛 **Early bug fixes applied** — known Debian quirks patched before they reach you
- 🧩 **Modular by design** — built to grow with community contributions

---

## 🚧 Current Development Stage

> LakeOS is in its **early bootstrap phase**. Here's what we're currently working on:

| Phase | Status | Description |
|-------|--------|-------------|
| 1. Debian base setup | 🔨 In progress | Pulling minimal Debian base, configuring the core system |
| 2. Desktop Environment | 🔨 In progress | Selecting and configuring the DE |
| 3. Bug fixes & polish | 🔨 In progress | Squashing early-stage issues |
| 4. Installer | 📋 Planned | Custom live ISO + installer |
| 5. Branding | 📋 Planned | Logo, wallpapers, theming |
| 6. First stable release | 📋 Planned | Public release |

We're moving fast. Check back often.

---

## 🤝 Contributing

LakeOS is a team effort and we welcome contributions from everyone. Whether you're a developer, designer, tester, or just someone with good ideas — there's a place for you here.

### How to contribute

1. **Fork** this repository
2. **Create a branch** for your feature or fix:
```bash
   git checkout -b feature/your-feature-name
```
3. **Commit** your changes with a clear message:
```bash
   git commit -m "feat: describe what you did"
```
4. **Push** and open a **Pull Request**

We use [Conventional Commits](https://www.conventionalcommits.org/) for commit messages. Please follow the format — it keeps the history clean and makes changelogs easy to generate.

### What we need right now

- Debian/Linux packaging experience
- Bug testers willing to run early builds
- Shell scripting (setup scripts, post-install automation)
- Designers for branding and theming
- Documentation writers

---

## 🏗️ Project Structure
lakeos/

├── scripts/         # Build and setup automation scripts

├── configs/         # Default configs for DE and system tools

├── patches/         # Patches applied on top of the Debian base

├── docs/            # Project documentation

└── README.md        # You are here

> Structure will evolve as the project grows.

---

## 🧰 Building LakeOS

> ⚠️ Build instructions are a work in progress. This section will be updated as the build process stabilizes.

For now, the general flow is:

```bash
# Clone the repo
git clone https://github.com/kkrafale/Caelum-Project.git
cd Caelum-Project

# Run the base setup script (Debian base + DE configuration)
sudo bash scripts/setup-base.sh
```

Detailed build documentation will live in [`docs/building.md`](docs/building.md).

---

## 📋 Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| CPU | x86-64 dual-core | x86-64 quad-core or better |
| RAM | 2 GB | 4 GB+ |
| Storage | 15 GB | 30 GB+ |
| Architecture | amd64 | amd64 |

---

## 🛣️ Roadmap

- [x] Project kickoff
- [x] Debian base selected
- [ ] First bootable build
- [ ] Desktop Environment integrated and configured
- [ ] Custom live ISO
- [ ] Public alpha release
- [ ] Installer with GUI
- [ ] Official website
- [ ] First stable release

---

## 📜 License

LakeOS is distributed under the **MIT License**. See [`LICENSE`](LICENSE) for the full text.

The Debian base and bundled packages retain their own respective licenses.

---

## 👥 Team

LakeOS is built by **Caelum** — a small team of passionate Linux enthusiasts. Want to join? Open an issue or reach out — we'd love to have you.

---

<div align="center">
  <sub>Made with ❤️ and too many late nights — Caelum Team</sub>
</div>
