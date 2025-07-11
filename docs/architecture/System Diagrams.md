# BlueLab System Diagrams

This document provides visual representations of BlueLab's architecture and system flows.

## System Overview Diagram

```mermaid
graph TB
    subgraph "User Interaction Layer"
        A[iVentoy Web Form] 
        B[Homepage Dashboard]
        C[Just Commands]
        D[Dockge UI]
    end
    
    subgraph "BlueLab Core System"
        E[First-Boot Service]
        F[Stack Management Engine]
        G[Configuration Manager]
        H[Update Orchestrator]
    end
    
    subgraph "Container Platform"
        I[Docker Engine]
        J[Docker Compose Stacks]
        K[Watchtower]
    end
    
    subgraph "Base OS Layer"
        L[Bluefin-DX]
        M[Fedora Silverblue]
    end
    
    A --> E
    B --> F
    C --> F
    D --> J
    E --> G
    F --> I
    G --> J
    H --> K
    H --> L
    I --> J
    L --> M
```

## First-Boot Configuration Flow

```mermaid
sequenceDiagram
    participant User
    participant iVentoy
    participant System
    participant FirstBoot
    participant Docker
    participant Services
    
    User->>iVentoy: Fill configuration form
    iVentoy->>System: Boot with kernel parameters
    System->>FirstBoot: Trigger first-boot service
    FirstBoot->>FirstBoot: Parse parameters
    FirstBoot->>FirstBoot: Validate inputs
    FirstBoot->>System: Create user accounts
    FirstBoot->>System: Configure Tailscale
    FirstBoot->>Docker: Start Docker service
    FirstBoot->>Services: Deploy selected stacks
    Services->>Services: Configure Homepage
    FirstBoot->>System: Create completion marker
    System->>User: System ready notification
```

## Stack Management Architecture

```mermaid
graph LR
    subgraph "Template System"
        A[Stack Templates]
        B[Environment Templates]
        C[Compose Templates]
    end
    
    subgraph "Management Layer"
        D[Stack Engine]
        E[Port Manager]
        F[Dependency Resolver]
        G[Health Monitor]
    end
    
    subgraph "Runtime Layer"
        H[Running Stacks]
        I[Container Networks]
        J[Persistent Volumes]
    end
    
    A --> D
    B --> D
    C --> D
    D --> E
    D --> F
    E --> H
    F --> H
    D --> G
    H --> I
    H --> J
    G --> H
```

## Network Architecture

```mermaid
graph TB
    subgraph "External Access"
        A[User Devices]
        B[Internet]
    end
    
    subgraph "Network Layer"
        C[Tailscale VPN]
        D[Local Network]
        E[Firewall]
    end
    
    subgraph "BlueLab System"
        F[Host Interface]
        G[Docker Bridge]
        H[Container Networks]
    end
    
    subgraph "Services"
        I[Homepage :80]
        J[Jellyfin :8096]
        K[Dockge :5001]
        L[Grafana :3000]
    end
    
    A --> C
    A --> D
    C --> E
    D --> E
    E --> F
    F --> G
    G --> H
    H --> I
    H --> J
    H --> K
    H --> L
```

## Update Management Flow

```mermaid
flowchart TD
    A[Update Scheduler] --> B{In Update Window?}
    B -->|No| C[Skip Updates]
    B -->|Yes| D[Backup Configurations]
    D --> E[Update Containers]
    E --> F{Container Updates OK?}
    F -->|No| G[Log Error & Stop]
    F -->|Yes| H[Update Base System]
    H --> I[Verify Service Health]
    I --> J{All Services Healthy?}
    J -->|No| K[Rollback System]
    J -->|Yes| L[Update Complete]
    K --> M[Send Alert]
    L --> N[Cleanup Old Images]
```

## Data Flow Architecture

```mermaid
graph LR
    subgraph "Configuration Data"
        A["/var/lib/bluelab/<br/>config.env"]
        B["/var/lib/bluelab/<br/>stacks/*/"]
        C["/var/lib/bluelab/<br/>templates/"]
    end
    
    subgraph "Application Data"
        D["Media Libraries"]
        E["Photo Collections"]
        F["Configuration Backups"]
        G["Database Files"]
    end
    
    subgraph "System Data"
        H["Container Images"]
        I["Docker Volumes"]
        J["System Logs"]
    end
    
    A --> B
    C --> B
    B --> I
    D --> I
    E --> I
    F --> I
    G --> I
    H --> I
```

