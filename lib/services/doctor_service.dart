import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:agendafaciljp/models/doctor.dart';

class DoctorService {
  final CollectionReference _doctorsCollection = FirebaseFirestore.instance.collection('doctors');

  Future<List<Doctor>> getAllDoctors({bool onlyActive = true}) async {
    try {
      final checkSnapshot = await _doctorsCollection.limit(1).get();
      if (checkSnapshot.docs.isEmpty) {
        debugPrint('Coleção "doctors" vazia. Inicializando dados de exemplo...');
        await _initializeSampleData();
      }

      Query query = _doctorsCollection;
      if (onlyActive) {
        query = query.where('isActive', isEqualTo: true);
      }
      final snapshot = await query.get();
      
      return snapshot.docs.map((doc) => Doctor.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Error loading doctors: $e');
      return [];
    }
  }

  Future<Doctor?> getDoctorById(String id) async {
    try {
      final doc = await _doctorsCollection.doc(id).get();
      if (doc.exists) {
        return Doctor.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error getting doctor by id: $e');
    }
    return null;
  }

  Future<List<Doctor>> getDoctorsBySpecialty(String specialtyId) async {
    try {
      final checkSnapshot = await _doctorsCollection.limit(1).get();
      if (checkSnapshot.docs.isEmpty) {
        debugPrint('No doctors found in DB, initializing sample data...');
        await _initializeSampleData();
      }

      final snapshot = await _doctorsCollection
          .where('specialtyId', isEqualTo: specialtyId)
          .where('isActive', isEqualTo: true)
          .get();
      return snapshot.docs.map((doc) => Doctor.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Error getting doctors by specialty: $e');
      return [];
    }
  }

  Future<void> updateDoctor(Doctor doctor) async {
    try {
      await _doctorsCollection.doc(doctor.id).update(doctor.toJson());
    } catch (e) {
      debugPrint('Error updating doctor: $e');
    }
  }

  Future<void> _initializeSampleData() async {
    final now = DateTime.now();
    final sampleDoctors = [
      Doctor(
        id: 'doc1', name: 'Dra. Paula Rodrigues', email: 'paula@email.com', phone: '(11)99991', crm: 'CRM 12345', 
        specialtyId: 'sp1', specialtyName: 'Cardiologia', 
        bio: 'Cardiologista renomada com 15 anos de experiência.', createdAt: now, updatedAt: now, isActive: true, 
        rating: 4.8, ratingCount: 120,
        availableSchedule: {
          'monday': [TimeSlot(start: '08:00', end: '12:00')],
          'wednesday': [TimeSlot(start: '14:00', end: '18:00')],
          'friday': [TimeSlot(start: '08:00', end: '12:00')],
        }
      ),
      Doctor(
        id: 'doc2', name: 'Dr. João Santos', email: 'joao@email.com', phone: '(11)99992', crm: 'CRM 23456', 
        specialtyId: 'sp2', specialtyName: 'Pediatria', 
        bio: 'Pediatra dedicado com foco no atendimento infantil.', createdAt: now, updatedAt: now, isActive: true, 
        rating: 4.9, ratingCount: 203,
        availableSchedule: {
          'tuesday': [TimeSlot(start: '09:00', end: '13:00')],
          'thursday': [TimeSlot(start: '15:00', end: '19:00')],
        }
      ),
      Doctor(
        id: 'doc3', name: 'Dra. Maria Silva', email: 'maria@email.com', phone: '(11)99993', crm: 'CRM 34567', 
        specialtyId: 'sp3', specialtyName: 'Dermatologia', 
        bio: 'Especialista em tratamentos de pele e procedimentos estéticos.', createdAt: now, updatedAt: now, isActive: true, 
        rating: 4.7, ratingCount: 89,
        availableSchedule: {
          'monday': [TimeSlot(start: '10:00', end: '17:00')],
          'friday': [TimeSlot(start: '10:00', end: '17:00')],
        }
      ),
      Doctor(
        id: 'doc4', name: 'Dr. Carlos Oliveira', email: 'carlos@email.com', phone: '(11)99994', crm: 'CRM 45678', 
        specialtyId: 'sp4', specialtyName: 'Ortopedia', 
        bio: 'Foco em lesões esportivas e cirurgia do joelho.', createdAt: now, updatedAt: now, isActive: true, 
        rating: 4.6, ratingCount: 156,
        availableSchedule: {
          'tuesday': [TimeSlot(start: '08:00', end: '12:00')],
          'thursday': [TimeSlot(start: '08:00', end: '12:00')]
        }
      ),
      Doctor(
        id: 'doc5', name: 'Dra. Ana Costa', email: 'ana@email.com', phone: '(11)99995', crm: 'CRM 56789', 
        specialtyId: 'sp6', specialtyName: 'Oftalmologia', 
        bio: 'Especialista em cirurgia de catarata e retina.', createdAt: now, updatedAt: now, isActive: true, 
        rating: 4.9, ratingCount: 178,
        availableSchedule: {
          'wednesday': [TimeSlot(start: '09:00', end: '17:00')]
        }
      ),
      Doctor(
        id: 'doc6', name: 'Dr. Fernando Lima', email: 'fernando@email.com', phone: '(11)99996', crm: 'CRM 67890', 
        specialtyId: 'sp8', specialtyName: 'Neurologia', 
        bio: 'Diagnóstico e tratamento de doenças do sistema nervoso.', createdAt: now, updatedAt: now, isActive: true, 
        rating: 4.8, ratingCount: 112,
        availableSchedule: {
          'monday': [TimeSlot(start: '13:00', end: '19:00')],
          'thursday': [TimeSlot(start: '13:00', end: '19:00')]
        }
      ),
       Doctor(
        id: 'doc7', name: 'Dra. Beatriz Almeida', email: 'beatriz@email.com', phone: '(11)99997', crm: 'CRM 78901', 
        specialtyId: 'sp7', specialtyName: 'Psiquiatria', 
        bio: 'Apoio à saúde mental e bem-estar emocional.', createdAt: now, updatedAt: now, isActive: true, 
        rating: 4.9, ratingCount: 215,
        availableSchedule: {
          'tuesday': [TimeSlot(start: '10:00', end: '18:00')],
          'friday': [TimeSlot(start: '10:00', end: '18:00')]
        }
      ),
    ];

    final batch = FirebaseFirestore.instance.batch();
    for (var doctor in sampleDoctors) {
      final docRef = _doctorsCollection.doc(doctor.id);
      batch.set(docRef, doctor.toJson());
    }
    await batch.commit();
    debugPrint('>>>> Sample doctors with schedules initialized in Firestore!');
  }
}
