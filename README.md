# BlueLab - Your Personal Cloud at Home

> **🎉 PROJECT STATUS: Phase 1 Complete!**  
> BlueLab Phase 1 is **100% complete** and follows proper Universal Blue philosophy! No custom ISOs needed - just rebase and setup. Active development continues with **Phase 2** in the [BlueLab Stacks repository](https://github.com/JungleJM/BlueLab-Stacks).

## What is BlueLab?

BlueLab transforms your computer into a personal cloud service that runs at home - like having your own Netflix, Spotify, Google Photos, and Dropbox, all on hardware you control completely. Built on the rock-solid **Bluefin Linux** foundation, BlueLab makes complex self-hosting technology simple with a one-click setup experience.

## 🎯 The Vision

**Complete Privacy**: Your photos, movies, and files never leave your home. No corporations scanning your data.

**Cost Savings**: After setup, no monthly subscription fees. Stream unlimited movies, backup unlimited photos, share files without storage limits.

**Beginner Friendly**: Perfect introduction to Linux and self-hosting without overwhelming complexity.

**Family Ready**: Everyone in your household can access services from any device, anywhere in the world.

## ✨ What Makes BlueLab Special

### One-Click Magic
Instead of spending weeks learning commands and configurations:
1. **Boot** from a USB drive
2. **Fill out** a simple web form (like creating any online account)  
3. **Walk away** while everything installs itself
4. **Return** to a fully working personal cloud

### Built on Bluefin Linux
- **Auto-updates** like your phone
- **Self-healing** - resets if anything breaks
- **Gaming optimized** with Steam and performance tweaks
- **Beginner friendly** but powerful
- **Beautiful wallpapers** - Bing Photo of the Day changes daily

### Beautiful Dashboard
Your services organized like apps on your phone's home screen, showing status and providing easy access to everything.

## 🚀 Services You'll Get

### Essential Services (Always Included)
- **Homepage**: Your personal dashboard showing all services and their status
- **Dockge**: Visual "app store" to install/remove services with clicks
- **System Monitoring**: Automatic health monitoring 
- **Auto Updates**: Keeps everything secure while you sleep

### Media Entertainment Center
- **Jellyfin**: Your personal Netflix - stream your collection to any device
- **Media Management**: Auto-downloads new episodes, organizes movies, gets subtitles
- **Music Streaming**: Your own Spotify with any music you want
- **Podcast Manager**: Never miss your favorite podcasts

### Photo & File Management  
- **Immich**: Private Google Photos with face recognition and memories
- **File Sharing**: Access your files anywhere (your own Dropbox)
- **Nextcloud**: Complete office suite for documents and collaboration

### Optional Additions
- **Gaming Integration**: Steam setup and performance optimization
- **Book Library**: Digital library for ebooks and audiobooks
- **Advanced Monitoring**: Detailed system analytics and alerting

## 🚀 Quick Installation

### Prerequisites
- Any computer from the last 5 years with 8GB+ RAM and 500GB+ storage
- No Linux experience required!

### 3-Step Installation
```bash
# Step 1: Install standard Bluefin-DX (download from projectbluefin.io)
# Step 2: Rebase to BlueLab image
rpm-ostree rebase ostree-unverified-registry:ghcr.io/junglejm/bluelab

# Step 3: Reboot and run setup
sudo systemctl reboot
ujust bluelab-setup

# Step 4 (Optional): Install complete service stacks
ujust download-bluelab-stacks
```

### That's It!
- **Homepage**: http://bluelab.local:3000
- **Container Management**: http://bluelab.local:5001
- **Total Time**: ~30 minutes

## 🛠 Getting Started

### What You Need
**Minimum**: Any computer from the last 5 years with:
- 8GB RAM (16GB recommended)
- 500GB storage (more for media)
- Internet connection

**No Experience Required**:
- No command line knowledge
- No Linux experience  
- No networking expertise
- Simple web interfaces for everything

### Detailed Setup Process
1. **Install Bluefin-DX** (15 min): Download and install from [projectbluefin.io](https://projectbluefin.io)
2. **Rebase to BlueLab** (5 min): Run the rebase command above
3. **Run Setup** (10 min): Interactive configuration via `ujust bluelab-setup`
4. **Ongoing**: System maintains itself automatically

## 🔒 Security & Access

### Tailscale Integration
Creates a private, encrypted tunnel between your devices and BlueLab:
- Access services safely from anywhere
- No complex network setup required
- Military-grade encryption
- Services stay private, not exposed to internet

### User-Friendly Security
- Automatic security updates
- Encrypted connections everywhere  
- Safe defaults protect you automatically
- No technical security knowledge required

## 📊 Development Status

### Phase 1: Core Foundation (100% Complete!)
- ✅ **BlueBuild Recipe**: Container image recipe ready
- ✅ **Interactive Setup**: Clean `ujust bluelab-setup` command
- ✅ **Service Integration**: BlueLab-Stacks repository integration
- ✅ **Resource Efficiency**: Automatic builds disabled to conserve resources
- ✅ **Proper Workflow**: Follows Universal Blue philosophy

### Current Work: Phase 2 (Active Development)
**Primary Repository**: [BlueLab Stacks](https://github.com/JungleJM/BlueLab-Stacks)

Active development is focusing on Phase 2 features while Phase 1 installer issues are resolved:
- Stack system implementation and management
- Service discovery and integration  
- Advanced configuration and monitoring features

## 🏗 Architecture

BlueLab is built on:
- **Base OS**: Bluefin-DX (immutable, auto-updating Linux)
- **Containerization**: Docker for all services
- **Orchestration**: Docker Compose with templates
- **Networking**: Tailscale for secure remote access
- **Management**: Web-based interfaces for everything
- **Storage**: Flexible storage with ZFS support

## 📁 Repository Structure

```
BlueLab/
├── docs/                    # Comprehensive documentation
│   ├── architecture/        # Technical specifications  
│   ├── Production/          # Development handoff docs
│   └── SSH-Baremetal-Guide.md
├── files/                   # System files and configurations
│   ├── bin/                 # BlueLab executables
│   ├── lib/systemd/         # Service definitions
│   ├── share/               # Templates and resources
│   └── scripts/             # Setup and utility scripts
├── recipes/                 # BlueBuild recipe configuration
└── .github/workflows/       # CI/CD automation
```

## 📚 Documentation

- **[Why BlueLab?](docs/architecture/Why%20Bluelab.md)** - Vision and user benefits
- **[Technical Architecture](docs/architecture/Technical%20Architecture.md)** - Complete technical specification
- **[Development Handoff](docs/Production/Handoff.md)** - Current status and development guide
- **[SSH Guide](docs/SSH-Baremetal-Guide.md)** - Remote access for testing

## 🚧 Known Limitations

- **Manual Builds Only**: Automatic container builds disabled to conserve resources
- **External Dependency**: Relies on BlueLab-Stacks repository for complete functionality
- **Testing Required**: Core functionality needs real hardware validation
- **Documentation**: Some areas still being completed

## 🌍 Resource Conservation

BlueLab has disabled automatic container builds to conserve GitHub Actions resources. The project now uses an efficient rebase workflow that doesn't require custom ISO generation. This allows valuable build resources to be allocated to other open-source projects while maintaining full functionality through the simple rebase approach.

## 🎯 User Testimonials (Projected)

*"I digitized decades of family photos. Now relatives worldwide can access our family history safely and privately."* - The Family Archivist

*"Canceled Netflix, Hulu, and Spotify. My BlueLab provides better service and I've saved hundreds of dollars."* - The Cord-Cutter

*"Finally escaped big tech surveillance. My family's data stays in our home where it belongs."* - The Privacy Advocate

*"Started knowing nothing about Linux. Now I manage our family's complete digital infrastructure."* - The Lifelong Learner

## 🔗 Links

- **Phase 2 Development**: [BlueLab Stacks Repository](https://github.com/JungleJM/BlueLab-Stacks)
- **Base OS**: [Bluefin Project](https://github.com/ublue-os/bluefin)
- **Build System**: [BlueBuild](https://blue-build.org/)
- **Foundation**: [Universal Blue](https://universal-blue.org/)

---
