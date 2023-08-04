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
    _picController.text =
        'https://firebasestorage.googleapis.com/v0/b/woofme-467.appspot.com/o/DEFAULT%20EMPTY%20PICTURE%2FIMG_5468.png?alt=media&token=a3db9515-f0ec-4ead-9973-ee10f4fb37d7';
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      border: OutlineInputBorder(),
                      labelText: "Pet Name"),
                  style: Theme.of(context).textTheme.bodyMedium,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pet name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _ageController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      border: OutlineInputBorder(),
                      labelText: 'Pet Age'),
                  style: Theme.of(context).textTheme.bodyMedium,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pet age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _typeController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      border: OutlineInputBorder(),
                      labelText: 'Pet Type'),
                  style: Theme.of(context).textTheme.bodyMedium,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pet type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _breedController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      border: OutlineInputBorder(),
                      labelText: 'Breed'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _storyController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      border: OutlineInputBorder(),
                      labelText: 'Story'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _picController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      border: OutlineInputBorder(),
                      labelText: 'Image URL'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  'Pet Disposition',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                CheckboxListTile(
                  title: Text('Good with Animals',
                      style: Theme.of(context).textTheme.bodyMedium),
                  value: _goodAnimals,
                  activeColor: Colors.green,
                  onChanged: (bool? value) {
                    setState(() {
                      _goodAnimals = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Good with Children',
                      style: Theme.of(context).textTheme.bodyMedium),
                  value: _goodChildren,
                  activeColor: Colors.green,
                  onChanged: (bool? value) {
                    setState(() {
                      _goodChildren = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Must Leash',
                      style: Theme.of(context).textTheme.bodyMedium),
                  value: _mustLeash,
                  activeColor: Colors.green,
                  onChanged: (bool? value) {
                    setState(() {
                      _mustLeash = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Availability',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                RadioListTile<String>(
                  title: Text('Available',
                      style: Theme.of(context).textTheme.bodyMedium),
                  value: 'Available',
                  groupValue: _availability,
                  onChanged: (String? value) {
                    setState(() {
                      _availability = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Not Available',
                      style: Theme.of(context).textTheme.bodyMedium),
                  value: 'Not Available',
                  groupValue: _availability,
                  onChanged: (String? value) {
                    setState(() {
                      _availability = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Pending',
                      style: Theme.of(context).textTheme.bodyMedium),
                  value: 'Pending',
                  groupValue: _availability,
                  onChanged: (String? value) {
                    setState(() {
                      _availability = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Adopted',
                      style: Theme.of(context).textTheme.bodyMedium),
                  value: 'Adopted',
                  groupValue: _availability,
                  onChanged: (String? value) {
                    setState(() {
                      _availability = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50.0),
                  ),
                  icon: const Icon(Icons.save_alt_rounded),
                  onPressed: _addPet,
                  label: Text('Add Pet',
                      style: Theme.of(context).textTheme.displayMedium),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
