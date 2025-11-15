import 'package:dio/dio.dart';
import 'package:oasis/data/remote/dto/api_respuesta.dart';
import 'package:oasis/data/remote/dto/datos_basicos_actualizar_dto.dart';
import 'package:oasis/data/remote/dto/datos_basicos_dto.dart';

class DatosBasicosApi {
  final Dio _dio;

  DatosBasicosApi(this._dio);

  Future<ApiRespuesta<DatosBasicosDTO>> obtenerDatosBasicos(int idUsuario) async {
    try {
      final response = await _dio.get(
        'perfil/datos-basicos/consultar/$idUsuario',
        options: Options(extra: {'tokenRequerido': true}),
      );

      return ApiRespuesta.fromJson(
        response.data as Map<String, dynamic>,
            (json) => DatosBasicosDTO.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al obtener datos básicos',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }

  Future<ApiRespuesta<Map<String, dynamic>>> actualizarUsuario(
      int idEjecutor,
      DatosBasicosActualizarDTO dto,
      ) async {
    try {
      final response = await _dio.put(
        'perfil/usuario/datos-basicos/actualizar/$idEjecutor',
        data: dto.toJson(),
        options: Options(extra: {'tokenRequerido': true}),
      );

      return ApiRespuesta.fromJson(
        response.data as Map<String, dynamic>,
            (json) => json as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al actualizar usuario',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }
}