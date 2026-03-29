import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/services_screen.dart';
import 'screens/contact_screen.dart';
import 'widgets/navbar.dart';

void main() {
  runApp(const ShivayTechApp());
}

class ShivayTechApp extends StatelessWidget {
  const ShivayTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shivay Tech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF020408),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00D4FF),
          secondary: Color(0xFF7C3AED),
          tertiary: Color(0xFFF59E0B),
          surface: Color(0xFF070D14),
        ),
        textTheme: GoogleFonts.rajdhaniTextTheme(
          ThemeData.dark().textTheme,
        ).copyWith(
          displayLarge: GoogleFonts.orbitron(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ServicesScreen(),
    const ContactScreen(),
  ];

  void _navigateTo(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020408),
      body: Stack(
        children: [
          // Animated background
          const AnimatedBackground(),

          // Page content with animated transitions
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            transitionBuilder: (child, animation) {
              final slideAnim = Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ));
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: slideAnim,
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey(_currentIndex),
              child: _pages[_currentIndex],
            ),
          ),

          // Top Navigation Bar
          NavBar(
            currentIndex: _currentIndex,
            onNavigate: _navigateTo,
          ),
        ],
      ),
    );
  }
}

// ─── Animated Particle Background ──────────────────────────────────────────
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late Animation<double> _orb1;
  late Animation<double> _orb2;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);

    _orb1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeInOut),
    );
    _orb2 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: Listenable.merge([_orb1, _orb2]),
      builder: (context, _) {
        return CustomPaint(
          size: Size(size.width, size.height),
          painter: BackgroundPainter(
            orb1Value: _orb1.value,
            orb2Value: _orb2.value,
          ),
        );
      },
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double orb1Value;
  final double orb2Value;

  BackgroundPainter({required this.orb1Value, required this.orb2Value});

  @override
  void paint(Canvas canvas, Size size) {
    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFF00D4FF).withOpacity(0.04)
      ..strokeWidth = 0.5;

    const gridSize = 60.0;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Orb 1 — Cyan
    final orb1X = size.width * 0.2 + (size.width * 0.1 * orb1Value);
    final orb1Y = size.height * 0.2 + (size.height * 0.05 * orb1Value);
    final orb1Paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF00D4FF).withOpacity(0.25),
          const Color(0xFF00D4FF).withOpacity(0),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(orb1X, orb1Y),
        radius: 350,
      ));
    canvas.drawCircle(Offset(orb1X, orb1Y), 350, orb1Paint);

    // Orb 2 — Purple
    final orb2X = size.width * 0.8 - (size.width * 0.1 * orb2Value);
    final orb2Y = size.height * 0.7 + (size.height * 0.05 * orb2Value);
    final orb2Paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF7C3AED).withOpacity(0.2),
          const Color(0xFF7C3AED).withOpacity(0),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(orb2X, orb2Y),
        radius: 400,
      ));
    canvas.drawCircle(Offset(orb2X, orb2Y), 400, orb2Paint);

    // Orb 3 — Amber (static)
    final orb3Paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFF59E0B).withOpacity(0.12),
          const Color(0xFFF59E0B).withOpacity(0),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.5, size.height * 0.85),
        radius: 250,
      ));
    canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.85), 250, orb3Paint);
  }

  @override
  bool shouldRepaint(BackgroundPainter old) =>
      old.orb1Value != orb1Value || old.orb2Value != orb2Value;
}
