import 'package:oasis/domain/model/datos_basicos.dart';

abstract class DatosBasicosRepository {
  Future<DatosBasicos> obtenerDatosBasicos(int idUsuario);
  Future<void> actualizarDatosBasicos(DatosBasicos datosActualizados);
}