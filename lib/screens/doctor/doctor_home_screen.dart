import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:agendafaciljp/providers/auth_provider.dart';
import 'package:agendafaciljp/services/appointment_service.dart';
import 'package:agendafaciljp/models/appointment.dart';
import 'package:agendafaciljp/theme.dart';
import 'package:agendafaciljp/widgets/appointment_card.dart';
import 'package:agendafaciljp/widgets/commom/loading_indicator.dart';
import 'package:agendafaciljp/widgets/commom/empty_state.dart';
import 'package:agendafaciljp/utils/strings.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  List<Appointment> _todayAppointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final doctorId = authProvider.currentUser!.id;

    final allAppointments = await _appointmentService.getAppointmentsByDoctor(doctorId);
    final today = DateTime.now();

    setState(() {
      _todayAppointments = allAppointments.where((a) {
        return a.date.year == today.year &&
            a.date.month == today.month &&
            a.date.day == today.day &&
            a.status != AppointmentStatus.cancelled;
      }).toList();
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
              '${AppStrings.doctorHomeHello} ${user.name.split(' ').first}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              AppStrings.doctorHomeYourSchedule,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Meu Perfil',
            onPressed: () => context.push('/doctor-profile/${user.id}'),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: 'Gerenciar Agenda',
            onPressed: () => context.push('/manage-schedule'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAppointments,
        child: _isLoading
            ? const LoadingIndicator(message: AppStrings.doctorHomeLoading)
            : SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsCards(),
              const SizedBox(height: 24),
              Text(
                AppStrings.doctorHomeAppointmentsToday,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              if (_todayAppointments.isEmpty)
                const EmptyState(
                  icon: Icons.event_available,
                  title: AppStrings.doctorHomeNoAppointmentsToday,
                  message: AppStrings.doctorHomeNoAppointmentsTodayMessage,
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _todayAppointments.length,
                  itemBuilder: (context, index) {
                    return AppointmentCard(
                      appointment: _todayAppointments[index],
                      showDoctor: false,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.event,
            label: AppStrings.doctorHomeToday,
            value: _todayAppointments.length.toString(),
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle,
            label: AppStrings.doctorHomeConfirmed,
            value: _todayAppointments.where((a) => a.status == AppointmentStatus.confirmed).length.toString(),
            color: AppColors.statusConfirmed,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
