import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio);

  Future<Map<String, dynamic>> getJson(String url) async {
    final response = await dio.get(url);
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    return {'data': data};
  }
}
