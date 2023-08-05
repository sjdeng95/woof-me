class PetInfo {
  String? petId;
  String? name;
  String? pic;
  String? type;
  String? breed;
  bool? goodAnimals;
  bool? goodChildren;
  bool? mustLeash;
  String? availability;
  String? story;
  DateTime? createdAt;

  PetInfo(
      {this.petId,
      this.name,
      this.pic,
      this.type,
      this.breed,
      this.goodAnimals,
      this.goodChildren,
      this.mustLeash,
      this.availability,
      this.story,
      this.createdAt});
}
