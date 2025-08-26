import 'package:coachandstudent/configer/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      smallMobile: _mobileFooter(),
      mobile: _mobileFooter(),
      tablet: _webFooter(),
      desktop: _webFooter(),
    );
  }

  /// ------------------ MOBILE / APP FOOTER ------------------
  Widget _mobileFooter() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF3F3F3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              color: Color(0xFFFFFFFF),
            ),
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TRULY",
                  style: GoogleFonts.mogra(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey[200],
                  ),
                ),
                Text(
                  "INDIAN",
                  style: GoogleFonts.mogra(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[200],
                  ),
                ),
                Text(
                  "APP",
                  style: GoogleFonts.mogra(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[200],
                  ),
                ),
                const Text(
                  "MADE WITH ❤️ IN INDIA",
                  style: TextStyle(color: Colors.blueGrey),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ------------------ WEB FOOTER ------------------
  Widget _webFooter() {
    return Container(
      color: Colors.grey.shade900,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
      child: Column(
        children: [
          // Top Row with Sections
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                // Wide screen → Row
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _footerSection("About Us", [
                      "Who we are",
                      "Our mission",
                      "Careers",
                    ]),
                    _footerSection("Support", [
                      "Help Center",
                      "Contact Us",
                      "FAQs",
                    ]),
                    _footerSection("Legal", [
                      "Privacy Policy",
                      "Terms of Service",
                      "Refund Policy",
                    ]),
                    _downloadAppSection(), // ✅ Added here
                  ],
                );
              } else {
                // Small screen → Column
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _footerSection("About Us", [
                      "Who we are",
                      "Our mission",
                      "Careers",
                    ]),
                    const SizedBox(height: 20),
                    _footerSection("Support", [
                      "Help Center",
                      "Contact Us",
                      "FAQs",
                    ]),
                    const SizedBox(height: 20),
                    _footerSection("Legal", [
                      "Privacy Policy",
                      "Terms of Service",
                      "Refund Policy",
                    ]),
                    const SizedBox(height: 20),
                    _downloadAppSection(), // ✅ For smaller screens
                  ],
                );
              }
            },
          ),

          const SizedBox(height: 30),
          const Divider(color: Colors.white30),
          const SizedBox(height: 10),

          // Bottom copyright
          const Text(
            "© 2025 Coach & Student. All rights reserved.",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _footerSection(String title, List<String> items) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          for (var item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                item,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// ------------------ DOWNLOAD APP SECTION ------------------
  Widget _downloadAppSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Download App",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Play Store Button
              InkWell(
                onTap: () {},
                child: Image.asset(
                  "assets/images/googlePlayStore.png",
                  height: 40,
                ),
              ),
              const SizedBox(height: 12),
              // App Store Button
              InkWell(
                onTap: () {},
                child: Image.asset(
                  "assets/images/appStore.png",
                  height: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
