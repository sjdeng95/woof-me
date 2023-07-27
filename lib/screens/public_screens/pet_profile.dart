import 'package:flutter/material.dart';
import 'package:woofme/models/pet_info.dart';

import 'package:woofme/widgets/pet_info_basic.dart';
import 'package:woofme/widgets/pet_info_more.dart';

class PetProfileScreen extends StatefulWidget {
  final PetInfo petInfo;
  const PetProfileScreen({Key? key, required this.petInfo}) : super(key: key);

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All About ${widget.petInfo.name}'),
      ),
      // show pet info basic and pet info more
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: ListView(children: [
          PetInfoBasic(petInfo: widget.petInfo),
          PetInfoMore(petInfo: widget.petInfo),
        ]),
      ),
    );
  }
}
