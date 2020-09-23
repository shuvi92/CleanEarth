import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:timwan/ui/widgets/loading_button.dart';
import 'package:timwan/ui/widgets/text_link.dart';
import 'package:timwan/viewmodels/signin_view_model.dart';

class SignInScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ViewModelBuilder<SignInViewModel>.reactive(
        viewModelBuilder: () => SignInViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Welcome',
                    style: TextStyle(fontSize: 38),
                  ),
                  TextField(
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    controller: emailController,
                  ),
                  TextField(
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    obscureText: true,
                    controller: passwordController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 35,
                    child: (model.hasErrors
                        ? Text(
                            model.errors,
                            style: TextStyle(color: Colors.red),
                          )
                        : Container()),
                  ),
                  LoadingButton(
                    title: "Sign In",
                    isLoading: model.isLoading,
                    onPressed: () => model.signInWithEmail(
                        email: emailController.text,
                        password: passwordController.text),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextLink(
                    onPressed: () => model.navigateToSignUp(),
                    text: 'Create an account if you\'re new.',
                  ),
                  Divider(
                    height: 24,
                  ),
                  LoadingButton(
                    title: "or Continue Anonymous",
                    isLoading: model.isLoading,
                    onPressed: model.signInAnonymously,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
