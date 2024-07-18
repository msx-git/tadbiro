import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tadbiro/utils/exports/navigation.dart';
import 'package:tadbiro/utils/extensions/sizedbox_extension.dart';

import '../../../logic/blocs/auth/auth_bloc.dart';
import '../../../utils/constants/assets.dart';
import '../../widgets/my_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  void submit() async {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            RegisterEvent(
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
    _passwordConfirmController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedAuthState) {
          navigationService.goBack();
        }
      },
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                SizedBox(
                  height: 160,
                  width: 300,
                  child: SvgPicture.asset(Assets.signLogo),
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
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (ctx, state) {
                    if (state is ErrorAuthState) {
                      return Text(state.message, textAlign: TextAlign.center);
                    }

                    return const SizedBox();
                  },
                ),
                Text(
                  "Ro'yxatdan o'tish",
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
                    if (p0 == null || p0.trim().isEmpty) {
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
                MyTextFormField(
                  labelText: "Parolni tasdiqlash",
                  controller: _passwordConfirmController,
                  isPassword: true,
                  isLast: true,
                  validator: (p0) {
                    if (p0!.trim().isEmpty) {
                      return "Please, confirm password!";
                    } else if (p0.length < 6) {
                      return "Password must be 6 characters long at least!";
                    } else if (_passwordController.text.trim() !=
                        _passwordConfirmController.text.trim()) {
                      return "Passwords didn't match.";
                    }
                    return null;
                  },
                ),
                12.height,
                FilledButton(
                  onPressed: submit,
                  child: const Text("Ro'yxatdan o'tish"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tizimga kirish"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
