import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:radianthyve_unified/commonWidgets/constant.dart';
import 'package:radianthyve_unified/utils/prefsKey.dart';

/// Get home view based on user role
/// Roles expected: "parent", "teacher", "principal", "admin"
dynamic getHomeViewByRole() {
  final role = box.read(PrefsKey.role)?.toString().toLowerCase() ?? '';
  
  // Import the appropriate home views based on role
  // This will be populated based on available home views in the app
  switch(role) {
    case 'teacher':
      return null; // Will use TeachersHomeView when created
    case 'parent':
      return null; // Will use ParentsHomeView when created
    case 'principal':
    case 'admin':
      return null; // Will use PrincipalHomeView when created
    default:
      return null; // Default HomeView will be used
  }
}

/// Get user role from storage
String getUserRole() {
  return box.read(PrefsKey.role)?.toString() ?? 'parent';
}

/// Check if user is a teacher
bool isTeacher() {
  return getUserRole().toLowerCase() == 'teacher';
}

/// Check if user is a parent
bool isParent() {
  return getUserRole().toLowerCase() == 'parent';
}

/// Check if user is a principal or admin
bool isPrincipal() {
  final role = getUserRole().toLowerCase();
  return role == 'principal' || role == 'admin';
}
