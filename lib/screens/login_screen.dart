import 'package:flutter/material.dart';

import '../widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextFormField(
              iconData: Icons.email,
              controller: emailController,
              hintText: "Email",
              isObsecure: false,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextFormField(
              iconData: Icons.lock,
              controller: passwordController,
              hintText: "Password",
              isObsecure: true,
            ),
          ],
        ),
      ),
    );
  }
}
