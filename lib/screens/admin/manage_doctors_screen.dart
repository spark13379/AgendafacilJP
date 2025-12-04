import 'package:flutter/material.dart';
import 'package:agendafaciljp/services/doctor_service.dart';
import 'package:agendafaciljp/models/doctor.dart';
import 'package:agendafaciljp/theme.dart';
import 'package:agendafaciljp/widgets/doctor_card.dart';
import 'package:agendafaciljp/widgets/commom/loading_indicator.dart';
import 'package:agendafaciljp/widgets/commom/empty_state.dart';
import 'package:agendafaciljp/utils/strings.dart';

class ManageDoctorsScreen extends StatefulWidget {
  const ManageDoctorsScreen({super.key});

  @override
  State<ManageDoctorsScreen> createState() => _ManageDoctorsScreenState();
}

class _ManageDoctorsScreenState extends State<ManageDoctorsScreen> {
  final DoctorService _doctorService = DoctorService();
  List<Doctor> _doctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    setState(() => _isLoading = true);
    final doctors = await _doctorService.getAllDoctors();
    setState(() {
      _doctors = doctors;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.manageDoctorsTitle),
      ),
      body: _isLoading
          ? const LoadingIndicator(message: AppStrings.loadingDoctors)
          : _doctors.isEmpty
          ? const EmptyState(
        icon: Icons.person_add,
        title: AppStrings.noDoctorsRegistered,
        message: AppStrings.addDoctorsToSystem,
      )
          : RefreshIndicator(
        onRefresh: _loadDoctors,
        child: ListView.builder(
          padding: AppSpacing.paddingLg,
          itemCount: _doctors.length,
          itemBuilder: (context, index) {
            return DoctorCard(doctor: _doctors[index]);
          },
        ),
      ),
    );
  }
}
