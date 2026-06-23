part of 'translation_page.dart';

mixin _TranslationLogic on State<TranslationPage> {
  // Services & datasources
  final _translationService = TranslationService();
  final _ttsService = TtsService();
  final _audioService = AudioService();
  final _statisticsDataSource = StatisticsLocalDataSource();
  final _historyDataSource = HistoryLocalDataSource();

  // Use cases
  late AddFavoriteUseCase _addFavoriteUseCase;
  late RemoveFavoriteUseCase _removeFavoriteUseCase;
  late IsFavoriteUseCase _isFavoriteUseCase;

  // State
  bool _isExpertMode = false;
  bool _isFavorited = false;
  TranslationState _state = TranslationState.idle;
  String _analysisMessage = '';
  String _translatedText = '';
  bool _isEasterEgg = false;
  double _progress = 0.0;
  Timer? _analysisTimer;
  Timer? _progressTimer;
  int _messageIndex = 0;

  Future<void> _initializeFavoritesUseCases() async {
    final prefs = await SharedPreferences.getInstance();
    _addFavoriteUseCase = AddFavoriteUseCase(prefs);
    _removeFavoriteUseCase = RemoveFavoriteUseCase(prefs);
    _isFavoriteUseCase = IsFavoriteUseCase(prefs);
  }

  void _startRecording() async {
    final isPermanentlyDenied = await _audioService.isMicrophonePermissionPermanentlyDenied();
    if (isPermanentlyDenied) { if (mounted) _showPermissionErrorDialog(); return; }
    final permissionGranted = await _audioService.requestMicrophonePermission();
    if (!permissionGranted) { if (mounted) _showPermissionErrorDialog(); return; }
    await _audioService.playBeep(isStart: true);
    setState(() { _state = TranslationState.recording; _translatedText = ''; _isEasterEgg = false; });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted && _state == TranslationState.recording) _startAnalysis();
  }

  void _showPermissionErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Permission du microphone requise'),
        content: const Text('L\'application nécessite l\'accès au microphone. Veuillez l\'autoriser dans les paramètres.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Fermer')),
          TextButton(onPressed: () { Navigator.of(ctx).pop(); openAppSettings(); }, child: const Text('Paramètres')),
        ],
      ),
    );
  }

  void _stopRecording() { if (_state == TranslationState.recording) _startAnalysis(); }

  void _startAnalysis() async {
    await _audioService.playBeep(isStart: false);
    setState(() {
      _state = TranslationState.analyzing;
      _progress = 0.0;
      _messageIndex = 0;
      _analysisMessage = widget.profile.analysisMessages.isNotEmpty
          ? widget.profile.analysisMessages[0]
          : 'Analyse en cours...';
    });
    await _audioService.startAnalysisAmbience();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      if (_progress < 1.0) { setState(() => _progress += 0.02); } else { t.cancel(); }
    });
    _analysisTimer = Timer.periodic(const Duration(milliseconds: 800), (t) {
      if (_messageIndex < widget.profile.analysisMessages.length - 1) {
        setState(() { _messageIndex++; _analysisMessage = widget.profile.analysisMessages[_messageIndex]; });
      }
    });
    await Future.delayed(const Duration(seconds: 3));
    _analysisTimer?.cancel();
    _progressTimer?.cancel();
    await _audioService.stopAnalysisAmbience();
    if (mounted) _showResult();
  }

  void _showResult() async {
    final result = _translationService.generateTranslation(widget.profile.type);
    final translation = result.text;
    final favoriteId = '${widget.profile.type}_${translation.hashCode}';
    await _statisticsDataSource.incrementSpecimenTranslation(widget.profile.name);
    await _historyDataSource.createHistory(HistoryModel(
      profileType: widget.profile.name,
      translatedText: translation,
      timestamp: DateTime.now(),
    ));
    final isFav = await _isFavoriteUseCase(favoriteId);
    setState(() { _state = TranslationState.result; _translatedText = translation; _isEasterEgg = result.isEasterEgg; _isFavorited = isFav; });
    await Future.delayed(const Duration(milliseconds: 500));
    await _ttsService.speak(translation);
  }

  Future<void> _toggleFavorite() async {
    final favoriteId = '${widget.profile.type}_${_translatedText.hashCode}';
    try {
      if (_isFavorited) {
        await _removeFavoriteUseCase(favoriteId);
        setState(() => _isFavorited = false);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Supprimé des favoris'), duration: Duration(seconds: 1)));
      } else {
        await _addFavoriteUseCase(id: favoriteId, text: _translatedText, profileType: widget.profile.type.toString().split('.').last);
        setState(() => _isFavorited = true);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ajouté aux favoris'), duration: Duration(seconds: 1)));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red));
    }
  }

  void _openFavorites() => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesPage()));

  Future<void> _openAddPhraseSheet() async {
    final added = await showAddPhraseBottomSheet(context: context, profile: widget.profile, translationService: _translationService);
    if (!mounted || added != true) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Phrase ajoutée avec succès.'), backgroundColor: Colors.green));
    setState(() {});
  }

  void _reset() {
    _ttsService.stop();
    _audioService.stopAnalysisAmbience();
    setState(() { _state = TranslationState.idle; _translatedText = ''; _isEasterEgg = false; _progress = 0.0; _isFavorited = false; });
  }

  void _shareResult() => Share.share(_translatedText, subject: 'Traduction ${widget.profile.name}');

  (String, IconData) get _statusInfo => switch (_state) {
    TranslationState.idle      => ('Appuyez pour enregistrer', Icons.touch_app_rounded),
    TranslationState.recording => ('Écoute en cours...', Icons.hearing_rounded),
    TranslationState.analyzing => ('Traduction en cours', Icons.auto_awesome),
    TranslationState.result    => ('Traduction terminée', Icons.check_circle_rounded),
  };
}
