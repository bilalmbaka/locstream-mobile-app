class Asset {
  final String id;
  final String url;
  final String? thumbnail;
  final String? gif;
  final int? size;
  final String? mime;

  Asset({
    required this.id,
    required this.url,
    this.thumbnail,
    this.gif,
    this.size,
    this.mime,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] as String,
      url: json['url'] as String,
      thumbnail: json['thumbnail'] as String?,
      gif: json['gif'] as String?,
      size: json['size'] as int?,
      mime: json['mime'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'thumbnail': thumbnail,
      'gif': gif,
      'size': size,
      'mime': mime,
    };
  }

  Asset copyWith({
    String? id,
    String? url,
    String? thumbnail,
    String? gif,
    int? size,
    String? mime,
  }) {
    return Asset(
      id: id ?? this.id,
      url: url ?? this.url,
      thumbnail: thumbnail ?? this.thumbnail,
      gif: gif ?? this.gif,
      size: size ?? this.size,
      mime: mime ?? this.mime,
    );
  }
}
