class TrainSchedule {
  final String trainId;
  final String kaName;
  final String routeName;
  final String dest;
  final String timeEst;
  final String color;
  final String destTime;

  TrainSchedule({
    required this.trainId,
    required this.kaName,
    required this.routeName,
    required this.dest,
    required this.timeEst,
    required this.color,
    required this.destTime,
  });

  factory TrainSchedule.fromJson(Map<String, dynamic> json) {
    return TrainSchedule(
      trainId: json['train_id'] ?? '',
      kaName: json['ka_name'] ?? '',
      routeName: json['route_name'] ?? '',
      dest: json['dest'] ?? '',
      timeEst: json['time_est'] ?? '',
      color: json['color'] ?? '',
      destTime: json['dest_time'] ?? '',
    );
  }
}
