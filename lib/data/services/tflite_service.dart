import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TfliteService {
  factory TfliteService() => _instance;
  TfliteService._internal();

  static final TfliteService _instance = TfliteService._internal();

  Interpreter? _phishing;
  Interpreter? _malware;
  Interpreter? _wifi;
  Future<void>? _initFuture;
  bool _initialized = false;

  bool get isPhishingReady => _phishing != null;
  bool get isMalwareReady => _malware != null;
  bool get isWifiReady => _wifi != null;
  bool get isReady => _phishing != null && _malware != null && _wifi != null;

  Future<void> ensureInitialized() {
    if (_initialized) return Future.value();
    _initFuture ??= initialize();
    return _initFuture!;
  }

  Future<void> initialize() async {
    try {
      _phishing = await Interpreter.fromAsset('models/phishing_model.tflite');
    } catch (e) {
      debugPrint('TfliteService: phishing model unavailable — $e');
    }
    try {
      _malware = await Interpreter.fromAsset('models/malware_model.tflite');
    } catch (e) {
      debugPrint('TfliteService: malware model unavailable — $e');
    }
    try {
      _wifi = await Interpreter.fromAsset('models/wifi_model.tflite');
    } catch (e) {
      debugPrint('TfliteService: wifi model unavailable — $e');
    }
    _initialized = true;
  }

  Future<double> runPhishing(List<double> features) async {
    await ensureInitialized();
    if (_phishing == null) return 0.5;
    return _runModel(_phishing, features);
  }

  Future<double> runMalware(List<double> features) async {
    await ensureInitialized();
    if (_malware == null) return 0.5;
    return _runModel(_malware, features);
  }

  Future<double> runWifi(List<double> features) async {
    await ensureInitialized();
    if (_wifi == null) return 0.5;
    return _runModel(_wifi, features);
  }

  void dispose() {
    _phishing?.close();
    _malware?.close();
    _wifi?.close();
  }

  double _runModel(Interpreter? interpreter, List<double> features) {
    if (interpreter == null) return 0.5;
    try {
      final inputTensor = interpreter.getInputTensor(0);
      final inputLength = _shapeLength(inputTensor.shape);
      final inputValues = _normalize(features, inputLength);
      final input = _reshape(inputValues, inputTensor.shape);
      final outputTensor = interpreter.getOutputTensor(0);
      final output = _buildTensor(outputTensor.shape);
      interpreter.run(input, output);
      final flat = _flatten(output);
      if (flat.isEmpty) return 0.0;
      final rawScore = flat.length == 1 ? flat.first : flat.reduce(max);
      if (rawScore >= 0 && rawScore <= 1) return rawScore;
      return 1 / (1 + exp(-rawScore));
    } catch (e) {
      debugPrint('TfliteService: model inference failed — $e');
      return 0.5;
    }
  }

  int _shapeLength(List<int> shape) {
    if (shape.isEmpty) return 0;
    return shape.reduce((a, b) => a * b);
  }

  List<double> _normalize(List<double> values, int length) {
    if (length <= 0) return const [];
    final normalized = List<double>.from(values);
    if (normalized.length > length) {
      return normalized.sublist(0, length);
    }
    while (normalized.length < length) {
      normalized.add(0.0);
    }
    return normalized;
  }

  dynamic _reshape(List<double> values, List<int> shape) {
    var index = 0;
    dynamic build(List<int> dims) {
      if (dims.isEmpty) {
        final value = index < values.length ? values[index] : 0.0;
        index += 1;
        return value;
      }
      if (dims.length == 1) {
        return List.generate(dims[0], (_) {
          final value = index < values.length ? values[index] : 0.0;
          index += 1;
          return value;
        });
      }
      return List.generate(dims[0], (_) => build(dims.sublist(1)));
    }

    return build(shape);
  }

  dynamic _buildTensor(List<int> shape) {
    if (shape.isEmpty) return 0.0;
    if (shape.length == 1) {
      return List.filled(shape[0], 0.0);
    }
    return List.generate(shape[0], (_) => _buildTensor(shape.sublist(1)));
  }

  List<double> _flatten(dynamic values) {
    if (values is double) return [values];
    if (values is int) return [values.toDouble()];
    if (values is List) {
      return values.expand(_flatten).toList();
    }
    return const [];
  }
}
