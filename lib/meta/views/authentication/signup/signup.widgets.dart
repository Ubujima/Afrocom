import 'package:afrocom/app/constants/images.tag.dart';
import 'package:afrocom/app/routes/app.routes.dart';
import 'package:afrocom/app/shared/colors.dart';
import 'package:afrocom/app/shared/dimensions.dart';
import 'package:afrocom/app/shared/fonts.dart';
import 'package:afrocom/core/notifier/utility.notifier.dart';
import 'package:afrocom/meta/utilities/navigation.utility.dart';
import 'package:afrocom/meta/widgets/custom_button.dart';
import 'package:afrocom/meta/widgets/custom_text_field.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupWidgets {
  static Container appLogo() {
    return Container(
      height: 100,
      width: 100,
      child: Image.asset(ImageTags.AppLogo),
    );
  }

  static Container signupSection(
      {required List<TextEditingController> textEditingController,
      required BuildContext context}) {
    return Container(
      width: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField.stylishTextField(
                "Enter username", textEditingController[0]),
            vSizedBox1,
            CustomTextField.stylishTextField(
                "Enter full name", textEditingController[1]),
            vSizedBox1,
            CustomTextField.stylishTextField(
                "Enter email", textEditingController[2]),
            vSizedBox1,
            CustomTextField.stylishTextField(
                "Enter password", textEditingController[3]),
            vSizedBox1,
            CustomButton(
                iconData: EvaIcons.calendar,
                tag: "Date of birth",
                buttonColor: KConstantColors.bgColorFaint,
                height: 40,
                onPressed: () async {
                  await Provider.of<UtilityNotifier>(context, listen: false)
                      .selectUserDOB(context);
                },
                width: 200)
          ],
        ),
      ),
    );
  }

  static signupButton(
      {required BuildContext context, required dynamic onPressed}) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 200.0,
          height: 50.0,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(1),
              borderRadius: BorderRadius.circular(18.0)),
          child: Center(
            child: Text(
              "Signup",
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: KConstantFonts.MonteserratB),
            ),
          ),
        ),
      ),
    );
  }

  static loginScreenText({required dynamic onPressed}) {
    return Center(
      child: RichText(
        text: TextSpan(children: <TextSpan>[
          TextSpan(
            text: "Already have an account? ",
            style: TextStyle(
                color: KConstantColors.textColor,
                fontWeight: FontWeight.w700,
                fontFamily: KConstantFonts.Monteserrat),
          ),
          TextSpan(
            text: "Login",
            recognizer: TapGestureRecognizer()..onTap = onPressed,
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 17.0,
                color: KConstantColors.textColor,
                fontWeight: FontWeight.bold,
                fontFamily: KConstantFonts.MonteserratB),
          )
        ]),
      ),
    );
  }

  static skipAuthentication({required BuildContext context}) {
    final NavigationUtility navigationUtility = new NavigationUtility();
    return Center(
        child: TextButton(
      onPressed: navigationUtility.navigateTo(context, HomeRoute),
      child: Text(
        "Skip for now",
        style: TextStyle(
            color: KConstantColors.textColor,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w700,
            fontFamily: KConstantFonts.Monteserrat),
      ),
    ));
  }
}
