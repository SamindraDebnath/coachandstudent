import 'package:coachandstudent/configer/responsive.dart';
import 'package:coachandstudent/configer/sizeConfiger.dart';
import 'package:coachandstudent/widget/cardWidget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';


class CenterListWidget extends StatelessWidget {
  const CenterListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _mobileCenters(),       // ✅ your existing mobile
      smallMobile: _mobileCenters(),  // ✅ same for small mobile
      tablet: _webCenters(3),         // tablet → 2 columns
      desktop: _webCenters(5),        // desktop → 4 columns
    );
  }

  /// ---------------- MOBILE VERSION (your original) ----------------
  Widget _mobileCenters() {
    return SizedBox(
      height: SizeConfig.screenHeight / 2.7, // height of card + spacing
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('coach').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No centers available"));
          }

          final centers = snapshot.data!.docs;
          final itemCount = (centers.length / 2).ceil();

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: itemCount,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final firstIndex = index * 2;
              final firstData =
              centers[firstIndex].data() as Map<String, dynamic>;

              final hasSecond = firstIndex + 1 < centers.length;
              final secondData = hasSecond
                  ? centers[firstIndex + 1].data() as Map<String, dynamic>
                  : null;

              return Column(
                children: [
                  CardWidget(
                    imageUrl: firstData['imageUrl'] ?? '',
                    name: firstData['centerName'] ?? 'Unknown',
                    address: firstData['address'] ?? 'No Address',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${firstData['centerName']} Selected"),
                        ),
                      );
                    },height: SizeConfig.screenHeight/5.5,
                  ),
                  const SizedBox(height: 5),
                  if (secondData != null)
                    CardWidget(
                      imageUrl: secondData['imageUrl'] ?? '',
                      name: secondData['centerName'] ?? 'Unknown',
                      address: secondData['address'] ?? 'No Address',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text("${secondData['centerName']} Selected"),
                          ),
                        );
                      }, height: SizeConfig.screenHeight/5.5,
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  /// ---------------- WEB / TABLET VERSION ----------------
  Widget _webCenters(int crossAxisCount) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('coach').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No centers available"));
        }

        final centers = snapshot.data!.docs;

        return GridView.builder(
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // let page scroll
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, // 2 for tablet, 4 for desktop
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 2 / 2, // card ratio
          ),
          itemCount: centers.length,
          itemBuilder: (context, index) {
            final data = centers[index].data() as Map<String, dynamic>;
            return CardWidget(
              imageUrl: data['imageUrl'] ?? '',
              name: data['centerName'] ?? 'Unknown',
              address: data['address'] ?? 'No Address',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${data['centerName']} Selected")),
                );
              }, height: SizeConfig.screenHeight/3.5,
            );
          },
        );
      },
    );
  }
}

