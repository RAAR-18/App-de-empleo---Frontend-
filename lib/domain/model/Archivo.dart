class Archivo {
  final int idArchivo;
  final int idUsuario;
  final String nombrePublicoArchivo;
  final String nombrePrivadoArchivo;
  final String tipoArchivo;
  final String tamanioArchivo;
  final int grupoArchivo;
  final DateTime fechaSubida;

  Archivo({
    required this.idArchivo,
    required this.idUsuario,
    required this.nombrePublicoArchivo,
    required this.nombrePrivadoArchivo,
    required this.tipoArchivo,
    required this.tamanioArchivo,
    required this.grupoArchivo,
    required this.fechaSubida,
  });

  String get tamanioFormateado {
    try {
      final bytes = int.tryParse(tamanioArchivo);
      if (bytes == null) return tamanioArchivo;

      if (bytes < 1024) {
        return '$bytes B';
      } else if (bytes < 1024 * 1024) {
        final kb = (bytes / 1024).toStringAsFixed(2);
        return '$kb KB';
      } else {
        final mb = (bytes / (1024 * 1024)).toStringAsFixed(2);
        return '$mb MB';
      }
    } catch (e) {
      return tamanioArchivo;
    }
  }
}