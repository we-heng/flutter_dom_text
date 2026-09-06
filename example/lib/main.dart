import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:dom_text/dom_text.dart';

void main() {
  runApp(const DomTextExample());
}

class DomTextExample extends StatelessWidget {
  const DomTextExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF08111F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF77E6C5),
          brightness: Brightness.dark,
        ),
      ),
      home: const ShowcasePage(),
    );
  }
}

class ShowcasePage extends StatefulWidget {
  const ShowcasePage({super.key});

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  )..repeat();
  int _presses = 0;

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08111F),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: GardenPainter(_animation.value, _presses),
            child: child,
          );
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 700;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 24 : 72,
                  vertical: compact ? 28 : 56,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 920),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const DomText(
                              'DOM TEXT / CANVASKIT',
                              style: TextStyle(
                                color: Color(0xFF77E6C5),
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2,
                              ),
                              softWrap: false,
                              maxLines: 1,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(
                                    0xFF77E6C5,
                                  ).withValues(alpha: 0.45),
                                ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 8,
                                    color: Color(0xFF77E6C5),
                                  ),
                                  SizedBox(width: 8),
                                  DomText(
                                    'LIVE HTML LAYER',
                                    style: TextStyle(
                                      color: Color(0xFFD2DCE8),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                    ),
                                    softWrap: false,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 52),
                        DomText(
                          'Words above the canvas.',
                          htmlElement: 'h1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: compact ? 46 : 76,
                            fontWeight: FontWeight.w800,
                            height: 1.05,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                          softWrap: true,
                        ),
                        const SizedBox(height: 24),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 680),
                          child: const DomText(
                            'This paragraph is selectable HTML text rendered over a moving Flutter CustomPaint scene. Resize the window, copy a sentence, or use the buttons below.',
                            htmlElement: 'p',
                            style: TextStyle(
                              color: Color(0xFFD2DCE8),
                              fontSize: 18,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            ElevatedButton(
                              onPressed: () => setState(() => _presses++),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF77E6C5),
                                foregroundColor: const Color(0xFF08111F),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 16,
                                ),
                              ),
                              child: DomText(
                                'Pulse the canvas ($_presses)',
                                style: const TextStyle(
                                  color: Color(0xFF08111F),
                                  fontWeight: FontWeight.w800,
                                ),
                                cursorEvent: false,
                                softWrap: false,
                                maxLines: 1,
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () => setState(() => _presses = 0),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white54),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 16,
                                ),
                              ),
                              child: const DomText(
                                'Reset',
                                style: TextStyle(color: Colors.white),
                                cursorEvent: false,
                                softWrap: false,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 64),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: const [
                            _SignalTile(value: '01', label: 'REAL DOM TEXT'),
                            _SignalTile(value: '02', label: 'FLUTTER LAYOUT'),
                            _SignalTile(value: '03', label: 'COPY + SEARCH'),
                          ],
                        ),
                        const SizedBox(height: 56),
                        const DomText(
                          'The canvas keeps moving while the browser owns the words. That is the whole trick.',
                          style: TextStyle(
                            color: Color(0xFF9FB0C2),
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SignalTile extends StatelessWidget {
  final String value;
  final String label;

  const _SignalTile({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF102D3A).withValues(alpha: 0.72),
        border: Border.all(color: const Color(0xFF315263)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DomText(
            value,
            style: const TextStyle(
              color: Color(0xFF77E6C5),
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
            softWrap: false,
            maxLines: 1,
          ),
          const SizedBox(height: 6),
          DomText(
            label,
            style: const TextStyle(
              color: Color(0xFFB4C4D2),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
            softWrap: false,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

class GardenPainter extends CustomPainter {
  final double progress;
  final int pulse;

  GardenPainter(this.progress, this.pulse);

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF08111F), Color(0xFF102D3A), Color(0xFF08111F)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, background);

    final glow = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 42);
    for (var index = 0; index < 9; index++) {
      final angle = progress * 6.28 + index * 0.7;
      final center = Offset(
        size.width * (0.5 + 0.38 * math.cos(angle)),
        size.height * (0.52 + 0.32 * math.sin(angle * 1.3)),
      );
      glow.color = Color.lerp(
        const Color(0xFF3DE0B4),
        const Color(0xFF65A7FF),
        index / 9,
      )!.withValues(alpha: 0.22);
      canvas.drawCircle(center, 34 + index * 3, glow);
    }

    final particles = Paint()..style = PaintingStyle.fill;
    for (var index = 0; index < 22; index++) {
      final angle = progress * (index.isEven ? -1.2 : 0.8) + index * 1.7;
      final radius = 0.18 + (index % 5) * 0.075;
      final center = Offset(
        size.width * (0.5 + radius * math.cos(angle)),
        size.height * (0.5 + radius * math.sin(angle * 1.15)),
      );
      particles.color = const Color(
        0xFFB3F9E7,
      ).withValues(alpha: 0.12 + (index % 3) * 0.05);
      canvas.drawCircle(center, 1.5 + index % 3, particles);
    }

    final pulsePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (var index = 0; index < math.min(pulse, 5); index++) {
      final phase = (progress * 0.8 + index * 0.21) % 1;
      final center = Offset(
        size.width * (0.2 + (index % 3) * 0.3),
        size.height * (0.3 + (index % 2) * 0.32),
      );
      pulsePaint.color = const Color(
        0xFF77E6C5,
      ).withValues(alpha: (1 - phase) * 0.48);
      canvas.drawCircle(center, 20 + phase * 150, pulsePaint);
    }
  }

  @override
  bool shouldRepaint(GardenPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.pulse != pulse;
}
