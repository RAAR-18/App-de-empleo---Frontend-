class ImagenDTO {
  final int? idImagen;
  final int idUsuario;
  final String nombrePublicoImagen;
  final String nombrePrivadoImagen;
  final String tipoImagen;
  final String tamanioImagen;
  final int favoritaImagen;
  final int categoria;

  ImagenDTO({
    this.idImagen,
    required this.idUsuario,
    required this.nombrePublicoImagen,
    required this.nombrePrivadoImagen,
    required this.tipoImagen,
    required this.tamanioImagen,
    required this.favoritaImagen,
    required this.categoria,
  });

  factory ImagenDTO.fromJson(Map<String, dynamic> json) {
    return ImagenDTO(
      idImagen: json['idImagen'] as int?,
      idUsuario: json['idUsuario'] as int,
      nombrePublicoImagen: json['nombrePublicoImagen'] as String,
      nombrePrivadoImagen: json['nombrePrivadoImagen'] as String,
      tipoImagen: json['tipoImagen'] as String,
      tamanioImagen: json['tamanioImagen'] as String,
      favoritaImagen: json['favoritaImagen'] as int,
      categoria: json['categoria'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'idImagen': idImagen,
    'idUsuario': idUsuario,
    'nombrePublicoImagen': nombrePublicoImagen,
    'nombrePrivadoImagen': nombrePrivadoImagen,
    'tipoImagen': tipoImagen,
    'tamanioImagen': tamanioImagen,
    'favoritaImagen': favoritaImagen,
    'categoria': categoria,
  };
}