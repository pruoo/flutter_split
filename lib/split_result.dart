class SplitResult {
  String? splitName;
  String? treatment;
  Map<String, dynamic>? config;

  SplitResult.fromJson(json) {
    this.splitName = json['splitName'];
    this.config = json['config'] ?? {};
    this.treatment = json['treatment'];
  }
}
