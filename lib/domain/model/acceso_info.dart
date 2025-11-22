class AccesoInfo {
  final int idUsuario;
  final String telefonoAcceso;
  final String? email;
  final int? estadoVerificacionCorreo;

  bool get correoVerificado => estadoVerificacionCorreo == 3; // o el estado que definas

  AccesoInfo({
    required this.idUsuario,
    required this.telefonoAcceso,
    this.email,
    this.estadoVerificacionCorreo,
  });

  factory AccesoInfo.fromJson(Map<String, dynamic> json) {
    return AccesoInfo(
      idUsuario: json['idUsuario'] as int,
      telefonoAcceso: json['telefonoAcceso'] as String,
      email: json['correoAcceso'] as String?,
      estadoVerificacionCorreo: json['estadoCorreoVerificado'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'telefonoAcceso': telefonoAcceso,
      'correoAcceso': email,
      'estadoCorreoVerificado': estadoVerificacionCorreo,
    };
  }

  AccesoInfo copyWith({
    int? idUsuario,
    String? telefonoAcceso,
    String? email,
    int? estadoVerificacionCorreo,
  }) {
    return AccesoInfo(
      idUsuario: idUsuario ?? this.idUsuario,
      telefonoAcceso: telefonoAcceso ?? this.telefonoAcceso,
      email: email ?? this.email,
      estadoVerificacionCorreo: estadoVerificacionCorreo ?? this.estadoVerificacionCorreo,
    );
  }
}
