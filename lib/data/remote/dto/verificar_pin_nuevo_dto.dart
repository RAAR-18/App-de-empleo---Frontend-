class VerificarPinNuevoDto {
  final int idCambioTelefono;
  final String pinNuevo;

  VerificarPinNuevoDto({
    required this.idCambioTelefono,
    required this.pinNuevo,
  });

  Map<String, dynamic> toJson() {
    return {
      'idCambioTelefono': idCambioTelefono,
      'pinNuevo': pinNuevo,
    };
  }
}