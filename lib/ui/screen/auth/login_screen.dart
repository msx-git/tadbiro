import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tadbiro/ui/screen/auth/register_screen.dart';
import 'package:tadbiro/utils/extensions/sizedbox_extension.dart';

import '../../../logic/blocs/auth/auth_bloc.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/exports/navigation.dart';
import '../../widgets/my_text_form_field.dart';
import '../../widgets/show_loader.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void submit() async {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  height: 160,
                  width: 300,
                  child: SvgPicture.asset(Assets.signLogo),
                ),
              ),
              Text(
                "Tadbiro",
                style: GoogleFonts.caveat(
                    fontWeight: FontWeight.w700,
                    fontSize: 60,
                    color: Colors.orange.shade800,
                    height: 0.6),
                textAlign: TextAlign.center,
              ),
              40.height,
              Text(
                "Tizimga kirish",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              20.height,
              MyTextFormField(
                labelText: "Email",
                controller: _emailController,
                isEmail: true,
                validator: (p0) {
                  if (p0 == null || p0
                      .trim()
                      .isEmpty) {
                    return "Please, enter email!";
                  } else if (!RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(p0.trim())) {
                    return "Please, enter a valid email!";
                  }
                  return null;
                },
              ),
              12.height,
              MyTextFormField(
                labelText: "Parol",
                controller: _passwordController,
                isPassword: true,
                isLast: true,
                validator: (p0) {
                  if (p0!.trim().isEmpty) {
                    return "Please, enter password!";
                  } else if (p0.length < 6) {
                    return "Password must be 6 characters long at least!";
                  }
                  return null;
                },
              ),
              12.height,
              FilledButton(
                onPressed: submit,
                child: const Text("Kirish"),
              ),
              12.height,
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, CupertinoPageRoute(
                    builder: (context) {
                      return const RegisterScreen();
                    },
                  ));
                },
                child: const Text("Ro'yxatdan O'tish"),
              ),
              20.height,
              TextButton(
                onPressed: () {
                  navigationService.navigateTo(AppRoute.resetPassword);
                },
                child: const Text("Parolingizni unutdingizmi?"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
