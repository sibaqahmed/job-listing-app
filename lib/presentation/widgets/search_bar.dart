// lib/presentation/widgets/search_bar.dart
import 'dart:async';
import 'package:flutter/material.dart';

class SearchBarr extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  /// If zero duration, input is forwarded immediately on every keystroke.
  final Duration debounceDuration;

  const SearchBarr({
    Key? key,
    this.initialValue = '',
    required this.onChanged,
    this.onClear,
    this.debounceDuration = Duration.zero,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBarr> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    // If immediate mode (zero), we still keep controller listener for UI only.
    if (widget.debounceDuration == Duration.zero) {
      _controller.addListener(_immediateListener);
    }
  }

  @override
  void didUpdateWidget(covariant SearchBarr oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue && widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
    // If debounce mode changed, adjust listener behavior
    if (oldWidget.debounceDuration == Duration.zero && widget.debounceDuration != Duration.zero) {
      _controller.removeListener(_immediateListener);
    } else if (oldWidget.debounceDuration != Duration.zero && widget.debounceDuration == Duration.zero) {
      _controller.addListener(_immediateListener);
    }
  }

  void _immediateListener() {
    // forward immediately on every keystroke
    widget.onChanged(_controller.text);
  }

  void _onTextChangedDebounced(String text) {
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged(text);
    });
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    widget.onClear?.call();
    // Immediately notify upstream that query cleared
    widget.onChanged('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (widget.debounceDuration == Duration.zero) {
      _controller.removeListener(_immediateListener);
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, child) {
        final hasText = value.text.isNotEmpty;
        return TextField(
          controller: _controller,
          textInputAction: TextInputAction.search,
          onChanged: widget.debounceDuration == Duration.zero
              ? null // handled by controller listener for immediate mode
              : _onTextChangedDebounced,
          onSubmitted: (s) {
            // bypass debounce on submit
            _debounce?.cancel();
            widget.onChanged(s);
          },
          decoration: InputDecoration(
            hintText: 'Search by title or company',
            prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
            suffixIcon: hasText
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clear,
              splashRadius: 18,
            )
                : null,
            filled: true,
            fillColor: theme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),
        );
      },
    );
  }
}
