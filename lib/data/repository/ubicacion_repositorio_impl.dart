import 'package:oasis/data/remote/ubicacion_api.dart';
import 'package:oasis/data/remote/dto/ubicacion_dto.dart';
import 'package:oasis/domain/model/ubicacion.dart';
import 'package:oasis/domain/repository/ubicacion_repositorio.dart';

class UbicacionRepositoryImpl implements UbicacionRepository {
  final UbicacionApi _api;

  UbicacionRepositoryImpl(this._api);

  @override
  Future<List<Ubicacion>> buscarUbicaciones(String termino) async {
    if (termino.isEmpty) {
      return [];
    }

    final respuesta = await _api.buscarUbicaciones(
      buscar: termino,
      tamanio: 20, // Límite de resultados para el autocompletado
    );

    if (respuesta.datos == null) {
      throw Exception(respuesta.mensaje ?? 'Error al buscar ubicaciones');
    }

    final contenido = respuesta.datos!['contenido'] as List<dynamic>;

    return contenido.map((json) {
      final dto = UbicacionDTO.fromJson(json as Map<String, dynamic>);
      return Ubicacion(
        idUbicacion: dto.idUbicacion,
        nombreUbicacion: dto.nombreUbicacion,
        idPadreUbicacion: dto.idPadreUbicacion,
        nombrePadre: dto.nombrePadre,
      );
    }).toList();
  }
}
