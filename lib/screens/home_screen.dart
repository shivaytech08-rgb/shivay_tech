import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroCtrl;
  late AnimationController _rotateCtrl;
  late AnimationController _pulseCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;
  late Animation<double> _rotate;
  late Animation<double> _pulse;

  final List<String> _typewriterText = [
    'Mobile Apps',
    'Web Platforms',
    'IT Solutions',
    'Digital Growth',
  ];
  int _typeIndex = 0;
  String _displayed = '';
  bool _deleting = false;
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();

    _heroCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _heroCtrl, curve: const Interval(0, 0.6, curve: Curves.easeOut)),
    );

    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _heroCtrl, curve: const Interval(0, 0.7, curve: Curves.easeOutCubic)),
    );

    _rotate = Tween<double>(begin: 0, end: 2 * math.pi).animate(_rotateCtrl);

    _pulse = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _startTypewriter();
  }

  void _startTypewriter() async {
    while (mounted) {
      final target = _typewriterText[_typeIndex];
      if (!_deleting) {
        if (_charIndex < target.length) {
          setState(() {
            _charIndex++;
            _displayed = target.substring(0, _charIndex);
          });
          await Future.delayed(const Duration(milliseconds: 80));
        } else {
          await Future.delayed(const Duration(milliseconds: 1800));
          _deleting = true;
        }
      } else {
        if (_charIndex > 0) {
          setState(() {
            _charIndex--;
            _displayed = target.substring(0, _charIndex);
          });
          await Future.delayed(const Duration(milliseconds: 40));
        } else {
          _deleting = false;
          _typeIndex = (_typeIndex + 1) % _typewriterText.length;
        }
      }
    }
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    _rotateCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Hero Section
          SizedBox(
            height: size.height,
            child: Stack(
              children: [
                // Rotating ring decoration
                Positioned(
                  top: size.height * 0.1,
                  right: isMobile ? -100 : -60,
                  child: AnimatedBuilder(
                    animation: _rotate,
                    builder: (_, __) => Transform.rotate(
                      angle: _rotate.value,
                      child: CustomPaint(
                        size: const Size(500, 500),
                        painter: _RingPainter(),
                      ),
                    ),
                  ),
                ),

                // Hero content
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      isMobile ? 24 : 80, 120, isMobile ? 24 : 80, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge
                        FadeTransition(
                          opacity: _fadeIn,
                          child: _Badge('NEXT GEN IT SOLUTIONS'),
                        ),
                        const SizedBox(height: 30),

                        // Main Title
                        SlideTransition(
                          position: _slideIn,
                          child: FadeTransition(
                            opacity: _fadeIn,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SHIVAY',
                                  style: GoogleFonts.orbitron(
                                    fontSize: isMobile ? 52 : 88,
                                    fontWeight: FontWeight.w900,
                                    height: 0.9,
                                    foreground: Paint()
                                      ..shader = const LinearGradient(
                                        colors: [Colors.white, Color(0xFF00D4FF)],
                                      ).createShader(const Rect.fromLTWH(0, 0, 500, 100)),
                                  ),
                                ),
                                ShaderMask(
                                  shaderCallback: (b) => const LinearGradient(
                                    colors: [Color(0xFF7C3AED), Color(0xFF00D4FF)],
                                  ).createShader(b),
                                  child: Text(
                                    'TECH',
                                    style: GoogleFonts.orbitron(
                                      fontSize: isMobile ? 52 : 88,
                                      fontWeight: FontWeight.w900,
                                      height: 0.9,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '— DIGITAL INNOVATION —',
                                  style: GoogleFonts.orbitron(
                                    fontSize: isMobile ? 11 : 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF00D4FF).withOpacity(0.4),
                                    letterSpacing: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Typewriter
                        FadeTransition(
                          opacity: _fadeIn,
                          child: Row(
                            children: [
                              Text(
                                'We Build  ',
                                style: GoogleFonts.rajdhani(
                                  fontSize: isMobile ? 20 : 26,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF4A6080),
                                  letterSpacing: 1,
                                ),
                              ),
                              Text(
                                _displayed,
                                style: GoogleFonts.rajdhani(
                                  fontSize: isMobile ? 20 : 26,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF00D4FF),
                                  letterSpacing: 1,
                                ),
                              ),
                              _Cursor(),
                            ],
                          ),
                        ),

                        const SizedBox(height: 48),

                        // CTA Buttons
                        FadeTransition(
                          opacity: _fadeIn,
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 12,
                            children: [
                              _GlowButton(
                                label: 'OUR SERVICES',
                                isPrimary: true,
                                onTap: () {},
                              ),
                              _GlowButton(
                                label: 'CONTACT US',
                                isPrimary: false,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 60),

                        // Stats row
                        FadeTransition(
                          opacity: _fadeIn,
                          child: _StatsRow(isMobile: isMobile),
                        ),
                      ],
                    ),
                  ),
                ),

                // Scroll indicator
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: _fadeIn,
                    child: AnimatedBuilder(
                      animation: _pulse,
                      builder: (_, __) => Transform.scale(
                        scale: _pulse.value,
                        child: Column(
                          children: [
                            Text(
                              'SCROLL',
                              style: GoogleFonts.rajdhani(
                                fontSize: 10,
                                letterSpacing: 4,
                                color: const Color(0xFF4A6080),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF00D4FF),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Why Shivay Tech Section
          _WhySection(isMobile: isMobile),

          // ── Tech Stack Section
          _TechStack(isMobile: isMobile),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ─── Badge ──────────────────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final String text;
  const _Badge(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.3)),
        color: const Color(0xFF00D4FF).withOpacity(0.05),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6, height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF00D4FF),
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00D4FF).withOpacity(0.8),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.rajdhani(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 4,
              color: const Color(0xFF00D4FF),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Blinking cursor ────────────────────────────────────────────────────────
class _Cursor extends StatefulWidget {
  @override
  State<_Cursor> createState() => _CursorState();
}

class _CursorState extends State<_Cursor> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Opacity(
        opacity: _ctrl.value,
        child: Container(
          width: 2,
          height: 26,
          color: const Color(0xFF00D4FF),
        ),
      ),
    );
  }
}

// ─── Glow Button ────────────────────────────────────────────────────────────
class _GlowButton extends StatefulWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _GlowButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  State<_GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<_GlowButton>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1, end: 0.97).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          widget.onTap();
        },
        child: ScaleTransition(
          scale: _scale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              color: widget.isPrimary
                  ? (_hovered ? const Color(0xFF00D4FF) : Colors.transparent)
                  : Colors.transparent,
              border: Border.all(
                color: widget.isPrimary
                    ? const Color(0xFF00D4FF)
                    : const Color(0xFF7C3AED),
                width: 1,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: (widget.isPrimary
                                ? const Color(0xFF00D4FF)
                                : const Color(0xFF7C3AED))
                            .withOpacity(0.4),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Text(
              widget.label,
              style: GoogleFonts.orbitron(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: widget.isPrimary
                    ? (_hovered ? const Color(0xFF020408) : const Color(0xFF00D4FF))
                    : const Color(0xFF7C3AED),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Stats Row ──────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final bool isMobile;
  const _StatsRow({required this.isMobile});

  static const _stats = [
    {'num': '50+', 'label': 'Projects Done'},
    {'num': '30+', 'label': 'Happy Clients'},
    {'num': '3+', 'label': 'Years Experience'},
    {'num': '24/7', 'label': 'Support'},
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 32,
      runSpacing: 16,
      children: _stats.map((s) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s['num']!,
              style: GoogleFonts.orbitron(
                fontSize: isMobile ? 28 : 36,
                fontWeight: FontWeight.w900,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [Color(0xFF00D4FF), Color(0xFF7C3AED)],
                  ).createShader(const Rect.fromLTWH(0, 0, 100, 50)),
              ),
            ),
            Text(
              s['label']!,
              style: GoogleFonts.rajdhani(
                fontSize: 13,
                letterSpacing: 2,
                color: const Color(0xFF4A6080),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

// ─── Ring Painter ───────────────────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final rings = [
      {'r': 200.0, 'opacity': 0.08, 'dash': 20.0, 'gap': 10.0},
      {'r': 160.0, 'opacity': 0.12, 'dash': 8.0, 'gap': 6.0},
      {'r': 120.0, 'opacity': 0.06, 'dash': 40.0, 'gap': 20.0},
    ];

    for (final ring in rings) {
      final paint = Paint()
        ..color = const Color(0xFF00D4FF).withOpacity(ring['opacity'] as double)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      final r = ring['r'] as double;
      final dash = ring['dash'] as double;
      final gap = ring['gap'] as double;
      final circumference = 2 * math.pi * r;
      final totalDash = dash + gap;
      final dashCount = (circumference / totalDash).floor();

      for (int i = 0; i < dashCount; i++) {
        final startAngle = (i * totalDash / circumference) * 2 * math.pi;
        final sweepAngle = (dash / circumference) * 2 * math.pi;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: r),
          startAngle, sweepAngle, false, paint,
        );
      }
    }

    // Center dot
    canvas.drawCircle(
      center, 4,
      Paint()
        ..color = const Color(0xFF00D4FF).withOpacity(0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Why Section ────────────────────────────────────────────────────────────
class _WhySection extends StatelessWidget {
  final bool isMobile;
  const _WhySection({required this.isMobile});

  static const _features = [
    {
      'icon': Icons.phone_android_rounded,
      'title': 'App Development',
      'desc': 'Flutter & Native apps for iOS and Android with stunning UI/UX',
      'color': 0xFF00D4FF,
    },
    {
      'icon': Icons.language_rounded,
      'title': 'Web Development',
      'desc': 'Modern, responsive websites and web applications for your business',
      'color': 0xFF7C3AED,
    },
    {
      'icon': Icons.support_agent_rounded,
      'title': 'IT Support',
      'desc': '24/7 technical support and IT consulting for your organization',
      'color': 0xFFF59E0B,
    },
    {
      'icon': Icons.trending_up_rounded,
      'title': 'Digital Marketing',
      'desc': 'SEO, social media, and digital growth strategies that convert',
      'color': 0xFF10B981,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 80,
      ),
      child: Column(
        children: [
          _SectionHeader(
            badge: 'WHY CHOOSE US',
            title: 'Powering Your\nDigital Future',
          ),
          const SizedBox(height: 60),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: isMobile ? 3 : 2.2,
            children: _features.map((f) => _FeatureCard(
              icon: f['icon'] as IconData,
              title: f['title'] as String,
              desc: f['desc'] as String,
              color: Color(f['color'] as int),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _ctrl;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _glow = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        _ctrl.forward();
      },
      onExit: (_) {
        setState(() => _hovered = false);
        _ctrl.reverse();
      },
      child: AnimatedBuilder(
        animation: _glow,
        builder: (_, __) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.color.withOpacity(0.05)
                : const Color(0xFF0B1521),
            border: Border.all(
              color: _hovered
                  ? widget.color.withOpacity(0.4)
                  : const Color(0xFF00D4FF).withOpacity(0.1),
              width: 1,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: widget.color.withOpacity(0.15 * _glow.value),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.1),
                  border: Border.all(
                    color: widget.color.withOpacity(0.3),
                  ),
                ),
                child: Icon(widget.icon, color: widget.color, size: 26),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.orbitron(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.desc,
                      style: GoogleFonts.rajdhani(
                        fontSize: 14,
                        color: const Color(0xFF4A6080),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Tech Stack ─────────────────────────────────────────────────────────────
class _TechStack extends StatelessWidget {
  final bool isMobile;
  const _TechStack({required this.isMobile});

  static const _techs = [
    'Flutter', 'React', 'Node.js', 'Firebase',
    'Laravel', 'MySQL', 'AWS', 'Figma',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80),
      child: Column(
        children: [
          _SectionHeader(
            badge: 'TECH STACK',
            title: 'Technologies\nWe Master',
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: _techs.map((t) => _TechChip(label: t)).toList(),
          ),
        ],
      ),
    );
  }
}

class _TechChip extends StatefulWidget {
  final String label;
  const _TechChip({required this.label});

  @override
  State<_TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<_TechChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: _hovered
              ? const Color(0xFF00D4FF).withOpacity(0.1)
              : const Color(0xFF0B1521),
          border: Border.all(
            color: _hovered
                ? const Color(0xFF00D4FF).withOpacity(0.5)
                : const Color(0xFF00D4FF).withOpacity(0.1),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: const Color(0xFF00D4FF).withOpacity(0.2),
                    blurRadius: 16,
                  ),
                ]
              : [],
        ),
        child: Text(
          widget.label,
          style: GoogleFonts.rajdhani(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: _hovered ? const Color(0xFF00D4FF) : const Color(0xFF4A6080),
          ),
        ),
      ),
    );
  }
}

// ─── Section Header ─────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String badge;
  final String title;

  const _SectionHeader({required this.badge, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.3)),
            color: const Color(0xFF00D4FF).withOpacity(0.05),
          ),
          child: Text(
            badge,
            style: GoogleFonts.rajdhani(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 4,
              color: const Color(0xFF00D4FF),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [Colors.white, Color(0xFF4A6080)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(b),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.orbitron(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(width: 60, height: 2, color: const Color(0xFF00D4FF)),
      ],
    );
  }
}
