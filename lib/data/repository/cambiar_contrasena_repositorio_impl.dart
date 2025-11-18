import 'package:oasis/data/remote/contrasena_api.dart';
import 'package:oasis/domain/model/cambiar_contrasena_peticion.dart';
import 'package:oasis/domain/repository/cambiar_contrasena_repositorio.dart';

class CambiarContrasenaRepositorioImpl implements CambiarContrasenaRepositorio {
  final ContrasenaApi api;

  CambiarContrasenaRepositorioImpl(this.api);

  @override
  Future<void> cambiarContrasena(CambiarContrasenaPeticion request) async {
    final response = await api.cambiarContrasena(request);

    if (response.statusCode != 200) {
      final mensaje = response.data?["mensaje"] ?? "Error al cambiar contraseña";
      throw Exception(mensaje);
    }
  }
}