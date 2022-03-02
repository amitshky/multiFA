import mongoose from 'mongoose'
import bcrypt from 'bcrypt' // hashing password
import config from 'config' // defaults
import speakeasy from 'speakeasy' // totp
import { ObjectSchema } from 'yup';


export const privateFields = ['password', 'sskey', '__v']; // private fields of the db that you dont want to send as json

const UserSchema = new mongoose.Schema({
	email: {
		type    : String,
		required: true,
		unique  : true
	},
	username: {
		type    : String,
		required: true,
		unique  : true
	},
	password: {
		type    : String,
		required: true
	},
	sskey: { // shared secret key for totp verification
		type    : String,
		required: true,
		default : 'N/A'
	}
	//multiFactorOptions: {
	//	hasTotp: {
	//		type    : Boolean,
	//		required: true,
	//		default : true
	//	},
	//	hasBiometric: {
	//		type    : Boolean,
	//		required: true,
	//		default : true
	//	},
	//}
}, { timestamps: true });

// all the properties the mongodb document should have
// so that we can get our custom type definitions on the schema
export interface UserDocument extends mongoose.Document
{
	email: string;
	username: string;
	password: string;
	sskey: string;
	createdAt: Date;
	UpdatedAt: Date;

	generateSSKey(): Promise<string>;

	comparePassword(candidatedPassword: string): Promise<boolean>;
	compareToken(candidateToken: string): Promise<boolean>;
}

// executes before save()
UserSchema.pre('save', async function(next)
{
	let user = this as UserDocument;

	// hash if the password has been modified
	if (!user.isModified('password'))
		return next();

	// add salt (random data) to password when hashing
	const salt = await bcrypt.genSalt(config.get('saltWorkFactor'));
	const hash = await bcrypt.hashSync(user.password, salt);

	// replace password with the hash
	user.password = hash;

	return next();
});

UserSchema.methods.generateSSKey = async function (): Promise<string>
{
	const user   = this as UserDocument;
	const secret = speakeasy.generateSecret({ name: user.email });
	user.sskey   = secret.base32;
	return secret.otpauth_url!;
}

UserSchema.methods.comparePassword = async function (candidatedPassword: string): Promise<boolean>
{
	const user = this as UserDocument;

	// hash and then compare
	return bcrypt.compare(candidatedPassword, user.password).catch((e) => false);
}

UserSchema.methods.compareToken = async function (candidateToken: string): Promise<boolean>
{
	const user = this as UserDocument;
	return speakeasy.totp.verify({
		secret: user.sskey,
		encoding: 'base32',
		token: candidateToken
	});
}


const User = mongoose.model<UserDocument>('user', UserSchema);
export default User;