import 'package:oasis/domain/repository/cambio_telefono_repositorio.dart';

class ReenviarCodigoAnteriorCasoUso {
  final CambioTelefonoRepositorio _repositorio;

  ReenviarCodigoAnteriorCasoUso(this._repositorio);

  Future<void> call(int idCambioTelefono) async {
    return await _repositorio.reenviarCodigoAnterior(idCambioTelefono);
  }
}