import path from 'path'
import dotenv from 'dotenv'
dotenv.config();

export default {
	port : process.env.PORT,
	host : process.env.HOST,
	dbUri: process.env.DB_URI,
	//dbUri: 'mongodb://localhost:27017/rest-api', // this was for the local db connection, keep it
	publicPath     : path.resolve(__dirname, '../public/'), // path to public folder
	saltWorkFactor : 10,
	accessTokenTTL : '15m',
	refreshTokenTTL: '1y',
	// generated using https://travistidwell.com/jsencrypt/demo/
	privateKey: process.env.PRIVATE_KEY,
	publicKey : process.env.PUBLIC_KEY // maybe you can store the public key here
}
