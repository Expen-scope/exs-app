class Validator {
  static String? validateEmail(String email) {
    if (email.isEmpty) return "يجب إدخال البريد الإلكتروني";
    final RegExp emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(email)) return "صيغة البريد الإلكتروني غير صحيحة";
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return "يجب إدخال كلمة المرور";
    final RegExp regex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{7,}$');
    if (!regex.hasMatch(password)) {
      return "كلمة المرور يجب أن تحتوي على 7 أحرف على الأقل مع رقم ورمز خاص";
    }
    return null;
  }
}
