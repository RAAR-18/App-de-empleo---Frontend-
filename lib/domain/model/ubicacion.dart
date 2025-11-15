class Ubicacion {
  final int idUbicacion;
  final String nombreUbicacion;
  final int? idPadreUbicacion;
  final String? nombrePadre;

  const Ubicacion({
    required this.idUbicacion,
    required this.nombreUbicacion,
    this.idPadreUbicacion,
    this.nombrePadre,
  });

  // Mostrar ubicación completa con padre
  String get nombreCompleto {
    if (nombrePadre != null && nombrePadre!.isNotEmpty) {
      return '$nombreUbicacion, $nombrePadre';
    }
    return nombreUbicacion;
  }

  @override
  String toString() => nombreCompleto;

  @override
  bool operator ==(Object other) {
    return other is Ubicacion && other.idUbicacion == idUbicacion;
  }

  @override
  int get hashCode => idUbicacion.hashCode;
}