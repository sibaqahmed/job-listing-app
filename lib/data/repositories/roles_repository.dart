import '../models/job.dart';

abstract class RolesRepository {
  Future<List<Job>> getActiveRoles();
  Future<List<Job>> getArchivedRoles();
}
