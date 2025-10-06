import 'package:educatory_mobile_application/providers/home_provider.dart';
import 'package:educatory_mobile_application/views/screens/home/home_page/widgets/course_card.dart';
import 'package:educatory_mobile_application/views/screens/home/home_page/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C3AED),
        elevation: 0.5,
        title: Text(
          'All Courses',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Text(
                'Error: ${provider.errorMessage}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final courses = provider.courses?.data ?? [];

          if (courses.isEmpty) {
            return const Center(
              child: Text(
                'No courses available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: 'Explore Our Courses', actionText: ''),
                const SizedBox(height: 16),

                Column(
                  children: courses.map((c) {
                    return CourseCard(
                      title: c.title ?? 'Untitled',
                      author: c.author ?? 'Unknown',
                      duration: c.duration ?? 'N/A',
                      price: c.price ?? 'N/A',
                      oldPrice: c.originalPrice ?? '',
                      rating: c.rating ?? 0.0,
                      reviews: c.reviews ?? 0,
                      badge: c.tag ?? '',
                      imageUrl: c.image ?? '',
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
