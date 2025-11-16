import 'dart:io';
import 'package:oasis/domain/repository/archivo_repositorio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DescargarCVUseCase {
  final ArchivoRepositorio _repositorio;

  DescargarCVUseCase(this._repositorio);

  Future<String> call(String nombrePrivado, String nombrePublico) async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Se necesitan permisos de almacenamiento');
      }
    }

    final bytes = await _repositorio.descargarCV(nombrePrivado);

    Directory? directory;

    if (Platform.isAndroid) {

      directory = Directory('/storage/emulated/0/Download');

      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory == null) {
      throw Exception('No se pudo acceder al almacenamiento');
    }
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${nombrePublico.replaceAll('.pdf', '')}_$timestamp.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }
}