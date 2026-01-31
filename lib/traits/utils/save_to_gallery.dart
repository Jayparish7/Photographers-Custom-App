import 'dart:convert';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/shared_preference_constants.dart';

class ScrollOffsetManager {
  // Method to update or add a scroll offset for a specific event code
  Future<void> updateScrollOffset(String folderCode, double offset) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the existing map from SharedPreferences
    String? offsetData = prefs.getString(scrollOffsetKey);
    Map<String, double> offsetMap = offsetData != null
        ? Map<String, double>.from(jsonDecode(offsetData))
        : {};

    // Update or add the offset for the specified event code
    offsetMap[folderCode] = offset;

    // Save the updated map back to SharedPreferences
    await prefs.setString(scrollOffsetKey, jsonEncode(offsetMap));
  }

  // Method to retrieve the scroll offset for a specific event code
  Future<double?> getScrollOffset(String folderCode) async {
    final prefs = await SharedPreferences.getInstance();
    String? offsetData = prefs.getString(scrollOffsetKey);
    showLog('getScrollOffset $offsetData');
    if (offsetData != null) {
      Map<String, double> offsetMap =
          Map<String, double>.from(jsonDecode(offsetData));
      return offsetMap[folderCode];
    }

    return null;
  }
}

class ScrollIndexManager {
  // Method to update or add a scroll index for a specific event code
  Future<void> updateScrollIndex(String folderCode, int index) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the existing map from SharedPreferences
    String? indexData = prefs.getString(scrollIndexKey);
    Map<String, int> indexMap =
        indexData != null ? Map<String, int>.from(jsonDecode(indexData)) : {};

    // Update or add the index for the specified event code
    indexMap[folderCode] = index;

    // Save the updated map back to SharedPreferences
    await prefs.setString(scrollIndexKey, jsonEncode(indexMap));
  }

  // Method to retrieve the scroll index for a specific event code
  Future<int?> getScrollIndex(String folderCode) async {
    final prefs = await SharedPreferences.getInstance();
    String? indexData = prefs.getString(scrollIndexKey);
    showLog('getScrollIndex $indexData');
    if (indexData != null) {
      Map<String, int> indexMap = Map<String, int>.from(jsonDecode(indexData));
      return indexMap[folderCode];
    }

    return null;
  }
}
