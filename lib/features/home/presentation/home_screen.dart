import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shattok/features/auth/state/auth_notifier.dart';
import 'package:shattok/routes/app_routes.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _handleSignOut(BuildContext context, WidgetRef ref) async {
    // sign out
    await ref.read(authNotifierProvider.notifier).signOut();

    // redirect user to login screen
    Navigator.pushReplacementNamed(context, AppRoutes.auth);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to the home screen!'),
            ElevatedButton(
              onPressed: () => _handleSignOut(context, ref),
              child: const Text('Sign Out'),
            ),
            if (authState.isLoading)
              const CircularProgressIndicator(), // Mostrar indicador de carga si está cargando
            if (authState.error != null)
              Text(
                'Error: ${authState.error}',
                style: const TextStyle(color: Colors.red),
              ), // Mostrar errores si existen
          ],
        ),
      ),
    );
  }
}