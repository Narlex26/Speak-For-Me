import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/favorite_tts.dart';
import '../../domain/usecases/favorite_usecases.dart';
import '../../../text_to_speech/data/datasources/tts_service.dart';
import '../widgets/favorites_body.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late GetFavoritesUseCase _getFavoritesUseCase;
  late RemoveFavoriteUseCase _removeFavoriteUseCase;
  late SharedPreferences _prefs;
  late TtsService _ttsService;

  List<FavoriteTTS> _favorites = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeDependencies();
  }

  Future<void> _initializeDependencies() async {
    _prefs = await SharedPreferences.getInstance();
    _getFavoritesUseCase = GetFavoritesUseCase(_prefs);
    _removeFavoriteUseCase = RemoveFavoriteUseCase(_prefs);
    _ttsService = TtsService();
    await _ttsService.initialize();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final favorites = await _getFavoritesUseCase();
      favorites.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      setState(() {
        _favorites = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement des favoris';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteFavorite(String id) async {
    try {
      await _removeFavoriteUseCase(id);
      _loadFavorites();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Favori supprimé'), duration: Duration(seconds: 2)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _reListen(String text) async {
    try {
      await _ttsService.speak(text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de lecture: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Mes Favoris',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FavoritesBody(
        isLoading: _isLoading,
        errorMessage: _errorMessage,
        favorites: _favorites,
        onRetry: _loadFavorites,
        onGoBack: () => Navigator.pop(context),
        onDelete: _deleteFavorite,
        onReListen: _reListen,
      ),
    );
  }
}
