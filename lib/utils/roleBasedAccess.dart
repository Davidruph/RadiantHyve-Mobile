import 'package:get/get.dart';
import 'package:radianthyve_unified/commonWidgets/constant.dart';
import 'package:radianthyve_unified/utils/messages.dart';
import 'package:radianthyve_unified/utils/prefsKey.dart';

/// Check if current user has access to a specific screen/module
bool hasAccessTo(String requiredRole) {
  final userRole = box.read(PrefsKey.role)?.toString().toLowerCase() ?? '';
  
  // Admin has access to everything
  if (userRole == 'admin') return true;
  
  return userRole == requiredRole.toLowerCase();
}

/// Get list of accessible roles for a screen
List<String> getAccessibleRoles(String screenType) {
  switch (screenType.toLowerCase()) {
    // Parent screens
    case 'attendance':
    case 'childreports':
    case 'payment':
      return ['parent', 'admin'];
    
    // Teacher screens
    case 'markattendance':
    case 'studentdata':
    case 'myleave':
      return ['teacher', 'admin'];
    
    // Principal screens
    case 'stafflist':
    case 'parentslist':
    case 'studentlist':
    case 'staffleave':
    case 'certification':
    case 'mealtracking':
    case 'sleeplogs':
    case 'medication':
    case 'upcomingbirthday':
    case 'emergency':
    case 'program':
      return ['principal', 'admin'];
    
    // Common screens
    case 'message':
    case 'profile':
    case 'home':
      return ['parent', 'teacher', 'principal', 'admin'];
    
    default:
      return [];
  }
}

/// Check if user can access a screen
bool canAccessScreen(String screenType) {
  final userRole = box.read(PrefsKey.role)?.toString().toLowerCase() ?? 'parent';
  final allowedRoles = getAccessibleRoles(screenType);
  return allowedRoles.contains(userRole);
}

/// Show access denied message
void showAccessDenied() {
  Get.snackbar(
    'Access Denied',
    'You do not have permission to access this screen.',
    snackPosition: SnackPosition.BOTTOM,
    duration: Duration(seconds: 2),
  );
}
