import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_academy_app/core/di/di.dart';
import 'package:oc_academy_app/presentation/features/auth/bloc/auth_bloc.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocProvider(
        create: (_) => getIt<AuthBloc>(),
        child: const LoginForm(),
      ),
    );
  }
}
