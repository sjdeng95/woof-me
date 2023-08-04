import 'package:flutter/material.dart';
import 'package:woofme/models/pet_info.dart';

class PetInfoBasic extends StatelessWidget {
  final PetInfo? petInfo;

  const PetInfoBasic({Key? key, this.petInfo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          '${petInfo!.pic}',
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.60,
          fit: BoxFit.cover,
        ),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),
        Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${petInfo!.name}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                const SizedBox(height: 2),
                Text('${petInfo!.availability}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    )),
                const SizedBox(height: 2),
                Text('${petInfo!.type} - ${petInfo!.breed}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    )),
                const SizedBox(height: 2),
              ],
            )),
      ],
    );
  }
}
