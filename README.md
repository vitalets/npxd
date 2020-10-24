# npxd
> Conveniently run [`npx`](https://nodejs.dev/learn/the-npx-nodejs-package-runner) commands inside Docker container

`npxd <command>` runs command inside Docker container no matter from where you call it:
 * if called from outside container - ensures container is running via `docker-compose up` and runs command via `docker-compose exec`
 * if called from inside container - just runs command ¯\\\_(ツ)\_/¯
 
Just prepend `npxd ...` to scripts in `package.json`.

## Install
```
npm i -D npxd
```

## Usage
Ensure you have dockerized project with `Dockerfile` and `docker-compose.yml` files.

#### Usage in package.json
1. Prepend scripts with `npxd`:
   ```diff
   "scripts": {
   -  "lint": "eslint ./src",
   +  "lint": "npxd eslint ./src",
   },
   ```
2. Run as usual from your host machine: 
   ```
   npm run lint
   ```
   The `eslint` command will be executed inside Docker container.

#### Usage NOT in package.json
When invoked not from `package.json` scripts you need to use `npx` in front of `npxd` 
(as it is usual executable inside `node_modules/.bin`):
```
$ npx npxd eslint ./src
```

#### Passing env variables 
This will NOT work:
```
"scripts": {
  "lint": "FOO=42 npxd eslint ./src"
},
```

But this will work:
```
"scripts": {
  "lint": "npxd env FOO=42 eslint ./src"
},
```

#### Configuring service name
By default `npxd` runs command inside container having `build:` section in `docker-compose.yml`.
You can redefine it by passing env variable `NPXD`:
```
"scripts": {
  "lint": "NPXD=my_service npxd eslint ./src"
},
```
> Note: here env variable before `npxd` is ok because it is needed for `npxd` itself, not for command.

## Example
Please see example project in [/example](/example) directory.

