import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontdave_manga/domain/entities/manga.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Notifier to handle the last read chapter logic for a specific slug
class LastReadChapterNotifier extends StateNotifier<String?> {
  LastReadChapterNotifier() : super(null);

  // Load the last read chapter based on the slug
  Future<void> loadLastReadChapter(String slug) async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('lastReadChapter_$slug');
  }

  // Save the last read chapter based on the slug
  Future<void> setLastReadChapter(String slug, ChapterList chapter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastReadChapter_$slug', jsonEncode(chapter));
    state = jsonEncode(chapter);
  }
}

// Riverpod provider for the notifier
final lastReadChapterProvider =
    StateNotifierProvider<LastReadChapterNotifier, String?>(
  (ref) => LastReadChapterNotifier(),
);
