import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bgDark = const Color.fromARGB(255, 0, 20, 49);
    final neonGreen = const Color(0xFF39FF14);

    return Scaffold(
      backgroundColor: bgDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'lib/assets/HTB-svg.svg',
              width: 180,
              height: 180,
              color: neonGreen,
            ),
            const SizedBox(height: 24),
            Text(
              'QR Chat App',
              style: TextStyle(
                color: neonGreen,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                // shadows: [Shadow(color: neonGreen, blurRadius: 10)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
