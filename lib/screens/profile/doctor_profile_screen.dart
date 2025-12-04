import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:agendafaciljp/services/doctor_service.dart';
import 'package:agendafaciljp/models/doctor.dart';
import 'package:agendafaciljp/theme.dart';
import 'package:agendafaciljp/widgets/rating_stars.dart';
import 'package:agendafaciljp/widgets/commom/loading_indicator.dart';
import 'package:agendafaciljp/widgets/commom/custom_button.dart';
import 'package:agendafaciljp/utils/strings.dart';

class DoctorProfileScreen extends StatefulWidget {
  final String doctorId;

  const DoctorProfileScreen({super.key, required this.doctorId});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final DoctorService _doctorService = DoctorService();
  Doctor? _doctor;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctor();
  }

  Future<void> _loadDoctor() async {
    setState(() => _isLoading = true);
    final doctor = await _doctorService.getDoctorById(widget.doctorId);
    setState(() {
      _doctor = doctor;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: LoadingIndicator(message: AppStrings.doctorProfileLoading),
      );
    }

    if (_doctor == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text(AppStrings.doctorProfileNotFound)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.doctorProfileTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Padding(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(),
                  const SizedBox(height: 24),
                  _buildBioSection(),
                  const SizedBox(height: 24),
                  _buildRatingSection(),
                  const SizedBox(height: 24),
                  _buildCommentsSection(),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: AppStrings.doctorProfileBookAppointment,
                    icon: Icons.calendar_today,
                    onPressed: () => context.push('/book-appointment/${_doctor!.id}'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingLg,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlue, AppColors.lightBlue],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 3),
              color: AppColors.white,
              image: _doctor!.photoUrl != null
                  ? DecorationImage(
                      image: AssetImage(_doctor!.photoUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _doctor!.photoUrl == null
                ? const Icon(Icons.person, size: 50, color: AppColors.textSecondary)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            _doctor!.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            _doctor!.crm,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white.withAlpha(230),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.medical_services,
            label: AppStrings.doctorProfileSpecialty,
            value: _doctor!.specialtyName,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.email,
            label: AppStrings.doctorProfileEmail,
            value: _doctor!.email,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.phone,
            label: AppStrings.doctorProfilePhone,
            value: _doctor!.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.doctorProfileAbout,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Text(
          _doctor!.bio,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.textSecondary.withAlpha(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.doctorProfileRatings,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                _doctor!.rating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RatingStars(rating: _doctor!.rating, size: 20),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.doctorProfileNAppointments.replaceFirst('{count}', _doctor!.ratingCount.toString()),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    // Sample data for comments
    final comments = [
      {'name': 'Maria Joaquina', 'comment': 'Excelente profissional, muito atenciosa e cuidadosa.'},
      {'name': 'José da Silva', 'comment': 'Gostei muito do atendimento, o Dr. é muito experiente.'},
      {'name': 'Ana Clara', 'comment': 'Recomendo! Atendimento de primeira e muito profissional.'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comentários',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: AppSpacing.paddingMd,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment['name']!,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comment['comment']!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryBlue),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
