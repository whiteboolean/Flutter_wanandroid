List<E> parseList<E>(dynamic listJson, E Function(dynamic json) parseItem) {
  if (listJson is List) {
    return listJson.map((e) => parseItem(e)).toList();
  } else {
    return [];
  }
}
