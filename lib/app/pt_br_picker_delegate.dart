import 'dart:ui';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class PtBrPickerDelegate
    implements CameraPickerTextDelegate, AssetPickerTextDelegate {
  @override
  String get confirm => 'Confirmar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get edit => 'Editar';

  @override
  String get preview => 'Visualizar';

  @override
  String get emptyList => 'Nenhum item encontrado';

  @override
  String get select => 'Selecionar';

  @override
  String get original => 'Original';

  @override
  String get accessAllTip => 'Permitir acesso a todas as fotos';

  @override
  String get accessLimitedAssets => 'Aceder a fotos limitadas';

  @override
  String get accessiblePathName => 'Fotos Acessíveis';

  @override
  String get changeAccessibleLimitedAssets => 'Mudar fotos acessíveis';

  @override
  String? get countryCode => 'BR';

  @override
  String durationIndicatorBuilder(Duration duration) {
    final String min = duration.inMinutes.toString().padLeft(2, '0');
    final String sec = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  String get gifIndicator => 'GIF';

  @override
  String get goToSystemSettings => 'Ir para Configurações';

  @override
  String get languageCode => 'pt';

  @override
  String get livePhotoIndicator => 'LIVE';

  @override
  String get loadFailed => 'Falha ao carregar';

  @override
  String get loading => 'A carregar...';

  @override
  Locale get locale => const Locale('pt', 'BR');

  @override
  String get sActionManuallyFocusHint => 'Tocar para focar';

  @override
  String get sActionPlayHint => 'Tocar para reproduzir';

  @override
  String get sActionPreviewHint => 'Tocar para visualizar';

  @override
  String get sActionRecordHint => 'Segurar para gravar vídeo';

  @override
  String get sActionSelectHint => 'Tocar para selecionar';

  @override
  String get sActionShootHint => 'Tocar para tirar foto';

  @override
  String get sActionShootingButtonTooltip => 'Botão de disparo';

  @override
  String get sActionStopRecordingHint => 'Soltar para parar gravação';

  @override
  String get sActionSwitchPathLabel => 'Mudar álbum';

  @override
  String get sActionUseCameraHint => 'Tocar para usar câmara';

  @override
  String sCameraLensDirectionLabel(CameraLensDirection value) {
    return value == CameraLensDirection.front ? 'frontal' : 'traseira';
  }

  @override
  String? sCameraPreviewLabel(CameraLensDirection? value) {
    return 'Pré-visualização da câmara';
  }

  @override
  String sFlashModeLabel(FlashMode mode) {
    switch (mode) {
      case FlashMode.auto:
        return 'Auto';
      case FlashMode.torch:
        return 'Ligado';
      case FlashMode.off:
        return 'Desligado';
      default:
        return 'Flash';
    }
  }

  @override
  String get sNameDurationLabel => 'Duração';

  @override
  String sSwitchCameraLensDirectionLabel(CameraLensDirection value) {
    return value == CameraLensDirection.front
        ? 'Mudar para câmara traseira'
        : 'Mudar para câmara frontal';
  }

  @override
  String get sTypeAudioLabel => 'Áudio';

  @override
  String get sTypeImageLabel => 'Imagem';

  @override
  String get sTypeOtherLabel => 'Outro';

  @override
  String get sTypeVideoLabel => 'Vídeo';

  @override
  String get sUnitAssetCountLabel => 'itens';

  @override
  String get saving => 'A guardar...';

  @override
  String? get scriptCode => null;

  @override
  String semanticTypeLabel(AssetType type) {
    switch (type) {
      case AssetType.audio:
        return sTypeAudioLabel;
      case AssetType.image:
        return sTypeImageLabel;
      case AssetType.video:
        return sTypeVideoLabel;
      case AssetType.other:
        return sTypeOtherLabel;
    }
  }

  @override
  AssetPickerTextDelegate get semanticsTextDelegate => this;

  @override
  String get shootingOnlyRecordingTips => 'Segure o botão para gravar vídeo';

  @override
  String get shootingTapRecordingTips => 'Toque no botão para gravar vídeo';

  @override
  String get shootingTips => 'Toque para foto, segure para vídeo';

  @override
  String get shootingWithRecordingTips => 'Toque para foto, segure para vídeo';

  @override
  String get unSupportedAssetType => 'Tipo de ficheiro não suportado';

  @override
  String get unableToAccessAll => 'Não é possível aceder a todas as fotos';

  @override
  String get viewingLimitedAssetsTip =>
      'A visualizar fotos com acesso limitado';
}
