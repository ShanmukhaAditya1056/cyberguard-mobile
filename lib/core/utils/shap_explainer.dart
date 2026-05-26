class ShapExplainer {
  static List<Map<String, dynamic>> phishingDefaultReasons() {
    return const [
      {'feature': 'Suspicious domain', 'contribution': 0.42},
      {'feature': 'Bank keyword detected', 'contribution': 0.31},
      {'feature': 'Urgency pattern found', 'contribution': 0.19},
    ];
  }
}
