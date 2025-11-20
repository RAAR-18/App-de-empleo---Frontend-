import 'package:oasis/data/remote/cambio_telefono_api.dart';
import 'package:oasis/domain/repository/cambio_telefono_repositorio.dart';
import 'package:oasis/data/remote/dto/iniciar_cambio_telefono_respuesta_dto.dart';
import 'package:oasis/data/remote/dto/verificar_pin_anterior_respuesta_dto.dart';
import 'package:oasis/data/remote/dto/verificar_pin_nuevo_respuesta_dto.dart';
import 'package:oasis/data/remote/dto/iniciar_cambio_telefono_dto.dart';
import 'package:oasis/data/remote/dto/verificar_pin_anterior_dto.dart';
import 'package:oasis/data/remote/dto/verificar_pin_nuevo_dto.dart';

class CambioTelefonoRepositorioImpl implements CambioTelefonoRepositorio {
  final CambioTelefonoApi _api;

  CambioTelefonoRepositorioImpl(this._api);

  @override
  Future<IniciarCambioTelefonoRespuestaDto> iniciarCambio({
    required int idUsuario,
    required String telefonoNuevo,
  }) async {
    final dto = IniciarCambioTelefonoDto(
      idUsuario: idUsuario,
      telefonoNuevo: telefonoNuevo,
    );

    final response = await _api.iniciarCambio(dto);

    if (response.codigoEstado == 200 && response.datos != null) {
      return response.datos!;
    } else {
      throw Exception(response.mensaje);
    }
  }

  @override
  Future<VerificarPinAnteriorRespuestaDto> verificarPinAnterior({
    required int idCambioTelefono,
    required String pinAnterior,
  }) async {
    final dto = VerificarPinAnteriorDto(
      idCambioTelefono: idCambioTelefono,
      pinAnterior: pinAnterior,
    );

    final response = await _api.verificarPinAnterior(dto);

    if (response.codigoEstado == 200 && response.datos != null) {
      return response.datos!;
    } else {
      throw Exception(response.mensaje);
    }
  }

  @override
  Future<VerificarPinNuevoRespuestaDto> verificarPinNuevo({
    required int idCambioTelefono,
    required String pinNuevo,
  }) async {
    final dto = VerificarPinNuevoDto(
      idCambioTelefono: idCambioTelefono,
      pinNuevo: pinNuevo,
    );

    final response = await _api.verificarPinNuevo(dto);

    if (response.codigoEstado == 200 && response.datos != null) {
      return response.datos!;
    } else {
      throw Exception(response.mensaje);
    }
  }

  @override
  Future<void> reenviarCodigoAnterior(int idCambioTelefono) async {
    final response = await _api.reenviarCodigoAnterior(idCambioTelefono);

    if (response.codigoEstado != 200) {
      throw Exception(response.mensaje);
    }
  }

  @override
  Future<void> reenviarCodigoNuevo(int idCambioTelefono) async {
    final response = await _api.reenviarCodigoNuevo(idCambioTelefono);

    if (response.codigoEstado != 200) {
      throw Exception(response.mensaje);
    }
  }
}
