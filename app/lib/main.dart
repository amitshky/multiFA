import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app/style.dart';
import 'package:app/screens/home.dart';

void main()
{
	SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
	runApp(const App());
}

class App extends StatelessWidget
{
	static const String appTitle = 'MultiFA';
	const App({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) 
	{
		return MaterialApp(
			home: const HomeScreen(title: appTitle),
			theme: ThemeData(
				primarySwatch: appBgColor,
				appBarTheme  : const AppBarTheme(titleTextStyle: appBarTextStyle),
				scaffoldBackgroundColor: appBgColor,
				textTheme: const TextTheme(
					headline1: title1TextStyle,
					headline2: telText1Style,
					headline3: title2TextStyle,
					headline4: title3TextStyle,
					bodyText1: bodyText1Style,
					bodyText2: telText2Style,
				)
			),
		);
	}
}

