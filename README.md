# im-cw2

![License](https://img.shields.io/badge/License-MIT-green.svg)

## 1 Prerequisites

### 1.1 Docker

Ensure the Docker engine is installed on your system with version **18.06.0** or higher.

You can download and install the Docker engine from the [official Docker website](https://www.docker.com/get-started/).

> [!NOTE]
>
> - Especially on Linux, make sure your user has the [required permissions](https://docs.docker.com/engine/install/linux-postinstall/) to interact with the Docker daemon.
> - If you are unable to do this, either append `sudo` in front of each `docker` command or switch to root using `sudo -s`.

### 1.2 Docker Compose

Ensure that Docker Compose is installed on your system with **version 1.28.0** or higher.

You can download and install Docker Compose from the [official Docker website](https://docs.docker.com/compose/install/).

### 1.3 PostgreSQL

Ensure that PostgreSQL is installed on your system with **version 13** or higher.

You can download PostgreSQL using the following command based on your operating system:

macOS:

- Install Homebrew (if not already installed).

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

> [!NOTE]
>
> - Visit Homebrew's official website [here](https://brew.sh) for more information.
> - You will require administrative priviledges during the installation process.

```bash
brew install postgresql
```

Linux:

- Debian/Ubuntu:

```bash
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib
```

- CentOS/RHEL:

```bash
sudo yum check-update
sudo yum install ftp
```

- Fedora:

```bash
sudo dnf check-update
sudo dnf install ftp
```

- Arch:

```bash
sudo pacman -Sy
sudo pacman -S ftp
```

Windows:

You can download the PostgreSQL installer from the official website [here](https://www.postgresql.org/download/windows/) and follow the installation instructions.

### 1.4 Port availability

The PostgreSQL service running on the Docker Container uses **Port `5433`** on your host system. Ensure that this port is free and is not running any conflicting services or has any firewall rules concerning them.

## 2 Usage

1. Clone the repository to your local machine.

```bash
git clone https://github.com/iArcanic/im-cw2
```

2. Navigate to the project's directory.

```bash
cd im-cw2
```

3. Create an environment variable file.

```bash
touch .env
```

4. Add the following contents to the `.env` file.

```bash
POSTGRES_USER=postgres
POSTGRES_PASSWORD=mypassword
POSTGRES_DB=student_db
```

> [!NOTE]
>
> - These environment variables are necessary for configuring the PostgreSQL database.
> - You can modify them as needed for your environment, but ensure that the [`docker-compose.yml`](https://github.com/iArcanic/im-cw2/blob/main/docker-compose.yml) file is updated accordingly with any changes to these credentials.

5. Build and run all Docker containers.

```bash
docker-compose up
```

> [!NOTE]
> With Docker Compose, you can also optionally use the following:
>
> - If you want to build the images each time (or changed a Dockerfile), use:
>
> ```bash
> docker-compose up --build
> ```
>
> - If you want to run all the services in the background, use:
>
> ```bash
> docker-compose up -d
> ```
>
> After, you can optionally view Docker images, status of containers, and interact with running containers using the Docker Desktop application.

6. Use the PostgreSQL CLI to connect to the Docker container.

```bash
psql -h localhost -p 5433 -U <POSTGRES_USER>
```

For example:

```bash
psql -h localhost -p 5433 -U postgres
```

> [!NOTE]
>
> - The default name of the PostgreSQL user will be the value of the `POSTGRES_USER` variable that you set in your `.env` file.
>
> - You will be prompted to enter a password like so:
>
> ```plaintext
> Password for user postgres:
> ```
>
> - This will be the value of the `POSTGRES_PASSWORD` variable that you set in your `.env` file.

7. Connect to the database.

```postgresql
\c <POSTGRES_DB>
```

For example:

```postgresql
\c student_db
```

> [!NOTE]
> The name of your database will be the value of the `POSTGRES_DB` variable that you set in your `.env` file.

8. Experiment with connecting to the database as different users.

```postgresql
\c <POSTGRES_DB> <USERNAME>
```

For example:

```postgresql
\c student_db admin_user
```

> [!NOTE]
> The credentials for these users are found in [`sql/06_create_users.sql`](https://github.com/iArcanic/im-cw2/blob/main/sql/06_create_users.sql).

> [!IMPORTANT]
> When referencing the tables, you must use the schema name `student_info` before the table name.

1. Experiment with Role-Based Access Control (RBAC).

For example, as `admin_user` (assuming that you have connected as `admin_user` beforehand):

```postgresql
SELECT date_of_birth FROM student_info.students;
```

You should see the following:

```plaintext
ERROR:  permission denied for schema student_info
```

> [!NOTE]
> The permissions for these roles are found in [`sql/05_grant_permissions.sql`](https://github.com/iArcanic/im-cw2/blob/main/sql/05_grant_permissions.sql).

9. Quit the PostgreSQL connection to the Docker container after usage.

```postgresql
\q
```

10. Destroy the Docker container after usage.

```bash
docker-compose down
```
