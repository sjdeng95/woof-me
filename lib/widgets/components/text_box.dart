


import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {

  final String text;
  final String sectionName;
  final void Function()? onPressed;

  const TextBox({
    super.key, 
    required this.text,
    required this.sectionName,
    required this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.only(
          bottom: 15, 
          left: 15,),
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //section name
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(color: Colors.grey[500]
                ),
              ),
              IconButton(
                onPressed: onPressed, 
                icon: const Icon(Icons.edit)
              )
            ],
          ),
          Text(text),
      ]),
    );
  }

}