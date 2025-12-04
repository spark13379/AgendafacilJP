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

class AppointmentHistoryScreen extends StatefulWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  State<AppointmentHistoryScreen> createState() => _AppointmentHistoryScreenState();
}

class _AppointmentHistoryScreenState extends State<AppointmentHistoryScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  List<Appointment> _appointments = [];
  bool _isLoading = true;
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final clientId = authProvider.currentUser!.id;

    final appointments = await _appointmentService.getAppointmentsByClient(clientId);

    setState(() {
      _appointments = appointments;
      _isLoading = false;
    });
  }

  List<Appointment> get _filteredAppointments {
    switch (_filter) {
      case 'upcoming':
        return _appointments.where((a) => a.isFuture && a.status != AppointmentStatus.cancelled).toList();
      case 'past':
        return _appointments.where((a) => a.isPast || a.status == AppointmentStatus.completed).toList();
      case 'cancelled':
        return _appointments.where((a) => a.status == AppointmentStatus.cancelled).toList();
      default:
        return _appointments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appointmentHistoryTitle),
      ),
      body: _isLoading
          ? const LoadingIndicator(message: AppStrings.appointmentHistoryLoading)
          : Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _filteredAppointments.isEmpty
                ? const EmptyState(
              icon: Icons.event_busy,
              title: AppStrings.appointmentHistoryNoAppointments,
              message: AppStrings.appointmentHistoryNoAppointmentsForFilter,
            )
                : RefreshIndicator(
              onRefresh: _loadAppointments,
              child: ListView.builder(
                padding: AppSpacing.paddingLg,
                itemCount: _filteredAppointments.length,
                itemBuilder: (context, index) {
                  return AppointmentCard(
                    appointment: _filteredAppointments[index],
                    onTap: () => context.push('/appointment-details/${_filteredAppointments[index].id}'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: AppSpacing.horizontalLg,
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            label: AppStrings.appointmentHistoryFilterAll,
            isSelected: _filter == 'all',
            onTap: () => setState(() => _filter = 'all'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: AppStrings.appointmentHistoryFilterUpcoming,
            isSelected: _filter == 'upcoming',
            onTap: () => setState(() => _filter = 'upcoming'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: AppStrings.appointmentHistoryFilterPast,
            isSelected: _filter == 'past',
            onTap: () => setState(() => _filter = 'past'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: AppStrings.appointmentHistoryFilterCancelled,
            isSelected: _filter == 'cancelled',
            onTap: () => setState(() => _filter = 'cancelled'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isSelected ? AppColors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
