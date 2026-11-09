import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints/api_endpoints.dart';
import '../../domain/entities/airtime_pool.dart';
import '../../domain/repositories/airtime_repository.dart';

class AirtimeRepositoryImpl implements AirtimeRepository {
  final ApiClient _api;
  AirtimeRepositoryImpl({required ApiClient api}) : _api = api;

  AirtimePool _parse(Map<String, dynamic> j) => AirtimePool(
        id: j['id'] as String,
        amountPerClaim: (j['amount_per_claim'] as num).toDouble(),
        maxClaims: j['max_claims'] as int,
        claimsMade: j['claims_made'] as int? ?? 0,
        status: AirtimePoolStatus.values.firstWhere(
            (s) => s.name == (j['status'] as String? ?? 'pendingPayment'),
            orElse: () => AirtimePoolStatus.pendingPayment),
        publicLink: j['public_link'] as String?,
        message: j['message'] as String?,
        anonymous: j['anonymous'] as bool? ?? false,
        expiresAt: j['expires_at'] != null
            ? DateTime.parse(j['expires_at'] as String)
            : null,
      );

  @override
  Future<AirtimePool> createPool(Map<String, dynamic> payload) async {
    final res = await _api.post(ApiEndpoints.airtimePool, body: payload,
        idempotencyKey: 'airtime-create-${DateTime.now().millisecondsSinceEpoch}');
    return _parse(res);
  }

  @override
  Future<void> initializePayment(String poolId, String paymentMethod) =>
      _api.post('${ApiEndpoints.airtimePool}/$poolId/payment',
          body: {'method': paymentMethod},
          idempotencyKey: 'airtime-pay-$poolId');

  @override
  Future<AirtimePool> verifyPayment(String poolId, String reference) async {
    final res = await _api.post(
      ApiEndpoints.airtimePaymentVerify.replaceFirst('{id}', poolId),
      body: {'reference': reference},
    );
    return _parse(res);
  }

  @override
  Future<AirtimePool> getPool(String poolId) async {
    final res = await _api.get('${ApiEndpoints.airtimePool}/$poolId');
    return _parse(res);
  }
}
