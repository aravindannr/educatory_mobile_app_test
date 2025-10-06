import 'dart:convert';
import 'dart:io';
import 'package:educatory_mobile_application/core/utils/helpers.dart';
import 'package:educatory_mobile_application/data/models/add_profile_image_model.dart';
import 'package:educatory_mobile_application/data/models/create_user_model.dart';
import 'package:educatory_mobile_application/data/models/full_name_adding_model.dart';
import 'package:educatory_mobile_application/data/models/get_banner_model.dart';
import 'package:educatory_mobile_application/data/models/get_course_model.dart';
import 'package:educatory_mobile_application/data/models/get_materials_model.dart';
import 'package:educatory_mobile_application/data/models/get_otp_model.dart';
import 'package:educatory_mobile_application/data/models/get_profile_model.dart';
import 'package:educatory_mobile_application/data/models/get_sugbjects_model.dart';
import 'package:educatory_mobile_application/data/models/verify_model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final String baseUrl = 'https://machinetest.flutter.penoft.com/api/user';
  final String baseUrl2 = 'https://machinetest.flutter.penoft.com/api/data/';

  Future<GetOtpModel> getOtp(String email) async {
    try {
      final url = Uri.parse("$baseUrl/send-otp");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );
      if (response.statusCode == 200) {
        return getOtpModelFromJson(response.body);
      } else {
        Helpers.print('Server error: ${response.body}');
        throw Exception("Failed to send OTP: ${response.body}");
      }
    } catch (e) {
      Helpers.print('Exception while sending OTP: $e');
      rethrow;
    }
  }

  Future<VerifyOtpModel> verifyOtp(String email, String otp) async {
    try {
      final url = Uri.parse("$baseUrl/verify-otp");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'otp': otp}),
      );
      if (response.statusCode == 200) {
        return verifyOtpModelFromJson(response.body);
      } else {
        Helpers.print('Server error: ${response.body}');
        throw Exception("Failed to verify OTP: ${response.body}");
      }
    } catch (e) {
      Helpers.print('Exception while verifying OTP: $e');
      rethrow;
    }
  }

  Future<FullNameAddingModel> addFullName(
    String fullname,
    String? token,
  ) async {
    try {
      final url = Uri.parse("$baseUrl/add-fullname");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"fullname": fullname}),
      );
      if (response.statusCode == 200) {
        return fullNameAddingModelFromJson(response.body);
      } else {
        Helpers.print('Server error: ${response.body}');
        throw Exception("Failed to add name: ${response.body}");
      }
    } catch (e) {
      Helpers.print('Exception while adding name: $e');
      rethrow;
    }
  }

  Future<AddProfileImageModel?> uploadProfilePicture({
    required String token,
    required File imageFile,
  }) async {
    final url = Uri.parse("$baseUrl/add-picture");

    try {
      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      request.files.add(
        await http.MultipartFile.fromPath('Picture', imageFile.path),
      );

      var response = await request.send();

      var responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        return addProfileImageModelFromJson(responseBody.body);
      } else {
        Helpers.print('Upload failed: ${response.statusCode}');
        Helpers.print(responseBody.body);
        return null;
      }
    } catch (e) {
      Helpers.print('Exception while uploading: $e');
      return null;
    }
  }

  Future<GetSubjectModel> fetchSubjects({required String token}) async {
    final url = Uri.parse('$baseUrl2/subjects');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Helpers.print("Subjects fetched successfully: ${response.body}");
        return getSubjectModelFromJson(response.body);
      } else {
        Helpers.print("Failed to fetch subjects: ${response.statusCode}");
        Helpers.print(response.body);
        throw Exception(
          'Failed to fetch subjects (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      Helpers.print("Exception while fetching subjects: $e");
      rethrow;
    }
  }

  Future<GetCourseModel> fetchCourses({required String token}) async {
    final url = Uri.parse('$baseUrl2/courses');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Helpers.print("Courses fetched successfully: ${response.body}");
        return getCourseModelFromJson(response.body);
      } else {
        Helpers.print("Failed to fetch courses: ${response.statusCode}");
        Helpers.print(response.body);
        throw Exception(
          'Failed to fetch courses (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      Helpers.print("Exception while fetching courses: $e");
      rethrow;
    }
  }

  Future<GetMaterialsModel> fetchMaterials({required String token}) async {
    final url = Uri.parse('$baseUrl2/materials');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Helpers.print("Materials fetched successfully: ${response.body}");
        return getMaterialsModelFromJson(response.body);
      } else {
        Helpers.print("Failed to fetch materials: ${response.statusCode}");
        Helpers.print(response.body);
        throw Exception(
          'Failed to fetch materials (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      Helpers.print("Exception while fetching materials: $e");
      rethrow;
    }
  }

  Future<GetBannerModel> fetchBanner({required String token}) async {
    final url = Uri.parse('$baseUrl2/banner');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Helpers.print("Banner fetched successfully: ${response.body}");
        return getBannerModelFromJson(response.body);
      } else {
        Helpers.print("Failed to fetch banner: ${response.statusCode}");
        Helpers.print(response.body);
        throw Exception(
          'Failed to fetch banner (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      Helpers.print("Exception while fetching banner: $e");
      rethrow;
    }
  }

  Future<GetProfileModel> fetchProfile({required String token}) async {
    final url = Uri.parse('$baseUrl/get-user');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Helpers.print("User fetched successfully: ${response.body}");
        return getProfileModelFromJson(response.body);
      } else {
        Helpers.print("Failed to fetch user: ${response.statusCode}");
        Helpers.print(response.body);
        throw Exception(
          'Failed to fetch user (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      Helpers.print("Exception while fetching user: $e");
      rethrow;
    }
  }

  Future<CreateUserModel> createUser(
    String fullname,
    String email,
    String phoneNumber,
    String imageUrl,
  ) async {
    try {
      final url = Uri.parse("$baseUrl/create-user");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fullname": fullname,
          "email": email,
          "phone": phoneNumber,
          "picture": imageUrl,
        }),
      );
      if (response.statusCode == 200) {
        return createUserModelFromJson(response.body);
      } else {
        Helpers.print('Server error: ${response.body}');
        throw Exception("Failed to create-user: ${response.body}");
      }
    } catch (e) {
      Helpers.print('Exception while create-user: $e');
      rethrow;
    }
  }
}
