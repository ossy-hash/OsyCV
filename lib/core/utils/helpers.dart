String formatDate(DateTime? date) {
  if (date == null) return '';
  return '${date.month}/${date.year}';
}

String dateRangeString(DateTime? from, DateTime? to, {bool current = false}) {
  if (current) return '${formatDate(from)} - Present';
  if (from == null && to == null) return '';
  return '${formatDate(from)} - ${formatDate(to)}';
}
