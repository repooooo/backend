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
- **Local** (`infrastructure/local/`): This directory is used for locally running all services during development.
- **Tests** (`infrastructure/tests/`): This directory is used to run all services for subsequent test executions.
