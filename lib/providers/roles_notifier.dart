import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/job.dart';
import '../data/models/filter.dart';
import '../data/repositories/roles_repository.dart';
import 'roles_state.dart';

class RolesNotifier extends StateNotifier<RolesState> {
  final RolesRepository repository;
  final bool archived;

  JobFilter _filters = const JobFilter();

  RolesNotifier(this.repository, {this.archived = false}) : super(RolesState.initial());


  Future<void> loadAppliedFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('applied_jobs') ?? [];
      final ids = list.map((s) => int.tryParse(s)).whereType<int>().toList();
      state = state.copyWith(appliedJobIds: ids);
    } catch (_) {}
  }

  Future<void> toggleApply(int jobId) async {
    final current = List<int>.from(state.appliedJobIds ?? []);
    if (current.contains(jobId)) {
      current.remove(jobId);
    } else {
      current.add(jobId);
    }
    state = state.copyWith(appliedJobIds: current);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('applied_jobs', current.map((e) => e.toString()).toList());
    } catch (_) {}
  }

  void setFilters(JobFilter f) {
    _filters = f;
  }

  void clearFilters() {
    _filters = const JobFilter();
    applyFilters();
  }

  Future<void> applyFilters() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Use cached list if available to avoid refetching
      final all = state.all.isNotEmpty ? state.all : (archived ? await repository.getArchivedRoles() : await repository.getActiveRoles());
      final filtered = _applyLocalFilter(all, _filters);
      state = state.copyWith(isLoading: false, filtered: filtered);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Load roles initially (or refresh)
  Future<void> loadRoles() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final List<Job> list = archived ? await repository.getArchivedRoles() : await repository.getActiveRoles();
      // apply current search query (if any) and filters
      final filteredBySearch = _applyFilter(list, state.searchQuery);
      final filteredByAll = _applyLocalFilter(filteredBySearch, _filters);
      state = state.copyWith(all: list, filtered: filteredByAll, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Search query handling (live local filtering)
  void setSearchQuery(String q) {
    final query = q.trim();
    final filtered = _applyFilter(state.all, query);
    // also apply active filters on top of search results
    final filteredWithFilters = _applyLocalFilter(filtered, _filters);
    state = state.copyWith(searchQuery: query, filtered: filteredWithFilters);
  }

  Future<void> refresh() async {
    await loadRoles();
  }

  // -------------------------
  // Internal helpers
  // -------------------------
  List<Job> _applyFilter(List<Job> source, String query) {
    if (query.isEmpty) return List<Job>.from(source);
    final q = query.toLowerCase();
    return source.where((job) {
      final title = job.name.toLowerCase();
      final company = (job.CompanyName ?? '').toLowerCase();
      return title.contains(q) || company.contains(q);
    }).toList();
  }

  List<Job> _applyLocalFilter(List<Job> list, JobFilter f) {
    return list.where((job) {
      // keyword (from filter model)
      if (f.keyword.isNotEmpty) {
        final kw = f.keyword.toLowerCase();
        final inName = job.name.toLowerCase().contains(kw);
        final inCompany = (job.CompanyName ?? '').toLowerCase().contains(kw);
        if (!inName && !inCompany) return false;
      }

      if (f.companyName != null && f.companyName!.isNotEmpty) {
        if ((job.CompanyName ?? '').toLowerCase() != f.companyName!.toLowerCase()) return false;
      }

      if (f.minExperience != null && (job.max_experience ?? 0) < f.minExperience!) return false;
      if (f.maxExperience != null && (job.min_experience ?? 0) > f.maxExperience!) return false;

      if (f.minSalary != null && (job.max_salary ?? 0) < f.minSalary!) return false;
      if (f.maxSalary != null && (job.min_salary ?? 0) > f.maxSalary!) return false;

      if (f.startDateFrom != null && (job.start_date == null || job.start_date!.isBefore(f.startDateFrom!))) return false;
      if (f.startDateTo != null && (job.start_date == null || job.start_date!.isAfter(f.startDateTo!))) return false;

      if (f.active != null && job.active != f.active) return false;
      if (f.categoryId != null && job.category_id != f.categoryId) return false;
      if (f.domainId != null && job.domain_id != f.domainId) return false;
      if (f.statusId != null && job.status_id != f.statusId) return false;

      if (f.location != null && f.location!.isNotEmpty) {
        final loc = (job.briefing ?? '').toLowerCase();
        if (!loc.contains(f.location!.toLowerCase())) return false;
      }

      if (f.minReferral != null && (job.referral_amount ?? 0) < f.minReferral!) return false;
      if (f.maxReferral != null && (job.referral_amount ?? 0) > f.maxReferral!) return false;

      if (f.minPositions != null && (job.no_of_positions ?? 0) < f.minPositions!) return false;
      if (f.maxPositions != null && (job.no_of_positions ?? 0) > f.maxPositions!) return false;

      return true;
    }).toList();
  }
}

// Providers (unchanged)
final rolesRepositoryProvider = Provider<RolesRepository>((ref) {
  throw UnimplementedError();
});

final activeRolesNotifierProvider = StateNotifierProvider<RolesNotifier, RolesState>((ref) {
  final repo = ref.watch(rolesRepositoryProvider);
  return RolesNotifier(repo, archived: false);
});

final archivedRolesNotifierProvider = StateNotifierProvider<RolesNotifier, RolesState>((ref) {
  final repo = ref.watch(rolesRepositoryProvider);
  return RolesNotifier(repo, archived: true);
});
