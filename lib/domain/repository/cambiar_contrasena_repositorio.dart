import 'package:oasis/domain/model/cambiar_contrasena_peticion.dart';

abstract class CambiarContrasenaRepositorio{
  Future<void> cambiarContrasena(CambiarContrasenaPeticion request);
}