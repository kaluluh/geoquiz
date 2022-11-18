class City {
  final String name;
  final String country;
  final int population;
  final bool isCapital;
  final String additionalInformation;


  City(this.name,this.country,this.population,this.isCapital,[this.additionalInformation = ""]);

  Map<String,dynamic> toMap() {
    return {
      'name': name,
      'country': country,
      'population': population,
      'isCapital': isCapital
    };
  }

  factory City.fromMap(Map<String, dynamic> data) {
    return City(data['name'], data['country'], data['population'], data['isCapital']);
  }

  factory City.fromJson(List<Map<String, dynamic>> json) {
    return City(json[0]['name'], json[0]['country'], json[0]['population'], json[0]['is_capital']);
  }
}