import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final String nextRoute;
  final Duration duration;

  const SplashScreen({super.key, this.nextRoute = '/', required this.duration});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _backgroundController;
  late final AnimationController _loadingController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;

  late final Animation<Offset> _textSlide;
  late final Animation<double> _textFade;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _logoScale = Tween(begin: .65, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoFade = CurvedAnimation(parent: _logoController, curve: Curves.easeIn);

    _textSlide = Tween<Offset>(begin: const Offset(0, .35), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    _textFade = CurvedAnimation(parent: _textController, curve: Curves.easeIn);

    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 550), () {
      if (mounted) {
        _textController.forward();
      }
    });

    Timer(const Duration(seconds: 4), () {
      if (!mounted) return;

      Navigator.pushReplacementNamed(context, widget.nextRoute);
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool dark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return Stack(
            children: [

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(
                      -1 + (_backgroundController.value * .25),
                      -1,
                    ),
                    end: Alignment(1, 1 - (_backgroundController.value * .25)),
                    colors: dark
                        ? const [
                            Color(0xff06131F),
                            Color(0xff0A2239),
                            Color(0xff102D52),
                          ]
                        : const [
                            Color(0xffF8FAFF),
                            Color(0xffEAF3FF),
                            Color(0xffDDEBFF),
                          ],
                  ),
                ),
              ),

              //-----------------------------------
              // Floating Circles
              //-----------------------------------
              ...List.generate(
                10,
                (index) => _FloatingBubble(
                  animation: _backgroundController,
                  index: index,
                ),
              ),

              //-----------------------------------
              // Center Content
              //-----------------------------------
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FadeTransition(
                          opacity: _logoFade,
                          child: ScaleTransition(
                            scale: _logoScale,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 20,
                                  sigmaY: 20,
                                ),
                                child: Container(
                                  height: 400,
                                  width: 400,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(
                                      dark ? .08 : .55,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(.18),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(.20),
                                        blurRadius: 35,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Image.asset(
                                      "assets/images/booksapp.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 42),

                        FadeTransition(
                          opacity: _textFade,
                          child: SlideTransition(
                            position: _textSlide,
                            child: Column(
                              children: [
                                Text(
                                  "Job Listing",
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -.8,
                                      ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  "Discover opportunities.\nBuild your future.",
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    height: 1.45,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(.70),
                                  ),
                                ),

                                const SizedBox(height: 45),


                                AnimatedBuilder(
                                  animation: _loadingController,
                                  builder: (context, child) {
                                    return Container(
                                      width: 230,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey.withOpacity(.15),
                                      ),
                                      child: Stack(
                                        children: [
                                          FractionallySizedBox(
                                            widthFactor:
                                                .28 +
                                                (.72 *
                                                    _loadingController.value),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xff2563EB),
                                                    Color(0xff3B82F6),
                                                    Color(0xff60A5FA),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 26),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    3,
                                    (index) => AnimatedBuilder(
                                      animation: _loadingController,
                                      builder: (context, child) {
                                        final value = sin(
                                          (_loadingController.value * 2 * pi) -
                                              index * .65,
                                        );

                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          width: 10 + value * 2,
                                          height: 10 + value * 2,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xff2563EB),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 34),

                                Text(
                                  "Powered by BooksApp",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(.55),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                const SizedBox(height: 14),

                                Text(
                                  "Version 1.0",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(.40),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          );
        },
      ),
    );
  }
}

class _FloatingBubble extends StatelessWidget {
  final Animation<double> animation;
  final int index;

  const _FloatingBubble({required this.animation, required this.index});

  @override
  Widget build(BuildContext context) {
    final random = Random(index * 71);

    final size = 40.0 + random.nextInt(80);

    final left = random.nextDouble() * MediaQuery.of(context).size.width;

    final top = random.nextDouble() * MediaQuery.of(context).size.height;

    final offset = sin((animation.value * 2 * pi) + index) * 25;

    return Positioned(
      left: left,
      top: top + offset,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.blue.withOpacity(.12),
                Colors.blue.withOpacity(.02),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
