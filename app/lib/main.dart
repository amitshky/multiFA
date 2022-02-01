import 'package:flutter/material.dart';

import 'package:app/style.dart';
import 'package:app/pages/home.dart';

void main() => runApp(const App());

class App extends StatelessWidget
{
	static const String appTitle = 'MultiFA';
	const App({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) 
	{
		return MaterialApp(
			home: const HomePage(title: appTitle),
			theme: ThemeData(
				primarySwatch: appBgColor,
				appBarTheme: const AppBarTheme(titleTextStyle: appBarTextStyle),
				scaffoldBackgroundColor: appBgColor,
				textTheme: const TextTheme(
					headline1: titleTextStyle,
					bodyText1: bodyText1Style,
					headline2: telText1Style,
					bodyText2: telText2Style,
				)
			), 
		);
	}
}

