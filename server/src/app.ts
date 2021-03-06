import config from 'config'
import express from 'express'
import cookieParser from 'cookie-parser'

import logger from './logger'
import connect from './db/connect'
import routes from './routes'
import { deserializeUser } from './middleware'


const HOST = config.get('host') as string;
const PORT = config.get('port') as number;
const app  = express();

// middleware
app.use(cookieParser());
app.use(express.static('./public/'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(deserializeUser);

app.listen(PORT, (): void => 
{
	logger.info(`Listening on ${HOST}:${PORT}`);
	connect();
	routes(app);
});