## Security Layers Diagram

```mermaid
graph TB
    subgraph "Layer 4: Application Security"
        A[Service Authentication]
        B[API Key Management]
        C[Data Encryption]
    end
    
    subgraph "Layer 3: Container Security"
        D[Non-root Containers]
        E[Resource Limits]
        F[Network Isolation]
    end
    
    subgraph "Layer 2: System Security"
        G[Firewall Rules]
        H[SSH Hardening]
        I[Auto Security Updates]
    end
    
    subgraph "Layer 1: Network Security"
        J[Tailscale VPN]
        K[No Internet Exposure]
        L[Certificate Management]
    end
    
    A --> D
    B --> E
    C --> F
    D --> G
    E --> H
    F --> I
    G --> J
    H --> K
    I --> L
```

## Service Discovery Flow

```mermaid
sequenceDiagram
    participant Stack as New Stack
    participant Engine as Stack Engine
    participant Homepage as Homepage
    participant Config as Configuration
    
    Stack->>Engine: Stack deployed
    Engine->>Engine: Scan running containers
    Engine->>Engine: Extract service metadata
    Engine->>Config: Update service registry
    Config->>Homepage: Trigger config regeneration
    Homepage->>Homepage: Parse service definitions
    Homepage->>Homepage: Generate dashboard
    Homepage->>Stack: Display service status
```

## Backup and Recovery Architecture

```mermaid
graph TD
    subgraph "Backup Sources"
        A[Stack Configurations]
        B[Environment Files]
        C[Database Snapshots]
        D[User Data]
    end
    
    subgraph "Backup Process"
        E[Scheduled Backup]
        F[Pre-change Backup]
        G[Manual Backup]
    end
    
    subgraph "Storage Locations"
        H[Local Backup Dir]
        I[External Storage]
        J[Cloud Backup]
    end
    
    subgraph "Recovery Process"
        K[Configuration Restore]
        L[Full System Restore]
        M[Selective Restore]
    end
    
    A --> E
    B --> F
    C --> G
    D --> E
    E --> H
    F --> H
    G --> I
    H --> J
    H --> K
    I --> L
    J --> M
```

## Container Stack Relationships

```mermaid
graph TB
    subgraph "Core Stack (Always Present)"
        A[Homepage]
        B[Dockge]
        C[Grafana]
        D[Prometheus]
        E[Uptime Kuma]
        F[Watchtower]
    end
    
    subgraph "Media Stack"
        G[Jellyfin]
        H[Sonarr]
        I[Radarr]
        J[Deluge]
        K[Jellyseerr]
    end
    
    subgraph "Audio Stack"
        L[Navidrome]
        M[Lidarr]
        N[Podgrab]
    end
    
    subgraph "Other Stacks"
        O[Photos: Immich]
        P[Books: Calibre]
        Q[Productivity: Nextcloud]
        R[SMB: Samba]
    end
    
    A -.-> G
    A -.-> L
    A -.-> O
    A -.-> P
    A -.-> Q
    A -.-> R
    D --> C
    E --> B
    F -.-> G
    F -.-> H
    F -.-> I
```

## Hardware Resource Allocation

```mermaid
pie title CPU Resource Allocation
    "System OS" : 20
    "Core Services" : 30
    "Media Stack" : 25
    "Other Stacks" : 15
    "Reserved" : 10
```

```mermaid
pie title Storage Allocation
    "System" : 50
    "Media Libraries" : 300
    "Photos" : 100
    "Configuration" : 10
    "Backups" : 40
```

## Development Workflow

```mermaid
flowchart TD
    A["Initial Spec"] --> B["BlueBuild Recipe"]
    B --> C["First-Boot Service"]
    C --> D["Basic Stack Deploy"]
    D --> E["Phase 1 Merge"]
    E --> F["All Stacks"]
    F --> G["Dockge Integration"]
    G --> H["Homepage Enhancement"]
    H --> I["Phase 2 Merge"]
    I --> J["Advanced Features"]
    J --> K["Service Discovery"]
    K --> L["Phase 3 Merge"]
    
    subgraph "Main Branch"
        A
        E
        I
        L
    end
    
    subgraph "Phase 1"
        B
        C
        D
    end
    
    subgraph "Phase 2"
        F
        G
        H
    end
    
    subgraph "Phase 3"
        J
        K
    end
```

These diagrams provide visual representations of BlueLab's architecture, helping developers understand the system's complexity and relationships between components. They serve as both design documentation and implementation guidance.