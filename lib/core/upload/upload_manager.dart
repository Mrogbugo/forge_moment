// Upload manager (FR-GIFT-006, FR-PRO-003, FRD Section 18)
// Responsibilities:
//   - Compress images without unacceptable visual loss
//   - Strip unnecessary EXIF metadata
//   - Report upload progress
//   - Support cancellation and retry
//   - Optionally use signed resumable URLs when backend provides them (FR-10.2)
// NEVER log or expose upload URLs in analytics (FR-12.4)
abstract class UploadManager {
  Future<UploadResult> uploadImage(
    String localPath, {
    String? uploadUrl,
    void Function(double progress)? onProgress,
  });

  Future<void> cancel(String uploadId);
}

class UploadResult {
  final String uploadId;
  final String remoteUrl;
  const UploadResult({required this.uploadId, required this.remoteUrl});
}
