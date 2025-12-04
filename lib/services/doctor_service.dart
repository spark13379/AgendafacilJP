import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agendafaciljp/models/doctor.dart';

class DoctorService {
  static const String _storageKey = 'doctors';

  Future<List<Doctor>> getAllDoctors() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_storageKey);

      if (data == null) {
        await _initializeSampleData();
        return getAllDoctors();
      }

      final List<dynamic> jsonList = json.decode(data);
      return jsonList.map((json) => Doctor.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading doctors: $e');
      return [];
    }
  }

  Future<Doctor?> getDoctorById(String id) async {
    final doctors = await getAllDoctors();
    try {
      return doctors.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Doctor>> getDoctorsBySpecialty(String specialtyId) async {
    final doctors = await getAllDoctors();
    return doctors.where((d) => d.specialtyId == specialtyId).toList();
  }

  Future<void> addDoctor(Doctor doctor) async {
    try {
      final doctors = await getAllDoctors();
      doctors.add(doctor);
      await _saveDoctors(doctors);
    } catch (e) {
      debugPrint('Error adding doctor: $e');
    }
  }

  Future<void> updateDoctor(Doctor doctor) async {
    try {
      final doctors = await getAllDoctors();
      final index = doctors.indexWhere((d) => d.id == doctor.id);
      if (index != -1) {
        doctors[index] = doctor;
        await _saveDoctors(doctors);
      }
    } catch (e) {
      debugPrint('Error updating doctor: $e');
    }
  }

  Future<void> deleteDoctor(String id) async {
    try {
      final doctors = await getAllDoctors();
      doctors.removeWhere((d) => d.id == id);
      await _saveDoctors(doctors);
    } catch (e) {
      debugPrint('Error deleting doctor: $e');
    }
  }

  Future<void> _saveDoctors(List<Doctor> doctors) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = doctors.map((d) => d.toJson()).toList();
    await prefs.setString(_storageKey, json.encode(jsonList));
  }

  Future<void> _initializeSampleData() async {
    final now = DateTime.now();
    final doctors = [
      Doctor(
        id: 'doc1',
        name: 'Dra. Paula Rodrigues',
        email: 'paula.rodrigues@clinica.com',
        phone: '(83) 99876-5432',
        photoUrl: 'assets/images/Female_Doctor_Professional_null_1764593852505.jpg',
        crm: 'CRM 12345',
        specialtyId: 'sp1',
        specialtyName: 'Cardiologia',
        bio: 'Especialista em cardiologia com 15 anos de experiência. Atendimento humanizado e uso de tecnologias avançadas para diagnóstico e tratamento de doenças cardiovasculares.',
        rating: 4.8,
        ratingCount: 127,
        createdAt: now,
        updatedAt: now,
        availableSchedule: {
          'monday': [TimeSlot(start: '08:00', end: '12:00'), TimeSlot(start: '14:00', end: '18:00')],
          'tuesday': [TimeSlot(start: '08:00', end: '12:00'), TimeSlot(start: '14:00', end: '18:00')],
          'wednesday': [TimeSlot(start: '08:00', end: '12:00')],
          'thursday': [TimeSlot(start: '14:00', end: '18:00')],
          'friday': [TimeSlot(start: '08:00', end: '12:00'), TimeSlot(start: '14:00', end: '18:00')],
        },
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
        bio: 'Pediatra dedicado ao cuidado integral de crianças e adolescentes. Atendimento acolhedor e orientação aos pais sobre desenvolvimento infantil.',
        rating: 4.9,
        ratingCount: 203,
        createdAt: now,
        updatedAt: now,
        availableSchedule: {
          'monday': [TimeSlot(start: '09:00', end: '12:00'), TimeSlot(start: '14:00', end: '17:00')],
          'tuesday': [TimeSlot(start: '09:00', end: '12:00'), TimeSlot(start: '14:00', end: '17:00')],
          'wednesday': [TimeSlot(start: '09:00', end: '12:00'), TimeSlot(start: '14:00', end: '17:00')],
          'thursday': [TimeSlot(start: '09:00', end: '12:00'), TimeSlot(start: '14:00', end: '17:00')],
          'friday': [TimeSlot(start: '09:00', end: '12:00')],
        },
      ),
      Doctor(
        id: 'doc3',
        name: 'Dra. Maria Silva',
        email: 'maria.silva@clinica.com',
        phone: '(83) 99654-3210',
        photoUrl: 'assets/images/Dermatologist_Professional_null_1764593855092.jpg',
        crm: 'CRM 34567',
        specialtyId: 'sp3',
        specialtyName: 'Dermatologia',
        bio: 'Dermatologista especializada em tratamentos estéticos e clínicos. Ampla experiência em procedimentos dermatológicos modernos.',
        rating: 4.7,
        ratingCount: 89,
        createdAt: now,
        updatedAt: now,
        availableSchedule: {
          'monday': [TimeSlot(start: '08:00', end: '12:00')],
          'tuesday': [TimeSlot(start: '08:00', end: '12:00'), TimeSlot(start: '14:00', end: '18:00')],
          'wednesday': [TimeSlot(start: '14:00', end: '18:00')],
          'thursday': [TimeSlot(start: '08:00', end: '12:00'), TimeSlot(start: '14:00', end: '18:00')],
          'friday': [TimeSlot(start: '08:00', end: '12:00')],
        },
      ),
      Doctor(
        id: 'doc4',
        name: 'Dr. Carlos Oliveira',
        email: 'carlos.oliveira@clinica.com',
        phone: '(83) 99543-2109',
        photoUrl: 'assets/images/Orthopedist_Surgeon_null_1764593854261.jpg',
        crm: 'CRM 45678',
        specialtyId: 'sp4',
        specialtyName: 'Ortopedia',
        bio: 'Ortopedista especializado em cirurgias articulares e tratamento de lesões esportivas. Referência em reabilitação ortopédica.',
        rating: 4.6,
        ratingCount: 156,
        createdAt: now,
        updatedAt: now,
        availableSchedule: {
          'monday': [TimeSlot(start: '14:00', end: '18:00')],
          'tuesday': [TimeSlot(start: '08:00', end: '12:00')],
          'wednesday': [TimeSlot(start: '08:00', end: '12:00'), TimeSlot(start: '14:00', end: '18:00')],
          'thursday': [TimeSlot(start: '14:00', end: '18:00')],
          'friday': [TimeSlot(start: '08:00', end: '12:00'), TimeSlot(start: '14:00', end: '18:00')],
        },
      ),
      Doctor(
        id: 'doc5',
        name: 'Dra. Ana Costa',
        email: 'ana.costa@clinica.com',
        phone: '(83) 99432-1098',
        photoUrl: 'assets/images/Healthcare_Professional_Smiling_null_1764593856629.jpg',
        crm: 'CRM 56789',
        specialtyId: 'sp1',
        specialtyName: 'Cardiologia',
        bio: 'Cardiologista com foco em prevenção e tratamento de doenças do coração. Abordagem preventiva e educativa com os pacientes.',
        rating: 4.9,
        ratingCount: 178,
        createdAt: now,
        updatedAt: now,
        availableSchedule: {
          'monday': [TimeSlot(start: '08:00', end: '12:00'), TimeSlot(start: '14:00', end: '18:00')],
          'tuesday': [TimeSlot(start: '08:00', end: '12:00')],
          'wednesday': [TimeSlot(start: '08:00', end: '12:00'), TimeSlot(start: '14:00', end: '18:00')],
          'thursday': [TimeSlot(start: '08:00', end: '12:00'), TimeSlot(start: '14:00', end: '18:00')],
          'friday': [TimeSlot(start: '14:00', end: '18:00')],
        },
      ),
    ];
    await _saveDoctors(doctors);
  }
}
