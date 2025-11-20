import 'package:oasis/domain/repository/cambio_telefono_repositorio.dart';

class ReenviarCodigoNuevoCasoUso {
  final CambioTelefonoRepositorio _repositorio;

  ReenviarCodigoNuevoCasoUso(this._repositorio);

  Future<void> call(int idCambioTelefono) async {
    return await _repositorio.reenviarCodigoNuevo(idCambioTelefono);
  }
}