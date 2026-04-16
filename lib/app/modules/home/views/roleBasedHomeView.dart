import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radianthyve_unified/app/modules/home/views/home_view.dart';
import 'package:radianthyve_unified/app/modules/home/views/teachers_home_view.dart';
import 'package:radianthyve_unified/app/modules/home/views/principal_home_view.dart';
import 'package:radianthyve_unified/utils/roleBasedNavigation.dart';

/// Unified home view that routes to role-specific screens
class UnifiedHomeView extends StatelessWidget {
  const UnifiedHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final userRole = getUserRole();
    
    // Route to appropriate home based on role
    switch(userRole.toLowerCase()) {
      case 'teacher':
        return const TeachersHomeView();
      case 'parent':
        return HomeView();
      case 'principal':
      case 'admin':
        return const PrincipalHomeView();
      default:
        return HomeView();
    }
  }
}
