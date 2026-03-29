import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _serviceCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  String _selectedService = 'Mobile App Development';
  bool _sending = false;
  bool _sent = false;

  static const _services = [
    'Mobile App Development',
    'Web Development',
    'UI/UX Design',
    'Cloud & Hosting',
    'IT Support',
    'Digital Marketing',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _serviceCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendMail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sending = true);

    // Compose mailto URL — opens email client with pre-filled data
    final subject = Uri.encodeComponent(
        'New Inquiry from ${_nameCtrl.text} — ${_selectedService}');
    final body = Uri.encodeComponent('''
Hi Shivay Tech Team,

You have a new inquiry from your website!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Name    : ${_nameCtrl.text}
  Email   : ${_emailCtrl.text}
  Phone   : ${_phoneCtrl.text}
  Service : ${_selectedService}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Message:
${_messageCtrl.text}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Sent from ShivayTech Website
''');

    final mailtoUrl = Uri.parse(
        'mailto:shivaytech08@gmail.com?subject=$subject&body=$body');

    await Future.delayed(const Duration(milliseconds: 800));

    if (await canLaunchUrl(mailtoUrl)) {
      await launchUrl(mailtoUrl);
      setState(() {
        _sending = false;
        _sent = true;
      });
      // Reset after 4s
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            _sent = false;
            _nameCtrl.clear();
            _emailCtrl.clear();
            _phoneCtrl.clear();
            _messageCtrl.clear();
            _selectedService = _services[0];
          });
        }
      });
    } else {
      setState(() => _sending = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not open mail client. Please email us at shivaytech08@gmail.com',
              style: GoogleFonts.rajdhani(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF7C3AED),
          ),
        );
      }
    }
  }

  Future<void> _launchPhone() async {
    final uri = Uri.parse('tel:+919909379472');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchEmail() async {
    final uri = Uri.parse('mailto:shivaytech08@gmail.com');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchWhatsApp() async {
    final uri = Uri.parse('https://wa.me/919909379472');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          isMobile ? 24 : 80, 120, isMobile ? 24 : 80, 80),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              // Header
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.3)),
                      color: const Color(0xFF00D4FF).withOpacity(0.05),
                    ),
                    child: Text(
                      'GET IN TOUCH',
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
                      "Let's Build\nSomething Great",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.orbitron(
                        fontSize: isMobile ? 28 : 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(width: 60, height: 2, color: const Color(0xFF00D4FF)),
                  const SizedBox(height: 16),
                  Text(
                    'Have an idea? We would love to hear about it.',
                    style: GoogleFonts.rajdhani(
                      fontSize: 16,
                      color: const Color(0xFF4A6080),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 64),

              // Main content — Contact info + Form
              isMobile
                  ? Column(
                      children: [
                        _ContactInfo(
                          onPhone: _launchPhone,
                          onEmail: _launchEmail,
                          onWhatsApp: _launchWhatsApp,
                        ),
                        const SizedBox(height: 40),
                        _InquiryForm(
                          formKey: _formKey,
                          nameCtrl: _nameCtrl,
                          emailCtrl: _emailCtrl,
                          phoneCtrl: _phoneCtrl,
                          messageCtrl: _messageCtrl,
                          services: _services,
                          selectedService: _selectedService,
                          onServiceChanged: (v) =>
                              setState(() => _selectedService = v ?? _services[0]),
                          onSend: _sendMail,
                          sending: _sending,
                          sent: _sent,
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 340,
                          child: _ContactInfo(
                            onPhone: _launchPhone,
                            onEmail: _launchEmail,
                            onWhatsApp: _launchWhatsApp,
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          child: _InquiryForm(
                            formKey: _formKey,
                            nameCtrl: _nameCtrl,
                            emailCtrl: _emailCtrl,
                            phoneCtrl: _phoneCtrl,
                            messageCtrl: _messageCtrl,
                            services: _services,
                            selectedService: _selectedService,
                            onServiceChanged: (v) =>
                                setState(() => _selectedService = v ?? _services[0]),
                            onSend: _sendMail,
                            sending: _sending,
                            sent: _sent,
                          ),
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

// ─── Contact Info Panel ─────────────────────────────────────────────────────
class _ContactInfo extends StatelessWidget {
  final VoidCallback onPhone;
  final VoidCallback onEmail;
  final VoidCallback onWhatsApp;

  const _ContactInfo({
    required this.onPhone,
    required this.onEmail,
    required this.onWhatsApp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company Info Card
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1521),
            border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00D4FF).withOpacity(0.06),
                blurRadius: 40,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo mark
              Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00D4FF), Color(0xFF7C3AED)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'ST',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SHIVAY TECH',
                        style: GoogleFonts.orbitron(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [Color(0xFF00D4FF), Color(0xFF7C3AED)],
                            ).createShader(const Rect.fromLTWH(0, 0, 150, 20)),
                        ),
                      ),
                      Text(
                        'IT Solutions & Development',
                        style: GoogleFonts.rajdhani(
                          fontSize: 12,
                          color: const Color(0xFF4A6080),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 28),
              Container(height: 1, color: const Color(0xFF00D4FF).withOpacity(0.1)),
              const SizedBox(height: 28),

              // Contact items
              _ContactItem(
                icon: Icons.phone_rounded,
                label: 'Phone / WhatsApp',
                value: '+91 9909379472',
                color: const Color(0xFF10B981),
                onTap: onPhone,
              ),
              const SizedBox(height: 20),
              _ContactItem(
                icon: Icons.email_rounded,
                label: 'Email',
                value: 'shivaytech08@gmail.com',
                color: const Color(0xFF00D4FF),
                onTap: onEmail,
              ),
              const SizedBox(height: 28),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: _ActionBtn(
                      icon: Icons.phone_rounded,
                      label: 'CALL',
                      color: const Color(0xFF10B981),
                      onTap: onPhone,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionBtn(
                      icon: Icons.chat_rounded,
                      label: 'WHATSAPP',
                      color: const Color(0xFF25D366),
                      onTap: onWhatsApp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Office hours card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1521),
            border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.schedule_rounded, color: Color(0xFF7C3AED), size: 18),
                  const SizedBox(width: 10),
                  Text(
                    'OFFICE HOURS',
                    style: GoogleFonts.rajdhani(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                      color: const Color(0xFF7C3AED),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _HoursRow('Mon – Sat', '9:00 AM – 8:00 PM'),
              const SizedBox(height: 8),
              _HoursRow('Sunday', 'On Call / Emergency'),
            ],
          ),
        ),
      ],
    );
  }
}

class _HoursRow extends StatelessWidget {
  final String day;
  final String time;
  const _HoursRow(this.day, this.time);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(day, style: GoogleFonts.rajdhani(
          fontSize: 13, color: const Color(0xFF4A6080), letterSpacing: 0.5)),
        Text(time, style: GoogleFonts.rajdhani(
          fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ContactItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<_ContactItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: widget.color.withOpacity(_hovered ? 0.15 : 0.08),
                border: Border.all(
                  color: widget.color.withOpacity(_hovered ? 0.5 : 0.2)),
              ),
              child: Icon(widget.icon, color: widget.color, size: 20),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: GoogleFonts.rajdhani(
                    fontSize: 11,
                    letterSpacing: 2,
                    color: const Color(0xFF4A6080),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.value,
                  style: GoogleFonts.rajdhani(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _hovered ? widget.color : Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: _hovered ? widget.color.withOpacity(0.15) : Colors.transparent,
            border: Border.all(
              color: _hovered ? widget.color : widget.color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: widget.color, size: 16),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.rajdhani(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: widget.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Inquiry Form ───────────────────────────────────────────────────────────
class _InquiryForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController messageCtrl;
  final List<String> services;
  final String selectedService;
  final ValueChanged<String?> onServiceChanged;
  final VoidCallback onSend;
  final bool sending;
  final bool sent;

  const _InquiryForm({
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.messageCtrl,
    required this.services,
    required this.selectedService,
    required this.onServiceChanged,
    required this.onSend,
    required this.sending,
    required this.sent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1521),
        border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D4FF).withOpacity(0.05),
            blurRadius: 40,
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form header
            Row(
              children: [
                Container(
                  width: 4, height: 24,
                  color: const Color(0xFF00D4FF),
                ),
                const SizedBox(width: 12),
                Text(
                  'SEND AN INQUIRY',
                  style: GoogleFonts.orbitron(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Fill in the form and we will get back to you within 24 hours',
              style: GoogleFonts.rajdhani(
                fontSize: 13,
                color: const Color(0xFF4A6080),
              ),
            ),

            const SizedBox(height: 32),

            // Name & Email row
            _FormRow(children: [
              _FormField(
                ctrl: nameCtrl,
                label: 'Your Name',
                hint: 'Rahul Sharma',
                icon: Icons.person_rounded,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Name is required' : null,
              ),
              _FormField(
                ctrl: emailCtrl,
                label: 'Email Address',
                hint: 'you@example.com',
                icon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email is required';
                  if (!v.contains('@')) return 'Enter valid email';
                  return null;
                },
              ),
            ]),

            const SizedBox(height: 20),

            // Phone & Service row
            _FormRow(children: [
              _FormField(
                ctrl: phoneCtrl,
                label: 'Phone Number',
                hint: '+91 9999999999',
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Phone is required' : null,
              ),
              _DropdownField(
                label: 'Service Required',
                value: selectedService,
                items: services,
                onChanged: onServiceChanged,
              ),
            ]),

            const SizedBox(height: 20),

            // Message
            _FormField(
              ctrl: messageCtrl,
              label: 'Your Message',
              hint: 'Tell us about your project, goals, timeline...',
              icon: Icons.chat_bubble_rounded,
              maxLines: 5,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Message is required' : null,
            ),

            const SizedBox(height: 32),

            // Submit button
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: sent
                  ? _SuccessMessage(key: const ValueKey('success'))
                  : _SubmitButton(
                      key: const ValueKey('btn'),
                      sending: sending,
                      onTap: onSend,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormRow extends StatelessWidget {
  final List<Widget> children;
  const _FormRow({required this.children});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return isMobile
        ? Column(
            children: children
                .expand((w) => [w, const SizedBox(height: 20)])
                .toList()
              ..removeLast(),
          )
        : Row(
            children: children
                .expand((w) => [Expanded(child: w), const SizedBox(width: 16)])
                .toList()
              ..removeLast(),
          );
  }
}

class _FormField extends StatefulWidget {
  final TextEditingController ctrl;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _FormField({
    required this.ctrl,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  State<_FormField> createState() => _FormFieldState();
}

class _FormFieldState extends State<_FormField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: GoogleFonts.rajdhani(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
            color: const Color(0xFF4A6080),
          ),
        ),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (f) => setState(() => _focused = f),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              border: Border.all(
                color: _focused
                    ? const Color(0xFF00D4FF).withOpacity(0.6)
                    : const Color(0xFF00D4FF).withOpacity(0.1),
                width: 1,
              ),
              color: _focused
                  ? const Color(0xFF00D4FF).withOpacity(0.03)
                  : Colors.transparent,
              boxShadow: _focused
                  ? [
                      BoxShadow(
                        color: const Color(0xFF00D4FF).withOpacity(0.1),
                        blurRadius: 16,
                      ),
                    ]
                  : [],
            ),
            child: TextFormField(
              controller: widget.ctrl,
              maxLines: widget.maxLines,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              style: GoogleFonts.rajdhani(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: GoogleFonts.rajdhani(
                  fontSize: 14,
                  color: const Color(0xFF4A6080),
                ),
                prefixIcon: widget.maxLines == 1
                    ? Icon(
                        widget.icon,
                        color: _focused
                            ? const Color(0xFF00D4FF)
                            : const Color(0xFF4A6080),
                        size: 18,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: widget.maxLines == 1 ? 0 : 16,
                  vertical: 14,
                ),
                errorStyle: GoogleFonts.rajdhani(
                  fontSize: 11,
                  color: const Color(0xFFF59E0B),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.rajdhani(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
            color: const Color(0xFF4A6080),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF0B1521),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF4A6080),
                size: 20,
              ),
              style: GoogleFonts.rajdhani(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              items: items
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatefulWidget {
  final bool sending;
  final VoidCallback onTap;

  const _SubmitButton({super.key, required this.sending, required this.onTap});

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
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
        onTap: widget.sending ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 54,
          decoration: BoxDecoration(
            gradient: _hovered || widget.sending
                ? const LinearGradient(
                    colors: [Color(0xFF00D4FF), Color(0xFF7C3AED)],
                  )
                : null,
            border: Border.all(
              color: _hovered
                  ? Colors.transparent
                  : const Color(0xFF00D4FF).withOpacity(0.5),
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: const Color(0xFF00D4FF).withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: widget.sending
                ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      const SizedBox(width: 12),
                      Text(
                        'SEND INQUIRY',
                        style: GoogleFonts.orbitron(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: _hovered ? Colors.white : const Color(0xFF00D4FF),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _SuccessMessage extends StatelessWidget {
  const _SuccessMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withOpacity(0.1),
        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.2),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_rounded,
              color: Color(0xFF10B981), size: 20),
          const SizedBox(width: 12),
          Text(
            'INQUIRY SENT SUCCESSFULLY!',
            style: GoogleFonts.orbitron(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }
}
