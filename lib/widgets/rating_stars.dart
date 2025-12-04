import 'package:flutter/material.dart';
import 'package:agendafaciljp/theme.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double size;
  final bool interactive;
  final Function(int)? onRatingChanged;

  const RatingStars({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.size = 24,
    this.interactive = false,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        final starValue = index + 1;
        final isFullStar = rating >= starValue;
        final isHalfStar = rating >= starValue - 0.5 && rating < starValue;

        return GestureDetector(
          onTap: interactive && onRatingChanged != null
              ? () => onRatingChanged!(starValue)
              : null,
          child: Icon(
            isFullStar
                ? Icons.star
                : isHalfStar
                ? Icons.star_half
                : Icons.star_border,
            size: size,
            color: AppColors.statusPending,
          ),
        );
      }),
    );
  }
}

class RatingSelector extends StatefulWidget {
  final Function(int) onRatingSelected;
  final int initialRating;

  const RatingSelector({
    super.key,
    required this.onRatingSelected,
    this.initialRating = 0,
  });

  @override
  State<RatingSelector> createState() => _RatingSelectorState();
}

class _RatingSelectorState extends State<RatingSelector> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() => _currentRating = starValue);
            widget.onRatingSelected(starValue);
          },
          child: Icon(
            starValue <= _currentRating ? Icons.star : Icons.star_border,
            size: 40,
            color: AppColors.statusPending,
          ),
        );
      }),
    );
  }
}
