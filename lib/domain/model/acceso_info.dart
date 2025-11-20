class AccesoInfo {
  final int idUsuario;
  final String telefonoAcceso;

  AccesoInfo({
    required this.idUsuario,
    required this.telefonoAcceso,

  });

  factory AccesoInfo.fromJson(Map<String, dynamic> json) {
    return AccesoInfo(
      idUsuario: json['idUsuario'] as int,
      telefonoAcceso: json['telefonoAcceso'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'telefonoAcceso': telefonoAcceso,
    };
  }

  AccesoInfo copyWith({
    int? idUsuario,
    String? telefonoAcceso,
    String? correoAcceso,
    bool? correoVerificado,
  }) {
    return AccesoInfo(
      idUsuario: idUsuario ?? this.idUsuario,
      telefonoAcceso: telefonoAcceso ?? this.telefonoAcceso,
    );
  }
}