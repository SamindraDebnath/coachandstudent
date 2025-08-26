import 'package:coachandstudent/auth/sessionController.dart';
import 'package:coachandstudent/auth/userNameAuth.dart';
import 'package:coachandstudent/configer/responsive.dart';
import 'package:coachandstudent/configer/sizeConfiger.dart';
import 'package:coachandstudent/imageSlider/topImageSilder.dart';
import 'package:coachandstudent/list/homeCategoryList.dart';
import 'package:coachandstudent/screens/authScreens/signInScreen.dart';
import 'package:coachandstudent/screens/homeScreens/drawerScreen.dart';
import 'package:coachandstudent/utils/nextScreen.dart';
import 'package:coachandstudent/widget/centerListWidget.dart';
import 'package:coachandstudent/widget/footerWidget.dart';
import 'package:coachandstudent/widget/headLineWidget.dart';
import 'package:coachandstudent/widget/recomendedForYou.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String greeting = '';

  @override
  void initState() {
    super.initState();
    _updateGreeting();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Responsive(
      smallMobile: _buildMobileLayout(context, crossAxisCount: 2),
      mobile: _buildMobileLayout(context, crossAxisCount: 3),
      tablet: _buildTabletLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  /// ------------------- LAYOUTS -------------------

  Widget _buildMobileLayout(BuildContext context, {int crossAxisCount = 2}) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context, crossAxisCount),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context, 4),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context,),
      body: Expanded(child: _buildBody(context, 5, padding: 40)),
    );
  }

  /// ------------------- COMMON BODY -------------------

  Widget _buildBody(BuildContext context, int crossAxisCount, {double padding = 16}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: GoogleFonts.poppins(
                    fontSize: Responsive.isDesktop(context) ? 32 : 26,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 5),
                UserNameAuthenticate(
                  userId: _auth.currentUser?.uid ?? "",
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 5),
          TopImageSlider(field: 'home'),

          const SizedBox(height: 10),
          HeadLine(text: "Category"),

          // Category Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: homeCategories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: Responsive.isDesktop(context) ? 4 : 3,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${homeCategories[index]} Selected")),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      homeCategories[index],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),
          const Divider(color: Color(0xFFACACAC)),

          HeadLine(text: "Top Centers"),
          const CenterListWidget(),

          const SizedBox(height: 20),
          const Divider(color: Color(0xFFACACAC)),

          HeadLine(text: "Recommended for You"),
          const RecommendedForYou(),

          const SizedBox(height: 20),
          const FooterWidget(),
        ],
      ),
    );
  }

  /// ------------------- APPBAR -------------------

  AppBar _buildAppBar(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return AppBar(
      elevation: 0,
      title: const Text('Home'),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: () async {
              if (user == null) {
                // 🔹 Not logged in → go to Sign In
                nextScreenReplace(context, SignInScreen());
              } else {
                // 🔹 Logged in → perform logout
                await FirebaseAuth.instance.signOut();
                // Optional: redirect to login screen after logout
                nextScreenReplace(context, SignInScreen());
              }
            },
            child: Text(
              user == null ? 'LOGIN' : 'LOGOUT',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  /// ------------------- GREETING LOGIC -------------------

  void _updateGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 4 && hour < 12) {
      greeting = 'Good Morning!';
    } else if (hour < 17) {
      greeting = 'Good Afternoon!';
    } else if (hour < 20) {
      greeting = 'Good Evening!';
    } else {
      greeting = 'Good Night!';
    }
  }
}
