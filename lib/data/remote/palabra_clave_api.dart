import 'package:dio/dio.dart';
import 'package:oasis/data/remote/dto/api_respuesta.dart';
import 'package:oasis/data/remote/dto/palabra_clave_dto.dart';

class PalabraClaveApi {
  final Dio _dio;

  PalabraClaveApi(this._dio);

  Future<ApiRespuesta<List<PalabraClaveDTO>>> obtenerCatalogo() async {
    try {
      final response = await _dio.get(
        'palabra-clave/catalogo',
        options: Options(extra: {'tokenRequerido': true}),
      );

      return ApiRespuesta.fromJson(
        response.data as Map<String, dynamic>,
            (json) => (json as List)
            .map((e) => PalabraClaveDTO.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al obtener catálogo',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }

  // Agregar palabras clave a un usuario
  // Envía: { "idUsuario": 123, "idsPalabrasClave": [1, 5, 8] }
  Future<ApiRespuesta<void>> agregarPalabrasClave(
      int idUsuario,
      List<int> idsPalabrasClave,
      ) async {
    try {
      final response = await _dio.post(
        'palabra-clave/agregar',
        data: {
          'idUsuario': idUsuario,
          'idsPalabrasClave': idsPalabrasClave,
        },
        options: Options(extra: {'tokenRequerido': true}),
      );

      return ApiRespuesta.fromJson(
        response.data as Map<String, dynamic>,
            (json) => null,
      );
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al agregar palabras clave',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }
}