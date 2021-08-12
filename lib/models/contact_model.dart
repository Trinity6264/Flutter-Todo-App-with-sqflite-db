class ContactHelper {
  final String name;
  final String number;
  final String time;

  ContactHelper({required this.name, required this.number, required this.time});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
      'time': time,
    };
  }

  factory ContactHelper.fromJson(Map<String, dynamic> json) {
    return ContactHelper(
      name: json['name'],
      number: json['number'],
      time: json['time'],
    );
  }
}
