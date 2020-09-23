import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:timwan/ui/widgets/loading_button.dart';
import 'package:timwan/viewmodels/signup_view_model.dart';

class SignUpScreen extends StatelessWidget {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      builder: (context, model, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.only(
              top: 30,
              left: 30,
              right: 30,
            ),
            children: <Widget>[
              Text(
                'Sign Up',
                style: TextStyle(fontSize: 38),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Full Name",
                ),
                controller: fullNameController,
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
                title: "Sign Up",
                isLoading: model.isLoading,
                onPressed: () => model.signUp(
                  fullName: fullNameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
