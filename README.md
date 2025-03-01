# backend

```bash
git clone --recursive https://github.com/repooooo/backend.git
```

for update:
```bash
git submodule update --init --recursive
```

for update branches:
```bash
git submodule foreach "
    git fetch origin &&
    git checkout master &&
    git branch --set-upstream-to=origin/master master &&
    git pull
"
```
```bash
git submodule update --remote
```
```bash
git add . && \
git commit -m "Switched all submodules to the master branch"
```

## Project Structure

The project is organized into multiple microservices, each stored as a separate Git submodule within the `microservices/` directory.
```bash
backend/
  └── infrastructure/
      └── common/
          ├── logs/
          └── secrets/
      ├── local/
      └── tests/
  └── microservices/
      ├── auth/
      └── email/
```


### Microservices

- **Authentication Service** (`microservices/auth/`): This submodule contains the authentication service responsible for handling user authentication and authorization.
- **Email Service** (`microservices/email/`): This submodule contains the email service responsible for managing and sending emails.

### Infrastructure

- **Common** (`infrastructure/common/`):
    - **Logs** (`logs/`): : This directory is used for storing logs from all services. Logs are preferably stored in `.log` format.
    - **Secrets** (`secrets/`): This directory is used to store sensitive data such as API keys, passwords, and other secrets.
- **Local** (`infrastructure/local/`): This directory is used for locally running all services during development.
- **Tests** (`infrastructure/tests/`): This directory is used to run all services for subsequent test executions.
