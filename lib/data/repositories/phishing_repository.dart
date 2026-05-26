import 'dart:math';

import '../../core/constants/indian_threats.dart';
import '../models/scan_result.dart';
import '../services/local_storage_service.dart';

class PhishingRepository {
  PhishingRepository(this._storage);

  final LocalStorageService _storage;

  Future<ScanResult> scan(String input) async {
    final normalized = input.trim().toLowerCase();
    final analysis = _analyze(normalized);

    final result = ScanResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      input: input,
      verdict: analysis.verdict,
      confidence: analysis.confidence,
      explanation: analysis.explanation,
      timestamp: DateTime.now(),
      reasons: analysis.reasons,
    );
    await _storage.addScanResult(result);
    return result;
  }

  Future<List<ScanResult>> history() async {
    return _storage.getScanHistory();
  }

  _AnalysisResult _analyze(String value) {
    final sanitized = value.startsWith('http') ? value : 'https://$value';
    final uri = Uri.tryParse(sanitized);
    final host = uri?.host.isNotEmpty == true ? uri!.host : value;

    // Rule 1: Safe domain whitelist
    for (final domain in IndianThreats.safeDomains) {
      if (host.contains(domain)) {
        return _AnalysisResult(
          verdict: 'SAFE',
          confidence: 98,
          explanation:
              'This URL belongs to a verified trusted domain ($domain).',
          reasons: [],
        );
      }
    }

    double suspicionScore = 0;
    final reasons = <ShapReason>[];

    // Rule 2: Suspicious keywords
    final keywordMatches = IndianThreats.suspiciousKeywords
        .where((keyword) => value.contains(keyword))
        .toList();
    if (keywordMatches.length >= 3) {
      suspicionScore += 45 + (keywordMatches.length * 5);
      reasons.add(ShapReason(
        feature: 'Bank/scam keywords detected (${keywordMatches.length})',
        contribution: 0.31 + (keywordMatches.length * 0.05),
      ));
    } else if (keywordMatches.isNotEmpty) {
      suspicionScore += 15 * keywordMatches.length;
      reasons.add(ShapReason(
        feature: 'Suspicious keyword: ${keywordMatches.first}',
        contribution: 0.20 + (keywordMatches.length * 0.04),
      ));
    }

    // Rule 3: Suspicious TLD
    final hasSuspiciousTld =
        IndianThreats.suspiciousTlds.any((tld) => host.endsWith(tld));
    if (hasSuspiciousTld) {
      suspicionScore += 35;
      reasons.add(ShapReason(
        feature: 'Suspicious domain extension',
        contribution: 0.42,
      ));
    }

    // Rule 4: IP address as domain
    final ipRegex = RegExp(r'\b(\d{1,3}\.){3}\d{1,3}\b');
    if (ipRegex.hasMatch(host)) {
      suspicionScore += 40;
      reasons.add(ShapReason(
        feature: 'IP address used instead of domain',
        contribution: 0.38,
      ));
    }

    // Rule 5: Excessive hyphens
    final hyphenCount = '-'.allMatches(host).length;
    if (hyphenCount >= 3) {
      suspicionScore += 25;
      reasons.add(ShapReason(
        feature: 'Multiple hyphens in domain ($hyphenCount)',
        contribution: 0.22,
      ));
    }

    // Rule 6: Long URL
    if (value.length > 100) {
      suspicionScore += 15;
      reasons.add(ShapReason(
        feature: 'Unusually long URL (${value.length} chars)',
        contribution: 0.15,
      ));
    }

    // Urgency patterns
    final urgencyKeywords = [
      'urgent',
      'verify',
      'immediately',
      'click',
      'otp',
      'reset',
      'expire',
      'suspended'
    ];
    final hasUrgency = urgencyKeywords.any(value.contains);
    if (hasUrgency) {
      suspicionScore += 10;
      reasons.add(ShapReason(
        feature: 'Urgency pattern found',
        contribution: 0.19,
      ));
    }

    // Excessive digits in domain
    final digitCount = RegExp(r'\d').allMatches(host).length;
    if (digitCount >= 4) {
      suspicionScore += 10;
      reasons.add(ShapReason(
        feature: 'Many digits in domain ($digitCount)',
        contribution: 0.12,
      ));
    }

    // Determine verdict
    reasons.sort((a, b) => b.contribution.compareTo(a.contribution));
    final topReasons = reasons.take(4).toList();

    if (suspicionScore >= 50) {
      final confidence =
          min(99.0, 75.0 + (suspicionScore - 50) * 0.5).roundToDouble();
      return _AnalysisResult(
        verdict: 'PHISHING',
        confidence: confidence,
        explanation:
            'Multiple high-risk indicators detected. This content matches known phishing patterns targeting Indian users.',
        reasons: topReasons,
      );
    } else if (suspicionScore >= 25) {
      return _AnalysisResult(
        verdict: 'PHISHING',
        confidence: 65 + suspicionScore * 0.4,
        explanation:
            'Suspicious patterns detected. Exercise caution before interacting with this content.',
        reasons: topReasons,
      );
    }

    return _AnalysisResult(
      verdict: 'SAFE',
      confidence: max(70, 95 - suspicionScore).toDouble(),
      explanation:
          'No significant phishing indicators found. The content appears safe.',
      reasons: [],
    );
  }
}

class _AnalysisResult {
  final String verdict;
  final double confidence;
  final String explanation;
  final List<ShapReason> reasons;

  _AnalysisResult({
    required this.verdict,
    required this.confidence,
    required this.explanation,
    required this.reasons,
  });
}
