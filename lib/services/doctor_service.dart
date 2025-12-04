import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:agendafaciljp/models/doctor.dart';

class DoctorService {
  final CollectionReference _doctorsCollection = FirebaseFirestore.instance.collection('doctors');

  // Por padrão, busca apenas médicos ativos. O painel de admin pode passar `onlyActive: false`.
  Future<List<Doctor>> getAllDoctors({bool onlyActive = true}) async {
    try {
      Query query = _doctorsCollection;
      if (onlyActive) {
        query = query.where('isActive', isEqualTo: true);
      }
      final snapshot = await query.get();
      return snapshot.docs.map((doc) => Doctor.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Error loading doctors: $e');
      // Se a coleção não existir, inicializa com dados de exemplo.
      if (e is FirebaseException && e.code == 'unimplemented') {
         await _initializeSampleData();
         return getAllDoctors(onlyActive: onlyActive);
      }
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
      final snapshot = await _doctorsCollection
          .where('specialtyId', isEqualTo: specialtyId)
          .where('isActive', isEqualTo: true) // Pacientes só veem médicos ativos
          .get();
      return snapshot.docs.map((doc) => Doctor.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Error getting doctors by specialty: $e');
      return [];
    }
  }

  Future<void> addDoctor(Doctor doctor) async {
    try {
      await _doctorsCollection.doc(doctor.id).set(doctor.toJson());
    } catch (e) {
      debugPrint('Error adding doctor: $e');
    }
  }

  Future<void> updateDoctor(Doctor doctor) async {
    try {
      await _doctorsCollection.doc(doctor.id).update(doctor.toJson());
    } catch (e) {
      debugPrint('Error updating doctor: $e');
    }
  }

  Future<void> deleteDoctor(String id) async {
    try {
      await _doctorsCollection.doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting doctor: $e');
    }
  }

  // Função para popular o Firestore com dados de exemplo na primeira vez
  Future<void> _initializeSampleData() async {
    final now = DateTime.now();
    final sampleDoctors = [
      Doctor(
        id: 'doc1',
        name: 'Dra. Paula Rodrigues',
        email: 'paula.rodrigues@clinica.com',
        phone: '(83) 99876-5432',
        photoUrl: 'assets/images/Female_Doctor_Professional_null_1764593852505.jpg',
        crm: 'CRM 12345',
        specialtyId: 'sp1',
        specialtyName: 'Cardiologia',
        bio: 'Especialista em cardiologia com 15 anos de experiência.',
        rating: 4.8,
        ratingCount: 127,
        createdAt: now,
        updatedAt: now,
      ),
       Doctor(
        id: 'doc2',
        name: 'Dr. João Santos',
        email: 'joao.santos@clinica.com',
        phone: '(83) 99765-4321',
        photoUrl: 'assets/images/Medical_Doctor_Portrait_null_1764593851897.jpg',
        crm: 'CRM 23456',
        specialtyId: 'sp2',
        specialtyName: 'Pediatria',
        bio: 'Pediatra dedicado ao cuidado integral de crianças e adolescentes.',
        rating: 4.9,
        ratingCount: 203,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    final batch = FirebaseFirestore.instance.batch();
    for (var doctor in sampleDoctors) {
      final docRef = _doctorsCollection.doc(doctor.id);
      batch.set(docRef, doctor.toJson());
    }
    await batch.commit();
  }
}
