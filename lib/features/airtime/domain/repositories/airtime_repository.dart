import '../entities/airtime_pool.dart';

abstract class AirtimeRepository {
  Future<AirtimePool> createPool(Map<String, dynamic> payload);
  Future<void> initializePayment(String poolId, String paymentMethod);
  Future<AirtimePool> verifyPayment(String poolId, String reference);
  Future<AirtimePool> getPool(String poolId);
}
