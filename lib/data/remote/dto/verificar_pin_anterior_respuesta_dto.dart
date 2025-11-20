class VerificarPinAnteriorRespuestaDto {
  final int idCambioTelefono;
  final bool verificado;
  final bool pinNuevoEnviado;
  final String mensaje;

  VerificarPinAnteriorRespuestaDto({
    required this.idCambioTelefono,
    required this.verificado,
    required this.pinNuevoEnviado,
    required this.mensaje,
  });

  factory VerificarPinAnteriorRespuestaDto.fromJson(Map<String, dynamic> json) {
    return VerificarPinAnteriorRespuestaDto(
      idCambioTelefono: json['idCambioTelefono'] as int,
      verificado: json['verificado'] as bool,
      pinNuevoEnviado: json['pinNuevoEnviado'] as bool,
      mensaje: json['mensaje'] as String,
    );
  }
}