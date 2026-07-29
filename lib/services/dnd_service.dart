import 'package:flutter/services.dart';

class DndService {
  static const MethodChannel _channel =
      MethodChannel('focusforge/dnd');

  static Future<void> requestPermission() async {
    await _channel.invokeMethod('requestPermission');
  }

  static Future<void> enableDnd() async {
    await _channel.invokeMethod('enableDnd');
  }

  static Future<void> disableDnd() async {
    await _channel.invokeMethod('disableDnd');
  }
}