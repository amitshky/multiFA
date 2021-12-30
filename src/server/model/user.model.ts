import mongoose from 'mongoose'
import bcrypt from 'bcrypt' // hashing password
import config from 'config' // defaults


const UserSchema = new mongoose.Schema({
	email: {
		type: String,
		required: true,
		unique: true
	},
	username: {
		type: String,
		required: true,
		unique: true
	},
	password: {
		type: String,
		required: true
	}
}, { timestamps: true });

// all the properties the mongodb document should have
// so that we can get our custom type definitions on the schema
export interface UserDocument extends mongoose.Document
{
	email: string;
	username: string;
	password: string;
	createdAt: Date;
	UpdatedAt: Date;

	comparePassword(candidatedPassword: string): Promise<boolean>;
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

UserSchema.methods.comparePassword = async function(candidatedPassword: string)
{
	const user = this as UserDocument;

	// hash and then compare
	return bcrypt.compare(candidatedPassword, user.password).catch((e) => false);
}


const User = mongoose.model<UserDocument>('user', UserSchema);
export default User;