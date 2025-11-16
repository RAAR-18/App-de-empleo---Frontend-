class GrupoArchivo {
  static const int hojaVida = 1;
  static const int documento = 2;
  static const int soporteEstudio = 3;
  static const int soporteExperiencia = 4;
  static const int otros = 5;

  static String getNombre(int grupo) {
    switch (grupo) {
      case hojaVida:
        return 'Hoja de vida';
      case documento:
        return 'Documento';
      case soporteEstudio:
        return 'Soporte estudio';
      case soporteExperiencia:
        return 'Soporte experiencia';
      case otros:
        return 'Otros';
      default:
        return 'Desconocido';
    }
  }
}