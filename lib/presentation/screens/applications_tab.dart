import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/roles_notifier.dart';
import '../widgets/job_card.dart';
import '../../data/models/job.dart';
import 'job_details_screen.dart';

class ApplicationsTab extends ConsumerWidget {
  const ApplicationsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activeRolesNotifierProvider);
    final notifier = ref.read(activeRolesNotifierProvider.notifier);

    final appliedIds = state.appliedJobIds ?? <int>[];

    // prefer showing applied jobs from full list (state.all) so details are available
    final all = state.all;
    final appliedJobs = all.where((j) => appliedIds.contains(j.id)).toList();

    if (state.isLoading && all.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    if (appliedJobs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.assignment_turned_in_outlined, size: 64, color: Theme.of(context).colorScheme.primary),
              SizedBox(height: 12),
              Text('No applications yet', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 8),
              Text('Apply to a job and it will appear here.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: appliedJobs.length,
      itemBuilder: (context, index) {
        final job = appliedJobs[index];
        return InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => JobDetailsScreen(job: job))),
          child: JobCard(job: job),
        );
      },
    );
  }
}
