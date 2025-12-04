import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:agendafaciljp/providers/auth_provider.dart';
import 'package:agendafaciljp/theme.dart';
import 'package:agendafaciljp/utils/constants.dart';
import 'package:agendafaciljp/utils/validators.dart';
import 'package:agendafaciljp/widgets/commom/custom_button.dart';
import 'package:agendafaciljp/widgets/commom/custom_field_text.dart';
import 'package:agendafaciljp/models/user.dart';
import 'package:agendafaciljp/utils/strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String _selectedRole = 'client';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      final user = authProvider.currentUser!;

      if (user.role.name != _selectedRole) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Este usuário não é um ${_getRoleLabel(_selectedRole)}'),
            backgroundColor: AppColors.statusCancelled,
          ),
        );
        await authProvider.logout();
        setState(() => _isLoading = false);
        return;
      }

      switch (user.role) {
        case UserRole.client:
          context.go('/client-home');
          break;
        case UserRole.doctor:
          context.go('/doctor-home');
          break;
        case UserRole.admin:
          context.go('/admin-home');
          break;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.incorrectEmailOrPassword),
          backgroundColor: AppColors.statusCancelled,
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case 'client':
        return AppStrings.loginPatient;
      case 'doctor':
        return AppStrings.loginHealthProfessional;
      case 'admin':
        return AppStrings.loginAdmin;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                _buildLogo(),
                const SizedBox(height: 40),
                Text(
                  AppStrings.loginWelcome,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _buildRoleSelector(),
                const SizedBox(height: 24),
                CustomTextField(
                  label: AppStrings.loginEmailOrCpfLabel,
                  hint: AppStrings.loginEmailHint,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: AppStrings.loginPasswordLabel,
                  hint: AppStrings.loginPasswordHint,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: Validators.validatePassword,
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(AppStrings.loginForgotPassword),
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: AppStrings.loginButton,
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.loginNoAccount,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => context.push('/register'),
                      child: const Text(AppStrings.loginCreateAccount),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTestCredentials(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/logo.png',
      width: 180,
      errorBuilder: (context, error, stackTrace) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.lightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(
              Icons.medical_services,
              size: 48,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.greyBorder.withAlpha(77),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.greyBorder),
      ),
      child: Row(
        children: [
          _buildRoleTab('client', AppStrings.loginPatient),
          _buildRoleTab('doctor', AppStrings.loginHealthProfessional),
        ],
      ),
    );
  }

  Widget _buildRoleTab(String role, String label) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTestCredentials() {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: AppColors.primaryBlue),
              SizedBox(width: 8),
              Text(
                AppStrings.loginTestUsers,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.loginTestUsersCredentials,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
