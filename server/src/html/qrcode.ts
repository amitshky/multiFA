const qrcodeHtml = (qrData: string) =>
{
	return `
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>MultiFA</title>
	<link rel="shortcut icon" href="#">
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="./styles.css">
</head>
<body>
	<div class="container">
		<form action="/api/users/reg-2fa" id="qrForm" class="form" method="POST">
			<h1 class="form__title">Two-factor authentication</h1>

			<div class="qr_container">
				<img src="${qrData}" width="200">
			</div>
			<label for="token"> Use your token generator app to scan and generate a token, and enter it below. </label>
			<div class="form__input-group">
				<input 
					class         = "form__input"
					type          = "text" 
					name          = "token"
					id            = "token"
					placeholder   = "Scan and enter the token"
					inputmode     = "numeric"
					pattern       = "[0-9]*" 
					minlength     = "6" 
					maxlength     = "6" 
					autocomplete  = "one-time-code"
					autofocus
					required
				/>
			</div>
			<button type="submit" class="form__button">Verify</button>
			<p class="form__text">
				<a class="form__link" href="/register" id='linkCreateAccount'>Back to registration</a>
			</p>
		</form>
	</div>
</body>
</html>
	`;
}

export default qrcodeHtml;