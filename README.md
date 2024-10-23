# Core Project - Installation and Run Guide

This project is a Swift-based server-side application built using the [Vapor](https://vapor.codes) framework and additional dependencies like Swift NIO, Fluent, and Postgres. Follow the steps below to install and run the project locally.

## Prerequisites

Before you begin, ensure you have the following installed on your machine:

1. **macOS 13 or later**
2. **Swift 5.10 or later**: [Install Swift](https://swift.org/getting-started/)
3. **PostgreSQL**: [Install PostgreSQL](https://www.postgresql.org/download/)
4. **Vapor Toolbox** (optional but recommended): Install via Homebrew with the following command:
    ```bash
    brew install vapor
    ```

## Installation

### 1. Clone the repository

First, clone the repository to your local machine:

```bash
git clone <repository-url>
cd core
```

### 2. Configure PostgreSQL

Ensure that PostgreSQL is running and you have created the necessary database. Use the following commands to create the database:

```bash
psql postgres
CREATE DATABASE coredb;
CREATE USER coreuser WITH PASSWORD 'vapor';
GRANT ALL PRIVILEGES ON DATABASE coredb TO coreuser;
```

Update the PostgreSQL connection settings in your configure.swift or app.swift file if needed, depending on your setup.

### 3. Install Swift Package Dependencies
Run the following command to resolve and download the required dependencies:

```bash
swift package resolve
```

### 4. Build the Project
To build the project, use the Swift Package Manager (SPM):

```bash
swift build
```

### 5. Running the Project
Once built, you can run the project using the following command:

```bash
swift run
```

Alternatively, if you have Vapor Toolbox installed, you can run the project with:

```bash
vapor run
```

By default, the application will start on port 8080. You can navigate to http://localhost:8080 in your browser to confirm the app is running.

### 6. Running Tests
To run the test suite, use:

```bash
swift test
```

This will execute all the tests defined in the AppTests target.

## Project Structure

- Package.swift: Defines the Swift package, including dependencies and targets.
- Sources/App: Contains the main application code.
- Tests/AppTests: Contains the unit and integration tests for the application.

### Additional Notes

Database Migrations: Make sure to set up the database migrations if applicable by running:

```bash
swift run App migrate
```

This will create the necessary tables and schema in your PostgreSQL database.

JWT Setup: If the application uses JWT for authentication, ensure you configure the necessary secrets and environment variables related to token generation.

### Troubleshooting

If you encounter any issues during setup, verify that:

- PostgreSQL is properly configured and running.
- Dependencies are resolved correctly with swift package resolve.
- The correct Swift version is installed (swift --version).
- For further help, refer to the [Vapor documentation](https://docs.vapor.codes/) or the [Swift webpage](https://www.swift.org/).


