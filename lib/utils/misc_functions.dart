
String capitalize(String input) {
  if (input.isEmpty) return '';
  return input
      .split(' ')
      .map((word) => word.substring(0, 1).toUpperCase() + word.substring(1))
      .join(' ');
}
