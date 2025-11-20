class VerificarPinAnteriorDto {
  final int idCambioTelefono;
  final String pinAnterior;

  VerificarPinAnteriorDto({
    required this.idCambioTelefono,
    required this.pinAnterior,
  });

  Map<String, dynamic> toJson() {
    return {
      'idCambioTelefono': idCambioTelefono,
      'pinAnterior': pinAnterior,
    };
  }
}