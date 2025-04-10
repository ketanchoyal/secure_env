# Secure Environment Manager

A robust environment management system for handling multiple project configurations.

## Overview

This tool manages environment variables across different projects and environments (flavors) while maintaining security through encryption. It's designed to work seamlessly with CI/CD pipelines while keeping sensitive data secure.

## Key Features

- **Multi-Project Support**: Manage environment variables for multiple projects in a single repository
- **Common Values**: Define shared environment variables that can be reused across projects
- **Environment-Specific Values**: Configure environment-specific values for different deployment stages (dev, staging, prod)
- **Git Integration**: Store encrypted configurations directly in Git
- **Pipeline Ready**: Generate `.env` files during CI/CD pipeline execution
- **Secure Storage**: All sensitive data is encrypted before being committed to Git
- **Version Control**: Track changes to environment configurations
- **Access Control**: Manage who can view/edit environment values

## Structure

```
.
├── projects/
│   ├── project1/
│   │   ├── dev.env.enc
│   │   ├── staging.env.enc
│   │   └── prod.env.enc
│   └── project2/
│       ├── dev.env.enc
│       ├── staging.env.enc
│       └── prod.env.enc
├── common/
│   ├── global.env.enc
│   └── staging.env.enc
└── keys/
    └── .gitignore    # Ignore encryption keys
```

## Security

- Uses industry-standard encryption (AES-256-GCM)
- Encryption keys are never stored in the repository
- Keys are managed through secure key management systems (AWS KMS, HashiCorp Vault, etc.)

## Usage Workflow

1. **Define Common Values**
   - Create shared environment variables used across multiple projects
   - Store in `common/` directory

2. **Project-Specific Configuration**
   - Define project-specific variables
   - Override common values if needed
   - Store in `projects/<project-name>/` directory

3. **CI/CD Integration**
   - Pipeline fetches encryption key from secure storage
   - Decrypts necessary environment files
   - Generates `.env` file for the specific environment
   - Cleans up after deployment

## Access Management

- **Team Members**: Access through encryption keys stored in secure key management
- **CI/CD**: Access through service accounts with limited permissions
- **Audit Trail**: Track who accessed/modified environment configurations

## Best Practices

1. Never commit unencrypted environment files
2. Rotate encryption keys periodically
3. Use different keys for different environments
4. Maintain backup of encryption keys
5. Document all environment variables

## Planned Features

- [x] CLI tool for easy management
- [ ] Web interface for non-technical users
- [ ] Change history and rollback capability
- [ ] Environment variable validation
- [ ] Integration with popular CI/CD platforms

## Requirements

- Git
- Access to secure key management system
- CI/CD pipeline integration capability

## Getting Started

Documentation for setup and usage will be provided in subsequent sections once the implementation begins.

## GUI Application

The GUI application is built with Flutter, providing a cross-platform interface for managing environment configurations.

### GUI Features

- **Project Dashboard**
  - Overview of all projects and their environments
  - Status indicators for encryption state
  - Quick actions for common operations

- **Environment Editor**
  - Side-by-side comparison of different environments
  - Syntax highlighting for environment values
  - Visual diff tool for comparing environments
  - Search and filter capabilities

- **Common Values Management**
  - Drag-and-drop interface for reusing common values
  - Visual indicators for overridden values
  - Bulk edit capabilities

- **Security Features**
  - Biometric authentication support
  - Role-based access control
  - Audit log viewer
  - Key management interface

- **CI/CD Integration**
  - Pipeline status visualization
  - Environment deployment history
  - One-click environment generation
  - Integration with popular CI platforms

### GUI Screenshots

(Screenshots will be added once the implementation is complete)

### System Requirements

- **Windows**: Windows 10 or later
- **macOS**: macOS 10.15 or later
- **Linux**: Ubuntu 20.04 or compatible
- **Memory**: 4GB RAM minimum
- **Storage**: 200MB free space

### Installation

Installation packages will be provided for:
- Windows (.exe installer)
- macOS (.dmg)
- Linux (.deb, .AppImage)
- Snap Store

### Keyboard Shortcuts

| Action | Windows/Linux | macOS |
|--------|--------------|-------|
| New Project | Ctrl+N | ⌘+N |
| Save Changes | Ctrl+S | ⌘+S |
| Encrypt All | Ctrl+E | ⌘+E |
| Search | Ctrl+F | ⌘+F |
| Quick Actions | Ctrl+Space | ⌘+Space |
