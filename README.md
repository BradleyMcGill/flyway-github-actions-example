# Flyway GitHub Actions Demo

Demo repository showing how to use [Redgate Flyway](https://www.red-gate.com/products/flyway/) with [GitHub Actions](https://github.com/red-gate/flyway-actions) for automated database deployments with pre-deployment checks.

## What's Included

### Migrations (`flyway/migrations/`)

Three sample SQL Server migrations:

- `V001__create_users_table.sql` - Creates a users table
- `V002__create_orders_table.sql` - Creates an orders table
- `V003__add_user_email_index.sql` - Adds an index on user email

### Workflows

| Workflow | Trigger | What it does |
|----------|---------|--------------|
| **CI - Migration Checks** | PR to `main`, manual | Runs pre-deployment checks against staging. Optionally seeds drift for demo. |
| **Deploy to Staging** | Manual | Runs checks then deploys migrations to staging. |
| **Deploy to Production** | Manual | Runs checks (with approval gate), then deploys to production (with separate approval gate). |

### Pre-deployment Checks

The `checks` action runs automatically on every pipeline and includes:

- **Drift detection** - Detects out-of-band changes made directly to the database
- **Code review** - Scans migration SQL for potential issues
- **Deployment changes report** - Preview of schema changes the migration will make
- **Deployment script review** - Dry run of the actual deploy script

Reports and drift resolution scripts are uploaded as artifacts automatically by the action.

### Drift Detection Demo

Run the **CI - Migration Checks** workflow manually with `seed-drift: true` to see drift detection in action. This:

1. Deploys migrations up to V003
2. Introduces an out-of-band `ALTER TABLE` (simulating someone changing the DB directly)
3. Runs checks, which detect the drift and produce resolution scripts

## Setup

### GitHub Environments

Create these [environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment) in your repo settings:

| Environment | Purpose |
|-------------|---------|
| `ci` | CI checks on pull requests |
| `staging` | Staging deployment |
| `production-read-only` | Production pre-deployment checks (no approval required, or lighter approval) |
| `production` | Production deployment (add required reviewers for approval gate) |

### GitHub Secrets

| Secret | Purpose |
|--------|---------|
| `FLYWAY_EMAIL` | Flyway Enterprise license email |
| `FLYWAY_TOKEN` | Flyway Enterprise license token |
| `STAGING_DATABASE_PASSWORD` | SA password for the staging service container |
| `PRODUCTION_DATABASE_PASSWORD` | SA password for the production service container |
| `BUILD_DATABASE_PASSWORD` | SA password for the build database and service container |

For this demo, all database password secrets should have the same value since they all connect to an ephemeral SQL Server service container.

### Configuration

Database environments are defined in `flyway/flyway.toml`. Passwords reference environment variables (e.g. `${STAGING_DATABASE_PASSWORD}`) which are set from GitHub secrets at the job level.

## Project Structure

```
flyway/
  flyway.toml              # Flyway configuration with environment definitions
  migrations/              # Versioned SQL migration scripts
.github/
  actions/setup-demo/      # Composite action: creates DBs, installs Flyway, seeds drift
  workflows/
    ci-checks.yml           # PR checks + drift demo
    deploy-staging.yml      # Staging deployment
    deploy-production.yml   # Production deployment with approval gates
```
