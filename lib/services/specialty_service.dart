import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:agendafaciljp/models/specialty.dart';

class SpecialtyService {
  final CollectionReference _specialtiesCollection = FirebaseFirestore.instance.collection('specialties');

  Future<List<Specialty>> getAllSpecialties() async {
    try {
      final snapshot = await _specialtiesCollection.get();
      if (snapshot.docs.isEmpty) {
        await _initializeSampleData();
        return getAllSpecialties(); // Re-fetch after initializing
      }
      return snapshot.docs.map((doc) => Specialty.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Error loading specialties: $e');
      return [];
    }
  }

  Future<Specialty?> getSpecialtyById(String id) async {
    try {
      final doc = await _specialtiesCollection.doc(id).get();
      if (doc.exists) {
        return Specialty.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error getting specialty by id: $e');
    }
    return null;
  }

  Future<void> addSpecialty(Specialty specialty) async {
    try {
      await _specialtiesCollection.doc(specialty.id).set(specialty.toJson());
    } catch (e) {
      debugPrint('Error adding specialty: $e');
    }
  }

  Future<void> updateSpecialty(Specialty specialty) async {
    try {
      await _specialtiesCollection.doc(specialty.id).update(specialty.toJson());
    } catch (e) {
      debugPrint('Error updating specialty: $e');
    }
  }

  Future<void> deleteSpecialty(String id) async {
    try {
      await _specialtiesCollection.doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting specialty: $e');
    }
  }

  Future<void> _initializeSampleData() async {
    final now = DateTime.now();
    final specialties = [
      Specialty(
        id: 'sp1',
        name: 'Cardiologia',
        iconName: 'favorite',
        description: 'Especialidade médica que cuida do coração e sistema circulatório',
        createdAt: now,
      ),
      Specialty(
        id: 'sp2',
        name: 'Pediatria',
        iconName: 'child_care',
        description: 'Atendimento médico para crianças e adolescentes',
        createdAt: now,
      ),
      Specialty(
        id: 'sp3',
        name: 'Dermatologia',
        iconName: 'face',
        description: 'Cuidados com a pele, cabelo e unhas',
        createdAt: now,
      ),
      Specialty(
        id: 'sp4',
        name: 'Ortopedia',
        iconName: 'accessibility',
        description: 'Tratamento de ossos, músculos e articulações',
        createdAt: now,
      ),
      Specialty(
        id: 'sp5',
        name: 'Ginecologia',
        iconName: 'pregnant_woman',
        description: 'Saúde da mulher e sistema reprodutor feminino',
        createdAt: now,
      ),
      Specialty(
        id: 'sp6',
        name: 'Oftalmologia',
        iconName: 'visibility',
        description: 'Cuidados com os olhos e a visão',
        createdAt: now,
      ),
      Specialty(
        id: 'sp7',
        name: 'Psiquiatria',
        iconName: 'psychology',
        description: 'Saúde mental e tratamento de transtornos psiquiátricos',
        createdAt: now,
      ),
      Specialty(
        id: 'sp8',
        name: 'Neurologia',
        iconName: 'brain',
        description: 'Diagnóstico e tratamento de doenças do sistema nervoso',
        createdAt: now,
      ),
    ];

    for (var specialty in specialties) {
      await addSpecialty(specialty);
    }
  }
}
