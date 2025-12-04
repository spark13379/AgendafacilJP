import 'package:flutter/material.dart';
import 'package:agendafaciljp/models/specialty.dart';
import 'package:agendafaciljp/theme.dart';

class SpecialtyCard extends StatelessWidget {
  final Specialty specialty;
  final VoidCallback? onTap;

  const SpecialtyCard({
    super.key,
    required this.specialty,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryBlue.withAlpha(26),
                      AppColors.lightBlue.withAlpha(13),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  _getIconData(),
                  size: 32,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                specialty.name,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData() {
    switch (specialty.iconName) {
      case 'favorite':
        return Icons.favorite;
      case 'child_care':
        return Icons.child_care;
      case 'face':
        return Icons.face;
      case 'accessibility':
        return Icons.accessibility;
      case 'pregnant_woman':
        return Icons.pregnant_woman;
      case 'visibility':
        return Icons.visibility;
      case 'psychology':
        return Icons.psychology;
      case 'brain':
        return Icons.psychology_alt;
      default:
        return Icons.local_hospital;
    }
  }
}
