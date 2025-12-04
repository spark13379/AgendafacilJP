import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:agendafaciljp/services/appointment_service.dart';
import 'package:agendafaciljp/models/appointment.dart';
import 'package:agendafaciljp/theme.dart';
import 'package:agendafaciljp/utils/date_formatter.dart';
import 'package:agendafaciljp/widgets/commom/loading_indicator.dart';
import 'package:agendafaciljp/widgets/commom/custom_button.dart';
import 'package:agendafaciljp/utils/strings.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final String appointmentId;

  const AppointmentDetailsScreen({super.key, required this.appointmentId});

  @override
  State<AppointmentDetailsScreen> createState() => _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  Appointment? _appointment;
  bool _isLoading = true;
  bool _isCancelling = false;

  @override
  void initState() {
    super.initState();
    _loadAppointment();
  }

  Future<void> _loadAppointment() async {
    setState(() => _isLoading = true);
    final appointment = await _appointmentService.getAppointmentById(widget.appointmentId);
    setState(() {
      _appointment = appointment;
      _isLoading = false;
    });
  }

  Future<void> _cancelAppointment() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.appointmentDetailsCancelAppointment),
        content: const Text(AppStrings.appointmentDetailsCancelConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.appointmentDetailsNo),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(AppStrings.appointmentDetailsYesCancel),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isCancelling = true);

    final updated = _appointment!.copyWith(
      status: AppointmentStatus.cancelled,
      cancellationReason: AppStrings.appointmentDetailsCancelledByPatient,
      updatedAt: DateTime.now(),
    );

    await _appointmentService.updateAppointment(updated);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.appointmentDetailsSuccessfullyCancelled),
        backgroundColor: AppColors.statusCancelled,
      ),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: LoadingIndicator(message: AppStrings.appointmentDetailsLoading),
      );
    }

    if (_appointment == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text(AppStrings.appointmentDetailsNotFound)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appointmentDetailsTitle),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 16),
            _buildInfoCard(),
            const SizedBox(height: 16),
            if (_appointment!.notes != null) ...[
              _buildNotesCard(),
              const SizedBox(height: 16),
            ],
            if (_appointment!.canCancel) ...[
              CustomButton(
                text: AppStrings.appointmentDetailsCancelAppointment,
                onPressed: _cancelAppointment,
                isLoading: _isCancelling,
                isOutlined: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          children: [
            Icon(
              _getStatusIcon(),
              size: 48,
              color: _getStatusColor(),
            ),
            const SizedBox(height: 12),
            Text(
              _getStatusText(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: _getStatusColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.appointmentDetailsInfo,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _InfoRow(icon: Icons.person, label: AppStrings.appointmentDetailsDoctor, value: _appointment!.doctorName),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.medical_services, label: AppStrings.appointmentDetailsSpecialty, value: _appointment!.specialtyName),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.calendar_today, label: AppStrings.appointmentDetailsDate, value: DateFormatter.formatDate(_appointment!.date)),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.access_time, label: AppStrings.appointmentDetailsTime, value: _appointment!.timeSlot),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard() {
    return Card(
      child: Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.appointmentDetailsNotes,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _appointment!.notes!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (_appointment!.status) {
      case AppointmentStatus.confirmed:
        return AppColors.statusConfirmed;
      case AppointmentStatus.pending:
        return AppColors.statusPending;
      case AppointmentStatus.completed:
        return AppColors.accentGreen;
      case AppointmentStatus.cancelled:
        return AppColors.statusCancelled;
    }
  }

  IconData _getStatusIcon() {
    switch (_appointment!.status) {
      case AppointmentStatus.confirmed:
        return Icons.check_circle;
      case AppointmentStatus.pending:
        return Icons.schedule;
      case AppointmentStatus.completed:
        return Icons.task_alt;
      case AppointmentStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _getStatusText() {
    switch (_appointment!.status) {
      case AppointmentStatus.confirmed:
        return AppStrings.appointmentStatusConfirmed;
      case AppointmentStatus.pending:
        return AppStrings.appointmentStatusPending;
      case AppointmentStatus.completed:
        return AppStrings.appointmentStatusCompleted;
      case AppointmentStatus.cancelled:
        return AppStrings.appointmentStatusCancelled;
    }
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
        Icon(icon, size: 20, color: AppColors.textSecondary),
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
