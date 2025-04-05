# Secure Env CLI Documentation

A secure environment variable manager for your projects.

## Installation

```bash
dart pub global activate secure_env
```

## Quick Start

1. Create a new environment:
```bash
secure_env create --project my_project --name dev
```

2. Import environment variables:
```bash
# From .env file
secure_env import env --project my_project --name dev --file .env

# From .properties file
secure_env import properties --project my_project --name dev --file config.properties

# From .xcconfig file
secure_env import xcconfig --project my_project --name dev --file Debug.xcconfig
```

3. View environment info:
```bash
secure_env info --project my_project --name dev
```

## Command Reference

### Environment Management

#### Create Environment
```bash
secure_env create --project <project> --name <name> [--description "description"]
```

#### List Environments
```bash
secure_env list --project <project>
```

#### Show Environment Info
```bash
secure_env info --project <project> --name <name>
```

#### Edit Environment
```bash
secure_env edit --project <project> --name <name> --key API_KEY --value "new_value"
```

#### Export Environment
```bash
secure_env export --project <project> --name <name> [--format env|properties|xcconfig] [--output path/to/file]
```

#### Delete Environment
```bash
secure_env delete --project <project> --name <name>
```

### Import Commands

#### Import .env File
```bash
secure_env import env --project <project> --name <name> --file path/to/.env
```

#### Import .properties File
```bash
secure_env import properties --project <project> --name <name> --file path/to/config.properties
```

#### Import .xcconfig File
```bash
secure_env import xcconfig --project <project> --name <name> --file path/to/Debug.xcconfig
```

### Advanced Features

#### Variable Substitution in .xcconfig
The CLI supports variable substitution in .xcconfig files:

```xcconfig
# base.xcconfig
BASE_URL = https://api.example.com
ENV = production

# app.xcconfig
#include "base.xcconfig"
API_ENDPOINT = $(BASE_URL)/v1
SERVICE_URL = $(BASE_URL)/$(ENV)/api
```

When imported, variables will be properly substituted:
```
BASE_URL = https://api.example.com
ENV = production
API_ENDPOINT = https://api.example.com/v1
SERVICE_URL = https://api.example.com/production/api
```

#### Validation
- Keys cannot be empty or whitespace-only
- Values can be empty or null
- Invalid keys will result in a validation error
