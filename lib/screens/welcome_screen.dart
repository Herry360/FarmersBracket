import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _bgController;
  late Animation<Color?> _bgAnimation;
  late final AnimationController _logoController;
  late final Animation<double> _logoAnimation;
  int _currentPage = 0;
  bool _isLoading = false;

  final List<Map<String, String>> _onboardingPages = [
    {
      'title': 'Discover Fresh Products',
      'desc': 'Browse a wide variety of farm-fresh goods and local specialties.'
    },
    {
      'title': 'Shop with Ease',
      'desc': 'Add your favorite products to cart and enjoy a seamless checkout experience.'
    },
    {
      'title': 'Customer Support & Reviews',
      'desc': 'Read reviews, rate products, and get help whenever you need it.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );
    _logoController.forward();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _bgAnimation = ColorTween(
      begin: const Color(0xFF81C784),
      end: const Color(0xFF388E3C),
    ).animate(CurvedAnimation(parent: _bgController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _logoController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  void _navigateToNext(BuildContext context) async {
  setState(() => _isLoading = true);
  await Future.delayed(const Duration(milliseconds: 600));
  if (!mounted) return;
  Navigator.pushReplacementNamed(context, '/profile-registration');
  setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width > 600;
    
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _bgAnimation.value ?? const Color(0xFF81C784),
                  const Color(0xFF388E3C)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 64.0 : 24.0,
                  vertical: isWide ? 32.0 : 16.0,
                ),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 
                                MediaQuery.of(context).padding.top - 
                                MediaQuery.of(context).padding.bottom,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(255, 255, 255, 0.18),
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                                border: Border.all(
                                    color: const Color.fromRGBO(255, 255, 255, 0.25),
                                  width: 2,
                                ),
                              ),
                              padding: EdgeInsets.all(isWide ? 32 : 16),
                              child: Column(
                                children: [
                                  Semantics(
                                    label: 'Marketplace Logo',
                                    child: ScaleTransition(
                                      scale: _logoAnimation,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(24),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(alpha: 0.18),
                                                blurRadius: 16,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Image.asset(
                                            'assets/images/farm_logo.jpg',
                                            height: isWide ? 180 : 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  AnimatedOpacity(
                                    opacity: 1.0,
                                    duration: const Duration(milliseconds: 800),
                                    child: Text(
                                      'Welcome to FarmBracket Marketplace',
                                      style: theme.textTheme.headlineMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        shadows: [
                                          const Shadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: isWide ? 120 : 100,
                              child: PageView.builder(
                                itemCount: _onboardingPages.length,
                                onPageChanged: (i) => setState(() => _currentPage = i),
                                itemBuilder: (context, i) {
                                  final page = _onboardingPages[i];
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        page['title']!,
                                        style: theme.textTheme.titleLarge?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        page['desc']!,
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          color: Colors.white70,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(_onboardingPages.length, (i) {
                                return Container(
                                  width: 10,
                                  height: 10,
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: i == _currentPage ? Colors.white : Colors.white38,
                                    border: Border.all(color: Colors.white70, width: 1),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 32.0),
                          child: Column(
                            children: [
                              _isLoading
                                  ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                                  : ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(48),
                                        backgroundColor: theme.colorScheme.primary,
                                        foregroundColor: Colors.white,
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      icon: const Icon(Icons.arrow_forward),
                                      label: const Text('Get Started'),
                                      onPressed: () => _navigateToNext(context),
                                    ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        Navigator.pushNamed(context, '/login');
                                      },
                                child: const Text(
                                  'Already have an account? Log in',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}