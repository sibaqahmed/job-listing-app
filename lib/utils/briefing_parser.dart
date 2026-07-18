String? extractLocationFromBriefing(String? briefing) {
  if (briefing == null || briefing.trim().isEmpty) return null;

  final lower = briefing.toLowerCase();

  final patterns = [
    'applicable location for project:',
    'location for project:',
    'applicable location:',
    'location:',
    'applicable location for project',
  ];

  for (final p in patterns) {
    final idx = lower.indexOf(p);
    if (idx >= 0) {
      final after = briefing.substring(idx + p.length).trim();
      final endIdx = after.indexOf(RegExp(r'[\n\r<\.]'));
      final raw = endIdx >= 0 ? after.substring(0, endIdx) : after;
      final cleaned = raw.replaceAll(RegExp(r'[^A-Za-z0-9,\s\-]'), '').trim();
      if (cleaned.isNotEmpty) return cleaned;
    }
  }

  final cityCountry = RegExp(r'([A-Z][a-z]{2,}(?:\s[A-Z][a-z]{2,}){0,2})\s+(India|USA|United States|UK|United Kingdom|Canada)', caseSensitive: false);
  final match = cityCountry.firstMatch(briefing);
  if (match != null) return match.group(0)?.trim();

  final knownCities = ['Coimbatore', 'Bengaluru', 'Bangalore', 'Mumbai', 'Delhi', 'Hyderabad', 'Chennai', 'Pune', 'Kolkata', 'Noida'];
  for (final c in knownCities) {
    if (lower.contains(c.toLowerCase())) return c;
  }

  return null;
}
