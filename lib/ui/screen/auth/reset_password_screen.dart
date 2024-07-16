import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiro/ui/widgets/my_text_form_field.dart';
import 'package:tadbiro/utils/extensions/sizedbox_extension.dart';

import '../../../utils/exports/logics.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SendResetPasswordEvent(
              _emailController.text.trim(),
            ),
          );
      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parolni qayta tiklash')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              const Text(
                "Elektron pochtangizni kiriting.\nParolingizni tiklash havolasini jo'natamiz.",
                textAlign: TextAlign.center,
              ),
              16.height,
              MyTextFormField(
                controller: _emailController,
                validator: (p0) {
                  if (p0 == null || p0.trim().isEmpty) {
                    return "Email kiriting.";
                  } else if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(p0.trim())) {
                    return "Please, enter a valid email!";
                  }
                  return null;
                },
              ),
              12.height,
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is SendingResetState) {
                    return const Text("Havola jo'natilmoqda...");
                  }
                  if (state is SendingResetFailState) {
                    return Text(
                      "Xatolik: ${state.message}",
                      textAlign: TextAlign.center,
                    );
                  }
                  if (state is SendingResetSuccessState) {
                    return const Text(
                      "Havola jo'natildi.\nElektron pochtangizni tekshiring.",
                      textAlign: TextAlign.center,
                    );
                  }
                  return FilledButton(
                    onPressed: submit,
                    child: const Text("Jo'natish"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
