import 'package:dio/dio.dart';
import 'package:oasis/data/remote/dto/api_respuesta.dart';

class PortafolioApi {
  final Dio _dio;

  PortafolioApi(this._dio);

  // Obtiene el portafolio de un usuario
  Future<ApiRespuesta<Map<String, dynamic>>> obtenerPortafolio(
      int idUsuario) async {
    try {
      final response = await _dio.get(
        'perfil/portafolio/$idUsuario',
        options: Options(extra: {'tokenRequerido': true}),
      );

      return ApiRespuesta.fromJson(
        response.data as Map<String, dynamic>,
            (json) => json as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al obtener portafolio',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }

  // Sube una nueva imagen al portafolio
  Future<ApiRespuesta<Map<String, dynamic>>> subirImagenPortafolio({
    required int idUsuario,
    required String rutaArchivo,
    required String nombreProyecto,
  }) async {
    try {
      final formData = FormData.fromMap({
        'archivo': await MultipartFile.fromFile(
          rutaArchivo,
          filename: rutaArchivo.split('/').last,
        ),
        'idUsuario': idUsuario,
        'nombreProyecto': nombreProyecto,
      });

      final response = await _dio.post(
        'usuario/perfil/imagen-portafolio/agregar',
        data: formData,
        options: Options(
          extra: {'tokenRequerido': true},
          contentType: 'multipart/form-data',
        ),
      );

      return ApiRespuesta.fromJson(
        response.data as Map<String, dynamic>,
            (json) => json as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al subir imagen al portafolio',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }

  // Elimina una imagen del portafolio
  Future<ApiRespuesta<Map<String, dynamic>>> eliminarImagen(
      int idImagen) async {
    try {
      final response = await _dio.delete(
        'usuario/perfil/imagen/eliminar/$idImagen',
        options: Options(extra: {'tokenRequerido': true}),
      );

      return ApiRespuesta.fromJson(
        response.data as Map<String, dynamic>,
            (json) => json as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al eliminar imagen',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }
}