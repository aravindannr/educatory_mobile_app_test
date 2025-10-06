import 'package:educatory_mobile_application/data/models/get_sugbjects_model.dart';
import 'package:educatory_mobile_application/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/get_course_model.dart';
import '../data/models/get_materials_model.dart';

class HomeProvider with ChangeNotifier {
  GetSubjectModel? subjects;
  GetCourseModel? courses;
  GetMaterialsModel? materials;
  String? bannerImage;

  bool isLoading = false;
  String? errorMessage;

  final Map<String, int> _cart = {};
  Map<String, int> get cart => _cart;

  final Set<String> _expandedCardTitles = {};
  Set<String> get expandedCardTitles => _expandedCardTitles;

  int get totalCartCount =>
      _cart.values.fold(0, (sum, quantity) => sum + quantity);

  bool isCardExpanded(String title) => _expandedCardTitles.contains(title);

  void addToCart(String title) {
    if (_cart.containsKey(title)) {
      _cart[title] = _cart[title]! + 1;
    } else {
      _cart[title] = 1;
      _expandedCardTitles.add(title);
    }
    notifyListeners();
  }

  void removeFromCart(String title) {
    if (_cart.containsKey(title)) {
      if (_cart[title]! > 1) {
        _cart[title] = _cart[title]! - 1;
      } else {
        _cart.remove(title);
        _expandedCardTitles.remove(title);
      }
      notifyListeners();
    }
  }

  int getItemCount(String title) => _cart[title] ?? 0;

  void collapseCard(String title) {
    _expandedCardTitles.remove(title);
    notifyListeners();
  }

  void toggleCardExpansion(String title) {
    if (_expandedCardTitles.contains(title)) {
      _expandedCardTitles.remove(title);
    } else {
      _expandedCardTitles.add(title);
    }
    notifyListeners();
  }

  Future<void> fetchData() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('No token found');

      final subjectData = await ApiServices().fetchSubjects(token: token);
      final courseData = await ApiServices().fetchCourses(token: token);
      final materialData = await ApiServices().fetchMaterials(token: token);
      final bannerData = await ApiServices().fetchBanner(token: token);

      subjects = subjectData;
      courses = courseData;
      materials = materialData;
      bannerImage = bannerData.data ?? '';
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  LinearGradient parseGradient(String? mainColor, String? gradientColor) {
    try {
      Color main = Color(
        int.parse(mainColor?.replaceFirst('#', '0xFF') ?? '0xFFFF6773'),
      );
      Color gradient = Color(
        int.parse(gradientColor?.replaceFirst('#', '0xFF') ?? '0xFFFE8B6E'),
      );
      return LinearGradient(
        colors: [main, gradient],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } catch (e) {
      return const LinearGradient(
        colors: [Color(0xFFFF6773), Color(0xFFFE8B6E)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }
}
