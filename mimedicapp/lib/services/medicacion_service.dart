import 'package:mimedicapp/models/medicamento.dart';

import 'api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  /// registrar un nuevo medicamento
  Future<Medicamento> createMedicamento(Medicamento medicamento) async {
    try {



      return Medicamento(
        id: medicamento.id,
        nombre: medicamento.nombre,
        dosis: medicamento.dosis,
        unidad: medicamento.unidad,
        frecuenciaHoras: medicamento.frecuenciaHoras,
        fechaInicio: medicamento.fechaInicio,
        fechaFin: medicamento.fechaFin,
      );
    } catch(e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error al registrar medicamento: $e');
    }
  }
}