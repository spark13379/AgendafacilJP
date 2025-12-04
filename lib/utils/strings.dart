class AppStrings {
  static const String manageDoctorsTitle = 'Gerenciar Médicos';
  static const String loadingDoctors = 'Carregando médicos...';
  static const String noDoctorsRegistered = 'Nenhum médico cadastrado';
  static const String addDoctorsToSystem = 'Adicione médicos ao sistema';

  static const String manageSpecialtiesTitle = 'Gerenciar Especialidades';
  static const String loadingSpecialties = 'Carregando especialidades...';
  static const String noSpecialtiesRegistered = 'Nenhuma especialidade cadastrada';
  static const String addSpecialtiesToSystem = 'Adicione especialidades ao sistema';

  static const String loginWelcome = 'Bem vindo(a), acesse a sua conta.';
  static const String loginEmailOrCpfLabel = 'Email ou CPF';
  static const String loginEmailHint = 'seu@email.com';
  static const String loginPasswordLabel = 'Senha';
  static const String loginPasswordHint = '••••••';
  static const String loginForgotPassword = 'Esqueceu a senha? Recuperar';
  static const String loginButton = 'Entrar';
  static const String loginNoAccount = 'Não tem conta? ';
  static const String loginCreateAccount = 'Criar nova conta';
  static const String loginPatient = 'Paciente';
  static const String loginHealthProfessional = 'Profissional da saúde';
  static const String loginAdmin = 'Administrador';
  static const String loginTestUsers = 'Usuários de teste:';
  static const String loginTestUsersCredentials = 'Cliente: carlos@email.com / 123456\n'
      'Médico: joao.santos@clinica.com / 123456\n'
      'Admin: admin@clinica.com / 123456';
  static const String incorrectEmailOrPassword = 'Email ou senha incorretos';

  static const String registerPasswordsDoNotMatch = 'As senhas não coincidem';
  static const String registerCreateAccountTitle = 'Criar Nova Conta';
  static const String registerSubtitle = 'Preencha os dados abaixo para se cadastrar';
  static const String registerFullNameLabel = 'Nome Completo';
  static const String registerFullNameHint = 'Digite seu nome';
  static const String registerEmailLabel = 'Email';
  static const String registerPhoneLabel = 'Telefone';
  static const String registerPhoneHint = '(XX) XXXXX-XXXX';
  static const String registerPasswordHint = 'Mínimo 6 caracteres';
  static const String registerConfirmPasswordLabel = 'Confirmar Senha';
  static const String registerConfirmPasswordHint = 'Digite a senha novamente';
  static const String registerCreateAccountButton = 'Criar Conta';
  static const String registerAlreadyHaveAccount = 'Já tem conta? ';
  static const String registerLoginButton = 'Fazer login';
  static const String registerEmailAlreadyRegistered = 'Este email já está cadastrado';

  // Appointment Details
  static const String appointmentDetailsCancelAppointment = 'Cancelar Consulta';
  static const String appointmentDetailsCancelConfirmation = 'Tem certeza que deseja cancelar esta consulta?';
  static const String appointmentDetailsNo = 'Não';
  static const String appointmentDetailsYesCancel = 'Sim, cancelar';
  static const String appointmentDetailsCancelledByPatient = 'Cancelado pelo paciente';
  static const String appointmentDetailsSuccessfullyCancelled = 'Consulta cancelada com sucesso';
  static const String appointmentDetailsLoading = 'Carregando detalhes...';
  static const String appointmentDetailsNotFound = 'Consulta não encontrada';
  static const String appointmentDetailsTitle = 'Detalhes da Consulta';
  static const String appointmentDetailsInfo = 'Informações da Consulta';
  static const String appointmentDetailsDoctor = 'Médico';
  static const String appointmentDetailsSpecialty = 'Especialidade';
  static const String appointmentDetailsDate = 'Data';
  static const String appointmentDetailsTime = 'Horário';
  static const String appointmentDetailsNotes = 'Observações';
  static const String appointmentStatusConfirmed = 'Consulta Confirmada';
  static const String appointmentStatusPending = 'Aguardando Confirmação';
  static const String appointmentStatusCompleted = 'Consulta Realizada';
  static const String appointmentStatusCancelled = 'Consulta Cancelada';

  // Appointment History
  static const String appointmentHistoryTitle = 'Minhas Consultas';
  static const String appointmentHistoryLoading = 'Carregando consultas...';
  static const String appointmentHistoryNoAppointments = 'Nenhuma consulta encontrada';
  static const String appointmentHistoryNoAppointmentsForFilter = 'Não há consultas para exibir com o filtro selecionado';
  static const String appointmentHistoryFilterAll = 'Todas';
  static const String appointmentHistoryFilterUpcoming = 'Próximas';
  static const String appointmentHistoryFilterPast = 'Passadas';
  static const String appointmentHistoryFilterCancelled = 'Canceladas';

  // Book Appointment
  static const String bookAppointmentSelectTime = 'Selecione um horário';
  static const String bookAppointmentSuccess = 'Consulta agendada com sucesso!';
  static const String bookAppointmentLoading = 'Carregando informações...';
  static const String bookAppointmentDoctorNotFound = 'Médico não encontrado';
  static const String bookAppointmentTitle = 'Agendar Consulta';
  static const String bookAppointmentConfirmButton = 'Confirmar Agendamento';
  static const String bookAppointmentAvailableTimes = 'Horários Disponíveis';
  static const String bookAppointmentNoAvailableTimes = 'Nenhum horário disponível para esta data';
  static const String bookAppointmentNotesOptional = 'Observações (opcional)';
  static const String bookAppointmentNotesHint = 'Ex: Consulta de rotina, retorno, etc.';

  // Client Home
  static const String clientHomeHello = 'Olá';
  static const String clientHomeYourAppointments = 'Suas Consultas';
  static const String clientHomeLoadingAppointments = 'Carregando consultas...';
  static const String clientHomeNewAppointment = 'Nova Consulta';
  static const String clientHomeMyAppointments = 'Minhas\nConsultas';
  static const String clientHomeSpecialties = 'Especialidades';
  static const String clientHomeUpcomingAppointments = 'Próximas Consultas';
  static const String clientHomeViewAll = 'Ver todas';
  static const String clientHomeNoAppointments = 'Nenhuma consulta agendada';
  static const String clientHomeBookFirstAppointment = 'Agende sua primeira consulta tocando no botão abaixo';
  static const String clientHomeBookAppointment = 'Agendar Consulta';

  // Doctor Profile
  static const String doctorProfileLoading = 'Carregando perfil...';
  static const String doctorProfileNotFound = 'Médico não encontrado';
  static const String doctorProfileTitle = 'Perfil do Médico';
  static const String doctorProfileBookAppointment = 'Agendar Consulta';
  static const String doctorProfileSpecialty = 'Especialidade';
  static const String doctorProfileEmail = 'Email';
  static const String doctorProfilePhone = 'Telefone';
  static const String doctorProfileAbout = 'Sobre o Médico';
  static const String doctorProfileRatings = 'Avaliações';
  static const String doctorProfileNAppointments = '{count} avaliações';

  // Doctors By Specialty
  static const String doctorsBySpecialtyTitle = 'Médicos';
  static const String doctorsBySpecialtyLoading = 'Carregando médicos...';
  static const String doctorsBySpecialtyNotFound = 'Nenhum médico encontrado';
  static const String doctorsBySpecialtyNoDoctorsForSpecialty = 'Não há médicos disponíveis para esta especialidade no momento';
  static const String doctorsBySpecialtyBackButton = 'Voltar';

  // Specialties
  static const String specialtiesTitle = 'Especialidades';
  static const String specialtiesLoading = 'Carregando especialidades...';

  // Doctor Home
  static const String doctorHomeHello = 'Olá, Dr(a).';
  static const String doctorHomeYourSchedule = 'Sua Agenda';
  static const String doctorHomeLoading = 'Carregando agenda...';
  static const String doctorHomeAppointmentsToday = 'Consultas de Hoje';
  static const String doctorHomeNoAppointmentsToday = 'Nenhuma consulta hoje';
  static const String doctorHomeNoAppointmentsTodayMessage = 'Você não tem consultas agendadas para hoje';
  static const String doctorHomeToday = 'Hoje';
  static const String doctorHomeConfirmed = 'Confirmadas';
}
