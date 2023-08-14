String? validatePassword(String? value, String username, String email) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password.';
  }

  // Check for minimum length of 8 characters
  if (value.length < 8) {
    return 'Password must be at least 8 characters long.';
  }

  // Check for at least 1 number
  if (!value.contains(RegExp(r'\d'))) {
    return 'Password must contain at least 1 number.';
  }

  // Check for at least 1 uppercase letter
  if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain at least 1 uppercase letter.';
  }

  // Check for at least 1 lowercase letter
  if (!value.contains(RegExp(r'[a-z]'))) {
    return 'Password must contain at least 1 lowercase letter.';
  }

  // Check for at least 1 special character
  if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return 'Password must contain at least 1 special character.';
  }

  // Check if the password is derived from the username field
  if (username.isNotEmpty &&
      value.toLowerCase().contains(username.toLowerCase())) {
    return 'Password cannot be derived from the username.';
  }

  // Check if the password is derived from the email field
  if (email.isNotEmpty && value.toLowerCase().contains(email.toLowerCase())) {
    return 'Password cannot be derived from the email address.';
  }

  // Check if the password is a commonly used password
  final commonPasswords = [
    'Password@123',
    '123456Seven',
    '12345678',
    '87654321',
    '11111111',
  ]; // Add more common passwords if needed
  if (commonPasswords.contains(value)) {
    return 'Password is commonly used. Please choose a stronger password.';
  }

  return null; // Return null if the validation succeeds
}
