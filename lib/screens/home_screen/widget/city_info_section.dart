import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/text_styling.dart';
import '../../../core/theme_controller.dart';

class CityInfo extends StatefulWidget {
  final String? name;
  final String? region;
  final String? country;
  final String? localTime;
  final bool isLoading;

  const CityInfo({
    super.key,
    required this.localTime,
    required this.name,
    required this.region,
    required this.country,
    required this.isLoading,
  });

  @override
  State<CityInfo> createState() => _CityInfoState();
}

class _CityInfoState extends State<CityInfo>
    with SingleTickerProviderStateMixin {
  final themeController = Get.find<ThemeController>();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
      final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    Colors.black87.withOpacity(0.8),
                    Colors.black54.withOpacity(0.6),
                  ]
                : [
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.7),
                  ],
          ),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.black12,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black38 : Colors.black12,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.isLoading) ...[
                        _buildShimmerEffect(baseColor, highlightColor),
                      ] else ...[
                        _buildLocationInfo(isDark),
                        const SizedBox(height: 12),
                        _buildTimeInfo(isDark),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            _buildThemeToggle(isDark),
          ],
        ),
      );
    });
  }

  Widget _buildShimmerEffect(Color baseColor, Color highlightColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            width: 220,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            width: 160,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo(bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.white12 : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.location_on_rounded,
            size: 22,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '${widget.name}, ${widget.region}, ${widget.country}',
            style: GFonts.russoOne(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInfo(bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isDark ? Colors.white12 : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.access_time_rounded,
            size: 18,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          DateFormat('dd-MM-yyyy, hh:mm a')
              .format(DateTime.parse(widget.localTime!))
              .toString(),
          style: GFonts.russoOne(
            fontSize: 16,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeToggle(bool isDark) {
    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [Colors.grey[850]!, Colors.grey[900]!]
              : [Colors.white, Colors.grey[100]!],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : Colors.black12,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeInOutBack,
        switchOutCurve: Curves.easeInOutBack,
        transitionBuilder: (child, animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: (1 - animation.value) * 2.5 * 3.14159,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            },
            child: child,
          );
        },
        child: IconButton(
          key: ValueKey(isDark),
          icon: Icon(
            isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
            size: 26,
          ),
          color: isDark ? Colors.amber : Colors.indigo,
          onPressed: () => themeController.toggleTheme(),
        ),
      ),
    );
  }
}
