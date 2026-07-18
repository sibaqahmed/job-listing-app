// lib/data/models/job_filter.dart
class JobFilter {
  final String keyword;
  final String? companyName;
  final int? minExperience;
  final int? maxExperience;
  final int? minSalary;
  final int? maxSalary;
  final DateTime? startDateFrom;
  final DateTime? startDateTo;
  final bool? active;
  final int? categoryId;
  final int? domainId;
  final int? statusId;
  final int? minPositions;
  final int? maxPositions;
  final int? minReferral;
  final int? maxReferral;
  final String? location; // best-effort extracted from briefing

  const JobFilter({
    this.keyword = '',
    this.companyName,
    this.minExperience,
    this.maxExperience,
    this.minSalary,
    this.maxSalary,
    this.startDateFrom,
    this.startDateTo,
    this.active,
    this.categoryId,
    this.domainId,
    this.statusId,
    this.minPositions,
    this.maxPositions,
    this.minReferral,
    this.maxReferral,
    this.location,
  });

  JobFilter copyWith({
    String? keyword,
    String? companyName,
    int? minExperience,
    int? maxExperience,
    int? minSalary,
    int? maxSalary,
    DateTime? startDateFrom,
    DateTime? startDateTo,
    bool? active,
    int? categoryId,
    int? domainId,
    int? statusId,
    int? minPositions,
    int? maxPositions,
    int? minReferral,
    int? maxReferral,
    String? location,
  }) {
    return JobFilter(
      keyword: keyword ?? this.keyword,
      companyName: companyName ?? this.companyName,
      minExperience: minExperience ?? this.minExperience,
      maxExperience: maxExperience ?? this.maxExperience,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      startDateFrom: startDateFrom ?? this.startDateFrom,
      startDateTo: startDateTo ?? this.startDateTo,
      active: active ?? this.active,
      categoryId: categoryId ?? this.categoryId,
      domainId: domainId ?? this.domainId,
      statusId: statusId ?? this.statusId,
      minPositions: minPositions ?? this.minPositions,
      maxPositions: maxPositions ?? this.maxPositions,
      minReferral: minReferral ?? this.minReferral,
      maxReferral: maxReferral ?? this.maxReferral,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toJson() => {
    'keyword': keyword,
    'companyName': companyName,
    'minExperience': minExperience,
    'maxExperience': maxExperience,
    'minSalary': minSalary,
    'maxSalary': maxSalary,
    'startDateFrom': startDateFrom?.toIso8601String(),
    'startDateTo': startDateTo?.toIso8601String(),
    'active': active,
    'categoryId': categoryId,
    'domainId': domainId,
    'statusId': statusId,
    'minPositions': minPositions,
    'maxPositions': maxPositions,
    'minReferral': minReferral,
    'maxReferral': maxReferral,
    'location': location,
  };

  static JobFilter fromJson(Map<String, dynamic> j) => JobFilter(
    keyword: j['keyword'] ?? '',
    companyName: j['companyName'],
    minExperience: j['minExperience'],
    maxExperience: j['maxExperience'],
    minSalary: j['minSalary'],
    maxSalary: j['maxSalary'],
    startDateFrom: j['startDateFrom'] != null ? DateTime.parse(j['startDateFrom']) : null,
    startDateTo: j['startDateTo'] != null ? DateTime.parse(j['startDateTo']) : null,
    active: j['active'],
    categoryId: j['categoryId'],
    domainId: j['domainId'],
    statusId: j['statusId'],
    minPositions: j['minPositions'],
    maxPositions: j['maxPositions'],
    minReferral: j['minReferral'],
    maxReferral: j['maxReferral'],
    location: j['location'],
  );
}
