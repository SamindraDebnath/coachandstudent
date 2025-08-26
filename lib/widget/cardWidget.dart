import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String address;
  final double height;
  final VoidCallback onTap;

  const CardWidget({super.key,
    required this.imageUrl,
    required this.name,
    required this.address,
    required this.onTap,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: onTap,
      child: Container(
        // 🔹 make card responsive
        height: height, // passed from parent (different for mobile/web)
        width: screenWidth * 0.25, // 25% of screen width
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
                child: Image.network(
                  imageUrl.isNotEmpty
                      ? imageUrl
                      : 'https://www.nicepng.com/png/detail/793-7936442_book-logo-png-books-logo-black-png.png',
                  fit: BoxFit.fill,
                  height: height * 0.5, // 🔹 half of card height
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, _, __) {
                    return Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.fill,
                      height: height * 0.5,
                      width: double.infinity,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 14, // 🔹 responsive font size
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                address,
                style: GoogleFonts.poppins(
                  fontSize: 12, // 🔹 smaller but responsive
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}