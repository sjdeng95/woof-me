class UserInfo {
  int? userId;
  String? name;
  String? username;
  bool? isAdmin;
  String? email;
  int? phone;
  String? likedType;
  String? likedBreed;
  bool? likeGoodAnimals;
  bool? likeGoodChildren;
  bool? likeMustLeash;
  String? pic;
  List<String>? likedPets;
  List<String>? dislikedPets;


  UserInfo(
      {this.userId,
      this.name,
      this.username,
      this.isAdmin,
      this.email,
      this.phone,
      this.likedType,
      this.likedBreed,
      this.likeGoodAnimals,
      this.likeGoodChildren,
      this.likeMustLeash,
      this.pic,
      this.likedPets,
      this.dislikedPets});
}
