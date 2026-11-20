/// Limiteur de débit à fenêtre glissante, en mémoire.
///
/// Suffisant pour une instance unique. Pour plusieurs instances derrière un
/// répartiteur de charge, remplacer par une implémentation partagée
/// (Redis, base de données) qui respecte la même interface.
abstract interface class RateLimiter {
  /// Enregistre une tentative pour [key] et indique si elle est autorisée.
  bool hit(String key);
}

class MemoryRateLimiter implements RateLimiter {
  MemoryRateLimiter({required this.maxHits, required this.window, this.maxKeys = 10000});

  final int maxHits;
  final Duration window;

  /// Borne la mémoire utilisée en cas d'afflux d'adresses différentes.
  final int maxKeys;

  final Map<String, List<DateTime>> _hits = {};

  @override
  bool hit(String key) {
    final now = DateTime.now();
    final cutoff = now.subtract(window);
    if (_hits.length >= maxKeys) _purge(cutoff);
    if (_hits.length >= maxKeys) _hits.remove(_hits.keys.first);

    final list = _hits.putIfAbsent(key, () => [])..removeWhere((t) => t.isBefore(cutoff));
    if (list.length >= maxHits) return false;
    list.add(now);
    return true;
  }

  void _purge(DateTime cutoff) {
    _hits.removeWhere((_, list) => list.every((t) => t.isBefore(cutoff)));
  }
}
