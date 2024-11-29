import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';

import '../../shared/core/app_url.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late List<Animation<Offset>> _slideAnimations;
  late Animation<double> _fadeAnimation;
  var appVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _slideAnimations = List.generate(
      3,
      (index) => Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _slideController,
          curve: Interval(
            index * 0.2,
            (index * 0.2) + 0.6,
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'About',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF333333)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 40),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF333333),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Image.asset(
            'assets/images/app_logo.png',
            height: 100,
            width: 100,
          ),
        ),
        const SizedBox(height: 20),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Colors.orange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds),
          child: Text(
            'Calculator v$appVersion',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _share() {
    Share.share(
        "https://play.google.com/store/apps/details?id=com.idea.calculator");
  }

  void _rateApp(BuildContext context) {
    final InAppReview inAppReview = InAppReview.instance;

    inAppReview.openStoreListing(
      appStoreId: 'com.idea.calculator',
      microsoftStoreId: 'com.idea.calculator',
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionRow(
          0,
          [
            _buildActionButton(
                icon: Icons.share_outlined,
                label: 'Share',
                onTap: () {
                  _share();
                }),
            _buildActionButton(
              icon: Icons.star_outline,
              label: 'Rate',
              onTap: () {
                _rateApp(context);
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildActionRow(
          1,
          [
            _buildActionButton(
              icon: Icons.apps_outlined,
              label: 'Our Apps',
              onTap: () {
                AppUrl.launch(
                    'https://play.google.com/store/apps/developer?id=IdeaS0ft&hl=en&gl=US');
              },
            ),
            _buildActionButton(
              icon: Icons.email_outlined,
              label: 'suggestion',
              onTap: () {
                _sendEmail('');
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildActionRow(
          2,
          [
            _buildActionButton(
              icon: FontAwesomeIcons.twitter,
              label: 'Twitter',
              onTap: () {
                AppUrl.launch('https://twitter.com/IdeaS0ft');
              },
            ),
            _buildActionButton(
              icon: Icons.facebook,
              label: 'Facebook',
              onTap: () {
                AppUrl.launch('https://m.facebook.com/100083952761239/');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionRow(int animationIndex, List<Widget> children) {
    return SlideTransition(
      position: _slideAnimations[animationIndex],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.orange, size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendEmail(String emailAddress) async {
    final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'ideasoftwaretech@gmail.com',
        queryParameters: {'subject': ''});

    AppUrl.launchUri(emailLaunchUri);
  }
}
