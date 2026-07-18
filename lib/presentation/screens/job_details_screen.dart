import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/job.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter/services.dart';

import '../../providers/roles_notifier.dart';
import '../../theme/app_card.dart';

class JobDetailsScreen extends ConsumerStatefulWidget {
  final Job job;
  final bool archived;
  const JobDetailsScreen({Key? key, required this.job, this.archived = false}) : super(key: key);

  @override
  _JobDetailsScreenState createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends ConsumerState<JobDetailsScreen> {
  bool _briefingExpanded = false;

  // Reuse DateFormat instance
  static final DateFormat _dateFormat = DateFormat.yMMMMd().add_jm();

  // Precomputed values to avoid doing work in build()
  late final String _rawPretty;
  late final String _briefingHtml;
  late final String _briefingUnescaped;
  late final String _briefingPreview;

  @override
  void initState() {
    super.initState();
    _rawPretty = const JsonEncoder.withIndent('  ').convert(widget.job.raw);
    _briefingHtml = widget.job.briefing ?? '';
    _briefingUnescaped = HtmlUnescape().convert(_briefingHtml);
    _briefingPreview = _previewText(_briefingHtml);
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    return _dateFormat.format(dt);
  }

  Widget _row(String label, String value) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600))),
          Expanded(child: SelectableText(value, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }

  String _stripHtmlTags(String html) {
    final withoutEntities = HtmlUnescape().convert(html);
    return withoutEntities.replaceAll(RegExp(r'<[^>]*>'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String _previewText(String html, {int maxChars = 220}) {
    final plain = _stripHtmlTags(html);
    if (plain.length <= maxChars) return plain;
    return plain.substring(0, maxChars).trim() + '…';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final job = widget.job;


    final bool jobIsArchived = widget.archived || (job.active == false);

    final notifier = jobIsArchived
        ? ref.read(archivedRolesNotifierProvider.notifier)
        : ref.read(activeRolesNotifierProvider.notifier);

    final appliedActive = ref.watch(activeRolesNotifierProvider.select((s) => s.appliedJobIds?.contains(job.id) ?? false));
    final appliedArchived = ref.watch(archivedRolesNotifierProvider.select((s) => s.appliedJobIds?.contains(job.id) ?? false));
    final applied = appliedActive || appliedArchived;

    return Scaffold(
      appBar: AppBar(title: Text(job.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row with optional Archived chip
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    job.name,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold) ??
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                if (jobIsArchived)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark ? Colors.white10 : Colors.black12,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Archived', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
                  ),
              ],
            ),

            const SizedBox(height: 8),
            Text(job.CompanyName ?? '', style: theme.textTheme.titleMedium),
            const Divider(height: 24),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row('Start Date', _formatDate(job.start_date)),
                  _row('End Date', _formatDate(job.end_date)),
                  _row('Experience', '${job.min_experience ?? '—'} to ${job.max_experience ?? '—'} yrs'),
                  _row('Positions', job.no_of_positions?.toString() ?? '—'),
                  _row('Salary', job.min_salary != null ? '${job.min_salary} - ${job.max_salary}' : '—'),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Text('Briefing', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),

            if (_briefingHtml.trim().isEmpty)
              Text('—', style: theme.textTheme.bodyMedium)
            else
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_briefingPreview, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text(_briefingExpanded ? 'Show less' : 'Read more'),
                          onPressed: () => setState(() => _briefingExpanded = !_briefingExpanded),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '(Rendered from HTML using flutter_html)',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                    if (_briefingExpanded)
                      Builder(builder: (context) {
                        try {
                          return Html(data: _briefingUnescaped);
                        } catch (_) {
                          final plain = _stripHtmlTags(_briefingHtml);
                          return SelectableText(plain, style: theme.textTheme.bodyMedium);
                        }
                      }),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            AppCard(
              child: ExpansionTile(
                backgroundColor: theme.cardColor,
                title: Text('Show raw JSON', style: theme.textTheme.titleMedium),
                trailing: IconButton(
                  icon: Icon(Icons.copy, size: 18, color: theme.iconTheme.color),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _rawPretty));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Raw JSON copied to clipboard')));
                  },
                  tooltip: 'Copy JSON',
                ),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: theme.scaffoldBackgroundColor,
                    child: SelectableText(_rawPretty, style: theme.textTheme.bodySmall),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Buttons: Apply and Withdraw
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: jobIsArchived && !applied
                        ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('This role has ended and is no longer accepting applications.')),
                      );
                    }
                        : () async {
                      // Capture the pre-interaction state to know which message to display
                      final wasApplied = applied;

                      await notifier.toggleApply(widget.job.id);

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            wasApplied ? 'Application withdrawn' : 'Application submitted',
                          ),
                        ),
                      );
                    },
                    child: Text(applied ? 'Withdraw Application' : 'Apply Now'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error.withOpacity(0.8),
                    ),
                    onPressed: applied
                        ? () async {
                      await notifier.toggleApply(widget.job.id);

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Application withdrawn')),
                      );
                    }
                        : null,
                    child: const Text('Withdraw'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}