import 'package:coachandstudent/configer/responsive.dart';
import 'package:coachandstudent/screens/coachScreens/classCreateScreen.dart';
import 'package:coachandstudent/screens/liveScreens/liveClassScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveHomeScreen extends StatefulWidget {
  final String userId; // logged-in user ID
  final bool isCoach; // true = coach, false = student
  const LiveHomeScreen({super.key, required this.userId, required this.isCoach});

  @override
  State<LiveHomeScreen> createState() => _LiveHomeScreenState();
}

class _LiveHomeScreenState extends State<LiveHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coaching Marketplace"),
        actions: [
          if (widget.isCoach)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateClassScreen(coachId: widget.userId),
                  ),
                );
              },
            ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("classes")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No classes available"));
          }

          final classes = snapshot.data!.docs;

          return Responsive(
            smallMobile: _buildList(classes), // for <376px
            mobile: _buildList(classes), // for phones
            tablet: _buildGrid(classes, crossAxisCount: 2),
            desktop: _buildGrid(classes, crossAxisCount: 4),
          );
        },
      ),
    );
  }

  /// List View (for mobile)
  Widget _buildList(List<QueryDocumentSnapshot> classes) {
    return ListView.builder(
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final classData = classes[index].data() as Map<String, dynamic>;
        final classId = classes[index].id;

        return _classCard(classData, classId);
      },
    );
  }

  /// Grid View (for tablet & desktop)
  Widget _buildGrid(List<QueryDocumentSnapshot> classes,
      {required int crossAxisCount}) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final classData = classes[index].data() as Map<String, dynamic>;
        final classId = classes[index].id;

        return _classCard(classData, classId);
      },
    );
  }

  /// Card UI (reused in list/grid)
  Widget _classCard(Map<String, dynamic> classData, String classId) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              classData["title"] ?? "Untitled Class",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "${classData["subject"] ?? ""} • Grade ${classData["grade"] ?? ""}\nPrice: ₹${classData["priceINR"] ?? 0}",
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12), // ✅ instead of Spacer()
            Align(
              alignment: Alignment.centerRight,
              child: widget.isCoach
                  ? ElevatedButton(
                child: const Text("Start Live"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LiveClassPage(),
                    ),
                  );
                },
              )
                  : ElevatedButton(
                child: const Text("Join"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LiveClassPage(roomId: classId),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
