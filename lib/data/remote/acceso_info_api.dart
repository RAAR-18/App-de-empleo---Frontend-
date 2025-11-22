import 'package:dio/dio.dart';
import 'package:oasis/data/remote/dto/api_respuesta.dart';

class AccesoInfoApi {
  final Dio _dio;

  AccesoInfoApi(this._dio);

  Future<ApiRespuesta<String>> obtenerTelefono(int idUsuario) async {
    try {
      final response = await _dio.get('/user/acceso/$idUsuario/telefono');

      if (response.statusCode == 200) {
        final data = response.data['datos'] as Map<String, dynamic>;
        final telefono = data['telefono'] as String;

        return ApiRespuesta(
          codigoEstado: response.statusCode!,
          mensaje: response.data['mensaje'] as String? ?? 'OK',
          datos: telefono,
          fechaHora: DateTime.now().toIso8601String(),
        );
      } else {
        return ApiRespuesta(
          codigoEstado: response.statusCode ?? 500,
          mensaje: response.data['mensaje'] as String? ??
              'Error al obtener teléfono',
          datos: null,
          fechaHora: DateTime.now().toIso8601String(),
        );
      }
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? 500,
        mensaje: e.response?.data['mensaje'] as String? ??
            'Error de conexión',
        datos: null,
        fechaHora: DateTime.now().toIso8601String(),
      );
    }
  }

  Future<ApiRespuesta<Map<String, dynamic>>> obtenerInformacionAcceso(
      int idUsuario) async {
    try {
      final response = await _dio.get('/user/acceso/$idUsuario/informacion');

      if (response.statusCode == 200) {
        final data = response.data['datos'] as Map<String, dynamic>;

        return ApiRespuesta<Map<String, dynamic>>(
          codigoEstado: response.statusCode!,
          mensaje: response.data['mensaje'] as String? ?? 'OK',
          datos: data,
          fechaHora: DateTime.now().toIso8601String(),
        );
      } else {
        return ApiRespuesta(
          codigoEstado: response.statusCode ?? 500,
          mensaje: response.data['mensaje'] as String? ??
              'Error al obtener la información de acceso',
          datos: null,
          fechaHora: DateTime.now().toIso8601String(),
        );
      }
    } on DioException catch (e) {
      return ApiRespuesta(
        codigoEstado: e.response?.statusCode ?? 500,
        mensaje: e.response?.data['mensaje'] as String? ??
            'Error de conexión',
        datos: null,
        fechaHora: DateTime.now().toIso8601String(),
      );
    }
  }

}