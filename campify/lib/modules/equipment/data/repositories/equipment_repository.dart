import '../models/equipment_model.dart';

abstract class EquipmentRepository {
  Future<List<Equipment>> getRentalCatalog(String centerId);
  Future<List<Equipment>> getSalesCatalog(String centerId);
  Future<List<Equipment>> getInventory(String centerId);
}

class MockEquipmentRepository implements EquipmentRepository {
  @override
  Future<List<Equipment>> getRentalCatalog(String centerId) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return [
      Equipment(
        id: '1',
        name: '2-Person Tent',
        type: EquipmentType.rental,
        price: 15.0,
        stock: 5,
        description: 'Compact tent for 2 people.',
        imageUrl: 'https://via.placeholder.com/150',
        centerId: centerId,
      ),
      Equipment(
        id: '2',
        name: 'Sleeping Bag',
        type: EquipmentType.rental,
        price: 5.0,
        stock: 20,
        description: 'Warm sleeping bag.',
        imageUrl: 'https://via.placeholder.com/150',
        centerId: centerId,
      ),
    ];
  }

  @override
  Future<List<Equipment>> getSalesCatalog(String centerId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Equipment(
        id: '3',
        name: 'Camping Stove (New)',
        type: EquipmentType.sale,
        price: 45.0,
        stock: 3,
        description: 'Portable gas stove.',
        imageUrl: 'https://via.placeholder.com/150',
        centerId: centerId,
      ),
    ];
  }

  @override
  Future<List<Equipment>> getInventory(String centerId) async {
    // Admin sees everything
    final rentals = await getRentalCatalog(centerId);
    final sales = await getSalesCatalog(centerId);
    return [...rentals, ...sales];
  }
}
