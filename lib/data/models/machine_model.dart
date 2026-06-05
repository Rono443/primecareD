enum MachineStatus { idle, running, maintenance, error }

class MachineModel {
  final String id;
  final String name;
  final String type; // Washer, Dryer
  final MachineStatus status;
  final int capacityKg;
  final String? currentOrderId;

  MachineModel({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.capacityKg,
    this.currentOrderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'status': status.name,
      'capacityKg': capacityKg,
      'currentOrderId': currentOrderId,
    };
  }

  factory MachineModel.fromMap(Map<String, dynamic> map) {
    return MachineModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      status: MachineStatus.values.firstWhere((e) => e.name == map['status'], orElse: () => MachineStatus.idle),
      capacityKg: map['capacityKg'] ?? 0,
      currentOrderId: map['currentOrderId'],
    );
  }
}
