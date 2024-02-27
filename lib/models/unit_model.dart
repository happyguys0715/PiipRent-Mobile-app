class Unit {
  String? id;
  String? name;

  Unit({
    this.id,
    this.name,
  });

  factory Unit.fromJson(Map<String, dynamic> payload) {
    return Unit(
      name: payload['__str__'],
      id: payload['id'],
    );
  }
}
