class Imagen {
  final int? idImagen;
  final int idUsuario;
  final String nombrePublicoImagen;
  final String nombrePrivadoImagen;
  final String tipoImagen;
  final String tamanioImagen;
  final int favoritaImagen;
  final int categoria; // perfil = 1, portafolio = 2

  const Imagen({
    this.idImagen,
    required this.idUsuario,
    required this.nombrePublicoImagen,
    required this.nombrePrivadoImagen,
    required this.tipoImagen,
    required this.tamanioImagen,
    required this.favoritaImagen,
    required this.categoria,
  });

  @override
  String toString() {
    return 'Imagen(idImagen: $idImagen, idUsuario: $idUsuario, '
        'nombrePublico: $nombrePublicoImagen, categoria: $categoria)';
  }

  @override
  bool operator ==(Object other) {
    return other is Imagen && other.idImagen == idImagen;
  }

  @override
  int get hashCode => idImagen.hashCode;
}