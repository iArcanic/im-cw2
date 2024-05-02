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

> [!NOTE]
>
> - You may have to export the PostgreSQL `bin` directory to use the PostgreSQL commands system wide.
> - First, find out what shell you are currently using with:
>
> ```bash
> echo $SHELL
> ```
>
> - Open your shell config file (prefixed with a `.`) with an appropriate text editor (e.g. `nano`, `vim`, `nvim`, etc.).
>
> ```bash
> nano <SHELL_CONFIG_FILE>
> ```
>
> - Add the following line:
>
> ```bash
> export PATH="/usr/local/opt/postgresql@16/bin:$PATH"
> ```
>
> - Update your shell based on the config file changes.
>
> ```bash
> source <SHELL_CONFIG_FILE>
> ```

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

3. Build and run all Docker containers.

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

4. Use the PostgreSQL CLI to connect to the Docker container.

```bash
psql -h localhost -p 5433 -U postgres
```

5. Connect to the database.

```postgresql
\c student_db
```

6. Experiment with connecting to the database as different users.

```postgresql
\c student_db <USERNAME>
```

For example:

```postgresql
\c student_db admin_user
```

> [!NOTE]
> The credentials for these users are found in [`sql/06_create_users.sql`](https://github.com/iArcanic/im-cw2/blob/main/sql/06_create_users.sql).

> [!IMPORTANT]
> When referencing the tables, you must use the schema name `student_info` before the table name.

7. Experiment with Role-Based Access Control (RBAC).

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

8. Backup and export the database

Navigate to the scripts folder.

```bash
cd scripts
```

Make the `backup.sh` script an executable.

```bash
chmod +x backup.sh
```

Run the `backup.sh` script.

```bash
./backup.sh
```

Navigate to your home folder and you should see the backup folder with a database dump `.sql` file.

9. Quit the PostgreSQL connection to the Docker container after usage.

```postgresql
\q
```

10. Destroy the Docker container after usage.

```bash
docker-compose down
```
