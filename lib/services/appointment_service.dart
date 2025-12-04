import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:agendafaciljp/models/appointment.dart';

class AppointmentService {
  final CollectionReference _appointmentsCollection = FirebaseFirestore.instance.collection('appointments');

  Future<List<Appointment>> getAllAppointments() async {
    try {
      final snapshot = await _appointmentsCollection.get();
      return snapshot.docs.map((doc) => Appointment.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Error loading appointments: $e');
      return [];
    }
  }

  Future<Appointment?> getAppointmentById(String id) async {
    try {
      final doc = await _appointmentsCollection.doc(id).get();
      if (doc.exists) {
        return Appointment.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error getting appointment by id: $e');
    }
    return null;
  }

  Future<List<Appointment>> getAppointmentsByClient(String clientId) async {
    try {
      final snapshot = await _appointmentsCollection.where('clientId', isEqualTo: clientId).get();
      return snapshot.docs.map((doc) => Appointment.fromJson(doc.data() as Map<String, dynamic>)).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      debugPrint('Error getting appointments by client: $e');
      return [];
    }
  }

  Future<List<Appointment>> getAppointmentsByDoctor(String doctorId) async {
    try {
      final snapshot = await _appointmentsCollection.where('doctorId', isEqualTo: doctorId).get();
      return snapshot.docs.map((doc) => Appointment.fromJson(doc.data() as Map<String, dynamic>)).toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    } catch (e) {
      debugPrint('Error getting appointments by doctor: $e');
      return [];
    }
  }

  Future<List<Appointment>> getAppointmentsByDoctorAndDate(String doctorId, DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await _appointmentsCollection
          .where('doctorId', isEqualTo: doctorId)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .get();

      return snapshot.docs.map((doc) => Appointment.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Error getting appointments by doctor and date: $e');
      return [];
    }
  }

  Future<bool> isTimeSlotAvailable(String doctorId, DateTime date, String timeSlot) async {
    final appointments = await getAppointmentsByDoctorAndDate(doctorId, date);
    return !appointments.any((a) =>
    a.timeSlot == timeSlot &&
        a.status != AppointmentStatus.cancelled
    );
  }

  Future<void> addAppointment(Appointment appointment) async {
    try {
      await _appointmentsCollection.doc(appointment.id).set(appointment.toJson());
    } catch (e) {
      debugPrint('Error adding appointment: $e');
    }
  }

  Future<void> updateAppointment(Appointment appointment) async {
    try {
      await _appointmentsCollection.doc(appointment.id).update(appointment.toJson());
    } catch (e) {
      debugPrint('Error updating appointment: $e');
    }
  }

  Future<void> deleteAppointment(String id) async {
    try {
      await _appointmentsCollection.doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting appointment: $e');
    }
  }
}
