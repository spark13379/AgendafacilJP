import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:agendafaciljp/services/specialty_service.dart';
import 'package:agendafaciljp/models/specialty.dart';
import 'package:agendafaciljp/theme.dart';
import 'package:agendafaciljp/widgets/specialty_card.dart';
import 'package:agendafaciljp/widgets/commom/loading_indicator.dart';
import 'package:agendafaciljp/utils/strings.dart';

class SpecialtiesScreen extends StatefulWidget {
  const SpecialtiesScreen({super.key});

  @override
  State<SpecialtiesScreen> createState() => _SpecialtiesScreenState();
}

class _SpecialtiesScreenState extends State<SpecialtiesScreen> {
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
        title: const Text(AppStrings.specialtiesTitle),
      ),
      body: _isLoading
          ? const LoadingIndicator(message: AppStrings.specialtiesLoading)
          : GridView.builder(
        padding: AppSpacing.paddingLg,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _specialties.length,
        itemBuilder: (context, index) {
          return SpecialtyCard(
            specialty: _specialties[index],
            onTap: () => context.push('/doctors-by-specialty/${_specialties[index].id}'),
          );
        },
      ),
    );
  }
}
