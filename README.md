# multiFA
Multi-factor Authentication.

## Getting Started
### Prerequisites
Install these:
* [Node.js](https://nodejs.org/en/)
* [MongoDB Compass](https://www.mongodb.com/products/compass)

These should be globally installed:
* [TypeScript](https://www.typescriptlang.org/download) `npm install -g typescript`
* [ts-node](https://www.npmjs.com/package/ts-node) `npm install -g ts-node`

### Installation
(Type these commands by opening the command prompt (for windows) in the root directory of this repository)\
Install project packages
```
npm install
```
### Build
To start the server (runs nodemon for `src/server/app.ts`):
```
npm run server
```

You can then open `http://localhost:5000`.

## Output
### User Registration
* Open `localhost:5000/register`\
![](img/register.png)
* The user details will also be added to the database.

### Login
* Open `localhost:5000/login`\
![](img/login.png)
