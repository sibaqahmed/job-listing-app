import 'package:flutter/material.dart';
import '../../data/models/job.dart';
import 'package:intl/intl.dart';
import '../../theme/app_card.dart';

class JobCard extends StatelessWidget {
  final Job job;
  const JobCard({Key? key, required this.job}) : super(key: key);

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat.yMMMd().format(dt);
  }

  String _salaryText() {
    if (job.min_salary == null && job.max_salary == null) return '';
    if (job.min_salary != null && job.max_salary != null) {
      return '${job.min_salary} - ${job.max_salary}';
    }
    return (job.min_salary ?? job.max_salary).toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final company = (job.CompanyName ?? '').trim();
    final experience = job.min_experience != null ? '${job.min_experience} yrs' : '';
    final salary = _salaryText();
    final dateText = job.start_date != null ? _formatDate(job.start_date) : (job.created_date != null ? _formatDate(job.created_date) : '');

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        child: Row(
          children: [
            // Left: avatar / icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.work_outline, color: theme.colorScheme.primary, size: 28),
            ),

            const SizedBox(width: 12),

            // Middle: title + meta rows
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and company on one line
                  Text(
                    job.name,
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Meta rows (icons + text). Use Wrap so it adapts to narrow screens.
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (company.isNotEmpty)
                        _MetaItem(
                          icon: Icons.business,
                          label: company,
                          textStyle: textTheme.bodyMedium,
                          iconColor: theme.iconTheme.color,
                        ),

                      if (experience.isNotEmpty)
                        _MetaItem(
                          icon: Icons.timeline,
                          label: experience,
                          textStyle: textTheme.bodyMedium,
                          iconColor: theme.iconTheme.color,
                        ),
                      if (salary.isNotEmpty)
                        _MetaItem(
                          icon: Icons.monetization_on_outlined,
                          label: salary,
                          textStyle: textTheme.bodyMedium,
                          iconColor: theme.iconTheme.color,
                        ),
                      if (dateText.isNotEmpty)
                        _MetaItem(
                          icon: Icons.calendar_today_outlined,
                          label: dateText,
                          textStyle: textTheme.bodySmall,
                          iconColor: theme.iconTheme.color,
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Right: chevron
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: theme.iconTheme.color),
          ],
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextStyle? textStyle;
  final Color? iconColor;

  const _MetaItem({
    Key? key,
    required this.icon,
    required this.label,
    this.textStyle,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTextStyle = textStyle ?? Theme.of(context).textTheme.bodyMedium;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: iconColor?.withOpacity(0.9)),
        const SizedBox(width: 6),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 160),
          child: Text(
            label,
            style: effectiveTextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}