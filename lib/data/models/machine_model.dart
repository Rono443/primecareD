enum MachineStatus {
  idle,
  running,
  maintenance,
  error
}

class MachineModel {
  final String id;
  final String name;
  final String type;
  final MachineStatus status;
  final double capacityKg;
  final String? currentOrderId;
  final int totalCycles;
  final int maintenanceThreshold;

  MachineModel({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.capacityKg,
    this.currentOrderId,
    this.totalCycles = 0,
    this.maintenanceThreshold = 500,
  });

  bool get needsMaintenance => totalCycles >= maintenanceThreshold;
  double get healthPercentage => ((maintenanceThreshold - totalCycles) / maintenanceThreshold).clamp(0, 1);
}
