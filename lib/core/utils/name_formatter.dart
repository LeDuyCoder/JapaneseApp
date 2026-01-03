class NameFormatter{
  static String formatName(String fullname) {
    if (fullname.trim().isEmpty) return "";

    List<String> parts = fullname.trim().split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    } else {
      String first = parts[parts.length - 2][0].toUpperCase();
      String second = parts.last[0].toUpperCase();
      return first + second;
    }
  }
}