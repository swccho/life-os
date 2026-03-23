abstract final class DashboardGreeting {
  static String forTime(DateTime now) {
    final h = now.hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  static String firstNameOrFallback(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) return 'there';
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.first;
  }
}
