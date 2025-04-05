# Usage Examples

## Basic Usage

### Creating and Managing Environments

1. Create a development environment:
```bash
secure_env create --project my_app --name dev --description "Development environment"
```

2. Import variables from a .env file:
```bash
secure_env import env --project my_app --name dev --file .env
```

3. View the environment:
```bash
secure_env info --project my_app --name dev
```

4. Update a value:
```bash
secure_env edit --project my_app --name dev --key API_KEY --value "new_key"
```

5. Export to different formats:
```bash
# Export as .env
secure_env export --project my_app --name dev --format env --output .env

# Export as .properties
secure_env export --project my_app --name dev --format properties --output config.properties

# Export as .xcconfig
secure_env export --project my_app --name dev --format xcconfig --output Debug.xcconfig
```

## Advanced Usage

### Managing Multiple Environments

1. Create multiple environments:
```bash
# Development
secure_env create --project my_app --name dev
secure_env import env --project my_app --name dev --file dev.env

# Staging
secure_env create --project my_app --name staging
secure_env import env --project my_app --name staging --file staging.env

# Production
secure_env create --project my_app --name prod
secure_env import env --project my_app --name prod --file prod.env
```

2. List all environments:
```bash
secure_env env list --project my_app
```

### Working with .xcconfig Files

1. Base configuration:
```xcconfig
# base.xcconfig
BASE_URL = https://api.example.com
ENV = production
API_VERSION = v1
```

2. Environment-specific configuration:
```xcconfig
# dev.xcconfig
#include "base.xcconfig"
ENV = development
DEBUG = true
API_ENDPOINT = $(BASE_URL)/$(ENV)/$(API_VERSION)
```

3. Import with variable substitution:
```bash
secure_env xcconfig --project my_app --name dev --file dev.xcconfig
```

4. View resolved values:
```bash
secure_env env info --project my_app --name dev
```

### Working with .properties Files

1. Create a properties file:
```properties
# config.properties
app.name=My Application
app.version=1.0.0
api.url=https://api.example.com
api.key=secret123
```

2. Import the properties:
```bash
secure_env properties --project my_app --name dev --file config.properties
```

### Multiple File Import

You can import multiple files at once to merge their values:

```bash
secure_env import env --project my_app --name dev \
  --file common.env \
  --file dev.env \
  --file secrets.env
```

```bash
secure_env import properties --project my_app --name dev \
  --file base.properties \
  --file dev.properties
```

```bash
secure_env import xcconfig --project my_app --name dev \
  --file base.xcconfig \
  --file dev.xcconfig
```

The values from later files will override values from earlier files if there are conflicts.
