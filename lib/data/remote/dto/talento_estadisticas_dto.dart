class TalentoEstadisticasDTO {
  final int totalTalentos;
  final int totalCompetencias;
  final int totalHabilidades;
  final int nivelBasico;
  final int nivelIntermedio;
  final int nivelAvanzado;

  TalentoEstadisticasDTO({
    required this.totalTalentos,
    required this.totalCompetencias,
    required this.totalHabilidades,
    required this.nivelBasico,
    required this.nivelIntermedio,
    required this.nivelAvanzado,
  });

  factory TalentoEstadisticasDTO.fromJson(Map<String, dynamic> json) {
    return TalentoEstadisticasDTO(
      totalTalentos: json['totalTalentos'] as int,
      totalCompetencias: json['totalCompetencias'] as int,
      totalHabilidades: json['totalHabilidades'] as int,
      nivelBasico: json['nivelBasico'] as int,
      nivelIntermedio: json['nivelIntermedio'] as int,
      nivelAvanzado: json['nivelAvanzado'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalTalentos': totalTalentos,
      'totalCompetencias': totalCompetencias,
      'totalHabilidades': totalHabilidades,
      'nivelBasico': nivelBasico,
      'nivelIntermedio': nivelIntermedio,
      'nivelAvanzado': nivelAvanzado,
    };
  }
}