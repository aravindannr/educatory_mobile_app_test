import 'package:educatory_mobile_application/providers/home_provider.dart';
import 'package:educatory_mobile_application/views/screens/home/home_page/widgets/course_card.dart';
import 'package:educatory_mobile_application/views/screens/home/home_page/widgets/material_card.dart';
import 'package:educatory_mobile_application/views/screens/home/home_page/widgets/section_header.dart';
import 'package:educatory_mobile_application/views/screens/home/home_page/widgets/subject_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<HomeProvider>(context, listen: false).fetchData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.errorMessage != null
            ? Center(
                child: Text(
                  'Error: ${provider.errorMessage}',
                  style: const TextStyle(color: Colors.red),
                ),
              )
            : buildHomeContent(context, provider),
      ),
    );
  }

  Widget buildHomeContent(BuildContext context, HomeProvider provider) {
    final subjects = provider.subjects?.data ?? [];
    final courses = provider.courses?.data ?? [];
    final materials = provider.materials?.data ?? [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/images/menu-2.svg"),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/images/notification.svg"),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset("assets/images/cart.svg"),
                    ),
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Consumer<HomeProvider>(
                        builder: (context, provider, _) {
                          if (provider.totalCartCount == 0) {
                            return const SizedBox();
                          }
                          return Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF9F54F8),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              provider.totalCartCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCBD5E1)),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Icon(Icons.search, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      style: GoogleFonts.inter(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: GoogleFonts.inter(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 24,
                    width: 1,
                    color: const Color(0xFFCBD5E1),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.tune, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          SectionHeader(title: 'Subject Tutoring', actionText: 'All Subjects'),
          const SizedBox(height: 16),

          if (subjects.isEmpty)
            const Center(child: Text('No subjects available'))
          else
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final sub = subjects[index];
                  return SubjectCard(
                    title: sub.subject ?? 'Unknown',
                    icon: sub.icon ?? '',
                    gradient: provider.parseGradient(
                      sub.mainColor,
                      sub.gradientColor,
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 20),

          if (provider.bannerImage == null || provider.bannerImage!.isEmpty)
            const SizedBox(
              height: 140,
              child: Center(child: Text('No banner available')),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  provider.bannerImage!,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          const SizedBox(height: 24),

          SectionHeader(title: 'All Courses', actionText: ''),
          const SizedBox(height: 16),

          if (courses.isEmpty)
            const Center(child: Text('No courses available'))
          else
            Column(
              children: courses.map((c) {
                return CourseCard(
                  title: c.title ?? 'Untitled',
                  author: c.author ?? 'Unknown',
                  duration: c.duration ?? 'N/A',
                  price: c.price ?? 'N/A',
                  oldPrice: c.originalPrice ?? 'N/A',
                  rating: c.rating ?? 0.0,
                  reviews: c.reviews ?? 0,
                  badge: c.tag ?? '',
                  imageUrl: c.image ?? '',
                );
              }).toList(),
            ),

          const SizedBox(height: 24),

          SectionHeader(title: 'Buy Materials', actionText: ''),
          const SizedBox(height: 16),

          if (materials.isEmpty)
            const Center(child: Text('No materials available'))
          else
            Column(
              children: materials.map((m) {
                return MaterialCard(
                  title: m.title ?? 'Untitled',
                  seller: m.brand ?? 'Unknown',
                  price: m.price ?? '',
                  oldPrice: m.originalPrice ?? '',
                  rating: m.rating ?? 0.0,
                  reviews: m.reviews ?? 0,
                  badge: m.tag ?? '',
                  imageUrl: m.image ?? '',
                );
              }).toList(),
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
