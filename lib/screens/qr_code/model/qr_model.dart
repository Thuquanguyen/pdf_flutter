class QrModel {
  String? downloadUrl;
  String? message;
  String? title;
  int? size;
  String? code;
  bool? success;

  QrModel(
      {this.downloadUrl, this.message, this.success, this.title, this.size,this.code});

  factory QrModel.fromJson(Map<String, dynamic> json) {
    return QrModel(
      downloadUrl: json['download_url'],
      message: json['message'],
      success: json['success'],
      title: json['title'],
      size: json['size'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['download_url'] = downloadUrl;
    data['message'] = message;
    data['success'] = success;
    data['title'] = title;
    data['size'] = size;
    data['code'] = code;
    return data;
  }

  @override
  String toString() {
    return 'QrModel{downloadUrl: $downloadUrl, message: $message, title: $title, size: $size, code: $code, success: $success}';
  }
}
