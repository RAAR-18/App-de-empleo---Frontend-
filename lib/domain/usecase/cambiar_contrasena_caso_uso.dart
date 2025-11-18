import 'package:oasis/domain/model/cambiar_contrasena_peticion.dart';
import 'package:oasis/domain/repository/cambiar_contrasena_repositorio.dart';

class CambiarContrasenaCasoUso {
  final CambiarContrasenaRepositorio repositorio;

  CambiarContrasenaCasoUso(this.repositorio);

  Future<void> call(String contrasenaActual, String contrasenaNueva) async {
    if (contrasenaActual.isEmpty) {
      throw Exception('La contraseña actual es obligatoria');
    }

    if (contrasenaNueva.isEmpty) {
      throw Exception('La nueva contraseña es obligatoria');
    }

    if (contrasenaNueva.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres');
    }

    if (contrasenaActual == contrasenaNueva) {
      throw Exception('La nueva contraseña debe ser diferente a la actual');
    }

    final request = CambiarContrasenaPeticion(
      contrasenaActual: contrasenaActual,
      contrasenaNueva: contrasenaNueva,
    );

    await repositorio.cambiarContrasena(request);
  }
}