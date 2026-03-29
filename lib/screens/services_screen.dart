import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<Animation<double>> _cardAnims;

  static const _services = [
    {
      'icon': Icons.phone_android_rounded,
      'title': 'Mobile App Development',
      'subtitle': 'Flutter • iOS • Android',
      'desc':
          'We craft pixel-perfect mobile apps using Flutter for both iOS and Android. From startup MVPs to enterprise-grade solutions, we deliver apps that users love.',
      'features': ['Cross-platform Flutter', 'Native Performance', 'Beautiful UI/UX', 'App Store Deployment'],
      'color': 0xFF00D4FF,
      'price': 'Starting ₹15,000',
    },
    {
      'icon': Icons.language_rounded,
      'title': 'Web Development',
      'subtitle': 'React • Laravel • Full Stack',
      'desc':
          'Modern, responsive, and blazing-fast websites. From landing pages to complex web platforms, we build it all with clean code and stunning design.',
      'features': ['Responsive Design', 'SEO Optimized', 'CMS Integration', 'Fast Loading'],
      'color': 0xFF7C3AED,
      'price': 'Starting ₹10,000',
    },
    {
      'icon': Icons.design_services_rounded,
      'title': 'UI/UX Design',
      'subtitle': 'Figma • Adobe XD • Prototyping',
      'desc':
          'Design that converts. We create intuitive, beautiful interfaces that keep users engaged and drive business results.',
      'features': ['Wireframing', 'Prototyping', 'User Research', 'Design Systems'],
      'color': 0xFFF59E0B,
      'price': 'Starting ₹8,000',
    },
    {
      'icon': Icons.cloud_rounded,
      'title': 'Cloud & Hosting',
      'subtitle': 'AWS • Firebase • VPS',
      'desc':
          'Deploy, scale, and manage your applications on the cloud. We handle infrastructure so you can focus on your business.',
      'features': ['Cloud Setup', 'Auto Scaling', 'SSL & Security', '99.9% Uptime'],
      'color': 0xFF10B981,
      'price': 'Starting ₹3,000/mo',
    },
    {
      'icon': Icons.support_agent_rounded,
      'title': 'IT Support & Consulting',
      'subtitle': '24/7 • Remote • On-Site',
      'desc':
          'Full-spectrum IT support for your business. From troubleshooting to strategic technology planning, we have you covered.',
      'features': ['24/7 Support', 'Remote Assistance', 'IT Strategy', 'Software Training'],
      'color': 0xFFEC4899,
      'price': 'Starting ₹2,000/mo',
    },
    {
      'icon': Icons.trending_up_rounded,
      'title': 'Digital Marketing',
      'subtitle': 'SEO • Social Media • Ads',
      'desc':
          'Grow your digital presence with data-driven marketing strategies. More traffic, more leads, more revenue.',
      'features': ['SEO Optimization', 'Social Media', 'Google Ads', 'Analytics'],
      'color': 0xFFFF6B35,
      'price': 'Starting ₹5,000/mo',
    },
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _cardAnims = List.generate(_services.length, (i) {
      final start = (i * 0.1).clamp(0.0, 0.8);
      final end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _ctrl,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          isMobile ? 24 : 80,
          120,
          isMobile ? 24 : 80,
          80,
        ),
        child: Column(
          children: [
            // Header
            FadeTransition(
              opacity: _cardAnims[0],
              child: const _SectionHeader(
                badge: 'WHAT WE DO',
                title: 'Our Services',
              ),
            ),

            const SizedBox(height: 20),

            FadeTransition(
              opacity: _cardAnims[0],
              child: Text(
                'From idea to launch — we handle every step of your digital journey',
                textAlign: TextAlign.center,
                style: GoogleFonts.rajdhani(
                  fontSize: 16,
                  color: const Color(0xFF4A6080),
                  letterSpacing: 1,
                ),
              ),
            ),

            const SizedBox(height: 64),

            // Service Cards Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isMobile ? 1 : 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isMobile ? 1.4 : 1.2,
              children: List.generate(_services.length, (i) {
                final s = _services[i];
                return AnimatedBuilder(
                  animation: _cardAnims[i],
                  builder: (_, __) => Opacity(
                    opacity: _cardAnims[i].value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - _cardAnims[i].value)),
                      child: _ServiceCard(
                        icon: s['icon'] as IconData,
                        title: s['title'] as String,
                        subtitle: s['subtitle'] as String,
                        desc: s['desc'] as String,
                        features: s['features'] as List<String>,
                        color: Color(s['color'] as int),
                        price: s['price'] as String,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 80),

            // Process Section
            FadeTransition(
              opacity: _cardAnims.last,
              child: _ProcessSection(isMobile: isMobile),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String desc;
  final List<String> features;
  final Color color;
  final String price;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.desc,
    required this.features,
    required this.color,
    required this.price,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard>
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
    _glow = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
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
                ? widget.color.withOpacity(0.06)
                : const Color(0xFF0B1521),
            border: Border.all(
              color: _hovered
                  ? widget.color.withOpacity(0.5)
                  : widget.color.withOpacity(0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.12 * _glow.value),
                blurRadius: 40,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.12),
                      border: Border.all(color: widget.color.withOpacity(0.3)),
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.orbitron(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle,
                          style: GoogleFonts.rajdhani(
                            fontSize: 12,
                            letterSpacing: 1,
                            color: widget.color.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Container(height: 1, color: widget.color.withOpacity(0.1)),
              const SizedBox(height: 16),

              Expanded(
                child: Text(
                  widget.desc,
                  style: GoogleFonts.rajdhani(
                    fontSize: 14,
                    color: const Color(0xFF4A6080),
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: widget.features.map((f) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.08),
                    border: Border.all(color: widget.color.withOpacity(0.2)),
                  ),
                  child: Text(
                    f,
                    style: GoogleFonts.rajdhani(
                      fontSize: 11,
                      letterSpacing: 1,
                      color: widget.color.withOpacity(0.8),
                    ),
                  ),
                )).toList(),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.price,
                    style: GoogleFonts.orbitron(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: widget.color,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: widget.color.withOpacity(0.6),
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProcessSection extends StatelessWidget {
  final bool isMobile;
  const _ProcessSection({required this.isMobile});

  static const _steps = [
    {'num': '01', 'title': 'Discover', 'desc': 'We understand your needs and goals'},
    {'num': '02', 'title': 'Design', 'desc': 'Wireframes & prototypes for review'},
    {'num': '03', 'title': 'Develop', 'desc': 'Agile development with daily updates'},
    {'num': '04', 'title': 'Deploy', 'desc': 'Launch & support post-delivery'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SectionHeader(
          badge: 'OUR PROCESS',
          title: 'How We Work',
        ),
        const SizedBox(height: 48),
        isMobile
            ? Column(
                children: _steps.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _StepCard(
                    num: s['num']!,
                    title: s['title']!,
                    desc: s['desc']!,
                  ),
                )).toList(),
              )
            : Row(
                children: _steps.asMap().entries.map((e) {
                  final i = e.key;
                  final s = e.value;
                  return Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _StepCard(
                            num: s['num']!,
                            title: s['title']!,
                            desc: s['desc']!,
                          ),
                        ),
                        if (i < _steps.length - 1)
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xFF00D4FF),
                            size: 20,
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  final String num;
  final String title;
  final String desc;

  const _StepCard({
    required this.num,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1521),
        border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            num,
            style: GoogleFonts.orbitron(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [Color(0xFF00D4FF), Color(0xFF7C3AED)],
                ).createShader(const Rect.fromLTWH(0, 0, 80, 40)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.orbitron(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: GoogleFonts.rajdhani(
              fontSize: 13,
              color: const Color(0xFF4A6080),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

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
