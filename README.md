# multiFA
Multi-factor Authentication.

Includes user registration backend.

## Getting Started
### Prerequisites
Install these:
* [Node.js](https://nodejs.org/en/)
* [Postman](https://www.postman.com/)
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

You can then open postman.

## Output
### Create a user (User Registration)
* Open postman and create a POST HTTP request along with the body as shown below and send the request.\
![](img/postmanCreateUser.png)
![](img/postmanCreateUserBody.png)

* You should see a similar json as shown below.\
![](img/postmanCreateUserOutput.png)

* The user details should also be added to the database.

### Login Session
* Open postman and create a POST HTTP request along with the body as shown below and send the request. (The email and password should be of a registered user)\
![](img/postmanLoginCreateSession.png)
![](img/postmanLoginCreateSessionBody.png)

* You should see a similar json as shown below.\
![](img/postmanLoginCreateSessionOutput.png)

* You can then create environment varialbes for `accessToken` and `refreshToken`\
![](img/postmanLoginSessionEnv.png)

* Then add the following to the headers for GET and DELETE HTTP methods for `/api/sessions`\
![](img/postmanLoginSessionHeaders.png)
