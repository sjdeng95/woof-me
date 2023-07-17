import 'package:flutter/material.dart';
import 'package:woofme/widgets/pet_widget.dart';


class UserInfo extends StatelessWidget {
  final UserInfo? userInfo;

  const UserInfo({Key? key, this.userInfo}) : super(key: key);

  static const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  
  static const TextStyle infoStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo);
  
  static const TextStyle descStyle =
    TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 48,
                backgroundColor: Colors.white,
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: ClipOval(
                    child: Image.asset("assets/images/profile.png",
                    ),
                  )
                )
              )
            ),       
          ),
            
          const SizedBox(height: 10),
          const Text(
            'USER NAME',
            style: optionStyle,
          ),
          // const SizedBox(height: 10),
    
          const Row(
            children: [
              Expanded(child: Center(child: Text(
                'EMAIL',
                style: infoStyle,
              ),),),
              
              Expanded(child: Center(child: Text(
                'Phone',
                style: infoStyle,
              ),),),
            ],
          ),
          
          const SizedBox(height: 20),

          const Center(child: Row(
            children: [
              Icon(Icons.health_and_safety_sharp,size: 50,),
              Expanded(child: Center(child: Column(children:[
                  Text(
                    'VET NAME',
                    style: descStyle,
                  ),
                  Text(
                    'VET Home',
                    style: descStyle,
                  ),
                   Text(
                    'VET Address',
                    style: descStyle,
                  ),
              ],),),),
              // SizedBox(width: 30,),
              Icon(Icons.house_rounded, size: 50,),
              Expanded(child: Center(child: Column(children:[
                  Text(
                    'Home Type',
                    style: descStyle,
                  ),
                  Text(
                    'Rent/Owned',
                    style: descStyle,
                  ),
                   Text(
                    'Location',
                    style: descStyle,
                  ),
              ],),),),
            ],
          ),),
          
          const SizedBox(height: 20),

          const SizedBox(height: 100,
            child: Center(child: Text(
                'THIS IS WHERE THE DESCRIPTION GOES \n'
                'THIS IS WHERE THE DESCRIPTION GOES \n'
                'THIS IS WHERE THE DESCRIPTION GOES \n'
                'THIS IS WHERE THE DESCRIPTION GOES \n'
                'THIS IS WHERE THE DESCRIPTION GOES \n',
                style: descStyle,
              ),),),

          const SizedBox(height: 10),

          const SizedBox(height: 100,
            child: Center(child: Text(
                'THIS IS WHERE THE CURRENT PETS GO',
                style: descStyle,
              ),),),

          const SizedBox(height: 10),

          // TODO change with current pets 
          const PetWidget(),
          const SizedBox(height: 10,),
          const PetWidget(),

        ]);
  }
}
