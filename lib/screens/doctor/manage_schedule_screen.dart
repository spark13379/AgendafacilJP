import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:agendafaciljp/models/doctor.dart';
import 'package:agendafaciljp/providers/auth_provider.dart';
import 'package:agendafaciljp/services/doctor_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ManageScheduleScreen extends StatefulWidget {
  const ManageScheduleScreen({super.key});

  @override
  State<ManageScheduleScreen> createState() => _ManageScheduleScreenState();
}

class _ManageScheduleScreenState extends State<ManageScheduleScreen> {
  final DoctorService _doctorService = DoctorService();
  Doctor? _doctor;

  // Controle do Calendário
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Set<DateTime> _blockedDates = {};

  @override
  void initState() {
    super.initState();
    // Carrega os dados do médico logado
    final authProvider = context.read<AuthProvider>();
    if (authProvider.currentUser is Doctor) {
      _doctor = authProvider.currentUser as Doctor;
      // Converte a lista de datas para um Set para eficiência
      _blockedDates = Set.from(_doctor!.blockedDates);
    }
    _selectedDay = _focusedDay;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;

      if (_blockedDates.contains(selectedDay)) {
        _blockedDates.remove(selectedDay);
      } else {
        _blockedDates.add(selectedDay);
      }
    });
  }

  Future<void> _saveBlockedDates() async {
    if (_doctor == null) return;

    final updatedDoctor = _doctor!.copyWithDoctor(
      blockedDates: _blockedDates.toList(),
    );

    await _doctorService.updateDoctor(updatedDoctor);

    // Atualiza o provedor de autenticação com os novos dados
    context.read<AuthProvider>().updateUser(updatedDoctor);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datas de bloqueio salvas com sucesso!')),
      );
    }
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
            // Aba de Horários (Placeholder)
            _buildWeeklyScheduleTab(),

            // Aba de Bloqueios
            _buildBlockedDatesTab(),
          ],
        ),
      ),
    );
  }

  // Constrói a aba de bloqueio de datas
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
          onDaySelected: _onDaySelected,
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
            // Estiliza os dias bloqueados
            defaultBuilder: (context, day, focusedDay) {
              if (_blockedDates.any((blockedDay) => isSameDay(blockedDay, day))) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    day.day.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
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
            child: const Text('Salvar Bloqueios'),
          ),
        ),
      ],
    );
  }

  // Constrói a aba de horários semanais (Placeholder)
  Widget _buildWeeklyScheduleTab() {
    // Lógica para editar os horários virá aqui
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'Funcionalidade para definir os horários de atendimento padrão para cada dia da semana em desenvolvimento.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
