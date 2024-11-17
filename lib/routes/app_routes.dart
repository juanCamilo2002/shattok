import 'package:flutter/widgets.dart';
import 'package:shattok/features/auth/presentation/auth_screen.dart';
import 'package:shattok/features/auth/presentation/forgot_password_screen.dart';
import 'package:shattok/features/auth/presentation/register_screen.dart';
import 'package:shattok/features/home/presentation/home_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String auth = '/auth';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String tabs = '/tabs';

  static final routes = <String, WidgetBuilder>{
    home: (context) => const HomeScreen(),
    auth: (context) => const AuthScreen(),
    register: (context) => const RegisterScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    tabs: (context) => const HomeScreen(),
  };
}
