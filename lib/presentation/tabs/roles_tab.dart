// lib/presentation/screens/roles_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/roles_notifier.dart';
import '../screens/job_details_screen.dart';
import '../widgets/search_bar.dart';
import '../widgets/job_card.dart';
import '../../providers/roles_state.dart';
import '../../data/models/filter.dart';
import '../widgets/filter_button.dart';

class RolesTab extends ConsumerStatefulWidget {
  final bool archived;
  const RolesTab({Key? key, required this.archived}) : super(key: key);

  @override
  _RolesTabState createState() => _RolesTabState();
}

class _RolesTabState extends ConsumerState<RolesTab> with AutomaticKeepAliveClientMixin {
  JobFilter _currentFilter = const JobFilter();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = widget.archived
          ? ref.read(archivedRolesNotifierProvider.notifier)
          : ref.read(activeRolesNotifierProvider.notifier);
      notifier.loadRoles();
    });
  }

  bool get _hasAnyFilter {
    final f = _currentFilter;
    return f.keyword.isNotEmpty ||
        (f.companyName != null && f.companyName!.isNotEmpty) ||
        f.minExperience != null ||
        f.maxExperience != null ||
        f.minSalary != null ||
        f.maxSalary != null ||
        (f.location != null && f.location!.isNotEmpty) ||
        f.active != null ||
        f.categoryId != null ||
        f.domainId != null ||
        f.statusId != null ||
        f.minReferral != null ||
        f.maxReferral != null ||
        f.minPositions != null ||
        f.maxPositions != null;
  }

  void _applyFilterFromSheet(JobFilter f) {
    setState(() => _currentFilter = f);
    final notifier = widget.archived
        ? ref.read(archivedRolesNotifierProvider.notifier)
        : ref.read(activeRolesNotifierProvider.notifier);
    notifier.setFilters(f);
    notifier.applyFilters();
  }

  void _clearSingleFilterField(String field) {
    JobFilter updated;
    switch (field) {
      case 'keyword':
        updated = _currentFilter.copyWith(keyword: '');
        break;
      case 'company':
        updated = _currentFilter.copyWith(companyName: null);
        break;
      case 'experience':
        updated = _currentFilter.copyWith(minExperience: null, maxExperience: null);
        break;
      case 'salary':
        updated = _currentFilter.copyWith(minSalary: null, maxSalary: null);
        break;
      case 'location':
        updated = _currentFilter.copyWith(location: null);
        break;
      case 'active':
        updated = _currentFilter.copyWith(active: null);
        break;
      case 'referral':
        updated = _currentFilter.copyWith(minReferral: null, maxReferral: null);
        break;
      case 'positions':
        updated = _currentFilter.copyWith(minPositions: null, maxPositions: null);
        break;
      default:
        updated = const JobFilter();
    }

    setState(() => _currentFilter = updated);
    final notifier = widget.archived
        ? ref.read(archivedRolesNotifierProvider.notifier)
        : ref.read(activeRolesNotifierProvider.notifier);
    notifier.setFilters(updated);
    notifier.applyFilters();
  }

  void _clearAllFilters() {
    setState(() => _currentFilter = const JobFilter());
    final notifier = widget.archived
        ? ref.read(archivedRolesNotifierProvider.notifier)
        : ref.read(activeRolesNotifierProvider.notifier);
    notifier.clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Watch only the slices we need to minimize rebuilds
    final isLoading = widget.archived
        ? ref.watch(archivedRolesNotifierProvider.select((s) => s.isLoading))
        : ref.watch(activeRolesNotifierProvider.select((s) => s.isLoading));

    final error = widget.archived
        ? ref.watch(archivedRolesNotifierProvider.select((s) => s.error))
        : ref.watch(activeRolesNotifierProvider.select((s) => s.error));

    final filtered = widget.archived
        ? ref.watch(archivedRolesNotifierProvider.select((s) => s.filtered))
        : ref.watch(activeRolesNotifierProvider.select((s) => s.filtered));

    final searchQuery = widget.archived
        ? ref.watch(archivedRolesNotifierProvider.select((s) => s.searchQuery))
        : ref.watch(activeRolesNotifierProvider.select((s) => s.searchQuery));

    final notifier = widget.archived ? ref.read(archivedRolesNotifierProvider.notifier) : ref.read(activeRolesNotifierProvider.notifier);
    final theme = Theme.of(context);

    return Column(
      children: [
        // Search + Filter row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: SearchBarr(
                  initialValue: searchQuery,
                  // IMPORTANT: only setSearchQuery here. RolesNotifier.setSearchQuery performs local filtering.
                  onChanged: (q) {
                    notifier.setSearchQuery(q);
                  },
                  onClear: () {
                    notifier.setSearchQuery('');
                  },
                ),
              ),
              const SizedBox(width: 8),
              FilterButton(
                initial: _currentFilter,
                onApply: (f) => _applyFilterFromSheet(f),
              ),
            ],
          ),
        ),

        // Active filter chips (clean, wrapped)
        if (_hasAnyFilter)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (_currentFilter.keyword.isNotEmpty)
                  InputChip(
                    label: Text('Keyword: ${_currentFilter.keyword}'),
                    onDeleted: () => _clearSingleFilterField('keyword'),
                  ),
                if (_currentFilter.companyName != null && _currentFilter.companyName!.isNotEmpty)
                  InputChip(
                    label: Text('Company: ${_currentFilter.companyName}'),
                    onDeleted: () => _clearSingleFilterField('company'),
                  ),
                if (_currentFilter.minExperience != null || _currentFilter.maxExperience != null)
                  InputChip(
                    label: Text('Exp: ${_currentFilter.minExperience ?? '-'} - ${_currentFilter.maxExperience ?? '-'} yrs'),
                    onDeleted: () => _clearSingleFilterField('experience'),
                  ),
                if (_currentFilter.minSalary != null || _currentFilter.maxSalary != null)
                  InputChip(
                    label: Text('Salary: ${_currentFilter.minSalary ?? '-'} - ${_currentFilter.maxSalary ?? '-'}'),
                    onDeleted: () => _clearSingleFilterField('salary'),
                  ),
                if (_currentFilter.location != null && _currentFilter.location!.isNotEmpty)
                  InputChip(
                    label: Text('Location: ${_currentFilter.location}'),
                    onDeleted: () => _clearSingleFilterField('location'),
                  ),
                if (_currentFilter.active != null)
                  InputChip(
                    label: Text(_currentFilter.active == true ? 'Active' : 'Inactive'),
                    onDeleted: () => _clearSingleFilterField('active'),
                  ),
                if (_currentFilter.minReferral != null || _currentFilter.maxReferral != null)
                  InputChip(
                    label: Text('Referral: ${_currentFilter.minReferral ?? '-'} - ${_currentFilter.maxReferral ?? '-'}'),
                    onDeleted: () => _clearSingleFilterField('referral'),
                  ),
                if (_currentFilter.minPositions != null || _currentFilter.maxPositions != null)
                  InputChip(
                    label: Text('Positions: ${_currentFilter.minPositions ?? '-'} - ${_currentFilter.maxPositions ?? '-'}'),
                    onDeleted: () => _clearSingleFilterField('positions'),
                  ),
                ActionChip(
                  label: const Text('Clear all'),
                  onPressed: _clearAllFilters,
                ),
              ],
            ),
          ),

        // Main list area
        Expanded(
          child: Builder(builder: (_) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (error != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Error: $error', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: () => notifier.refresh(), child: const Text('Retry')),
                  ],
                ),
              );
            }

            if (filtered.isEmpty) {
              return Center(child: Text('No roles found.', style: theme.textTheme.bodyMedium));
            }

            return ListView.builder(
              key: PageStorageKey(widget.archived ? 'archived_list' : 'active_list'),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final job = filtered[index];
                return RepaintBoundary(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => JobDetailsScreen(job: job, archived: widget.archived)));
                    },
                    child: JobCard(job: job),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
