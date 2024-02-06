extension CapitalizeFirst on String {
  String capitalizeFirst() {
    assert(isNotEmpty, 'String cannot be empty');
    if (length == 1) {
      return toUpperCase();
    }
    return substring(0, 1).toUpperCase() + substring(1);
  }
}
