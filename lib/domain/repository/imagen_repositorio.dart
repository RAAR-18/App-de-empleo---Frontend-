abstract class ImagenRepository {
  Future<String?> obtenerFotoPerfil(int idUsuario);
  Future<void> subirFotoPerfil(int idUsuario, String rutaArchivo);
}