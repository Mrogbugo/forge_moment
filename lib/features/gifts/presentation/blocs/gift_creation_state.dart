part of 'gift_creation_bloc.dart';

enum GiftCreationStep {
  template,
  personalise,
  recipient,
  review,
  payment,
  success,
}

class GiftCreationState extends Equatable {
  final GiftCreationStep step;
  final List<Map<String, dynamic>> templates;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> musicTracks;
  final String? selectedTemplateId;
  final Map<String, dynamic>? selectedTemplate;
  final String? message;
  final double? monetaryAmount;
  final List<String> localMediaPaths;
  final List<String> uploadedMediaUrls;
  final String? musicTrackId;
  final bool anonymous;
  final String? recipientName;
  final String? recipientContact;
  final DeliveryMethod? deliveryMethod;
  final Gift? savedDraft;
  final bool isLoading;
  final String? errorMessage;
  final double mediaUploadProgress;

  const GiftCreationState({
    required this.step,
    required this.templates,
    required this.categories,
    required this.musicTracks,
    this.selectedTemplateId,
    this.selectedTemplate,
    this.message,
    this.monetaryAmount,
    required this.localMediaPaths,
    required this.uploadedMediaUrls,
    this.musicTrackId,
    required this.anonymous,
    this.recipientName,
    this.recipientContact,
    this.deliveryMethod,
    this.savedDraft,
    required this.isLoading,
    this.errorMessage,
    required this.mediaUploadProgress,
  });

  const GiftCreationState.initial()
      : step = GiftCreationStep.template,
        templates = const [],
        categories = const [],
        musicTracks = const [],
        selectedTemplateId = null,
        selectedTemplate = null,
        message = null,
        monetaryAmount = null,
        localMediaPaths = const [],
        uploadedMediaUrls = const [],
        musicTrackId = null,
        anonymous = false,
        recipientName = null,
        recipientContact = null,
        deliveryMethod = null,
        savedDraft = null,
        isLoading = false,
        errorMessage = null,
        mediaUploadProgress = 0.0;

  GiftCreationState copyWith({
    GiftCreationStep? step,
    List<Map<String, dynamic>>? templates,
    List<Map<String, dynamic>>? categories,
    List<Map<String, dynamic>>? musicTracks,
    String? selectedTemplateId,
    Map<String, dynamic>? selectedTemplate,
    String? message,
    double? monetaryAmount,
    List<String>? localMediaPaths,
    List<String>? uploadedMediaUrls,
    String? musicTrackId,
    bool? anonymous,
    String? recipientName,
    String? recipientContact,
    DeliveryMethod? deliveryMethod,
    Gift? savedDraft,
    bool? isLoading,
    String? errorMessage,
    double? mediaUploadProgress,
    bool clearMusicTrackId = false,
    bool clearErrorMessage = false,
  }) {
    return GiftCreationState(
      step: step ?? this.step,
      templates: templates ?? this.templates,
      categories: categories ?? this.categories,
      musicTracks: musicTracks ?? this.musicTracks,
      selectedTemplateId: selectedTemplateId ?? this.selectedTemplateId,
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      message: message ?? this.message,
      monetaryAmount: monetaryAmount ?? this.monetaryAmount,
      localMediaPaths: localMediaPaths ?? this.localMediaPaths,
      uploadedMediaUrls: uploadedMediaUrls ?? this.uploadedMediaUrls,
      musicTrackId: clearMusicTrackId ? null : (musicTrackId ?? this.musicTrackId),
      anonymous: anonymous ?? this.anonymous,
      recipientName: recipientName ?? this.recipientName,
      recipientContact: recipientContact ?? this.recipientContact,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      savedDraft: savedDraft ?? this.savedDraft,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      mediaUploadProgress: mediaUploadProgress ?? this.mediaUploadProgress,
    );
  }

  @override
  List<Object?> get props => [
        step,
        templates,
        categories,
        musicTracks,
        selectedTemplateId,
        selectedTemplate,
        message,
        monetaryAmount,
        localMediaPaths,
        uploadedMediaUrls,
        musicTrackId,
        anonymous,
        recipientName,
        recipientContact,
        deliveryMethod,
        savedDraft,
        isLoading,
        errorMessage,
        mediaUploadProgress,
      ];
}
