import 'package:oasis/domain/repository/cambio_telefono_repositorio.dart';
import 'package:oasis/data/remote/dto/iniciar_cambio_telefono_respuesta_dto.dart';

class IniciarCambioTelefonoCasoUso {
  final CambioTelefonoRepositorio _repositorio;

  IniciarCambioTelefonoCasoUso(this._repositorio);

  Future<IniciarCambioTelefonoRespuestaDto> call({
    required int idUsuario,
    required String telefonoNuevo,
  }) async {
    // Validar formato de teléfono
    if (telefonoNuevo.isEmpty) {
      throw Exception('El teléfono no puede estar vacío');
    }

    // Remover caracteres no numéricos
    final telefonoLimpio = telefonoNuevo.replaceAll(RegExp(r'[^\d]'), '');

    if (telefonoLimpio.length < 10 || telefonoLimpio.length > 15) {
      throw Exception('El teléfono debe tener entre 10 y 15 dígitos');
    }

    return await _repositorio.iniciarCambio(
      idUsuario: idUsuario,
      telefonoNuevo: telefonoLimpio,
    );
  }
}