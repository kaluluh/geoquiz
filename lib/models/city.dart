class City {
  final String name;
  final String country;
  final int population;
  final bool isCapital;
  final double latitude;
  final double longitude;
  final String additionalInformation;


  City(this.name, this.country, this.population, this.isCapital, this.latitude, this.longitude, [this.additionalInformation = ""]);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'country': country,
      'population': population,
      'isCapital': isCapital,
      'latitude': latitude,
      'longitude': longitude,
      'additionalInformation': additionalInformation,
    };
  }

  factory City.fromMap(Map<String, dynamic> data) {
    return City(
        data['name'],
        data['country'],
        data['population'],
        data['isCapital'],
        data['latitude'],
        data['longitude'],
        data['additionalInformation']
    );
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
        json['name'],
        json['country'],
        json['population'],
        json['is_capital'],
        json['latitude'],
        json['longitude']
    );
  }

  @override
  String toString() {
    return 'City{name: $name, country: $country, population: $population, isCapital: $isCapital, latitude: $latitude, longitude: $longitude, additionalInformation: $additionalInformation}';
  }
}