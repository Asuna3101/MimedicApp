import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mimedicapp/models/appointment_reminder.dart';
import 'package:mimedicapp/interfaces/reminder_repository_interface.dart';
import 'package:mimedicapp/usecases/get_upcoming_reminders.dart';
import 'package:mimedicapp/usecases/update_appointment_status.dart';


class NotificationsController extends ChangeNotifier {
  final ReminderRepository _repo;
  late final GetUpcomingReminders _getUpcoming;
  late final UpdateAppointmentStatus _updateStatus;

  NotificationsController({required ReminderRepository repo}) : _repo = repo {
    _getUpcoming = GetUpcomingReminders(_repo);
    _updateStatus = UpdateAppointmentStatus(_repo);
    // ensure futureReminders is initialized immediately so UI can access it
    futureReminders = _getUpcoming.call();
  }

  late Future<List<AppointmentReminder>> futureReminders;

  final Set<int> _dismissedIds = <int>{};
  final Set<int> _seenPendingIds = <int>{};
  final Map<int, AppointmentReminder> _cachedReminders = {};

  // expose read-only views
  List<AppointmentReminder> get visibleReminders {
    final list = _cachedReminders.values.where((r) {
      if (_dismissedIds.contains(r.id)) return false;
      if (r.status == AppointmentStatus.pendiente) return true;
      if (_seenPendingIds.contains(r.id)) return true;
      return false;
    }).toList()
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    return list;
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final dismissed = prefs.getStringList('notificaciones_dismissed_ids') ?? <String>[];
    final seen = prefs.getStringList('notificaciones_seen_pending_ids') ?? <String>[];
    _dismissedIds.clear();
    _dismissedIds.addAll(dismissed.map(int.parse));
    _seenPendingIds.clear();
    _seenPendingIds.addAll(seen.map(int.parse));

  futureReminders = _getUpcoming.call();
  final data = await futureReminders;
    for (final r in data) {
      _cachedReminders[r.id] = r;
    }

    final pendingIds = data.where((r) => r.status == AppointmentStatus.pendiente).map((r) => r.id);
    _seenPendingIds.addAll(pendingIds);
    await prefs.setStringList('notificaciones_seen_pending_ids', _seenPendingIds.map((e) => e.toString()).toList());

    notifyListeners();
  }

  Future<void> refresh() async {
  futureReminders = _getUpcoming.call();
  final data = await futureReminders;
    final prefs = await SharedPreferences.getInstance();
    for (final r in data) {
      _cachedReminders[r.id] = r;
    }
    final pendingIds = data.where((r) => r.status == AppointmentStatus.pendiente).map((r) => r.id);
    _seenPendingIds.addAll(pendingIds);
    await prefs.setStringList('notificaciones_seen_pending_ids', _seenPendingIds.map((e) => e.toString()).toList());
    notifyListeners();
  }

  Future<void> markAttended(int reminderId) async {
  await _updateStatus.call(reminderId: reminderId, status: AppointmentStatus.asistido);
    final cached = _cachedReminders[reminderId];
    if (cached != null) {
      final updated = AppointmentReminder(
        id: cached.id,
        startsAt: cached.startsAt,
        notes: cached.notes,
        clinic: cached.clinic,
        specialty: cached.specialty,
        doctor: cached.doctor,
        status: AppointmentStatus.asistido,
        isDueSoon: cached.isDueSoon,
      );
      _cachedReminders[reminderId] = updated;
    }
    notifyListeners();
  }

  Future<void> deleteFromView(int reminderId) async {
    final prefs = await SharedPreferences.getInstance();
    _dismissedIds.add(reminderId);
    await prefs.setStringList('notificaciones_dismissed_ids', _dismissedIds.map((e) => e.toString()).toList());
    notifyListeners();
  }
}
