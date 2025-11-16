class RelUsuarioTalento {
  final int idUsuario;
  final int idTalento;
  final String nombreTalento;
  final NivelDominio nivelDominio;

  RelUsuarioTalento({
    required this.idUsuario,
    required this.idTalento,
    required this.nombreTalento,
    required this.nivelDominio,
  });

  String get nivelTexto => nivelDominio.nombre;
}

enum NivelDominio {
  basico(1, 'Básico'),
  intermedio(2, 'Intermedio'),
  avanzado(3, 'Avanzado');

  final int valor;
  final String nombre;

  const NivelDominio(this.valor, this.nombre);

  static NivelDominio fromValor(int valor) {
    return NivelDominio.values.firstWhere(
          (e) => e.valor == valor,
      orElse: () => NivelDominio.basico,
    );
  }
}