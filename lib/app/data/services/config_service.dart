import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConfigService extends GetxService {
  late Box _settingsBox;
  static const String _thresholdKey = 'violation_threshold';
  static const String _serviceEnabledKey = 'service_enabled';
  static const double _defaultThreshold = 30.0;

  final threshold = _defaultThreshold.obs;
  final isServiceEnabled = false.obs;

  Future<ConfigService> init() async {
    _settingsBox = await Hive.openBox('settings');
    threshold.value = _settingsBox.get(_thresholdKey, defaultValue: _defaultThreshold);
    isServiceEnabled.value = _settingsBox.get(_serviceEnabledKey, defaultValue: false);
    return this;
  }

  Future<void> setThreshold(double value) async {
    await _settingsBox.put(_thresholdKey, value);
    threshold.value = value;
  }

  Future<void> setServiceEnabled(bool value) async {
    await _settingsBox.put(_serviceEnabledKey, value);
    isServiceEnabled.value = value;
  }
}
