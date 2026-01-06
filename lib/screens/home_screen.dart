import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// --- KONSTANTA WARNA GLOBAL ---
const Color kBackground = Color(0xFF0B0F13);
const Color kSurface = Color(0xFF161B22);
const Color kPrimary = Color(0xFF3B82F6); 
const Color kSecondary = Color(0xFF8B5CF6);
const Color kTextMain = Color(0xFFF3F4F6);
const Color kTextDim = Color(0xFF9CA3AF);

// --- MODEL DATA PROYEK ---
class ProjectData {
  final String title;
  final String description;
  final String techStack;
  final String imagePath;

  ProjectData({
    required this.title,
    required this.description,
    required this.techStack,
    required this.imagePath,
  });
}

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final aboutKey = GlobalKey();
  final skillsKey = GlobalKey();
  final portfolioKey = GlobalKey();
  final contactKey = GlobalKey();

  bool showMenu = false;
  List<ProjectData> myProjects = [];

  @override
  void initState() {
    super.initState();
    myProjects = [
      ProjectData(
        title: "Learn App With Flutter",
        description: "Aplikasi pembelajaran online programming.",
        techStack: "Flutter • Supabase • Dart",
        imagePath: "assets/images/flutter.png",
      ),
      ProjectData(
        title: "CRUD With Laravel",
        description: "Website Ecommerce sederhana dengan CRUD.",
        techStack: "Laravel • PHP • SQL",
        imagePath: "assets/images/laravel.png",
      ),
      ProjectData(
        title: "Login Page With Flutter",
        description: "Login Page sederhana dengan Flutter.",
        techStack: "Flutter • Supabase • Dart",
        imagePath: "assets/images/fluette.png", 
      ),
    ];
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 900;

  void scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastOutSlowIn,
      );
    }
    setState(() => showMenu = false);
  }

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);

    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [
          Positioned(top: -100, right: -100, child: _BlurCircle(color: kPrimary.withOpacity(0.15))),
          Positioned(bottom: -100, left: -100, child: _BlurCircle(color: kSecondary.withOpacity(0.15))),

          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHero(mobile),
                _buildAbout(mobile),
                _buildSkills(mobile),
                _buildProjects(mobile),
                _buildContact(mobile),
                const SizedBox(height: 50),
              ],
            ),
          ),
          _buildNavbar(mobile),
          if (mobile && showMenu) _buildMobileMenu(),
        ],
      ),
    );
  }

  // ================= SECTIONS =================

  Widget _buildHero(bool mobile) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: mobile ? 24 : 80),
      child: mobile 
        ? Column(mainAxisAlignment: MainAxisAlignment.center, children: _heroContent(true))
        : Row(children: _heroContent(false)),
    );
  }

  List<Widget> _heroContent(bool mobile) {
    return [
      if (mobile) _profileImage(100),
      if (mobile) const SizedBox(height: 30),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: mobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            _fadeIn(
              delay: 0.2,
              child: Text("WEB & MOBILE DEVELOPER",
                style: GoogleFonts.montserrat(color: kPrimary, fontWeight: FontWeight.bold, letterSpacing: 4, fontSize: 12)),
            ),
            const SizedBox(height: 15),
            _fadeIn(delay: 0.4, child: _AnimatedGradientName(mobile: mobile)),
            const SizedBox(height: 20),
            _fadeIn(
              delay: 0.6,
              child: Text("Mahasiswa Teknik Informatika Bina Sarana Global",
                textAlign: mobile ? TextAlign.center : TextAlign.start,
                style: GoogleFonts.inter(fontSize: 18, color: kTextDim, height: 1.5)),
            ),
            const SizedBox(height: 40),
            _fadeIn(
              delay: 0.8,
              child: _PrimaryButton(text: "Lihat Portfolio", onPressed: () => scrollTo(portfolioKey)),
            ),
          ],
        ),
      ),
      if (!mobile) const SizedBox(width: 50),
      if (!mobile) _profileImage(180),
    ];
  }

  Widget _profileImage(double radius) {
    return _fadeIn(
      delay: 0.5,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: kPrimary.withOpacity(0.3), width: 2)),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: kSurface,
          backgroundImage: const AssetImage('assets/images/jawa.png'),
        ),
      ),
    );
  }

  Widget _buildAbout(bool mobile) {
    return _sectionWrapper(
      key: aboutKey,
      title: "About Me",
      mobile: mobile,
      child: Text(
        "Saya Ihza, seorang developer yang antusias dalam menciptakan aplikasi mobile yang estetik dan fungsional menggunakan ekosistem Flutter Dan Laravel. Saya mahasiswa aktif jurusan Teknik Informatika, Prodi Software Engineering. Saya Memiliki Pengalaman Di Bidang Programing Dan Saya Sudah Berkecimpung Di Dunia Programing Sejak 2021",
        style: GoogleFonts.inter(color: kTextDim, fontSize: 18, height: 1.6),
      ),
    );
  }

  Widget _buildSkills(bool mobile) {
    final List<String> skills = ['Flutter', 'Dart', 'Laravel', 'PHP', 'SQL', 'Supabase', 'Git', 'UI/UX'];
    return _sectionWrapper(
      key: skillsKey,
      title: "Skills",
      mobile: mobile,
      child: Wrap(
        spacing: 15, runSpacing: 15,
        children: skills.map((s) => _SkillChip(label: s)).toList(),
      ),
    );
  }

  Widget _buildProjects(bool mobile) {
    return _sectionWrapper(
      key: portfolioKey,
      title: "Portfolio",
      mobile: mobile,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: mobile ? 1 : 3,
          crossAxisSpacing: 25,
          mainAxisSpacing: 25,
          childAspectRatio: 0.78,
        ),
        itemCount: myProjects.length,
        itemBuilder: (context, index) => _ProjectCard(project: myProjects[index]),
      ),
    );
  }

  Widget _buildContact(bool mobile) {
    return _sectionWrapper(
      key: contactKey,
      title: "Contact",
      mobile: mobile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white10)),
        child: Column(
          children: [
            Text("Mari Terhubung", style: GoogleFonts.montserrat(color: kTextMain, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            Wrap(
              spacing: 30,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _socialIcon(
                  icon: Icons.email_outlined,
                  color: Colors.redAccent,
                  label: "Email",
                  onTap: () => _launchURL("mailto:ihzaanasrulloh55@gmail.com"),
                ),
                _socialIcon(
                  icon: Icons.camera_alt_outlined,
                  color: Colors.pinkAccent,
                  label: "Instagram",
                  onTap: () => _launchURL("https://www.instagram.com/onlyyyzaa/"),
                ),
                _socialIcon(
                  icon: Icons.message_outlined, // Pengganti WA
                  color: Colors.greenAccent,
                  label: "WhatsApp",
                  onTap: () => _launchURL("https://wa.me/6281295252943"),
                ),
                _socialIcon(
                  icon: Icons.facebook_outlined,
                  color: Colors.blueAccent,
                  label: "Facebook",
                  onTap: () => _launchURL("https://www.facebook.com/ihza.a.haq?locale=id_ID"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- UI HELPERS ---
  Widget _buildNavbar(bool mobile) {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: mobile ? 24 : 80, vertical: 20),
            color: kBackground.withOpacity(0.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Ihza.", style: GoogleFonts.montserrat(fontSize: 26, fontWeight: FontWeight.w900, color: kPrimary, letterSpacing: -1.5)),
                if (!mobile) Row(
                  children: [
                    _navItem("About", () => scrollTo(aboutKey)),
                    _navItem("Skills", () => scrollTo(skillsKey)),
                    _navItem("Portfolio", () => scrollTo(portfolioKey)),
                    _navItem("Contact", () => scrollTo(contactKey)),
                  ],
                ) else IconButton(icon: Icon(showMenu ? Icons.close : Icons.menu, color: kTextMain), onPressed: () => setState(() => showMenu = !showMenu))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: InkWell(onTap: onTap, child: Text(title, style: GoogleFonts.inter(color: kTextMain, fontWeight: FontWeight.w500))),
    );
  }

  Widget _buildMobileMenu() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: kBackground.withOpacity(0.9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _mobileNavItem("About", () => scrollTo(aboutKey)),
              _mobileNavItem("Skills", () => scrollTo(skillsKey)),
              _mobileNavItem("Portfolio", () => scrollTo(portfolioKey)),
              _mobileNavItem("Contact", () => scrollTo(contactKey)),
              IconButton(onPressed: () => setState(() => showMenu = false), icon: const Icon(Icons.close, color: kPrimary, size: 40))
            ],
          ),
        ),
      ),
    );
  }

  Widget _mobileNavItem(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: InkWell(onTap: onTap, child: Text(title, style: GoogleFonts.montserrat(color: kTextMain, fontSize: 28, fontWeight: FontWeight.bold))),
    );
  }

  Widget _sectionWrapper({required Key key, required String title, required Widget child, required bool mobile}) {
    return Container(
      key: key, width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: mobile ? 24 : 80, vertical: 80),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.montserrat(fontSize: 32, fontWeight: FontWeight.bold, color: kTextMain)),
        const SizedBox(height: 10),
        Container(width: 40, height: 4, decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 40),
        child,
      ]),
    );
  }

  Widget _fadeIn({required Widget child, double delay = 0}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: (600 + (delay * 1000)).toInt()),
      builder: (context, value, _) => Opacity(opacity: value, child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child)),
    );
  }

  Widget _socialIcon({required IconData icon, required Color color, required String label, required VoidCallback onTap}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.1), border: Border.all(color: color.withOpacity(0.3))),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.inter(color: kTextDim, fontSize: 12)),
      ],
    );
  }
}

