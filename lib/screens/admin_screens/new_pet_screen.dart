import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woofme/screens/admin_screens/all_pets_screen.dart';

class NewPetScreen extends StatefulWidget {
  const NewPetScreen({super.key});

  @override
  State<NewPetScreen> createState() => _NewPetScreenState();
}

class _NewPetScreenState extends State<NewPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _typeController = TextEditingController();
  final _breedController = TextEditingController();
  late var _availability = 'Available';
  final _storyController = TextEditingController();
  final _picController = TextEditingController();
  bool _goodAnimals = false;
  bool _goodChildren = false;
  bool _mustLeash = false;

  void _addPet() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('pets').add({
        'name': _nameController.text,
        'age': int.parse(_ageController.text),
        'type': _typeController.text,
        'breed': _breedController.text,
        'good_w_animals': _goodAnimals,
        'good_w_children': _goodChildren,
        'must_leash': _mustLeash,
        'availability': _availability,
        'story': _storyController.text,
        'pic': _picController.text,
        'created_at': FieldValue.serverTimestamp(),
      });

      _nameController.clear();
      _ageController.clear();
      _typeController.clear();
      _breedController.clear();
      _goodAnimals = false;
      _goodChildren = false;
      _mustLeash = false;
      _storyController.clear();
      _picController.clear();

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AllPetsScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _picController.text = 'https://firebasestorage.googleapis.com/v0/b/woofme-467.appspot.com/o/DEFAULT%20EMPTY%20PICTURE%2FIMG_5468.png?alt=media&token=a3db9515-f0ec-4ead-9973-ee10f4fb37d7';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Pet'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _picController.text.isNotEmpty
                    ? Image.network(
                        _picController.text,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : const Placeholder(
                        fallbackWidth: 100,
                        fallbackHeight: 100,
                      ),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Pet Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pet name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Pet Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pet age';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _typeController,
                  decoration: const InputDecoration(labelText: 'Pet Type'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pet type';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _breedController,
                  decoration: const InputDecoration(labelText: 'Breed'),
                ),

                TextFormField(
                  controller: _storyController,
                  decoration: const InputDecoration(labelText: 'Story'),
                ),
                TextFormField(
                  controller: _picController, 
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
                CheckboxListTile(
                  title: const Text('Good with Animals'),
                  value: _goodAnimals,
                  onChanged: (bool? value) {
                    setState(() {
                      _goodAnimals = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Good with Children'),
                  value: _goodChildren,
                  onChanged: (bool? value) {
                    setState(() {
                      _goodChildren = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Must Leash'),
                  value: _mustLeash,
                  onChanged: (bool? value) {
                    setState(() {
                      _mustLeash = value ?? false;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Available'),
                  value: 'Available',
                  groupValue: _availability,
                  onChanged: (String? value) {
                    setState(() {
                      _availability = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Not Available'),
                  value: 'Not Available',
                  groupValue: _availability,
                  onChanged: (String? value) {
                    setState(() {
                      _availability = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Pending'),
                  value: 'Pending',
                  groupValue: _availability,
                  onChanged: (String? value) {
                    setState(() {
                      _availability = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Adopted'),
                  value: 'Adopted',
                  groupValue: _availability,
                  onChanged: (String? value) {
                    setState(() {
                      _availability = value!;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: _addPet,
                  child: const Text('Add Pet'),
                ),
                const SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
