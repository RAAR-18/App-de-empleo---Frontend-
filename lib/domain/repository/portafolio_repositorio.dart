abstract class PortafolioRepositorio {

  Future<Map<String, dynamic>> obtenerPortafolio(int idUsuario);

  // Sube una nueva imagen al portafolio
  Future<void> subirImagenPortafolio(
      int idUsuario,
      String rutaArchivo,
      String nombreProyecto,
      );

  // Elimina una imagen del portafolio
  Future<void> eliminarImagenPortafolio(int idImagen);
}