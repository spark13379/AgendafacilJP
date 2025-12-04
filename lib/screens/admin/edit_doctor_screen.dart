import 'package:flutter/material.dart';
import 'package:agendafaciljp/models/doctor.dart';
import 'package:agendafaciljp/services/doctor_service.dart';
import 'package:agendafaciljp/utils/validators.dart';
import 'package:agendafaciljp/widgets/commom/custom_field_text.dart';

class EditDoctorScreen extends StatefulWidget {
  final Doctor doctor;

  const EditDoctorScreen({super.key, required this.doctor});

  @override
  State<EditDoctorScreen> createState() => _EditDoctorScreenState();
}

class _EditDoctorScreenState extends State<EditDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _doctorService = DoctorService();

  late TextEditingController _nameController;
  late TextEditingController _crmController;
  late TextEditingController _specialtyNameController;
  late TextEditingController _bioController;
  late bool _isActive;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.doctor.name);
    _crmController = TextEditingController(text: widget.doctor.crm);
    _specialtyNameController = TextEditingController(text: widget.doctor.specialtyName);
    _bioController = TextEditingController(text: widget.doctor.bio);
    _isActive = widget.doctor.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _crmController.dispose();
    _specialtyNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveDoctor() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final updatedDoctor = widget.doctor.copyWithDoctor(
      name: _nameController.text,
      crm: _crmController.text,
      specialtyName: _specialtyNameController.text,
      bio: _bioController.text,
      isActive: _isActive,
    );

    await _doctorService.updateDoctor(updatedDoctor);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Médico atualizado com sucesso!')),
      );
      Navigator.of(context).pop();
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Médico'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            CustomTextField(
              label: 'Nome Completo',
              controller: _nameController,
              validator: Validators.validateName,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'CRM',
              controller: _crmController,
              validator: (value) => value == null || value.isEmpty ? 'CRM é obrigatório' : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Especialidade',
              controller: _specialtyNameController,
              validator: (value) => value == null || value.isEmpty ? 'Especialidade é obrigatória' : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Biografia (Bio)',
              controller: _bioController,
              maxLines: 4,
              validator: (value) => value == null || value.isEmpty ? 'Biografia é obrigatória' : null,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Médico Ativo'),
              subtitle: const Text('Médicos inativos não aparecerão nas buscas dos pacientes.'),
              value: _isActive,
              onChanged: (bool value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveDoctor,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
