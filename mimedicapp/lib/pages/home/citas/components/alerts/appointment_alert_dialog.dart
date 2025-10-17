// lib/pages/home/citas/components/alerts/appointment_alert_dialog.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mimedicapp/configs/colors.dart';
import 'package:mimedicapp/models/appointment_reminder.dart';

enum AppointmentAlertMode { dueSoon, past }

class AppointmentAlertDialog extends StatefulWidget {
  final List<AppointmentReminder> citas;
  final AppointmentAlertMode mode;
  final Future<void> Function(AppointmentReminder, AppointmentStatus) onAction;

  const AppointmentAlertDialog({
    super.key,
    required this.citas,
    required this.mode,
    required this.onAction,
  });

  @override
  State<AppointmentAlertDialog> createState() => _AppointmentAlertDialogState();
}

class _AppointmentAlertDialogState extends State<AppointmentAlertDialog> {
  late List<AppointmentReminder> _citas;
  String _fmt(DateTime dt) => DateFormat('dd/MM – HH:mm').format(dt);

  @override
  void initState() {
    super.initState();
    _citas = List.of(widget.citas); // copia mutable local
  }

  String get _title => widget.mode == AppointmentAlertMode.dueSoon
      ? 'Recordatorio: Cita en los próximos 30 minutos'
      : 'Citas pasadas (últimos 30 min)';

  Future<void> _handleTap(AppointmentReminder c, AppointmentStatus s) async {
    await widget.onAction(c, s);
    setState(() {
      _citas.removeWhere((x) => x.id == c.id);
    });
    if (_citas.isEmpty && mounted) Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 520),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.mode == AppointmentAlertMode.dueSoon
                            ? Icons.access_time_filled
                            : Icons.event_busy,
                        color: AppColors.accent, size: 22),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(_title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Titulo', fontSize: 16,
                            fontWeight: FontWeight.w800, color: AppColors.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _citas.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final c = _citas[i];
                        return _AppointmentCard(
                          title: c.specialty.nombre,
                          subtitle:
                              '${_fmt(c.startsAt)}  •  Dr./Dra. ${c.doctor.nombre}\n${c.clinic.nombre}',
                          onTapLeft: () => _handleTap(c, AppointmentStatus.asistido),
                          onTapRight: () => _handleTap(c, AppointmentStatus.noAsistido),
                          leftLabel: widget.mode == AppointmentAlertMode.dueSoon ? 'Asistiré' : 'Asistí',
                          rightLabel: widget.mode == AppointmentAlertMode.dueSoon ? 'No asistiré' : 'No asistí',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 4, right: 4,
              child: IconButton(
                tooltip: 'Cerrar',
                icon: const Icon(Icons.close, size: 22, color: Colors.black54),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final String title, subtitle, leftLabel, rightLabel;
  final Future<void> Function() onTapLeft, onTapRight;

  const _AppointmentCard({
    required this.title,
    required this.subtitle,
    required this.onTapLeft,
    required this.onTapRight,
    required this.leftLabel,
    required this.rightLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(
            fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.primary)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 13.5, color: Colors.black87)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onTapLeft,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.green.shade600, width: 1.2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    foregroundColor: Colors.green.shade700,
                  ),
                  child: Text(leftLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onTapRight,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: Text(rightLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
