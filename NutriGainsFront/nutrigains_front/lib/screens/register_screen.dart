import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/register_provider.dart';
import '../services/auth_service.dart';
import '../ui/input_decorations.dart';
import '../widgets/CustomToast.dart';
import '../widgets/auth_background.dart';
import '../widgets/card_container.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
                      'Crear cuenta',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 60),
                    ChangeNotifierProvider(
                      create: (_) => RegisterFormProvider(),
                      child: _RegisterForm(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'login'),
                style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(const StadiumBorder()),
                ),
                child: const Text(
                  '¿Ya tienes una cuenta?',
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

class _RegisterForm extends StatelessWidget with InputValidationMixin {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);

    return SingleChildScrollView(
      // Utiliza SingleChildScrollView como contenedor principal
      child: Form(
        key: registerForm.formKey,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                hintText: '',
                labelText: 'Username',
                prefixIcon: Icons.person,
              ),
              style: const TextStyle(color: Colors.white, fontSize: 20),
              onChanged: (value) => registerForm.username = value,
              validator: (name) {
                if (isTextValid(name)) {
                  return null;
                } else {
                  return 'Name field cant be null';
                }
              },
            ),
            const SizedBox(height: 40),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*******',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline,
              ),
              onChanged: (value) => registerForm.password = value,
              style: TextStyle(color: Colors.white, fontSize: 20),
              validator: (password) {
                if (isPasswordValid(password)) {
                  return null;
                } else {
                  return 'Enter a valid password';
                }
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Colors.grey,
              color: Colors.amber,
              onPressed: registerForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      if (!registerForm.isValidForm()) return;

                      registerForm.isLoading = true;

                      final String? errorMessage = await authService.register(
                        registerForm.username,
                        registerForm.password,
                      );

                      if (errorMessage == '201') {
                        CustomToast.customToast(
                            'Usuario creado con exito', context);
                        Navigator.pushReplacementNamed(context, 'login');
                      } else {
                        CustomToast.customToast(
                            'Este usuario ya existe', context);
                        Navigator.pushReplacementNamed(context, 'register');
                        registerForm.isLoading = false;
                        print(errorMessage);
                      }
                    },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  registerForm.isLoading ? 'Espere' : 'Registrar',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

mixin InputValidationMixin {
  bool isTextValid(texto) => texto.length > 0;

  bool isPasswordValid(password) => password.length > 6;
}
