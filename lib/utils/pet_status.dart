import 'package:flutter/material.dart';

Icon petStatus({required String status}) {
  if (status == 'Available') {
    return const Icon(Icons.check_circle, color: Colors.green, size: 25);
  } else if (status == 'Not Available') {
    return const Icon(Icons.not_interested, color: Colors.red, size: 25);
  } else if (status == 'Pending') {
    return const Icon(Icons.pending_outlined, color: Colors.grey, size: 25);
  } else if (status == 'Adopted') {
    return const Icon(Icons.done_rounded, color: Colors.blue, size: 25);
  } else {
    return const Icon(Icons.question_mark, color: Colors.grey, size: 25);
  }
}
