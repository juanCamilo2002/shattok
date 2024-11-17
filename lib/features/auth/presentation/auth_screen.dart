import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shattok/core/widgets/forms/text_field.dart';
import 'package:shattok/features/auth/state/auth_notifier.dart';
import 'package:shattok/routes/app_routes.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn(BuildContext context, WidgetRef ref) async {
    await ref
        .read(authNotifierProvider.notifier)
        .signIn(emailController.text.trim(), passwordController.text.trim());
  }



  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Escuchar cambios en el estado de autenticación
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.user != null) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.tabs,
        );
      } else if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: authState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFieldCustom(
                        label: 'Email', controller: emailController),
                    TextFieldCustom(
                      label: 'Password',
                      controller: passwordController,
                      isPassword: true,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _handleSignIn(context, ref),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Navegar a la pantalla de registro
                            Navigator.pushNamed(
                              context,
                              AppRoutes.register,
                            );
                          },
                          child: const Text('Create an Account'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navegar a la pantalla de recuperar contraseña
                            Navigator.pushNamed(
                              context,
                              AppRoutes.forgotPassword,
                            );
                          },
                          child: const Text('Forgot Password?'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
