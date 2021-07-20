import 'package:afrocom/app/routes/app.routes.dart';
import 'package:afrocom/app/shared/colors.dart';
import 'package:afrocom/app/shared/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Core());
}

class Core extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: DeciderRoute,
      routes: routes,
      theme: ThemeData(
          primaryColor: KConstantColors.yellowColor,
          fontFamily: KConstantFonts.Monteserrat),
    );
  }
}