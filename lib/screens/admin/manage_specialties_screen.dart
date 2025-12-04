import 'package:flutter/material.dart';
import 'package:agendafaciljp/services/specialty_service.dart';
import 'package:agendafaciljp/models/specialty.dart';
import 'package:agendafaciljp/theme.dart';
import 'package:agendafaciljp/widgets/specialty_card.dart';
import 'package:agendafaciljp/widgets/commom/loading_indicator.dart';
import 'package:agendafaciljp/widgets/commom/empty_state.dart';
import 'package:agendafaciljp/utils/strings.dart';

class ManageSpecialtiesScreen extends StatefulWidget {
  const ManageSpecialtiesScreen({super.key});

  @override
  State<ManageSpecialtiesScreen> createState() => _ManageSpecialtiesScreenState();
}

class _ManageSpecialtiesScreenState extends State<ManageSpecialtiesScreen> {
  final SpecialtyService _specialtyService = SpecialtyService();
  List<Specialty> _specialties = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSpecialties();
  }

  Future<void> _loadSpecialties() async {
    setState(() => _isLoading = true);
    final specialties = await _specialtyService.getAllSpecialties();
    setState(() {
      _specialties = specialties;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.manageSpecialtiesTitle),
      ),
      body: _isLoading
          ? const LoadingIndicator(message: AppStrings.loadingSpecialties)
          : _specialties.isEmpty
          ? const EmptyState(
        icon: Icons.add_circle,
        title: AppStrings.noSpecialtiesRegistered,
        message: AppStrings.addSpecialtiesToSystem,
      )
          : RefreshIndicator(
        onRefresh: _loadSpecialties,
        child: GridView.builder(
          padding: AppSpacing.paddingLg,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _specialties.length,
          itemBuilder: (context, index) {
            return SpecialtyCard(specialty: _specialties[index]);
          },
        ),
      ),
    );
  }
}
