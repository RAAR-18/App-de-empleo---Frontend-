class CambioTelefono {
  final int idCambioTelefono;
  final String telefonoAnterior;
  final String telefonoNuevo;
  final bool pinAnteriorEnviado;
  final bool verificadoAnterior;
  final bool verificadoNuevo;
  final bool completado;
  final String? mensaje;

  CambioTelefono({
    required this.idCambioTelefono,
    required this.telefonoAnterior,
    required this.telefonoNuevo,
    required this.pinAnteriorEnviado,
    this.verificadoAnterior = false,
    this.verificadoNuevo = false,
    this.completado = false,
    this.mensaje,
  });

  factory CambioTelefono.fromJson(Map<String, dynamic> json) {
    return CambioTelefono(
      idCambioTelefono: json['idCambioTelefono'] as int,
      telefonoAnterior: json['telefonoAnterior'] as String,
      telefonoNuevo: json['telefonoNuevo'] as String,
      pinAnteriorEnviado: json['pinAnteriorEnviado'] as bool,
      verificadoAnterior: json['verificadoAnterior'] as bool? ?? false,
      verificadoNuevo: json['verificadoNuevo'] as bool? ?? false,
      completado: json['completado'] as bool? ?? false,
      mensaje: json['mensaje'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCambioTelefono': idCambioTelefono,
      'telefonoAnterior': telefonoAnterior,
      'telefonoNuevo': telefonoNuevo,
      'pinAnteriorEnviado': pinAnteriorEnviado,
      'verificadoAnterior': verificadoAnterior,
      'verificadoNuevo': verificadoNuevo,
      'completado': completado,
      'mensaje': mensaje,
    };
  }

  CambioTelefono copyWith({
    int? idCambioTelefono,
    String? telefonoAnterior,
    String? telefonoNuevo,
    bool? pinAnteriorEnviado,
    bool? verificadoAnterior,
    bool? verificadoNuevo,
    bool? completado,
    String? mensaje,
  }) {
    return CambioTelefono(
      idCambioTelefono: idCambioTelefono ?? this.idCambioTelefono,
      telefonoAnterior: telefonoAnterior ?? this.telefonoAnterior,
      telefonoNuevo: telefonoNuevo ?? this.telefonoNuevo,
      pinAnteriorEnviado: pinAnteriorEnviado ?? this.pinAnteriorEnviado,
      verificadoAnterior: verificadoAnterior ?? this.verificadoAnterior,
      verificadoNuevo: verificadoNuevo ?? this.verificadoNuevo,
      completado: completado ?? this.completado,
      mensaje: mensaje ?? this.mensaje,
    );
  }
}
