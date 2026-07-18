import 'package:dio/dio.dart';
import '../api_client/api_clients.dart';
import '../models/job.dart';
import 'roles_repository.dart';

class RolesRepositoryImpl implements RolesRepository {
  final ApiClient client;
  static const String activePath = 'https://api.wraeglobal.com/roleRouter/getActiveRoles';
  static const String archivedPath = 'https://api.wraeglobal.com/roleRouter/getArchivedRoles';

  RolesRepositoryImpl(this.client);

  Future<List<Job>> _parseRolesResponse(Map<String, dynamic> json) async {
    final rolesRaw = json['roles'];
    if (rolesRaw is List) {
      return rolesRaw.map((e) {
        if (e is Map<String, dynamic>) {
          return Job.fromJson(e);
        }
        return Job.fromJson(Map<String, dynamic>.from(e));
      }).toList();
    }
    return [];
  }

  @override
  Future<List<Job>> getActiveRoles() async {
    try {
      final json = await client.getJson(activePath);
      return await _parseRolesResponse(json);
    } on DioError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Job>> getArchivedRoles() async {
    try {
      final json = await client.getJson(archivedPath);
      return await _parseRolesResponse(json);
    } on DioError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
