# multiFA
This is a project on Multi-factor Authentication System. We have an [android application](https://github.com/amitshky/multiFA/releases) and a simple [website](https://multifa.herokuapp.com/) (NOTE: this site may not work anymore, Heroku might have stopped hosting it). You can register an account from the [website](https://multifa.herokuapp.com/) and select one of the three Authentication options - Time-based One Time Password (TOTP) verification, or Fingerprint verification, or both - which you can use alongside Password verification during login. The [android application](https://github.com/amitshky/multiFA/releases) generates TOTP and verifies fingerprint.

The Android application was built for Android 7 and above.

## Usage
* Download and install the APK of the [android application](https://github.com/amitshky/multiFA/releases).
* Open the [website](https://multifa.herokuapp.com/) and register an account and choose an Authentication option.
* Set up authentication options in the Android application by scanning the QR code.
* You can then login to the website and try out the different authentication options.

## Getting Started
These instructions are for getting a copy of the project running on your machine for development and testing.

### Prerequisites
* [Node.js](https://nodejs.org/en/)
* [Flutter](https://docs.flutter.dev/get-started/install)

#### For Android
* [Android Studio](https://developer.android.com/studio)

#### For Typescript
These should be globally installed:
* [TypeScript](https://www.typescriptlang.org/download) `npm install -g typescript`
* [ts-node](https://www.npmjs.com/package/ts-node) `npm install -g ts-node`

### Installation
* Create a file called `.env` in the `server` folder and copy the contents below. Generate public and private keys using [RSA key generator](https://travistidwell.com/jsencrypt/demo/) and also create a MongoDB cluster using [MongoDB Atlas](https://www.mongodb.com/atlas), replace them to their respective places. The contents of the `.env` file:
	```
	DB_URI = '<ENTER_YOUR_MONGODB_URI_HERE>'

	PORT = 5000
	HOST = 'localhost'

	PRIVATE_KEY = '<ENTER_YOUR_PRIVATE_KEY_HERE>'

	PUBLIC_KEY = '<ENTER_YOUR_PUBLIC_KEY_HERE>'
	```

(Type these commands by opening the command prompt (for Windows) in the root directory of this repository.)
* This installs the project packages.
	```
	cd server
	npm install
	cd ../app
	flutter pub get
	```
	OR (for Windows),
	```
	./install.bat
	```
### Build
#### Server-side code
(Type these commands by opening the command prompt (for Windows) in the root directory of this repository.)
* To start the server (runs nodemon for `src/server/app.ts`). This will directly run the typescript files without building javascript files.
	```
	cd server
	npm run server
	```
	OR (for Windows),
	```
	./server.bat
	```
* You can then open `http://localhost:5000`.

OR,
* To build and run javascript files 
	```
	cd server
	npm run build
	npm run server-js
	```
	OR (for Windows),
	```
	./server-build.bat
	```
* You can then open `http://localhost:5000`.

#### Android Application
> Warning! In .pub-cache\hosted\pub.dartlang.org\flutter_barcode_scanner-2.0.0\android\src\main\java\com\amolg\flutterbarcodescanner\FlutterBarcodeScannerPlugin.java replace all references of FlutterActivity to FlutterFragmentActivity. This is because the local_auth package uses FlutterFragmentActivity and flutter_barcode_scanner uses FlutterActivity.

* Create and open an [Android Virtual Device (AVD)](https://developer.android.com/studio/run/managing-avds) in Android Studio.

* OR, you can also configure [USB Debugging](https://developer.android.com/studio/debug/dev-options).

(Type these commands by opening the command prompt (for Windows) in the root directory of this repository.)
* Build and run the project using the following command:
	```
	cd app
	flutter run
	```
	OR (for Windows),
	```
	./app.bat
	```
* OR, use vscode [flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) extension.

* Build and run the app in release mode
	```
	cd app
	flutter run --release
	```
	OR (for Windows),
	```
	./app-rel.bat
	```
* You can also clean (deleting build files and other generated files) the flutter project using the following command.
	```
	cd app
	flutter clean
	```
	OR (for Windows)
	```
	./app-clean.bat
	```


## Output
* **Website:** https://multifa.herokuapp.com/
* **Android App:** https://github.com/amitshky/multiFA/releases

### Android Application
* Home page\
	<img src="img/app.png" width=300>

* Fingerprint verification\
	<img src="img/appFingerprint.png" width=300>

* QR code scan page\
	<img src="img/appQrscan.png" width=300>


### User Registration
* Open `multifa.herokuapp.com/register`\
	<img src="img/register.png" width=450>

#### TOTP Registration
* After login:\
	<img src="img/totpSetup.png" width=450>

#### Fingerprint Registration
* After login:\
	<img src="img/fingerprintRegistration.png" width=450>

### Login
* Open `multifa.herokuapp.com/login`\
	<img src="img/login.png" width=450>

#### TOTP verification
* After login:\
	<img src="img/totp.png" width=450>

#### Fingerprint verification
* After login:\
	<img src="img/fingerprintVerification.png" width=450>

#### Profile
* After login:\
	<img src="img/profile.png" width=450>



