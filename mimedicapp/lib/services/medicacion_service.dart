import 'package:mimedicapp/configs/api_config.dart';
import 'package:mimedicapp/models/medicamento.dart';
import 'package:mimedicapp/models/medicamentoUsuario.dart';
import 'package:mimedicapp/models/responses/medicamentoResponse.dart';
import 'package:mimedicapp/models/unidad.dart';
import 'package:mimedicapp/services/api_service.dart';

class MedicacionService {
  final ApiService _apiService = ApiService();

  Future<List<Medicamento>> getMedicamentos() async {
    final response = await _apiService.get(ApiConfig.medicamentosEndpoint);
    final List data = response as List;
    return data.map((e) => Medicamento.fromJson(e)).toList();
  }

  Future<List<Unidad>> getUnidades() async {
    final response = await _apiService.get(ApiConfig.unidadesEndpoint);
    final List data = response as List;
    final unidades = data.map((e) => Unidad.fromJson(e)).toList();

    // Debug opcional
    // print('Unidades: ${unidades.map((u) => u.nombre).toList()}');

    return unidades;
  }

  Future<List<MedicamentoUsuario>> getMedicamentosUsuario() async {
    final response = await _apiService.get(ApiConfig.medicamentosUsuarioEndpoint);
    final List data = response as List;
    return data.map((e) => MedicamentoUsuario.fromJson(e)).toList();
  }

  Future<MedicamentoResponse> createMedicamentoUsuario(MedicamentoUsuario medicamento) async {
    try {
      final response = await _apiService.post(
        ApiConfig.agregarMedicamentoEndpoint,
        medicamento.toJson(),
      );

      return MedicamentoResponse.fromJson(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error al registrar medicamento: $e');
    }
  }

  Future<MedicamentoResponse> updateMedicamentoUsuario(int id, MedicamentoUsuario medicamento) async {
    try {
      // Usar el endpoint base definido en ApiConfig y concatenar el id
      final endpoint = '${ApiConfig.actualizarMedicamentoEndpoint}/$id';
      final response = await _apiService.put(endpoint, medicamento.toJson());

      return MedicamentoResponse.fromJson(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error al actualizar medicamento: $e');
    }
  }
}
