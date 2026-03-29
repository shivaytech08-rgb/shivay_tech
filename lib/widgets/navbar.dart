import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigate;

  const NavBar({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
  });

  static const _navItems = [
    {'label': 'HOME', 'icon': Icons.home_rounded},
    {'label': 'SERVICES', 'icon': Icons.grid_view_rounded},
    {'label': 'CONTACT', 'icon': Icons.mail_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 60,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF020408).withOpacity(0.75),
          border: const Border(
            bottom: BorderSide(color: Color(0x2600D4FF), width: 1),
          ),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ColorFilter.mode(
              Colors.transparent,
              BlendMode.srcOver,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
                _Logo(),

                // Nav Items
                Row(
                  children: List.generate(_navItems.length, (i) {
                    final item = _navItems[i];
                    final isActive = currentIndex == i;
                    return _NavItem(
                      label: item['label'] as String,
                      icon: item['icon'] as IconData,
                      isActive: isActive,
                      isMobile: isMobile,
                      onTap: () => onNavigate(i),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatefulWidget {
  @override
  State<_Logo> createState() => _LogoState();
}

class _LogoState extends State<_Logo> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glow = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glow,
      builder: (_, __) => Row(
        children: [
          // Hexagon icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00D4FF), Color(0xFF7C3AED)],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00D4FF).withOpacity(0.4 * _glow.value),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'ST',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF00D4FF), Color(0xFF7C3AED)],
            ).createShader(bounds),
            child: Text(
              'SHIVAY',
              style: GoogleFonts.orbitron(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
          ),
          Text(
            ' TECH',
            style: GoogleFonts.orbitron(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: const Color(0xFFF59E0B),
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool isMobile;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.isMobile,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _ctrl;
  late Animation<double> _underline;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _underline = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    if (widget.isActive) _ctrl.forward();
  }

  @override
  void didUpdateWidget(_NavItem old) {
    super.didUpdateWidget(old);
    if (widget.isActive) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
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
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _underline,
          builder: (_, __) {
            final color = widget.isActive || _hovered
                ? const Color(0xFF00D4FF)
                : const Color(0xFF4A6080);
            return Container(
              margin: EdgeInsets.only(left: widget.isMobile ? 12 : 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.isMobile
                      ? Icon(widget.icon, color: color, size: 20)
                      : Text(
                          widget.label,
                          style: GoogleFonts.rajdhani(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3,
                            color: color,
                          ),
                        ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 1,
                    width: widget.isActive
                        ? (widget.isMobile ? 20 : 40)
                        : (_hovered ? (widget.isMobile ? 10 : 20) : 0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D4FF),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00D4FF).withOpacity(0.8),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
