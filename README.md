# multiFA
Multi-factor Authentication.

## Getting Started
### Prerequisites
Install these:
* [Node.js](https://nodejs.org/en/)

These should be globally installed:
* [TypeScript](https://www.typescriptlang.org/download) `npm install -g typescript`
* [ts-node](https://www.npmjs.com/package/ts-node) `npm install -g ts-node`

### Installation
* Create a file called `.env` in the root directory of this project and copy the contents below. Generate public and private keys using [RSA key generator](https://travistidwell.com/jsencrypt/demo/) and also create a MongoDB cluster using [MongoDB Atlas](https://www.mongodb.com/atlas), replace them to their respective places. The contents of the `.env` file:
	```
	DB_URI = '<ENTER_YOUR_MONGODB_URI_HERE>'

	PRIVATE_KEY = '<ENTER_YOUR_PRIVATE_KEY_HERE>'

	PUBLIC_KEY = '<ENTER_YOUR_PUBLIC_KEY_HERE>'
	```

(Type these commands by opening the command prompt (for windows) in the root directory of this repository.)
* This installs the project packages.
	```
	cd server
	npm install
	```
### Build
* To start the server (runs nodemon for `src/server/app.ts`). This will directly run the typescript files without building javascript files.
	```
	cd server
	npm run server
	```
* You can then open `http://localhost:5000`.


OR,
* To build and run javascript files 
	```
	cd server
	npm run build
	npm run server-js
	```
* You can then open `http://localhost:5000`.

## Output
### User Registration
* Open `localhost:5000/register`\
![](img/register.png)
* The user details will also be added to the database.

### Login
* Open `localhost:5000/login`\
![](img/login.png)

### TOTP verification
* After login:\
![](img/totp.png)
