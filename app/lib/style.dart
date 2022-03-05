import 'package:flutter/material.dart';


// Colors
const Map<int, Color> _appColor = { // purple
	50 : Color.fromRGBO(111, 93, 121, 0.1),
	100: Color.fromRGBO(111, 93, 121, 0.2),
	200: Color.fromRGBO(111, 93, 121, 0.3),
	300: Color.fromRGBO(111, 93, 121, 0.4),
	400: Color.fromRGBO(111, 93, 121, 0.5),
	500: Color.fromRGBO(111, 93, 121, 0.6),
	600: Color.fromRGBO(111, 93, 121, 0.7),
	700: Color.fromRGBO(111, 93, 121, 0.8),
	800: Color.fromRGBO(111, 93, 121, 0.9),
	900: Color.fromRGBO(111, 93, 121, 1.0),
};

const Map<int, Color> _appBgColor = { // grey
	50 : Color.fromRGBO(16, 16,  16, 0.1),
	100: Color.fromRGBO(16, 16,  16, 0.2),
	200: Color.fromRGBO(16, 16,  16, 0.3),
	300: Color.fromRGBO(16, 16,  16, 0.4),
	400: Color.fromRGBO(16, 16,  16, 0.5),
	500: Color.fromRGBO(16, 16,  16, 0.6),
	600: Color.fromRGBO(16, 16,  16, 0.7),
	700: Color.fromRGBO(16, 16,  16, 0.8),
	800: Color.fromRGBO(16, 16,  16, 0.9),
	900: Color.fromRGBO(16, 16,  16, 1.0),
};

const Map<int, Color> _buttonColor = {  // light grey
	50 : Color.fromRGBO(44, 44,  44, 0.1),
	100: Color.fromRGBO(44, 44,  44, 0.2),
	200: Color.fromRGBO(44, 44,  44, 0.3),
	300: Color.fromRGBO(44, 44,  44, 0.4),
	400: Color.fromRGBO(44, 44,  44, 0.5),
	500: Color.fromRGBO(44, 44,  44, 0.6),
	600: Color.fromRGBO(44, 44,  44, 0.7),
	700: Color.fromRGBO(44, 44,  44, 0.8),
	800: Color.fromRGBO(44, 44,  44, 0.9),
	900: Color.fromRGBO(44, 44,  44, 1.0),
};

const Color textColor              = Color.fromARGB(255, 219, 219, 219);
const Color dismissalColor         = Color.fromARGB(255, 121,  72,  69);
const Color dividerColor           = Color.fromARGB(144, 100, 100, 100);
const Color circularProgIndBgColor = Colors.white12;
const String appColorHex           = '#6F5D79';                                 // purple
const MaterialColor appColor       = MaterialColor(0xFF6F5D79, _appColor);    // purple
const MaterialColor appBgColor     = MaterialColor(0xFF101010, _appBgColor);  // grey
const MaterialColor buttonColor    = MaterialColor(0xFF2C2C2C, _buttonColor); // light grey


// Fonts
const double largeTextSize   = 32.0;
const double mediumTextSize  = 20.0;
const double body1TextSize   = 16.0;
const double bodyTextSize    = 14.0;

const String appBarFont = 'Montserrat';
const String consolas   = 'Consolas';

const appBarTextStyle = TextStyle(
	fontFamily: appBarFont,
	fontWeight: FontWeight.w400,
	fontSize  : mediumTextSize,
	color     : textColor,
);

const title1TextStyle = TextStyle(
	fontWeight: FontWeight.w500,
	fontSize  : largeTextSize,
	color     : textColor,
);

const title2TextStyle = TextStyle(
	fontWeight: FontWeight.w500,
	fontSize  : mediumTextSize,
	color     : textColor,
);

const title3TextStyle = TextStyle(
	fontWeight: FontWeight.w500,
	fontSize  : body1TextSize,
	color     : textColor,
);

const bodyText1Style = TextStyle(
	fontWeight: FontWeight.w300,
	fontSize  : bodyTextSize,
	color     : textColor,
);

const telText1Style = TextStyle(
	fontFamily: consolas,
	fontWeight: FontWeight.w400,
	fontSize  : largeTextSize,
	color     : textColor,
);

const telText2Style = TextStyle(
	fontFamily: consolas,
	fontWeight: FontWeight.w200,
	fontSize  : bodyTextSize,
	color     : textColor,
);