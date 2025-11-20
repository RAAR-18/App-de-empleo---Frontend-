import 'package:oasis/domain/repository/cambio_telefono_repositorio.dart';
import 'package:oasis/data/remote/dto/verificar_pin_anterior_respuesta_dto.dart';

class VerificarPinAnteriorCasoUso {
  final CambioTelefonoRepositorio _repositorio;

  VerificarPinAnteriorCasoUso(this._repositorio);

  Future<VerificarPinAnteriorRespuestaDto> call({
    required int idCambioTelefono,
    required String pinAnterior,
  }) async {
    // Validar PIN
    if (pinAnterior.isEmpty) {
      throw Exception('El código no puede estar vacío');
    }

    if (pinAnterior.length != 6) {
      throw Exception('El código debe tener 6 dígitos');
    }

    if (!RegExp(r'^\d+$').hasMatch(pinAnterior)) {
      throw Exception('El código solo puede contener números');
    }

    return await _repositorio.verificarPinAnterior(
      idCambioTelefono: idCambioTelefono,
      pinAnterior: pinAnterior,
    );
  }
}
