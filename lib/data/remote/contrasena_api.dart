import 'package:dio/dio.dart';
import 'package:oasis/domain/model/cambiar_contrasena_peticion.dart';

class ContrasenaApi {
  final Dio dio;

  ContrasenaApi(this.dio);

  Future<Response> cambiarContrasena(CambiarContrasenaPeticion request) async {
    return await dio.put(
      "perfil/acceso/cambiar-contrasena",
      data: request.toJson(),
    );
  }
}