import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:agendafaciljp/models/doctor.dart';
import 'package:agendafaciljp/providers/auth_provider.dart';
import 'package:agendafaciljp/services/doctor_service.dart';
import 'package:provider/provider.dart';

class ManageScheduleScreen extends StatefulWidget {
  const ManageScheduleScreen({super.key});

  @override
  State<ManageScheduleScreen> createState() => _ManageScheduleScreenState();
}

class _ManageScheduleScreenState extends State<ManageScheduleScreen> {
  final DoctorService _doctorService = DoctorService();
  Doctor? _doctor;

  // Controle do Calendário de Bloqueios
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Set<DateTime> _blockedDates = {};

  // Controle dos Horários Semanais
  late Map<String, List<TimeSlot>> _weeklySchedule;
  final List<String> _weekDays = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
  final Map<String, String> _weekDayLabels = {
    'monday': 'Segunda-feira',
    'tuesday': 'Terça-feira',
    'wednesday': 'Quarta-feira',
    'thursday': 'Quinta-feira',
    'friday': 'Sexta-feira',
    'saturday': 'Sábado',
    'sunday': 'Domingo',
  };

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    if (authProvider.currentUser is Doctor) {
      _doctor = authProvider.currentUser as Doctor;
      _blockedDates = Set.from(_doctor!.blockedDates);
      _weeklySchedule = Map.from(_doctor!.availableSchedule.map((key, value) => MapEntry(key, List<TimeSlot>.from(value))));
    } else {
      _weeklySchedule = {};
    }
    _selectedDay = _focusedDay;
  }

  // ----- Lógica para a Aba de Bloqueios -----
  void _onDaySelectedForBlocking(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;

      final dayOnly = DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day);
      if (_blockedDates.contains(dayOnly)) {
        _blockedDates.remove(dayOnly);
      } else {
        _blockedDates.add(dayOnly);
      }
    });
  }

  Future<void> _saveBlockedDates() async {
    if (_doctor == null) return;

    final updatedDoctor = _doctor!.copyWithDoctor(blockedDates: _blockedDates.toList());
    await _doctorService.updateDoctor(updatedDoctor);

    if (!mounted) return;
    context.read<AuthProvider>().updateUser(updatedDoctor);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datas de bloqueio salvas com sucesso!')),
    );
  }

  // ----- Lógica para a Aba de Horários -----
  Future<void> _saveWeeklySchedule() async {
    if (_doctor == null) return;

    final updatedDoctor = _doctor!.copyWithDoctor(availableSchedule: _weeklySchedule);
    await _doctorService.updateDoctor(updatedDoctor);

    if (!mounted) return;
    context.read<AuthProvider>().updateUser(updatedDoctor);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Horários de atendimento salvos com sucesso!')),
    );
  }
  
  Future<void> _editDaySchedule(String dayKey) async {
    List<TimeSlot> currentSlots = List.from(_weeklySchedule[dayKey] ?? []);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Editar Horários - ${_weekDayLabels[dayKey]}'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: currentSlots.length,
                  itemBuilder: (context, index) {
                    final slot = currentSlots[index];
                    return ListTile(
                      title: Text('${slot.start} - ${slot.end}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setDialogState(() {
                            currentSlots.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Adicionar Horário'),
                  onPressed: () async {
                    final TimeOfDay? startTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                    if (startTime == null || !context.mounted) return;
                    final TimeOfDay? endTime = await showTimePicker(context: context, initialTime: startTime.replacing(hour: startTime.hour + 1));
                    if (endTime == null || !context.mounted) return;

                    final newSlot = TimeSlot(
                      start: startTime.format(context),
                      end: endTime.format(context),
                    );
                    setDialogState(() {
                      currentSlots.add(newSlot);
                      currentSlots.sort((a, b) => a.start.compareTo(b.start));
                    });
                  },
                ),
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Salvar'),
                  onPressed: () {
                    setState(() {
                      _weeklySchedule[dayKey] = currentSlots;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gerenciar Agenda'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.access_time), text: 'Horários'),
              Tab(icon: Icon(Icons.block), text: 'Bloqueios'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildWeeklyScheduleTab(),
            _buildBlockedDatesTab(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWeeklyScheduleTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _weekDays.length,
            itemBuilder: (context, index) {
              final dayKey = _weekDays[index];
              final dayLabel = _weekDayLabels[dayKey]!;
              final slots = _weeklySchedule[dayKey] ?? [];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(dayLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: slots.isEmpty
                      ? const Text('Não atende neste dia')
                      : Text(slots.map((s) => '${s.start} - ${s.end}').join(', ')),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editDaySchedule(dayKey),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _saveWeeklySchedule,
            child: const Text('Salvar Horários de Atendimento'),
          ),
        ),
      ],
    );
  }

  Widget _buildBlockedDatesTab() {
    return Column(
      children: [
        TableCalendar(
          locale: 'pt_BR',
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: _onDaySelectedForBlocking,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              final dayOnly = DateTime.utc(day.year, day.month, day.day);
              if (_blockedDates.any((blockedDay) => isSameDay(blockedDay, dayOnly))) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(day.day.toString(), style: const TextStyle(color: Colors.white)),
                );
              }
              return null;
            },
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _saveBlockedDates,
            child: const Text('Salvar Datas Bloqueadas'),
          ),
        ),
      ],
    );
  }
}
