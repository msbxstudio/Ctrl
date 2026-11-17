extension StringX on String {
  String obscure({String separator = ''}) {
    return split(' ').map((e) => '${e.substring(0, 1)}.').join(separator);
  }

  String normalizeForSearch() {
    return toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[áàäâãå]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöôõ]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll(RegExp(r'[ñ]'), 'n')
        .replaceAll(RegExp(r'[ç]'), 'c');
  }
}
