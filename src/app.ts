import express from 'express'

const app : express.Application = express();

app.get('/', (req: express.Request, res: express.Response) => res.send('Home page'));

app.listen(5000, () => console.log("Listening on port: 5000..."));