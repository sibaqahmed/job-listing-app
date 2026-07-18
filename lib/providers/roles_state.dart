import '../data/models/job.dart';

class RolesState {
  final List<Job> all;
  final List<Job> filtered;
  final String searchQuery;
  final bool isLoading;
  final String? error;
  final List<int>? appliedJobIds;

  RolesState({
    required this.all,
    required this.filtered,
    required this.searchQuery,
    required this.isLoading,
    required this.error,
    this.appliedJobIds,
  });

  factory RolesState.initial() => RolesState(all: [], filtered: [], searchQuery: '', isLoading: false, error: null, appliedJobIds: []);

  RolesState copyWith({
    List<Job>? all,
    List<Job>? filtered,
    String? searchQuery,
    bool? isLoading,
    String? error,
    List<int>? appliedJobIds,
  }) {
    return RolesState(
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      appliedJobIds: appliedJobIds ?? this.appliedJobIds,
    );
  }
}