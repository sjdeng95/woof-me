import 'package:flutter/material.dart';

class PetWidget extends StatelessWidget {
  final PetWidget? petWidget;

  const PetWidget({Key? key, this.petWidget}) : super(key: key);

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle descStyle =
    TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black);
  
  @override
  Widget build(BuildContext context) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Column(children:[SizedBox(width: 50, child: Image.asset("assets/images/profile.png",),
            ),]),

            const Column(children:[SizedBox(width: 50,),]),

            const Column(children:[     
              Row(children: [
                  Text(
                      'Name',
                      style: descStyle,
                      textAlign: TextAlign.left,
                  ),
                ], 
              ),
              Row(children: [
                  Text(
                      'Age',
                      style: descStyle,
                      textAlign: TextAlign.left,
                  ),
                ], 
              ),     
              Row(children: [
                  Text(
                      'Type',
                      style: descStyle,
                      textAlign: TextAlign.left,
                  ),
                ], 
              ),                       
              Row(children: [
                  Text(
                      'Temperment',
                      style: descStyle,
                      textAlign: TextAlign.left,
                  ),
                ], 
              ),
              ],),
            const Column(children:[SizedBox(width: 50,),]),

            const Column(children:[Icon(Icons.delete_outline,size: 50, color: Colors.red,),],),

            

        ],);
  }
}
