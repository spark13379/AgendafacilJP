import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:agendafaciljp/services/doctor_service.dart';
import 'package:agendafaciljp/services/specialty_service.dart';
import 'package:agendafaciljp/models/doctor.dart';
import 'package:agendafaciljp/models/specialty.dart';
import 'package:agendafaciljp/theme.dart';
import 'package:agendafaciljp/widgets/doctor_card.dart';
import 'package:agendafaciljp/widgets/commom/loading_indicator.dart';
import 'package:agendafaciljp/widgets/commom/empty_state.dart';
import 'package:agendafaciljp/utils/strings.dart';

class DoctorsBySpecialtyScreen extends StatefulWidget {
  final String specialtyId;

  const DoctorsBySpecialtyScreen({super.key, required this.specialtyId});

  @override
  State<DoctorsBySpecialtyScreen> createState() => _DoctorsBySpecialtyScreenState();
}

class _DoctorsBySpecialtyScreenState extends State<DoctorsBySpecialtyScreen> {
  final DoctorService _doctorService = DoctorService();
  final SpecialtyService _specialtyService = SpecialtyService();
  List<Doctor> _doctors = [];
  Specialty? _specialty;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final specialty = await _specialtyService.getSpecialtyById(widget.specialtyId);
    final doctors = await _doctorService.getDoctorsBySpecialty(widget.specialtyId);

    setState(() {
      _specialty = specialty;
      _doctors = doctors;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_specialty?.name ?? AppStrings.doctorsBySpecialtyTitle),
      ),
      body: _isLoading
          ? const LoadingIndicator(message: AppStrings.doctorsBySpecialtyLoading)
          : _doctors.isEmpty
          ? EmptyState(
        icon: Icons.person_search,
        title: AppStrings.doctorsBySpecialtyNotFound,
        message: AppStrings.doctorsBySpecialtyNoDoctorsForSpecialty,
        actionLabel: AppStrings.doctorsBySpecialtyBackButton,
        onAction: () => context.pop(),
      )
          : ListView.builder(
        padding: AppSpacing.paddingLg,
        itemCount: _doctors.length,
        itemBuilder: (context, index) {
          return DoctorCard(
            doctor: _doctors[index],
            onTap: () => context.push('/doctor-profile/${_doctors[index].id}'),
          );
        },
      ),
    );
  }
}