class _AnimatedGradientName extends StatefulWidget {
  final bool mobile;
  const _AnimatedGradientName({required this.mobile});
  @override
  State<_AnimatedGradientName> createState() => _AnimatedGradientNameState();
}

class _AnimatedGradientNameState extends State<_AnimatedGradientName> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 3), vsync: this)..repeat(reverse: true);
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: const [kPrimary, kSecondary, Color(0xFF34D399), kPrimary],
          stops: [0.0, _controller.value * 0.5, _controller.value, 1.0],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ).createShader(bounds),
        child: Text("Ihza Anasrulloh", textAlign: widget.mobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: widget.mobile ? 48 : 85, height: 1.1, letterSpacing: -2, color: Colors.white,
            shadows: [Shadow(color: kPrimary.withOpacity(0.5), blurRadius: 30, offset: Offset.zero)],
          )),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectData project;
  const _ProjectCard({required this.project});
  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: kSurface, borderRadius: BorderRadius.circular(25),
          border: Border.all(color: isHovered ? kPrimary : Colors.white10),
          boxShadow: [if (isHovered) BoxShadow(color: kPrimary.withOpacity(0.15), blurRadius: 30, spreadRadius: 5)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            child: Image.asset(widget.project.imagePath, width: double.infinity, fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: Colors.white10, child: const Icon(Icons.image, color: kTextDim, size: 40))),
          )),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.project.title, style: GoogleFonts.montserrat(color: kTextMain, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(widget.project.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(color: kTextDim, fontSize: 13, height: 1.4)),
              const SizedBox(height: 15),
              Text(widget.project.techStack, style: GoogleFonts.inter(color: kPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
            ]),
          )
        ]),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.text, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: kPrimary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 22), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      child: Text(text, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white10)),
      child: Text(label, style: GoogleFonts.inter(color: kTextMain, fontWeight: FontWeight.w500)),
    );
  }
}

class _BlurCircle extends StatelessWidget {
  final Color color;
  const _BlurCircle({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(width: 450, height: 450, decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100), child: Container()));
  }
}