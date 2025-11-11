import 'package:dio/dio.dart';
import 'package:oasis/data/remote/dto/api_respuesta.dart';
import 'package:oasis/data/remote/dto/perfil_dto.dart';
import 'package:oasis/data/remote/dto/palabra_clave_dto.dart';

class PerfilApi {
  final Dio _dio;

  PerfilApi(this._dio);

  Future<ApiRespuesta<PerfilDTO>> obtenerPerfil(int idUsuario) async {
    try {
      final response = await _dio.get(
        'perfil/$idUsuario',
        options: Options(extra: {'tokenRequerido': true}),
      );

      return ApiRespuesta.fromJson(
        response.data as Map<String, dynamic>,
            (json) => PerfilDTO.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al obtener el perfil',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }

  Future<ApiRespuesta<List<PalabraClaveDTO>>> obtenerPalabrasClave(int idUsuario) async {
    try {
      final response = await _dio.get(
        'perfil/palabra-clave/$idUsuario',
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
        mensaje: e.message ?? 'Error al obtener las palabras clave',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }
}
