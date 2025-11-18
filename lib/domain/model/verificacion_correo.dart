class VerificacionCorreo {
  final bool exito;
  final String mensaje;
  final String? correoVerificado;
  final int? estadoVerificacion; // 1=sin verificar, 2=pendiente, 3=verificado

  VerificacionCorreo({
    required this.exito,
    required this.mensaje,
    this.correoVerificado,
    this.estadoVerificacion,
  });

  factory VerificacionCorreo.fromJson(Map<String, dynamic> json) {
    return VerificacionCorreo(
      exito: json['exito'] ?? false,
      mensaje: json['mensaje'] ?? '',
      correoVerificado: json['correoVerificado'],
      estadoVerificacion: json['estadoVerificacion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exito': exito,
      'mensaje': mensaje,
      'correoVerificado': correoVerificado,
      'estadoVerificacion': estadoVerificacion,
    };
  }

  bool get estaVerificado => estadoVerificacion == 3;
  bool get estaPendiente => estadoVerificacion == 2;
  bool get sinVerificar => estadoVerificacion == 1;

  String get estadoTexto {
    switch (estadoVerificacion) {
      case 1:
        return 'Sin verificar';
      case 2:
        return 'Pendiente de verificación';
      case 3:
        return 'Verificado';
      default:
        return 'Desconocido';
    }
  }
}