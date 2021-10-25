# npxd
> [`npx`](https://nodejs.dev/learn/the-npx-nodejs-package-runner) for Docker

`npxd <command>` is like `npx <command>` but runs command inside Docker container defined in `docker-compose.yml`.

**The main benefit**: seamless command invocation from either host machine or inside container: 
 * if invoked from host machine - ensures container is running via `docker compose up` and runs command via `docker compose exec`
 * if invoked from inside container - just runs command ¯\\\_(ツ)\_/¯

## Usage
1. Ensure you have `docker-compose.yml` file in your project
2. Install npxd ([details](https://github.com/vitalets/npxd#installation)):
   ```
   npm i -D npxd
   ```
3. Prepend `package.json` scripts with `npxd`:
   ```diff
   "scripts": {
   -  "test": "mocha test/*.js",
   +  "test": "npxd mocha test/*.js",
   },
   ```
4. Run as usual from your host machine: 
   ```
   npm test
   ```
5. Check results of command executed in container:
   ```
   $ npm test
   
   > npxd mocha test/*.js
   
   Recreating example_app_1 ... done
   
     ✓ should add numbers
   
     1 passing (36ms)
   ```

See full example code in [example](https://github.com/vitalets/npxd/tree/main/example) directory.

## Installation
There are to installation options:
 
#### Install from NPM (recommended)
Installing from npm will add `npxd` executable to `node_modules/.bin` of your project.
You will be able to use `npxd` command in `package.json` scripts.
```
npm i -D npxd
```

#### Install from GitHub
Alternatively you can download script directly from GitHub and store it in your project.
It allows you to adopt script for your needs (as it's a few lines of code).
But in that case you should invoke it as `./npxd.sh` not `npxd` in `package.json` scripts.
```
wget -O npxd.sh https://raw.githubusercontent.com/vitalets/npxd/main/npxd.sh
chmod +x npxd.sh
```

## Passing env variables 
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

## Configuring service name
- if there is single service in `docker-compose.yml`, commands will automatically run inside it
- if there are several services in `docker-compose.yml`, you should create `.npxdrc` file containing target service name

Example of `.npxdrc` that runs commands in `my_app` service:
```
my_app
```

> Note: when you install `npxd` directly from GitHub you may just edit `./npxd.sh` to set particular service name.

## Usage from cli
When invoked not from `package.json` scripts section you need to use `npx` in front of `npxd` 
(as it is usual executable inside `node_modules/.bin`):
```
$ npx npxd eslint ./src
```
Or if you installed from GitHub, just run script:
```
$ ./npxd.sh eslint ./src
```

## License
MIT @ [Vitaliy Potapov](https://github.com/vitalets)
