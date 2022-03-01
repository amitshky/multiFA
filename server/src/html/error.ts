const errorHtml = (errorMsg: string) =>
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
			<h1 class="form__title">Oops!!</h1>
			<div class="qr_container">
				<img src="./assets/error.png" width="150" >
			</div>
			<label class="align_center"> ${errorMsg} </label>

			<p class="form__text">
				<a class="form__link" href="/" id='linkCreateAccount'>Return to Homepage</a>
			</p>
		</form>
	</div>
</body>
</html>
	`
}

export default errorHtml;