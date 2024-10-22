// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/login_provider.dart';
import '../services/auth_service.dart';
import '../ui/input_decorations.dart';
import '../widgets/CustomToast.dart';
import '../widgets/auth_background.dart';
import '../widgets/card_container.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 60),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'register'),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.black),
                  shape: MaterialStateProperty.all(const StadiumBorder()),
                ),
                child: const Text(
                  'Crear una nueva cuenta',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'username',
              labelText: 'Username',
              prefixIcon: Icons.person,
            ),
            onChanged: (value) => loginForm.username = value,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 40),
          Column(
            children: [
              TextFormField(
                autocorrect: false,
                obscureText: true,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '*****',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline,
                ),
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  return (value != null && value.length >= 5)
                      ? null
                      : 'La contraseña debe tener al menos 5 caracteres';
                },
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 10),
            ],
          ),
          const SizedBox(height: 30),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.black,
            elevation: 1,
            color: Colors.amber,
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final authService =
                        Provider.of<AuthService>(context, listen: false);

                    if (!loginForm.isValidForm()) return;

                    // validar si el login es correcto
                    final String? data = await authService.login(
                        loginForm.username, loginForm.password);
                    final spliter = data?.split(',');
                    loginForm.isLoading = true;
                    if (spliter?[0] == '200') {
                      if (spliter?[1] == 'ROLE_ADMIN') {
                        Navigator.pushReplacementNamed(context, '');
                      } else {
                        Navigator.pushReplacementNamed(
                            context, 'userMainScreen');
                      }
                    } else {
                      CustomToast.customToast(
                          'Email or password incorrect', context);
                      Navigator.pushReplacementNamed(context, 'login');
                    }
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(
                loginForm.isLoading ? 'Espere' : 'Ingresar',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black45,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
