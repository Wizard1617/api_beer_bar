class Beer {
  final int beerId;
  final String name;
  final double volume;
  final String? picture;
  final double degrees;
  final String description;

  Beer({
    required this.beerId,
    required this.name,
    required this.volume,
    required this.picture,
    required this.degrees,
    required this.description,
  });

  factory Beer.fromJson(Map<String, dynamic> json) {
    return Beer(
      beerId: json['beerId'],
      name: json['name'],
      volume: json['volume'].toDouble(),
      picture: json['picture'],
      degrees: json['degrees'].toDouble(),
      description: json['descripion'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'beerId': beerId,
      'name': name,
      'volume': volume,
      'picture': picture,
      'degrees': degrees,
      'descripion': description,
    };
  }
}
