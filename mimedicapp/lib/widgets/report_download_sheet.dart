import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:mimedicapp/configs/api_config.dart';
import 'package:mimedicapp/models/report_event.dart';
import 'package:mimedicapp/services/api_service.dart';

class ReportDownloadSheet extends StatelessWidget {
  final ReportEventType type;
  const ReportDownloadSheet({super.key, required this.type});

  String _typeToStr() => reportEventTypeToString(type);

  Future<void> _openFormat(String fmt) async {
    final token = await ApiService().getAuthToken();
    final url =
        '${ApiConfig.baseUrl}/reportes/modulo/download?module=${_typeToStr()}&format=$fmt';
    final authUrl =
        token != null ? '$url&token=$token' : url; // si backend soporta ?token
    if (!await launchUrlString(authUrl, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir $authUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            title: const Text('Descargar reporte'),
            subtitle: Text(_typeToStr()),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Texto'),
            onTap: () => _openFormat('txt'),
          ),
          ListTile(
            leading: const Icon(Icons.web_asset),
            title: const Text('HTML'),
            onTap: () => _openFormat('html'),
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text('PDF'),
            onTap: () => _openFormat('pdf'),
          ),
        ],
      ),
    );
  }
}
