# backend

```bash
git clone https://github.com/repooooo/backend.git
```
```bash
cd backend
```
```bash
git submodule update --init --recursive
```

## Project Structure

The project is organized into multiple microservices, each stored as a separate Git submodule within the `microservices/` directory.
```bash
backend/
  └── microservices/
      ├── email/
      └── auth/
```


### Microservices

- **Email Service** (`microservices/email/`): This submodule contains the email service responsible for managing and sending emails.
- **Authentication Service** (`microservices/auth/`): This submodule contains the authentication service responsible for handling user authentication and authorization.
