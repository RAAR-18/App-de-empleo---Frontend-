class PalabraClaveDTO {
  final int idPalabraClave;
  final String textoPalabraClave;

  PalabraClaveDTO({
    required this.idPalabraClave,
    required this.textoPalabraClave,
  });

  factory PalabraClaveDTO.fromJson(Map<String, dynamic> json) {
    return PalabraClaveDTO(
      idPalabraClave: json['idPalabraClave'] as int,
      textoPalabraClave: json['textoPalabraClave'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPalabraClave': idPalabraClave,
      'textoPalabraClave': textoPalabraClave,
    };
  }
}