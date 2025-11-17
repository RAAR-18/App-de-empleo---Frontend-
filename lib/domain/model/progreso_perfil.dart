class ProgresoPerfil {
  final bool tieneDatosBasicos;
  final bool tienePalabrasClave;
  final bool tieneCompetencias;
  final bool tieneCV;
  final bool tieneFotoPerfil;

  // Pesos de cada sección (total debe sumar 100%)
  static const double pesoDatosBasicos = 0.30;      // 30%
  static const double pesoPalabrasClave = 0.20;     // 20%
  static const double pesoCompetencias = 0.25;      // 25%
  static const double pesoCV = 0.20;                // 20%
  static const double pesoFotoPerfil = 0.05;        // 5%

  const ProgresoPerfil({
    required this.tieneDatosBasicos,
    required this.tienePalabrasClave,
    required this.tieneCompetencias,
    required this.tieneCV,
    required this.tieneFotoPerfil,
  });

  // Calcula el progreso total (0.0 a 1.0)
  double get progresoTotal {
    double progreso = 0.0;

    if (tieneDatosBasicos) progreso += pesoDatosBasicos;
    if (tienePalabrasClave) progreso += pesoPalabrasClave;
    if (tieneCompetencias) progreso += pesoCompetencias;
    if (tieneCV) progreso += pesoCV;
    if (tieneFotoPerfil) progreso += pesoFotoPerfil;

    return progreso;
  }

  // Retorna el porcentaje como entero (0 a 100)
  int get porcentaje => (progresoTotal * 100).toInt();

  // Lista de secciones faltantes
  List<String> get seccionesFaltantes {
    final List<String> faltantes = [];

    if (!tieneDatosBasicos) faltantes.add('Datos Básicos');
    if (!tienePalabrasClave) faltantes.add('Palabras Clave');
    if (!tieneCompetencias) faltantes.add('Competencias y Habilidades');
    if (!tieneCV) faltantes.add('Currículum Vitae');
    if (!tieneFotoPerfil) faltantes.add('Foto de Perfil');

    return faltantes;
  }

  // Retorna true si el perfil está completo
  bool get estaCompleto => progresoTotal >= 1.0;

  @override
  String toString() {
    return 'ProgresoPerfil(progreso: $porcentaje%, completo: $estaCompleto)';
  }
}