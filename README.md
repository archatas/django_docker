# Django Docker

## 1. Confirm execution permissions

You'll want to be able to run all the files under `scripts/` on the command line,
so we can ensure the permissions allow this:

```bash
$ chmod +x scripts/*.sh
```

## 2. Create environment file

Initially for development, and later for any environment that your project code
is used in, you'll want to create a configuration file with environment variable
settings.

Copy `config/.env-example` to `config/.env-dev`.

Edit the `config/.env-dev` file and add sensible values there.

## 3. Build the Docker containers

Run the build script for your environment (i.e., "dev"):

```bash
$ ./scripts/build.sh dev
```

## 3. Check if the build was successful

If you now go to `http://0.0.0.0/` you should see a "Hello, World!" page there.

If you now go to `http://0.0.0.0/admin/`, you should see the Django login. If instead you encounter
this:

```
OperationalError at /admin/
FATAL:  role "myproject" does not exist
```

This probably means that your database name and/or authentication environment variables have changed
since the containers were set up, and you need to create the new database and database user in the
`db` Docker container.

## 4. Create database user and project database

SSH into the database container and create user and database there with the same values as in the
`.env-dev` file, typing in the password when asked:

```bash
$ ./scripts/run.sh dev exec db bash
root:/# su - postgres postgres:
~/$ createuser --createdb --password $DATABASE_USER
Password: ...
postgres:~/$ createdb --username $DATABASE_USER $DATABASE_NAME
```

Alternately, you can try starting fresh by performing a complete teardown and rebuilding from scratch
with the updated environment variables:
```
$ ./scripts/teardown.sh dev
$ ./scripts/build.sh dev
```

Press `[Ctrl + D]` twice to logout of first the postgres user, and then the Docker container.

If you now go to `http://0.0.0.0/admin/`, you should see

```
ProgrammingError at /admin/
relation "django_session" does not exist
LINE 1: ...ession_data", "django_session"."expire_date" FROM "django_se...
```

This means that you have to run migrations to create database schema. You will also need to create
a superuser for login to the administration.

## 5. Run migration and collectstatic commands

SSH into the gunicorn container and run the necessary Django management commands:

```bash
$ ./scripts/manage.sh dev migrate
$ ./scripts/manage.sh dev collectstatic
$ ./scripts/manage.sh dev createsuperuser
```

Answer all the questions asked by the management commands.

Press `[Ctrl + D]` to logout of the Docker container.

If you now go to `http://0.0.0.0/admin/`, you should see the Django administration where you can login with the superuser credentials that you have just created.

## 6. Overview of useful commands

### Get usage instructions for the helper scripts

```bash
$ ./scripts/build.sh --help
$ ./scripts/manage.sh --help
$ ./scripts/run.sh --help
$ ./scripts/start.sh --help
$ ./scripts/stop.sh --help
$ ./scripts/teardown.sh --help
```

### Restart docker containers

```bash
$ ./scripts/stop.sh dev
$ ./scripts/start.sh dev
```

### Rebuild docker containers

```bash
$ ./scripts/teardown.sh dev
$ ./scripts/build.sh dev
```

### Run Django management commands

```bash
$ ./scripts/manage.sh dev command_name [options...]
```

### SSH to the Docker containers

```bash
$ ./scripts/run.sh dev exec gunicorn bash
$ ./scripts/run.sh dev exec nginx bash
$ ./scripts/run.sh dev exec db bash
```

### View logs

```bash
$ ./scripts/run.sh dev logs gunicorn
$ ./scripts/run.sh dev logs nginx
$ ./scripts/run.sh dev logs db
```

### Copy files and directories to and from Docker container

```bash
$ docker cp ~/avatar.png django_docker_gunicorn_1:/home/myproject/media/
$ docker cp django_docker_gunicorn_1:/home/myproject/media ~/Desktop/
```

## 7. Create analogous environment files for production, and any other environments

Copy `config/.env-example` to `config/.env-prod`, or any other `config/.env-xyz`, then change the
environment variables analogously.

## 8. Feedback

If you have any feedback about the boilerplate code or this README file, please open new issues.
