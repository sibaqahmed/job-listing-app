import 'package:flutter/material.dart';

class MessagesTab extends StatelessWidget {
  const MessagesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: theme.colorScheme.primary),
            SizedBox(height: 12),
            Text('Messages', style: theme.textTheme.titleLarge),
            SizedBox(height: 8),
            Text('Conversations and recruiter messages will appear here.', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
