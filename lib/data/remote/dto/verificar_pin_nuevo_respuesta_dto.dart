class VerificarPinNuevoRespuestaDto {
  final int idCambioTelefono;
  final bool verificado;
  final bool cambioCompletado;
  final String nuevoTelefono;
  final String mensaje;

  VerificarPinNuevoRespuestaDto({
    required this.idCambioTelefono,
    required this.verificado,
    required this.cambioCompletado,
    required this.nuevoTelefono,
    required this.mensaje,
  });

  factory VerificarPinNuevoRespuestaDto.fromJson(Map<String, dynamic> json) {
    return VerificarPinNuevoRespuestaDto(
      idCambioTelefono: json['idCambioTelefono'] as int,
      verificado: json['verificado'] as bool,
      cambioCompletado: json['cambioCompletado'] as bool,
      nuevoTelefono: json['nuevoTelefono'] as String,
      mensaje: json['mensaje'] as String,
    );
  }
}