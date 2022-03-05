import { object, string, ref } from 'yup' // schema builder and validation

export const createUserSchema = object({
	body: object({
		username: string().required('Username is required.'),
		email: string()
			.email('Must be a valid email.')
			.required('Email is required.'),
		password: string()
			.required('Password is required.')
			.matches(/^(?=.*\d)(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$/,
				'The password must contain at least 8 characters, one lowercase, one number, and should not be same as your username or email.')
			.notOneOf([ref('email'), ref('username'), null], 'The password should not be same as your username or email.'),
		passwordConfirmation: string()
			.oneOf([ref('password'), null], 'The passwords must match.')
	})
});

export const createUserSessionSchema = object({
	body: object({
		email: string()
			.email('Must be a valid email.')
			.required('Email is required.'),
		password: string()
			.required('Password is required.')
			//.matches(/^(?=.*\d)(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$/,
			//	'The password must contain at least 8 characters, one lowercase, one number, and should not be same as your username or email.')
	})
});