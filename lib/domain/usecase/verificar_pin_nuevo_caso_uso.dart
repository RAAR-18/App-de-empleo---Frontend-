import 'package:oasis/domain/repository/cambio_telefono_repositorio.dart';
import 'package:oasis/data/remote/dto/verificar_pin_nuevo_respuesta_dto.dart';

class VerificarPinNuevoCasoUso {
  final CambioTelefonoRepositorio _repositorio;

  VerificarPinNuevoCasoUso(this._repositorio);

  Future<VerificarPinNuevoRespuestaDto> call({
    required int idCambioTelefono,
    required String pinNuevo,
  }) async {
    // Validar PIN
    if (pinNuevo.isEmpty) {
      throw Exception('El código no puede estar vacío');
    }

    if (pinNuevo.length != 6) {
      throw Exception('El código debe tener 6 dígitos');
    }

    if (!RegExp(r'^\d+$').hasMatch(pinNuevo)) {
      throw Exception('El código solo puede contener números');
    }

    return await _repositorio.verificarPinNuevo(
      idCambioTelefono: idCambioTelefono,
      pinNuevo: pinNuevo,
    );
  }
}
