import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/filter.dart';

class FilterButton extends StatelessWidget {
  final JobFilter initial;
  final ValueChanged<JobFilter> onApply;

  const FilterButton({Key? key, required this.initial, required this.onApply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      tooltip: 'Filters',
      onPressed: () async {
        final result = await showModalBottomSheet<JobFilter>(
          context: context,
          isScrollControlled: true,
          // OPTIMIZATION: const prevents recreating the shape object
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) => FractionallySizedBox(
            heightFactor: 0.86,
            child: _FilterSheet(initial: initial),
          ),
        );
        if (result != null) onApply(result);
      },
    );
  }
}

class _FilterSheet extends StatefulWidget {
  final JobFilter initial;
  const _FilterSheet({Key? key, required this.initial}) : super(key: key);
  @override
  __FilterSheetState createState() => __FilterSheetState();
}

class __FilterSheetState extends State<_FilterSheet> {
  // OPTIMIZATION: Cache DateFormat. Instantiating this inside build()
  // during a 60fps keyboard animation creates massive memory garbage.
  static final DateFormat _dateFormat = DateFormat.yMMMd();

  late JobFilter _f;
  final _minExpCtrl = TextEditingController();
  final _maxExpCtrl = TextEditingController();
  final _minSalaryCtrl = TextEditingController();
  final _maxSalaryCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  DateTime? _startFrom;
  DateTime? _startTo;
  bool? _active;

  @override
  void initState() {
    super.initState();
    _f = widget.initial;
    _companyCtrl.text = _f.companyName ?? '';
    if (_f.minExperience != null) _minExpCtrl.text = _f.minExperience.toString();
    if (_f.maxExperience != null) _maxExpCtrl.text = _f.maxExperience.toString();
    if (_f.minSalary != null) _minSalaryCtrl.text = _f.minSalary.toString();
    if (_f.maxSalary != null) _maxSalaryCtrl.text = _f.maxSalary.toString();
    _startFrom = _f.startDateFrom;
    _startTo = _f.startDateTo;
    _active = _f.active;
  }

  @override
  void dispose() {
    _minExpCtrl.dispose();
    _maxExpCtrl.dispose();
    _minSalaryCtrl.dispose();
    _maxSalaryCtrl.dispose();
    _companyCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext ctx, bool isFrom) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: ctx,
      initialDate: isFrom ? (_startFrom ?? now) : (_startTo ?? now),
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => isFrom ? _startFrom = picked : _startTo = picked);
  }

  void _apply() {
    final minExp = int.tryParse(_minExpCtrl.text);
    final maxExp = int.tryParse(_maxExpCtrl.text);
    final minSal = int.tryParse(_minSalaryCtrl.text);
    final maxSal = int.tryParse(_maxSalaryCtrl.text);
    final out = _f.copyWith(
      companyName: _companyCtrl.text.isEmpty ? null : _companyCtrl.text,
      minExperience: minExp,
      maxExperience: maxExp,
      minSalary: minSal,
      maxSalary: maxSal,
      startDateFrom: _startFrom,
      startDateTo: _startTo,
      active: _active,
    );
    Navigator.of(context).pop(out);
  }

  void _clear() {
    setState(() {
      _f = const JobFilter();
      _companyCtrl.clear();
      _minExpCtrl.clear();
      _maxExpCtrl.clear();
      _minSalaryCtrl.clear();
      _maxSalaryCtrl.clear();
      _startFrom = null;
      _startTo = null;
      _active = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        // This line causes the whole widget to rebuild during keyboard animation.
        // The const children below ensure it doesn't cause frame drops!
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('Filters', style: theme.textTheme.titleLarge),
                  const Spacer(),
                  TextButton(onPressed: _clear, child: const Text('Clear')),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _companyCtrl,
                decoration: const InputDecoration(labelText: 'Company'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minExpCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Min exp (yrs)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _maxExpCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Max exp (yrs)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minSalaryCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Min salary'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _maxSalaryCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Max salary'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickDate(context, true),
                      child: Text(_startFrom == null ? 'Start date from' : 'From: ${_dateFormat.format(_startFrom!)}'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickDate(context, false),
                      child: Text(_startTo == null ? 'Start date to' : 'To: ${_dateFormat.format(_startTo!)}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('Active', style: theme.textTheme.bodyMedium),
                  const Spacer(),
                  DropdownButton<bool?>(
                    value: _active,
                    items: const [
                      DropdownMenuItem(value: null, child: Text('Any')),
                      DropdownMenuItem(value: true, child: Text('Active')),
                      DropdownMenuItem(value: false, child: Text('Inactive')),
                    ],
                    onChanged: (v) => setState(() => _active = v),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _apply,
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}