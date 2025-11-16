class ImagenPortafolio {
  final int idImagen;
  final String nombreProyecto;
  final String urlImagen;
  final String tipo;

  const ImagenPortafolio({
    required this.idImagen,
    required this.nombreProyecto,
    required this.urlImagen,
    required this.tipo,
  });

  factory ImagenPortafolio.fromJson(Map<String, dynamic> json) {
    return ImagenPortafolio(
      idImagen: json['idImagen'] as int,
      nombreProyecto: json['nombrePublico'] as String,
      urlImagen: json['urlImagen'] as String,
      tipo: json['tipo'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'idImagen': idImagen,
    'nombreProyecto': nombreProyecto,
    'urlImagen': urlImagen,
    'tipo': tipo,
  };

  @override
  String toString() {
    return 'ImagenPortafolio(idImagen: $idImagen, nombreProyecto: $nombreProyecto, urlImagen: $urlImagen)';
  }

  @override
  bool operator ==(Object other) {
    return other is ImagenPortafolio && other.idImagen == idImagen;
  }

  @override
  int get hashCode => idImagen.hashCode;
}