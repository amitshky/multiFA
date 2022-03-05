import mongoose from 'mongoose'
import { UserDocument } from './user.model'


const SessionSchema = new mongoose.Schema({
	user: { 
		type: mongoose.Schema.Types.ObjectId,
		ref : 'User'
	},
	valid: {
		type   : Boolean,
		default: true // make it false to log the user out
	},
	userAgent: { // browser or postmanRuntime
		type: String
	}
}, { timestamps: true });

export interface SessionDocument extends mongoose.Document
{
	user     : UserDocument['_id'];
	valid    : boolean;
	userAgent: string;
	createdAt: Date;
	updatedAt: Date;
}

const Session = mongoose.model<SessionDocument>('Session', SessionSchema);
export default Session;