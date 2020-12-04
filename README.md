# PIN INSTRUCTION

## Initial Dependences

Linux
```shell
sudo apt-get install libmagickwand-dev imagemagick redis
```

Mac

```shell
brew install imagemagick 
```

## Initial Setup

### Setup the required Environment Variables

If you need to make any changes to the default Evnrionment Variables, don't edit the file `.env.development`.

Create a new file named `.env.development.local` and put your personal settings in there:

```shell
cp .env.development .env.development.local
```

### Create Database

```shell
rails db:create
```

## Run every time has new migration

```shell
rails db:migrate
```

## Run to populate Database with a experimental data

```shell
rails db:seed
```

## Run local server (with -b to allow external access, see at: http://localhost:3000)

```shell
rails s -b 0.0.0.0
```

## Run tests

```shell
rspec
```
