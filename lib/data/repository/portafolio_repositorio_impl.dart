import 'package:oasis/data/remote/portafolio_api.dart';
import 'package:oasis/domain/model/imagen_portafolio.dart';
import 'package:oasis/domain/repository/portafolio_repositorio.dart';

class PortafolioRepositorioImpl implements PortafolioRepositorio {
  final PortafolioApi _api;

  PortafolioRepositorioImpl(this._api);

  @override
  Future<Map<String, dynamic>> obtenerPortafolio(int idUsuario) async {
    final respuesta = await _api.obtenerPortafolio(idUsuario);

    if (respuesta.datos == null || respuesta.codigoEstado != 200) {
      throw Exception(respuesta.mensaje ?? 'Error al obtener portafolio');
    }

    final datos = respuesta.datos!;
    final imagenesJson = datos['imagenes'] as List;
    final imagenes = imagenesJson
        .map((json) => ImagenPortafolio.fromJson(json as Map<String, dynamic>))
        .toList();

    return {
      'imagenes': imagenes,
      'totalProyectos': datos['totalProyectos'] as int,
      'limiteMaximo': datos['limiteMaximo'] as int,
    };
  }

  @override
  Future<void> subirImagenPortafolio(
      int idUsuario,
      String rutaArchivo,
      String nombreProyecto,
      ) async {
    final respuesta = await _api.subirImagenPortafolio(
      idUsuario: idUsuario,
      rutaArchivo: rutaArchivo,
      nombreProyecto: nombreProyecto,
    );

    if (respuesta.codigoEstado != 200) {
      throw Exception(respuesta.mensaje ?? 'Error al subir imagen');
    }
  }

  @override
  Future<void> eliminarImagenPortafolio(int idImagen) async {
    final respuesta = await _api.eliminarImagen(idImagen);

    if (respuesta.codigoEstado != 200) {
      throw Exception(respuesta.mensaje ?? 'Error al eliminar imagen');
    }
  }
}