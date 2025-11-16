import 'package:dio/dio.dart';
import 'package:oasis/data/remote/dto/api_respuesta.dart';
import 'package:oasis/data/remote/dto/archivo_dto.dart';

class ArchivoApi {
  final Dio _dio;

  ArchivoApi(this._dio);

  Future<ApiRespuesta<ArchivoDTO>> obtenerCV(int idUsuario) async {
    try {
      final response = await _dio.get(
        '/usuario/perfil/archivo/cv/$idUsuario',
        options: Options(extra: {'tokenRequerido': true}),
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data['datos'] == null) {
          return ApiRespuesta(
            codigoEstado: 200,
            mensaje: data['mensaje'] as String? ?? 'Usuario sin CV',
            fechaHora: data['fechaHora'] as String? ?? DateTime.now().toIso8601String(),
            datos: null,
            error: null,
          );
        }

        try {
          return ApiRespuesta.fromJson(
            data,
                (json) => ArchivoDTO.fromJson(json as Map<String, dynamic>),
          );
        } catch (parseError) {
          return ApiRespuesta(
            codigoEstado: 200,
            mensaje: 'Usuario sin CV o datos incompletos',
            fechaHora: DateTime.now().toIso8601String(),
            datos: null,
            error: parseError.toString(),
          );
        }
      }

      return ApiRespuesta(
        codigoEstado: response.statusCode ?? -1,
        mensaje: 'Usuario sin CV',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: null,
      );

    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al obtener CV',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    } catch (e) {
      return ApiRespuesta(
        codigoEstado: -1,
        mensaje: 'Error inesperado al obtener CV',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.toString(),
      );
    }
  }

  Future<List<int>> descargarCV(String nombrePrivado) async {
    try {
      final response = await _dio.get(
        '/usuario/perfil/archivo/descargar/$nombrePrivado',
        options: Options(
          responseType: ResponseType.bytes,
          extra: {'tokenRequerido': true},
        ),
      );

      return response.data as List<int>;

    } on DioException catch (e) {
      throw Exception('Error al descargar CV: ${e.message}');
    }
  }

  Future<ApiRespuesta<ArchivoDTO>> subirCV(
      int idUsuario,
      String rutaArchivo,
      ) async {
    try {
      final fileName = rutaArchivo.split('/').last;
      final formData = FormData.fromMap({
        'archivo': await MultipartFile.fromFile(
          rutaArchivo,
          filename: fileName,
        ),
        'idUsuario': idUsuario,
      });

      final response = await _dio.post(
        '/usuario/perfil/archivo/agregar',
        data: formData,
        options: Options(extra: {'tokenRequerido': true}),
      );

      return ApiRespuesta.fromJson(
        response.data as Map<String, dynamic>,
            (json) => ArchivoDTO.fromJson(json as Map<String, dynamic>),
      );

    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al subir CV',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }

  Future<ApiRespuesta<void>> eliminarCV(int idArchivo) async {
    try {
      final response = await _dio.delete(
        '/usuario/perfil/archivo/eliminar/$idArchivo',
        options: Options(extra: {'tokenRequerido': true}),
      );

      return ApiRespuesta.fromJson(
        response.data as Map<String, dynamic>,
            (json) => null,
      );

    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? -1,
        mensaje: e.message ?? 'Error al eliminar CV',
        fechaHora: DateTime.now().toIso8601String(),
        datos: null,
        error: e.error?.toString(),
      );
    }
  }
}