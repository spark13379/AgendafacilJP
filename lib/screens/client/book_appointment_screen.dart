import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:agendafaciljp/providers/auth_provider.dart';
import 'package:agendafaciljp/services/doctor_service.dart';
import 'package:agendafaciljp/services/appointment_service.dart';
import 'package:agendafaciljp/models/doctor.dart';
import 'package:agendafaciljp/models/appointment.dart';
import 'package:agendafaciljp/theme.dart';
import 'package:agendafaciljp/utils/constants.dart';
import 'package:agendafaciljp/widgets/commom/loading_indicator.dart';
import 'package:agendafaciljp/widgets/commom/custom_button.dart';
import 'package:agendafaciljp/utils/strings.dart';

class BookAppointmentScreen extends StatefulWidget {
  final String doctorId;

  const BookAppointmentScreen({super.key, required this.doctorId});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final DoctorService _doctorService = DoctorService();
  final AppointmentService _appointmentService = AppointmentService();
  final TextEditingController _notesController = TextEditingController();

  Doctor? _doctor;
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  List<String> _availableTimeSlots = [];
  bool _isLoading = true;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    _loadDoctor();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctor() async {
    setState(() => _isLoading = true);
    final doctor = await _doctorService.getDoctorById(widget.doctorId);
    setState(() {
      _doctor = doctor;
      _isLoading = false;
    });
    _updateAvailableTimeSlots();
  }

  void _updateAvailableTimeSlots() async {
    if (_doctor == null) return;

    // Verifica se a data selecionada está na lista de dias bloqueados
    final isBlocked = _doctor!.blockedDates.any((blockedDate) => isSameDay(blockedDate, _selectedDate));

    if (isBlocked) {
      setState(() => _availableTimeSlots = []);
      return;
    }

    final weekDay = AppConstants.weekDays[_selectedDate.weekday - 1];
    final schedule = _doctor!.availableSchedule[weekDay];

    if (schedule == null || schedule.isEmpty) {
      setState(() => _availableTimeSlots = []);
      return;
    }

    final allSlots = <String>[];
    for (final timeSlot in schedule) {
      allSlots.addAll(AppConstants.generateTimeSlots(timeSlot.start, timeSlot.end));
    }

    final bookedSlots = <String>[];
    final appointments = await _appointmentService.getAppointmentsByDoctorAndDate(
      widget.doctorId,
      _selectedDate,
    );

    for (final apt in appointments) {
      if (apt.status != AppointmentStatus.cancelled) {
        bookedSlots.add(apt.timeSlot);
      }
    }

    setState(() {
      _availableTimeSlots = allSlots.where((slot) => !bookedSlots.contains(slot)).toList();
      if (_selectedTimeSlot != null && !_availableTimeSlots.contains(_selectedTimeSlot)) {
        _selectedTimeSlot = null;
      }
    });
  }

  Future<void> _bookAppointment() async {
    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.bookAppointmentSelectTime)),
      );
      return;
    }

    setState(() => _isBooking = true);

    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser!;

    final appointment = Appointment(
      id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
      clientId: user.id,
      clientName: user.name,
      clientPhone: user.phone,
      doctorId: _doctor!.id,
      doctorName: _doctor!.name,
      specialtyName: _doctor!.specialtyName,
      date: _selectedDate,
      timeSlot: _selectedTimeSlot!,
      status: AppointmentStatus.confirmed,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _appointmentService.addAppointment(appointment);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.bookAppointmentSuccess),
        backgroundColor: AppColors.statusConfirmed,
      ),
    );

    context.go('/client-home');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: LoadingIndicator(message: AppStrings.bookAppointmentLoading),
      );
    }

    if (_doctor == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text(AppStrings.bookAppointmentDoctorNotFound)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.bookAppointmentTitle),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDoctorInfo(),
            const SizedBox(height: 24),
            _buildCalendar(),
            const SizedBox(height: 24),
            _buildTimeSlots(),
            const SizedBox(height: 24),
            _buildNotesField(),
            const SizedBox(height: 24),
            CustomButton(
              text: AppStrings.bookAppointmentConfirmButton,
              onPressed: _bookAppointment,
              isLoading: _isBooking,
              icon: Icons.check,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Card(
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                color: AppColors.cardBackground,
                image: _doctor!.photoUrl != null
                    ? DecorationImage(
                  image: AssetImage(_doctor!.photoUrl!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: _doctor!.photoUrl == null
                  ? const Icon(Icons.person, size: 30, color: AppColors.textSecondary)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _doctor!.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _doctor!.specialtyName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      child: Padding(
        padding: AppSpacing.paddingSm,
        child: TableCalendar(
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 90)),
          focusedDay: _selectedDate,
          selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDate = selectedDay;
              _selectedTimeSlot = null;
            });
            _updateAvailableTimeSlots();
          },
          calendarStyle: CalendarStyle(
            selectedDecoration: const BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: AppColors.primaryBlue.withAlpha(77),
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.bookAppointmentAvailableTimes,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        if (_availableTimeSlots.isEmpty)
          Container(
            padding: AppSpacing.paddingMd,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppStrings.bookAppointmentNoAvailableTimes,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableTimeSlots.map((slot) {
              final isSelected = _selectedTimeSlot == slot;
              return ChoiceChip(
                label: Text(slot),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _selectedTimeSlot = selected ? slot : null);
                },
                selectedColor: AppColors.primaryBlue,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.white : AppColors.textPrimary,
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.bookAppointmentNotesOptional,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: AppStrings.bookAppointmentNotesHint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
      ],
    );
  }
}
