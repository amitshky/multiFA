export default {
	port: 5000,
	host: 'localhost',
	dbUri: 'mongodb://localhost:27017/rest-api',
	saltWorkFactor: 10,
	accessTokenTTL: '15m',
	refreshTokenTTL: '1y',
	// generated using https://travistidwell.com/jsencrypt/demo/
	// TODO: generate a new one and store it in an env variable
	privateKey: `-----BEGIN RSA PRIVATE KEY-----
	MIICWwIBAAKBgQCErOQwscnqq977sjhp2yClNJ/FCvpoIft2wzgqUpJ1rYDeOBmE
	Losz82tIQIwglXIW7krhSzSA6jwiifAlfJ1ntvJup3Kuvu1RwWYbpP8mwPwmw04f
	lkO8WXK5YSVWgC3cnvTdLpU1QYNsSqoua4FJ9dRQ19pWufBmbmlsJFG4RwIDAQAB
	AoGAR/qQVgaud91EvSKETpGuVVKGd10sWwBMr7LbrsJbaPJ3Xpfq5/ZkWQvvoSQ7
	oZXSbrRa9X1af7IUa9yP55aCwjDRk0C1HLgpXf5It2vspZiau7K6hBTnin5Ciwmy
	aelRDm+4ZBRvq1hbfqZ13/Wl9i59wg0QEw/ya1rInfqaaZkCQQC760KtTIA86/42
	Qhso3oL0lW//LDCI8CLGGzfGsl4+9FI4QRymRzs5mi0tU1yRacExiys3KMapU7sJ
	NpHJyed1AkEAtL4A9FYF+fczrach6Q644sFVFgocKGFOWad9e64FS88lduOmDxIn
	C7pz9OC/z9br8e18U1eGQhhLE/PpSPslSwJAYF6Y1hi6VwPLXXXvSbk6vUV5pwm5
	ZjCIFMJWiz5j2LMhCxpRH/C9rZ+kdW8ftK7gVZECO4pcvu9ipqnmf+5cFQJAT45e
	vy3qPYfJEIPDkmEvkmgE+smCcWe7ZA0sV7dWj3Lji7xSiMm1tBzjE4OmCmcQvhGJ
	qumYqBknWuX+5mfdlwJALvWGBIAp+5oYd2AHL/vzOxzQMx55ujjH4/dXayw+UnrP
	TDoPt5YXDe33FmH8dvqgZx/fjEN65dujsuM1CZdmMA==
	-----END RSA PRIVATE KEY-----`,
}
