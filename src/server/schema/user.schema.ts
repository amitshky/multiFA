import { object, string, ref, number } from 'yup' // schema builder and validation

export const createUserSchema = object({
	body: object({
		username: string().required('Username is required'),
		email: string()
			.email('Must be a valid email')
			.required('Email is required'),
		password: string()
			.required('Password is required')
			.matches(/^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/,
				'The password must contain at least 8 characters, one uppercase, one lowercase, one number and one special-case character'),
		passwordConfirmation: string()
			.oneOf([ref('password'), null], 'The passwords must match')
	})
});

export const createUserSessionSchema = object({
	body: object({
		email: string()
			.email('Must be a valid email')
			.required('Email is required'),
		password: string()
			.required('Password is required')
			.matches(/^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/,
				'The password must contain at least 8 characters, one uppercase, one lowercase, one number and one special-case character'),
		token: string()
			.required('Token is required')
			.matches(/^[0-9]+$/, 'The token must be digits')
			.min(6, 'The token must be exactly 6 digits')
			.max(6, 'The token must be exactly 6 digits')
	})
});