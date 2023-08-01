import 'package:flutter/material.dart';

Icon petStatus({required String status}) {
  if (status == 'Available') {
    return const Icon(Icons.check_circle, color: Colors.green);
  } else if (status == 'Not Available') {
    return const Icon(Icons.not_interested, color: Colors.red);
  } else if (status == 'Pending') {
    return const Icon(Icons.pending_outlined, color: Colors.deepOrange);
  } else if (status == 'Adopted') {
    return const Icon(Icons.done_all, color: Colors.blue);
  } else {
    return const Icon(Icons.question_mark, color: Colors.grey);
  }
}