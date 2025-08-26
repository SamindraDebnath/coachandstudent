import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coachandstudent/configer/responsive.dart';
import 'package:coachandstudent/configer/sizeConfiger.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class TopImageSlider extends StatefulWidget {
  final String field;

  const TopImageSlider({super.key, required this.field});

  @override
  _TopImageSliderState createState() => _TopImageSliderState();
}

class _TopImageSliderState extends State<TopImageSlider> {
  int _index = 0;
  List<DocumentSnapshot> _bannerDocs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBannerData();
  }

  Future<void> _loadBannerData() async {
    var _fireStore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _fireStore
        .collection('topBanner')
        .where('field', isEqualTo: widget.field)
        .get();

    if (mounted) {
      setState(() {
        _bannerDocs = snapshot.docs;
        _isLoading = false;
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    // Responsive heights
    double sliderHeight;
    if (Responsive.isDesktop(context)) {
      sliderHeight = 400;
    } else if (Responsive.isTablet(context)) {
      sliderHeight = 300;
    } else if (Responsive.isMobile(context)) {
      sliderHeight = 220;
    } else {
      sliderHeight = 180; // small mobile
    }

    return Padding(
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
      child: Column(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_bannerDocs.isEmpty)
            const SizedBox() // No banners
          else
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: CarouselSlider.builder(
                itemCount: _bannerDocs.length,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  DocumentSnapshot sliderImage = _bannerDocs[index];
                  Map getImage = sliderImage.data() as Map;

                  final isAd = getImage['ad'] == true;
                  final link = getImage['link'] ?? '';

                  return InkWell(
                    onTap: () {
                      if (link.isNotEmpty) {
                        _launchUrl(link);
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        Responsive.isDesktop(context) ? 20 : 10,
                      ),
                      child: Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Image.network(
                              getImage['image'],
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, object, stack) {
                                return Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: Responsive.isDesktop(context)
                                        ? 150
                                        : 80,
                                    color: Colors.grey.shade400,
                                  ),
                                );
                              },
                            ),
                          ),

                          // Ad badge
                          if (isAd)
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Ad',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize:
                                    Responsive.isDesktop(context) ? 14 : 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                          // Visit Now button
                          if (isAd)
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Visit Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                    Responsive.isDesktop(context) ? 14 : 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  viewportFraction: 1,
                  initialPage: 0,
                  autoPlay: true,
                  height: sliderHeight,
                  onPageChanged: (int i, reason) {
                    setState(() {
                      _index = i;
                    });
                  },
                ),
              ),
            ),

          // Dots indicator
          if (_bannerDocs.isNotEmpty)
            DotsIndicator(
              dotsCount: _bannerDocs.length,
              position: _index.toDouble(),
              decorator: DotsDecorator(
                size: const Size.square(6.0),
                activeSize: const Size(18.0, 6.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                activeColor: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
