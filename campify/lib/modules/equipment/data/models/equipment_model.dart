enum EquipmentType { rental, sale }

class Equipment {
  final String id;
  final String name;
  final EquipmentType type;
  final double price;
  final int stock;
  final String description;
  final String imageUrl;
  final String? centerId; // ID of the center owning this equipment

  Equipment({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.stock,
    required this.description,
    required this.imageUrl,
    this.centerId,
  });

  // Factory for creating a dummy equipment for testing
  factory Equipment.dummy({
    String id = '1',
    String name = 'Tent',
    EquipmentType type = EquipmentType.rental,
  }) {
    return Equipment(
      id: id,
      name: name,
      type: type,
      price: 20.0,
      stock: 10,
      description: 'A high quality $name',
      imageUrl: 'https://via.placeholder.com/150',
    );
  }
}
