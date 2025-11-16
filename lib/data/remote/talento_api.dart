import 'package:dio/dio.dart';
import 'package:oasis/data/remote/dto/api_respuesta.dart';
import 'package:oasis/data/remote/dto/talento_dto.dart';
import 'package:oasis/data/remote/dto/rel_usuario_talento_dto.dart';
import 'package:oasis/data/remote/dto/talento_estadisticas_dto.dart';
import 'package:oasis/data/remote/dto/talento_agregar_dto.dart';

class TalentoApi {
  final Dio _dio;

  TalentoApi(this._dio);

  // Obtener todos los talentos de un usuario
  Future<ApiRespuesta<List<RelUsuarioTalentoDTO>>> obtenerTalentosUsuario(
      int idUsuario) async {
    try {
      final response = await _dio.get(
        'perfil/talento/listar/$idUsuario',
        options: Options(extra: {'tokenRequerido': true}),
      );

      return ApiRespuesta.fromJson(
        response.data as Map<String, dynamic>,
            (json) => (json as List)
            .map((e) =>
            RelUsuarioTalentoDTO.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al obtener los talentos del usuario',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }

  // Obtener talentos filtrados por tipo
  Future<ApiRespuesta<List<RelUsuarioTalentoDTO>>> obtenerTalentosPorTipo(
      int idUsuario, int tipo) async {
    try {
      final response = await _dio.get(
        'perfil/talento/listar/$idUsuario/tipo/$tipo',
        options: Options(extra: {'tokenRequerido': true}),
      );

      return ApiRespuesta.fromJson(
        response.data as Map<String, dynamic>,
            (json) => (json as List)
            .map((e) =>
            RelUsuarioTalentoDTO.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al obtener los talentos filtrados',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }

  // Obtener estadísticas de talentos
  Future<ApiRespuesta<TalentoEstadisticasDTO>> obtenerEstadisticas(
      int idUsuario) async {
    try {
      final response = await _dio.get(
        'perfil/talento/estadisticas/$idUsuario',
        options: Options(extra: {'tokenRequerido': true}),
      );

      return ApiRespuesta.fromJson(
        response.data as Map<String, dynamic>,
            (json) => TalentoEstadisticasDTO.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al obtener las estadísticas',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }

  // Obtener catálogo de talentos disponibles
  Future<ApiRespuesta<List<TalentoDTO>>> obtenerCatalogoTalentos() async {
    try {
      final response = await _dio.get(
        'perfil/talento/catalogo',
        options: Options(extra: {'tokenRequerido': true}),
      );

      return ApiRespuesta.fromJson(
        response.data as Map<String, dynamic>,
            (json) => (json as List)
            .map((e) => TalentoDTO.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al obtener el catálogo de talentos',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }

  // Agregar talento a usuario
  Future<ApiRespuesta<RelUsuarioTalentoDTO>> agregarTalento(
      TalentoAgregarDTO dto) async {
    try {
      final response = await _dio.post(
        'perfil/talento/agregar',
        data: dto.toJson(),
        options: Options(extra: {'tokenRequerido': true}),
      );

      return ApiRespuesta.fromJson(
        response.data as Map<String, dynamic>,
            (json) => RelUsuarioTalentoDTO.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al agregar el talento',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }

  // Editar nivel de dominio de un talento
  Future<ApiRespuesta<RelUsuarioTalentoDTO>> editarNivelTalento(
      int idUsuario, int idTalento, int nivelDominio) async {
    try {
      final response = await _dio.put(
        'perfil/talento/editar-nivel',
        data: {
          'idUsuario': idUsuario,
          'idTalento': idTalento,
          'nivelDominio': nivelDominio,
        },
        options: Options(extra: {'tokenRequerido': true}),
      );

      return ApiRespuesta.fromJson(
        response.data as Map<String, dynamic>,
            (json) => RelUsuarioTalentoDTO.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al editar el nivel del talento',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }

  // Eliminar talento de usuario
  Future<ApiRespuesta<void>> eliminarTalento(
      int idUsuario, int idTalento) async {
    try {
      final response = await _dio.delete(
        'perfil/talento/eliminar/$idUsuario/$idTalento',
        options: Options(extra: {'tokenRequerido': true}),
      );

      return ApiRespuesta.fromJson(
        response.data as Map<String, dynamic>,
            (json) => null,
      );
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al eliminar el talento',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }
}