import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:agendafaciljp/firebase_options.dart';
import 'package:agendafaciljp/providers/auth_provider.dart';
import 'package:agendafaciljp/theme.dart';
import 'package:agendafaciljp/screens/splash_screen.dart';
import 'package:agendafaciljp/screens/auth/login_screen.dart';
import 'package:agendafaciljp/screens/auth/register_screen.dart';
import 'package:agendafaciljp/screens/client/client_home_screen.dart';
import 'package:agendafaciljp/screens/profile/user_profile_screen.dart';
import 'package:agendafaciljp/screens/client/specialties_screen.dart';
import 'package:agendafaciljp/screens/client/doctors_by_specialty_screen.dart';
import 'package:agendafaciljp/screens/profile/doctor_profile_screen.dart';
import 'package:agendafaciljp/screens/client/book_appointment_screen.dart';
import 'package:agendafaciljp/screens/client/appointment_history_screen.dart';
import 'package:agendafaciljp/screens/client/appointment_details_screen.dart';
import 'package:agendafaciljp/screens/doctor/doctor_home_screen.dart';
import 'package:agendafaciljp/screens/admin/admin_home_screen.dart';
import 'package:agendafaciljp/screens/admin/manage_doctors_screen.dart';
import 'package:agendafaciljp/screens/admin/manage_specialties_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Ativa o App Check para o modo de depuração
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp.router(
        title: 'Agenda Fácil JP',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // Client Routes
    GoRoute(
      path: '/client-home',
      builder: (context, state) => const ClientHomeScreen(),
    ),
    GoRoute(
      path: '/user-profile',
      builder: (context, state) => const UserProfileScreen(),
    ),
    GoRoute(
      path: '/specialties',
      builder: (context, state) => const SpecialtiesScreen(),
    ),
    GoRoute(
      path: '/doctors-by-specialty/:specialtyId',
      builder: (context, state) {
        final specialtyId = state.pathParameters['specialtyId']!;
        return DoctorsBySpecialtyScreen(specialtyId: specialtyId);
      },
    ),
    GoRoute(
      path: '/doctor-profile/:doctorId',
      builder: (context, state) {
        final doctorId = state.pathParameters['doctorId']!;
        return DoctorProfileScreen(doctorId: doctorId);
      },
    ),
    GoRoute(
      path: '/book-appointment/:doctorId',
      builder: (context, state) {
        final doctorId = state.pathParameters['doctorId']!;
        return BookAppointmentScreen(doctorId: doctorId);
      },
    ),
    GoRoute(
      path: '/appointment-history',
      builder: (context, state) => const AppointmentHistoryScreen(),
    ),
    GoRoute(
      path: '/appointment-details/:appointmentId',
      builder: (context, state) {
        final appointmentId = state.pathParameters['appointmentId']!;
        return AppointmentDetailsScreen(appointmentId: appointmentId);
      },
    ),

    // Doctor Routes
    GoRoute(
      path: '/doctor-home',
      builder: (context, state) => const DoctorHomeScreen(),
    ),

    // Admin Routes
    GoRoute(
      path: '/admin-home',
      builder: (context, state) => const AdminHomeScreen(),
    ),
    GoRoute(
      path: '/manage-doctors',
      builder: (context, state) => const ManageDoctorsScreen(),
    ),
    GoRoute(
      path: '/manage-specialties',
      builder: (context, state) => const ManageSpecialtiesScreen(),
    ),
  ],
);
