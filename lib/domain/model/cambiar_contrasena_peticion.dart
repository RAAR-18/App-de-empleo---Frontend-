class CambiarContrasenaPeticion {
  final String contrasenaActual;
  final String contrasenaNueva;

  CambiarContrasenaPeticion({
    required this.contrasenaActual,
    required this.contrasenaNueva,
  });

  Map<String, dynamic> toJson() {
    return {
      'contrasenaActual': contrasenaActual,
      'contrasenaNueva': contrasenaNueva,
    };
  }

  @override
  String toString() {
    return 'CambiarContrasenaRequest{contrasenaActual: [OCULTO], contrasenaNueva: [OCULTO]}';
  }
}