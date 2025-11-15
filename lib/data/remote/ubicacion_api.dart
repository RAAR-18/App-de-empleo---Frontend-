import 'package:dio/dio.dart';
import 'package:oasis/data/remote/dto/api_respuesta.dart';

class UbicacionApi {
  final Dio _dio;

  UbicacionApi(this._dio);

  Future<ApiRespuesta<Map<String, dynamic>>> buscarUbicaciones({
    required String buscar,
    String campoBusqueda = 'nombreUbicacion',
    String campoOrden = 'nombreUbicacion',
    String orden = 'ASC',
    int numPagina = 0,
    int tamanio = 10,
  }) async {
    try {
      final response = await _dio.get(
        'perfil/ubicacion/listar-paginado',
        queryParameters: {
          'buscar': buscar,
          'campoBusqueda': campoBusqueda,
          'campoOrden': campoOrden,
          'orden': orden,
          'numPagina': numPagina,
          'tamanio': tamanio,
        },
        options: Options(extra: {'tokenRequerido': true}),
      );

      return ApiRespuesta.fromJson(
        response.data as Map<String, dynamic>,
            (json) => json as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al buscar ubicaciones',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }
}