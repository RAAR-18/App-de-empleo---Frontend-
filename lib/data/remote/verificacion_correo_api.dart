import 'package:dio/dio.dart';
import 'package:oasis/data/remote/dto/api_respuesta.dart';

class VerificacionCorreoApi {
  final Dio _dio;

  VerificacionCorreoApi(this._dio);

  /// Envía código de verificación al correo
  Future<ApiRespuesta> enviarCodigoVerificacion(String correoAcceso) async {
    try {
      final response = await _dio.post(
        '/api/verificacion-correo/enviar-codigo',
        data: {'correoAcceso': correoAcceso},
      );

      return ApiRespuesta.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiRespuesta.fromJson(e.response!.data);
      }
      throw Exception('Error de red: ${e.message}');
    }
  }

  /// Verifica el código ingresado
  Future<ApiRespuesta> verificarCodigo(String correoAcceso, String codigo) async {
    try {
      final response = await _dio.post(
        '/api/verificacion-correo/verificar-codigo',
        data: {
          'correoAcceso': correoAcceso,
          'codigo': codigo,
        },
      );

      return ApiRespuesta.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiRespuesta.fromJson(e.response!.data);
      }
      throw Exception('Error de red: ${e.message}');
    }
  }

  /// Obtiene el estado de verificación de un correo
  Future<ApiRespuesta> obtenerEstadoVerificacion(String correoAcceso) async {
    try {
      final response = await _dio.get(
        '/api/verificacion-correo/estado',
        queryParameters: {'correo': correoAcceso},
      );

      return ApiRespuesta.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiRespuesta.fromJson(e.response!.data);
      }
      throw Exception('Error de red: ${e.message}');
    }
  }
}