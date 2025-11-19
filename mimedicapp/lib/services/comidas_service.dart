import 'package:mimedicapp/configs/api_config.dart';
import 'package:mimedicapp/models/comida.dart';
import 'package:mimedicapp/services/api_service.dart';

class ComidasService {
  final ApiService _api = ApiService();

  Future<List<Comida>> getComidas() async {
    final response = await _api.get(ApiConfig.comidasEndpoint);
    final List data = response as List;
    return data.map((e) => Comida.fromJson(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getCategorias() async {
    final response = await _api.get(ApiConfig.categoriasEndpoint);
    final List data = response as List;
    return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<Map<String, List<Comida>>> getSections() async {
    final response = await _api.get(ApiConfig.comidasSectionsEndpoint);
    final Map data = response as Map;
    final recomendables =
        (data['recomendables'] as List).map((e) => Comida.fromJson(e)).toList();
    final noRec = (data['no_recomendables'] as List)
        .map((e) => Comida.fromJson(e))
        .toList();
    return {'recomendables': recomendables, 'no_recomendables': noRec};
  }

  Future<Comida> createComida(Comida c, {int? idCategoria}) async {
    final payload = Map<String, dynamic>.from(c.toJson())..remove('id');
    if (idCategoria != null) payload['idCategoria'] = idCategoria;
    final response = await _api.post(ApiConfig.comidasEndpoint, payload);
    return Comida.fromJson(response as Map<String, dynamic>);
  }

  Future<Comida> updateComida(int id, Comida c) async {
    final endpoint = '${ApiConfig.comidasEndpoint}/$id';
    final response = await _api.put(endpoint, c.toJson());
    return Comida.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deleteComida(int id) async {
    final endpoint = '${ApiConfig.comidasEndpoint}/$id';
    await _api.delete(endpoint);
  }
}
