const profileHtml = (username: string, email: string) =>
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
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
		<link rel="stylesheet" href="./styles.css">
	</head>
	<body>
		<div class="container">
			<h1 class="form__title">Profile</h1>
			<div>
				<div class="float_left" style="width: 25%; margin-bottom: 1rem;">
					<img src="./assets/user.png" width="75"/>
				</div>
				<div class="float_left"> 
					<div class="form__input-group">
						<span class="prof_label"><i class="fa fa-user"></i></span>
						<span>${username}</span>
					</div>
					<div class="form__input-group">
						<span><i class="fa fa-envelope"></i></span>
						<span>${email}</span>
					</div>
				</div>
			</div>
			
			<form action="/api/sessions/logout" id="logout" class="form" method="POST">
				<button type="submit" class="form__button">Logout</button>
			</form>
		</div>
	</body>
	</html>
	`;
}

export default profileHtml;