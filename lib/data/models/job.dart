class Job {
  final int id;
  final String name;
  final String? created_by;
  final int? company_id;
  final int? no_of_positions;
  final DateTime? start_date;
  final DateTime? end_date;
  final int? min_experience;
  final int? category_id;
  final String? briefing;
  final DateTime? created_date;
  final DateTime? updated_date;
  final String? updated_by;
  final bool? active;
  final int? max_experience;
  final int? status_id;
  final int? domain_id;
  final int? referral_amount;
  final int? min_salary;
  final int? max_salary;
  final bool? hide_company_name;
  final dynamic recruiter_id;
  final String? CompanyName;
  final Map<String, dynamic> raw;

  Job({
    required this.id,
    required this.name,
    this.created_by,
    this.company_id,
    this.no_of_positions,
    this.start_date,
    this.end_date,
    this.min_experience,
    this.category_id,
    this.briefing,
    this.created_date,
    this.updated_date,
    this.updated_by,
    this.active,
    this.max_experience,
    this.status_id,
    this.domain_id,
    this.referral_amount,
    this.min_salary,
    this.max_salary,
    this.hide_company_name,
    this.recruiter_id,
    this.CompanyName,
    required this.raw,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }
    return Job(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name']?.toString() ?? '',
      created_by: json['created_by']?.toString(),
      company_id: json['company_id'] is int ? json['company_id'] : (json['company_id'] == null ? null : int.tryParse(json['company_id'].toString())),
      no_of_positions: json['no_of_positions'] is int ? json['no_of_positions'] : (json['no_of_positions'] == null ? null : int.tryParse(json['no_of_positions'].toString())),
      start_date: parseDate(json['start_date']),
      end_date: parseDate(json['end_date']),
      min_experience: json['min_experience'] is int ? json['min_experience'] : (json['min_experience'] == null ? null : int.tryParse(json['min_experience'].toString())),
      category_id: json['category_id'] is int ? json['category_id'] : (json['category_id'] == null ? null : int.tryParse(json['category_id'].toString())),
      briefing: json['briefing']?.toString(),
      created_date: parseDate(json['created_date']),
      updated_date: parseDate(json['updated_date']),
      updated_by: json['updated_by']?.toString(),
      active: json['active'] is bool ? json['active'] : (json['active'] == null ? null : json['active'].toString().toLowerCase() == 'true'),
      max_experience: json['max_experience'] is int ? json['max_experience'] : (json['max_experience'] == null ? null : int.tryParse(json['max_experience'].toString())),
      status_id: json['status_id'] is int ? json['status_id'] : (json['status_id'] == null ? null : int.tryParse(json['status_id'].toString())),
      domain_id: json['domain_id'] is int ? json['domain_id'] : (json['domain_id'] == null ? null : int.tryParse(json['domain_id'].toString())),
      referral_amount: json['referral_amount'] is int ? json['referral_amount'] : (json['referral_amount'] == null ? null : int.tryParse(json['referral_amount'].toString())),
      min_salary: json['min_salary'] is int ? json['min_salary'] : (json['min_salary'] == null ? null : int.tryParse(json['min_salary'].toString())),
      max_salary: json['max_salary'] is int ? json['max_salary'] : (json['max_salary'] == null ? null : int.tryParse(json['max_salary'].toString())),
      hide_company_name: json['hide_company_name'] is bool ? json['hide_company_name'] : (json['hide_company_name'] == null ? null : json['hide_company_name'].toString().toLowerCase() == 'true'),
      recruiter_id: json['recruiter_id'],
      CompanyName: json['CompanyName']?.toString(),
      raw: Map<String, dynamic>.from(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_by': created_by,
      'company_id': company_id,
      'no_of_positions': no_of_positions,
      'start_date': start_date?.toIso8601String(),
      'end_date': end_date?.toIso8601String(),
      'min_experience': min_experience,
      'category_id': category_id,
      'briefing': briefing,
      'created_date': created_date?.toIso8601String(),
      'updated_date': updated_date?.toIso8601String(),
      'updated_by': updated_by,
      'active': active,
      'max_experience': max_experience,
      'status_id': status_id,
      'domain_id': domain_id,
      'referral_amount': referral_amount,
      'min_salary': min_salary,
      'max_salary': max_salary,
      'hide_company_name': hide_company_name,
      'recruiter_id': recruiter_id,
      'CompanyName': CompanyName,
    };
  }
}
