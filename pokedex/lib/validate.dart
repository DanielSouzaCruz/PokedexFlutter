bool isValidName(String name) {
  return name.isEmpty ||
      RegExp(r'[0-9!@#\$%^&*()_+={}\[\]:;<>,.?~\\/\|°]').hasMatch(name);
}

bool isValidNumber(String number) {
  return number.isEmpty ||
      RegExp(r'[a-z!@#\$%^&*()_+={}\[\]:;<>,.?~\\/\|°]').hasMatch(number) ||
      number.length > 5;
}

bool isValidAvatar(String avatar) {
  return avatar.isEmpty;
}
