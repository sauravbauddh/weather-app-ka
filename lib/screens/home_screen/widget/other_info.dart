import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/text_styling.dart';

class OtherInfo extends StatefulWidget {
  final String? windSpeed;
  final String? humidity;
  final String? cloudiness;
  final bool isLoading;

  const OtherInfo({
    super.key,
    required this.windSpeed,
    required this.humidity,
    required this.cloudiness,
    required this.isLoading,
  });

  @override
  State<OtherInfo> createState() => _OtherInfoState();
}

class _OtherInfoState extends State<OtherInfo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.withOpacity(0.15),
                Colors.blue.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem(
                icon: Icons.air_rounded,
                title: 'Wind',
                value: '${widget.windSpeed} km/h',
                color: Colors.blue.shade400,
              ),
              _buildDivider(),
              _buildInfoItem(
                icon: Icons.water_drop_rounded,
                title: 'Humidity',
                value: '${widget.humidity} %',
                color: Colors.indigo.shade400,
              ),
              _buildDivider(),
              _buildInfoItem(
                icon: Icons.cloud_rounded,
                title: 'Cloud',
                value: '${widget.cloudiness} %',
                color: Colors.blue.shade300,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width * 0.25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: color.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: widget.isLoading
                ? _buildShimmerIcon()
                : Icon(
                    icon,
                    color: color,
                    size: 32,
                  ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: gStyle(
              size: 16,
              weight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: gStyle(
                size: 14,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 65,
      width: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.withOpacity(0),
            Colors.blue.withOpacity(0.2),
            Colors.blue.withOpacity(0),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerIcon() {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
