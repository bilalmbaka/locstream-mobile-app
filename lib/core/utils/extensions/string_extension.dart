extension StringExtensions on String {
  String firstLetterToUpperCase() =>
      isEmpty ? "" : replaceRange(0, 1, this[0].toUpperCase());

  String allFirstLettersToUpperCase() => isEmpty
      ? ""
      : split(" ").map((e) {
          return e.isEmpty ? "" : e.replaceRange(0, 1, this[0].toUpperCase());
        }).join(" ");

  //Assets
  String get pngIcon => "assets/icons/png/$this.png";

  String get svgIcon => "assets/icons/svg/$this.svg";

  String get pngImage => "assets/images/png/$this.png";

  String get svgImage => "assets/images/svg/$this.svg";

  //File source
  bool get isRemote => startsWith("http");
  bool get isAnAsset => contains("assets");
  bool get isSvg => endsWith("svg");
}
