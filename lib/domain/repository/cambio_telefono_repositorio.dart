import 'package:oasis/data/remote/dto/iniciar_cambio_telefono_respuesta_dto.dart';
import 'package:oasis/data/remote/dto/verificar_pin_anterior_respuesta_dto.dart';
import 'package:oasis/data/remote/dto/verificar_pin_nuevo_respuesta_dto.dart';

abstract class CambioTelefonoRepositorio {

  Future<IniciarCambioTelefonoRespuestaDto> iniciarCambio({
    required int idUsuario,
    required String telefonoNuevo,
  });

  Future<VerificarPinAnteriorRespuestaDto> verificarPinAnterior({
    required int idCambioTelefono,
    required String pinAnterior,
  });

  Future<VerificarPinNuevoRespuestaDto> verificarPinNuevo({
    required int idCambioTelefono,
    required String pinNuevo,
  });

  Future<void> reenviarCodigoAnterior(int idCambioTelefono);

  Future<void> reenviarCodigoNuevo(int idCambioTelefono);
}