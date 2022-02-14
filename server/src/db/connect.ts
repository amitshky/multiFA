import mongoose from 'mongoose'
import config from 'config'
import logger from '../logger'


const dbUri = config.get('dbUri') as string;
const connect = (): void => 
{
	mongoose.connect(dbUri)
		.then((result: typeof mongoose) => logger.info(`Connected to the database.`))
		.catch((error: any) => logger.error(error));
}

export default connect;