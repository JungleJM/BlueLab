# BlueLab - Your Personal Cloud at Home

> **⚠️ PROJECT STATUS: Phase 1 On Hold (95% Complete)**  
> BlueLab Phase 1 is currently **on hold** due to installer timing issues during the BlueBuild/BlueFin ecosystem transition. Active development has shifted to **Phase 2** in the [BlueLab Stacks repository](https://github.com/JungleJM/BlueLab-Stacks) while we wait for upstream installer stabilization.

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

### Setup Process (3 Hours Total)
1. **Prep** (15 min): Download BlueLab, create USB drive
2. **Install** (30 min active): Boot USB, fill web form, let it work
3. **First Access** (15 min): Open dashboard, start using services
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

### Phase 1: Core Foundation (95% Complete)
- ✅ **BlueBuild Recipe**: Successfully building ISOs
- ✅ **First-Boot System**: Complete automation scripts
- ✅ **Service Templates**: All Docker stack configurations  
- ✅ **CI/CD Pipeline**: Automated ISO generation
- ⚠️ **Installer Timing**: Working through conflicts with system setup

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

- **Development Status**: Not ready for production use
- **Installer Issues**: Timing conflicts during system initial setup
- **Testing Required**: Core functionality needs VM validation
- **Documentation**: Some areas still being completed

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
