# Flyway GitHub Actions Demo

Demo repository showing how to use [Redgate Flyway](https://www.red-gate.com/products/flyway/) with [GitHub Actions](https://github.com/red-gate/flyway-actions) for automated database deployments. Demonstrates both **migration-based** and **state-based** deployment approaches with pre-deployment checks.

## What's Included

### Migration-Based Approach (`flyway/`)

Uses ordered, versioned SQL migration scripts to evolve the database schema incrementally.

#### Migrations (`flyway/migrations/`)

Three sample SQL Server migrations:

- `V001__create_users_table.sql` - Creates a users table
- `V002__create_orders_table.sql` - Creates an orders table
- `V003__add_user_email_index.sql` - Adds an index on user email

Each versioned migration has a corresponding undo migration (`U001`, `U002`, `U003`) that reverses the change.

### State-Based Approach (`flyway-state/`)

Defines the desired database schema as individual object definitions. Flyway compares this schema model against the target database and generates a deployment script to bring it in line.

#### Schema Model (`flyway-state/schemaModel/`)

Object definitions matching the same schema the migrations produce:

```
schemaModel/dbo/
  Tables/
    users.sql           # Users table definition
    orders.sql          # Orders table with FK to users
  Indexes/
    idx_users_email.sql
    idx_orders_user_id.sql
    idx_orders_status.sql
```

### Workflows

#### Migration Workflows

| Workflow | Trigger | What it does |
|----------|---------|--------------|
| **CI - Migration Checks** | PR to `main`, manual | Runs pre-deployment checks against staging. Optionally seeds drift for demo. |
| **Deploy to Staging** | Manual | Runs checks then deploys migrations to staging. |
| **Deploy to Production** | Manual | Runs checks (with approval gate), then deploys to production (with separate approval gate). |
| **Undo Production Migration** | Manual | Undoes the last migration (or down to a specified version) on production. |

#### State Workflows

| Workflow | Trigger | What it does |
|----------|---------|--------------|
| **State: Deploy to Staging** | Manual | Generates deployment script from schema model diff, then deploys to staging. Optionally seeds drift for demo. |
| **State: Deploy to Production** | Manual | Generates deployment script (with approval gate), then deploys to production (with separate approval gate). |

### Pre-deployment Checks

The `checks` and `state/prepare` actions run automatically on every pipeline and include:

- **Drift detection** - Detects out-of-band changes made directly to the database
- **Code review** - Scans SQL for potential issues
- **Deployment changes report** - Preview of schema changes
- **Deployment script review** - Dry run of the actual deploy script

Reports and drift resolution scripts are uploaded as artifacts automatically by the actions.

### Drift Detection Demo

**Migration-based:** Run the **CI - Migration Checks** workflow manually with `seed-drift: true` to see drift detection in action. This:

1. Deploys migrations up to V003
2. Introduces an out-of-band `ALTER TABLE` (simulating someone changing the DB directly)
3. Runs checks, which detect the drift and produce resolution scripts

**State-based:** Run the **State: Deploy to Staging** workflow with `seed-drift: true` for the same demo using the state-based approach. This:

1. Deploys the schema model to the target database
2. Introduces an out-of-band `ALTER TABLE`
3. Runs `state/prepare`, which detects the drift and produces resolution scripts alongside the deployment script

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

Database environments are defined in `flyway/flyway.toml` (migrations) and `flyway-state/flyway.toml` (state-based). Passwords reference environment variables (e.g. `${STAGING_DATABASE_PASSWORD}`) which are set from GitHub secrets at the job level.

## Project Structure

```
flyway/                              # Migration-based project
  flyway.toml                        # Flyway configuration with environment definitions
  migrations/                        # Versioned and undo SQL migration scripts
flyway-state/                        # State-based project
  flyway.toml                        # Flyway configuration with environment definitions
  schemaModel/                       # Desired database schema as object definitions
.github/
  actions/
    setup-demo/                      # Composite action for migration demo setup
    setup-state-demo/                # Composite action for state demo setup
  workflows/
    ci-checks.yml                    # PR checks + drift demo (migrations)
    deploy-staging.yml               # Staging deployment (migrations)
    deploy-production.yml            # Production deployment with approval gates (migrations)
    undo-production.yml              # Production migration undo
    state-deploy-staging.yml         # Staging deployment (state-based)
    state-deploy-production.yml      # Production deployment with approval gates (state-based)
```
