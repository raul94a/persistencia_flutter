extension CapitalizeFirst on String {
  String capitalizeFirst() {
    assert(isNotEmpty, 'String cannot be empty');
    return substring(0, 1).toUpperCase() + substring(1);
  }
}
