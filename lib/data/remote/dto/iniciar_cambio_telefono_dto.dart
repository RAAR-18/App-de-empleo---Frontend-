class IniciarCambioTelefonoDto {
  final int idUsuario;
  final String telefonoNuevo;

  IniciarCambioTelefonoDto({
    required this.idUsuario,
    required this.telefonoNuevo,
  });

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'telefonoNuevo': telefonoNuevo,
    };
  }
}