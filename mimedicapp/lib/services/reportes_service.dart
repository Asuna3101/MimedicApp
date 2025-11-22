import 'package:mimedicapp/configs/api_config.dart';
import 'package:mimedicapp/models/report_event.dart';
import 'package:mimedicapp/models/report_summary.dart';
import 'package:mimedicapp/services/api_service.dart';

class ReportesService {
  final ApiService _api = ApiService();

  Future<ReportSummary> getSummary() async {
    final data =
        await _api.get('${ApiConfig.baseUrl}/reportes/summary', auth: true);
    return ReportSummary.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<List<ReportEventModel>> getModuleEvents(String module) async {
    final data = await _api.get(
        '${ApiConfig.baseUrl}/reportes/modulo?module=$module',
        auth: true);
    return (data as List)
        .map((e) => ReportEventModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<String> downloadModule(String module) async {
    final data = await _api.get(
        '${ApiConfig.baseUrl}/reportes/modulo/download?module=$module',
        auth: true);
    if (data is String) return data;
    return data.toString();
  }
}
