import 'package:oasis/domain/model/acceso_info.dart';

abstract class AccesoInfoRepositorio {
  Future<String> obtenerTelefono(int idUsuario);
  Future<AccesoInfo> obtenerInformacionAcceso(int idUsuario);
}