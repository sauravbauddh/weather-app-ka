import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import '../../../core/theme_controller.dart';

class WeatherShimmerLoading extends StatelessWidget {
  const WeatherShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height;
    final screenWidth = Get.width;
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
      final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;
      final containerColor = isDark ? Colors.grey[850]! : Colors.white;
      final accentColor = isDark ? Colors.blue[700]! : Colors.blue[300]!;

      return SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: screenHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.grey[900]!,
                          Colors.grey[850]!,
                          Colors.grey[800]!
                        ]
                      : [Colors.blue[50]!, Colors.grey[100]!, Colors.white],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  height: screenHeight * 0.3,
                  width: screenWidth,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [Colors.grey[850]!, Colors.grey[900]!]
                          : [Colors.white, Colors.grey[100]!],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: screenHeight * 0.05),
                          height: 24,
                          width: screenWidth * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: containerColor,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: screenHeight * 0.03),
                          height: 60,
                          width: screenWidth * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: containerColor,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: screenHeight * 0.02),
                          height: 20,
                          width: screenWidth * 0.35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: containerColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Shimmer.fromColors(
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            3,
                            (index) => Container(
                              width: screenWidth * 0.27,
                              height: 100,
                              decoration: BoxDecoration(
                                color: containerColor,
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    containerColor,
                                    containerColor.withOpacity(0.8),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: accentColor.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: containerColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    width: 50,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color: containerColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Shimmer.fromColors(
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: containerColor,
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                containerColor,
                                containerColor.withOpacity(0.8),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: CustomPaint(
                            painter: WavePatternPainter(
                              color: isDark
                                  ? Colors.grey[800]!
                                  : Colors.grey[200]!,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: List.generate(
                                  5,
                                  (index) => Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: containerColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Container(
                                        width: 40,
                                        height: 15,
                                        decoration: BoxDecoration(
                                          color: containerColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          color: containerColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Shimmer.fromColors(
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        child: Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: containerColor,
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                containerColor,
                                containerColor.withOpacity(0.8),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: CustomPaint(
                            painter: CirclePatternPainter(
                              color: isDark
                                  ? Colors.grey[800]!
                                  : Colors.grey[200]!,
                            ),
                            child: Center(
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: containerColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: accentColor.withOpacity(0.2),
                                      blurRadius: 15,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class WavePatternPainter extends CustomPainter {
  final Color color;

  WavePatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = Path();
    var startY = 0.0;
    while (startY < size.height) {
      path.moveTo(0, startY);
      for (var i = 0; i < size.width / 20; i++) {
        path.quadraticBezierTo(
          10 + (i * 40),
          startY - 10,
          20 + (i * 40),
          startY,
        );
        path.quadraticBezierTo(
          30 + (i * 40),
          startY + 10,
          40 + (i * 40),
          startY,
        );
      }
      startY += 20;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CirclePatternPainter extends CustomPainter {
  final Color color;

  CirclePatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (var i = 0; i < 5; i++) {
      final radius = (i + 1) * 20.0;
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
