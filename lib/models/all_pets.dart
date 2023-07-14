import 'package:woofme/models/pet_info.dart';

class AllPets {
  List<PetInfo> pets;

  AllPets({this.pets = const []});

  int get numberOfPets => pets.length;
}
