class IniciarCambioTelefonoRespuestaDto {
  final int idCambioTelefono;
  final String telefonoAnterior;
  final String telefonoNuevo;
  final bool pinAnteriorEnviado;
  final String mensaje;

  IniciarCambioTelefonoRespuestaDto({
    required this.idCambioTelefono,
    required this.telefonoAnterior,
    required this.telefonoNuevo,
    required this.pinAnteriorEnviado,
    required this.mensaje,
  });

  factory IniciarCambioTelefonoRespuestaDto.fromJson(Map<String, dynamic> json) {
    return IniciarCambioTelefonoRespuestaDto(
      idCambioTelefono: json['idCambioTelefono'] as int,
      telefonoAnterior: json['telefonoAnterior'] as String,
      telefonoNuevo: json['telefonoNuevo'] as String,
      pinAnteriorEnviado: json['pinAnteriorEnviado'] as bool,
      mensaje: json['mensaje'] as String,
    );
  }
}