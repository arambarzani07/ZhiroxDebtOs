class ResponseReader {
  const ResponseReader._();

  static Map<String, dynamic> mapFrom(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  static List<Map<String, dynamic>> listFrom(dynamic value) {
    if (value is List) {
      return value.map((item) => mapFrom(item)).toList();
    }
    return const <Map<String, dynamic>>[];
  }

  static dynamic pick(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      if (source.containsKey(key) && source[key] != null) {
        return source[key];
      }
    }
    return null;
  }
}
