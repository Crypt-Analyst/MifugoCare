import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'core/constants/app_theme.dart';
import 'data/repositories/user_repository.dart';
import 'features/auth/screens/account_disabled_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/role_select_screen.dart';
import 'features/auth/screens/vet_pending_screen.dart';
import 'features/dashboards/admin_dashboard.dart';
import 'features/dashboards/buyer_dashboard.dart';
import 'features/dashboards/pastoralist_dashboard.dart';
import 'features/dashboards/vet_dashboard.dart';

class MifugoCareApp extends StatelessWidget {
  const MifugoCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MifugoCare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return const LoginScreen();
        }

        return FutureBuilder(
          future: UserRepository().getUserProfile(user.uid),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final profile = profileSnapshot.data;
            if (profile == null) {
              return RoleSelectScreen(user: user);
            }

            if (!profile.isActive) {
              return const AccountDisabledScreen();
            }

            if (profile.role == UserRole.vet && !profile.isVerified) {
              return const VetPendingScreen();
            }

            switch (profile.role) {
              case UserRole.pastoralist:
                return const PastoralistDashboard();
              case UserRole.vet:
                return const VetDashboard();
              case UserRole.buyer:
                return const BuyerDashboard();
              case UserRole.admin:
                return const AdminDashboard();
            }
          },
        );
      },
    );
  }
}
