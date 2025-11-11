class PalabraClave {
  final int idPalabraClave;
  final String textoPalabraClave;

  const PalabraClave({
    required this.idPalabraClave,
    required this.textoPalabraClave,
  });

  PalabraClave copyWith({
    int? idPalabraClave,
    String? textoPalabraClave,
  }) {
    return PalabraClave(
      idPalabraClave: idPalabraClave ?? this.idPalabraClave,
      textoPalabraClave: textoPalabraClave ?? this.textoPalabraClave,
    );
  }

  @override
  String toString() {
    return 'PalabraClave(idPalabraClave: $idPalabraClave, textoPalabraClave: $textoPalabraClave)';
  }

  @override
  bool operator ==(Object other) {
    return other is PalabraClave && other.idPalabraClave == idPalabraClave;
  }

  @override
  int get hashCode => idPalabraClave.hashCode;
}
