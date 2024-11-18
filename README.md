# backend

```bash
git clone --recursive https://github.com/repooooo/backend.git
```

for update:
```bash
git submodule update --init --recursive
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
      ├── email/
      └── protos/
```


### Microservices

- **Authentication Service** (`microservices/auth/`): This submodule contains the authentication service responsible for handling user authentication and authorization.
- **Email Service** (`microservices/email/`): This submodule contains the email service responsible for managing and sending emails.
- **Protos** (`microservices/protos/`): This submodule contains the Protobuf files that define data structures and APIs for communication between microservices.

### Infrastructure

- **Common** (`infrastructure/common/`):
    - **Logs** (`logs/`): : This directory is used for storing logs from all services. Logs are preferably stored in `.json` format for integration with monitoring systems like Loki and Grafana.
    - **Secrets** (`secrets/`): This directory is used to store sensitive data such as API keys, passwords, and other secrets.
- **Local** (`infrastructure/local/`): This directory is used for locally running all services during development.
- **Tests** (`infrastructure/tests/`): This directory is used to run all services for subsequent test executions.
