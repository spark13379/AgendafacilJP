import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:agendafaciljp/providers/auth_provider.dart';
import 'package:agendafaciljp/services/appointment_service.dart';
import 'package:agendafaciljp/models/appointment.dart';
import 'package:agendafaciljp/theme.dart';
import 'package:agendafaciljp/widgets/appointment_card.dart';
import 'package:agendafaciljp/widgets/commom/empty_state.dart';
import 'package:agendafaciljp/widgets/commom/loading_indicator.dart';
import 'package:agendafaciljp/utils/strings.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  List<Appointment> _upcomingAppointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final clientId = authProvider.currentUser!.id;

    final allAppointments = await _appointmentService.getAppointmentsByClient(clientId);

    setState(() {
      _upcomingAppointments = allAppointments
          .where((a) => a.isFuture && a.status != AppointmentStatus.cancelled)
          .take(5)
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppStrings.clientHomeHello}, ${user.name.split(' ').first}!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              AppStrings.clientHomeYourAppointments,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/user-profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAppointments,
        child: _isLoading
            ? const LoadingIndicator(message: AppStrings.clientHomeLoadingAppointments)
            : SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuickActions(),
              const SizedBox(height: 32),
              _buildUpcomingSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/specialties'),
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.clientHomeNewAppointment),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.calendar_month,
            label: AppStrings.clientHomeMyAppointments,
            color: AppColors.primaryBlue,
            onTap: () => context.push('/appointment-history'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.medical_services,
            label: AppStrings.clientHomeSpecialties,
            color: AppColors.accentGreen,
            onTap: () => context.push('/specialties'),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.clientHomeUpcomingAppointments,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (_upcomingAppointments.isNotEmpty)
              TextButton(
                onPressed: () => context.push('/appointment-history'),
                child: const Text(AppStrings.clientHomeViewAll),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_upcomingAppointments.isEmpty)
          EmptyState(
            icon: Icons.event_available,
            title: AppStrings.clientHomeNoAppointments,
            message: AppStrings.clientHomeBookFirstAppointment,
            actionLabel: AppStrings.clientHomeBookAppointment,
            onAction: () => context.push('/specialties'),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _upcomingAppointments.length,
            itemBuilder: (context, index) {
              return AppointmentCard(
                appointment: _upcomingAppointments[index],
                onTap: () => context.push('/appointment-details/${_upcomingAppointments[index].id}'),
              );
            },
          ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: AppSpacing.paddingLg,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
