class ConsumerModel {
  final String initials;
  final String name;
  final String time;
  final String type; // e.g., 'Retailer'
  final String quantity; // e.g., '2L/Day'
  final String status; // 'Delivered' or 'Pending'

  ConsumerModel({
    required this.initials,
    required this.name,
    required this.time,
    required this.type,
    required this.quantity,
    required this.status,
  });
}

// Dummy Data
final List<ConsumerModel> dummyConsumers = [
  ConsumerModel(initials: 'RK', name: 'Rajesh Kumar', time: '06:30 AM', type: 'Retailer', quantity: '2L/Day', status: 'Delivered'),
  ConsumerModel(initials: 'SS', name: 'Shantanu Singh', time: '06:30 AM', type: 'Retailer', quantity: '2L/Day', status: 'Pending'),
  ConsumerModel(initials: 'RK', name: 'Rajesh Kumar', time: '06:30 AM', type: 'Retailer', quantity: '2L/Day', status: 'Delivered'),
  ConsumerModel(initials: 'SS', name: 'Shantanu Singh', time: '06:30 AM', type: 'Retailer', quantity: '2L/Day', status: 'Pending'),
  ConsumerModel(initials: 'RK', name: 'Rajesh Kumar', time: '06:30 AM', type: 'Retailer', quantity: '2L/Day', status: 'Delivered'),
  ConsumerModel(initials: 'SS', name: 'Shantanu Singh', time: '06:30 AM', type: 'Retailer', quantity: '2L/Day', status: 'Pending'),
];