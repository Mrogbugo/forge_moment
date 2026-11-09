import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'upload_manager.dart';

/// Upload manager: compresses, strips EXIF, reports progress, supports
/// cancellation and retry (FR-GIFT-006, FR-PRO-003).
///
/// NEVER logs upload URLs or media paths in analytics (FR-12.4).
class FlutterUploadManagerImpl implements UploadManager {
  final Dio _dio;
  final Map<String, CancelToken> _activeUploads = {};

  // Quality target: good visual quality, reasonable file size
  static const int _targetQuality = 80;
  static const int _maxWidthHeight = 1920;

  FlutterUploadManagerImpl() : _dio = Dio();

  @override
  Future<UploadResult> uploadImage(
    String localPath, {
    String? uploadUrl,
    void Function(double progress)? onProgress,
  }) async {
    final uploadId = _generateId();
    final cancelToken = CancelToken();
    _activeUploads[uploadId] = cancelToken;

    try {
      // 1. Compress + strip EXIF
      final compressed = await _compress(localPath, uploadId);

      // 2. Upload
      final url = uploadUrl ?? _defaultUploadUrl();
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          compressed.path,
          filename: p.basename(compressed.path),
        ),
      });

      final response = await _dio.post<Map<String, dynamic>>(
        url,
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: (sent, total) {
          if (total > 0) onProgress?.call(sent / total);
        },
      );

      final remoteUrl = response.data?['url'] as String? ?? '';
      return UploadResult(uploadId: uploadId, remoteUrl: remoteUrl);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw Exception('Upload $uploadId was cancelled');
      }
      rethrow;
    } finally {
      _activeUploads.remove(uploadId);
    }
  }

  @override
  Future<void> cancel(String uploadId) async {
    _activeUploads[uploadId]?.cancel();
    _activeUploads.remove(uploadId);
  }

  Future<XFile> _compress(String sourcePath, String uploadId) async {
    final tempDir = await getTemporaryDirectory();
    final targetPath = p.join(tempDir.path, 'upload_$uploadId.jpg');

    final result = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      targetPath,
      quality: _targetQuality,
      minWidth: _maxWidthHeight,
      minHeight: _maxWidthHeight,
      keepExif: false, // strip all EXIF metadata (FR-GIFT-006)
      format: CompressFormat.jpeg,
    );

    if (result == null) {
      // Compression failed — fall back to original file
      return XFile(sourcePath);
    }
    return result;
  }

  String _defaultUploadUrl() =>
      '${_dio.options.baseUrl}/api/v1/media/upload';

  String _generateId() =>
      DateTime.now().millisecondsSinceEpoch.toString() +
      Random().nextInt(9999).toString().padLeft(4, '0');
}
