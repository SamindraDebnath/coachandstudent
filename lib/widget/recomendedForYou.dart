import 'package:coachandstudent/configer/responsive.dart';
import 'package:coachandstudent/configer/sizeConfiger.dart';
import 'package:coachandstudent/widget/cardWidget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class RecommendedForYou extends StatelessWidget {
  const RecommendedForYou({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _mobileRecommended(),       // ✅ horizontal list
      smallMobile: _mobileRecommended(),  // ✅ same for small mobile
      tablet: _webRecommended(3),         // ✅ tablet → 3 columns
      desktop: _webRecommended(5),        // ✅ desktop → 5 columns
    );
  }

  /// ---------------- MOBILE VERSION ----------------
  Widget _mobileRecommended() {
    return SizedBox(
      height: SizeConfig.screenHeight / 5.5, // one card row
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('coach')
            .where('isRecommended', isEqualTo: true)
            .limit(10)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No recommendations found"));
          }

          final centers = snapshot.data!.docs;

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: centers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final data = centers[index].data() as Map<String, dynamic>;
              return CardWidget(
                imageUrl: data['imageUrl'] ?? '',
                name: data['centerName'] ?? 'Unknown',
                address: data['address'] ?? 'No Address',
                height: SizeConfig.screenHeight / 5.5,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${data['centerName']} Selected")),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  /// ---------------- WEB / TABLET VERSION ----------------
  Widget _webRecommended(int crossAxisCount) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('coach')
          .where('isRecommended', isEqualTo: true)
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No recommendations found"));
        }

        final centers = snapshot.data!.docs;

        return GridView.builder(
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 3 / 3.5, // ✅ better ratio for web cards
          ),
          itemCount: centers.length,
          itemBuilder: (context, index) {
            final data = centers[index].data() as Map<String, dynamic>;
            return CardWidget(
              imageUrl: data['imageUrl'] ?? '',
              name: data['centerName'] ?? 'Unknown',
              address: data['address'] ?? 'No Address',
              height: SizeConfig.screenHeight / 3.5,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${data['centerName']} Selected")),
                );
              },
            );
          },
        );
      },
    );
  }
}

