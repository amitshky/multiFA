import config from 'config'
import express from 'express'

import logger from '../common/logger'
import connect from '../common/db/connect'
import routes from './routes'
import { deserializeUser } from './middleware'


const HOST = config.get('host') as string;
const PORT = config.get('port') as number;
const app  = express();

// middleware
app.use(express.static('./public/'));
app.use(deserializeUser);
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.listen(PORT, HOST, (): void => 
{
	logger.info(`Listening on http://${HOST}:${PORT}`);
	connect();
	routes(app);
});