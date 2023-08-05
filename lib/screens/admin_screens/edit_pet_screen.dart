import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../models/pet_info.dart';

class EditPetScreen extends StatefulWidget {
  final PetInfo petInfo;

  const EditPetScreen({Key? key, required this.petInfo}) : super(key: key);

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _breedController;
  late var _availability = 'Available';
  late TextEditingController _storyController;
  late TextEditingController _picController;
  bool _goodAnimals = false;
  bool _goodChildren = false;
  bool _mustLeash = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.petInfo.name);
    _typeController = TextEditingController(text: widget.petInfo.type);
    _breedController = TextEditingController(text: widget.petInfo.breed);
    _availability = widget.petInfo.availability!;
    _storyController = TextEditingController(text: widget.petInfo.story);
    _picController = TextEditingController(text: widget.petInfo.pic);
    _goodAnimals = widget.petInfo.goodAnimals!;
    _goodChildren = widget.petInfo.goodChildren!;
    _mustLeash = widget.petInfo.mustLeash!;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _breedController.dispose();
    _storyController.dispose();
    _picController.dispose();

    super.dispose();
  }

  void _updatePet() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('pets').doc(widget.petInfo.petId).update({
          'name': _nameController.text,
          'type': _typeController.text,
          'breed': _breedController.text,
          'good_w_animals': _goodAnimals,
          'good_w_children': _goodChildren,
          'must_leash': _mustLeash,
          'availability': _availability,
          'story': _storyController.text,
          'pic': _picController.text,
        });

        final updatedPetInfo = PetInfo(
          petId: widget.petInfo.petId,
          name: _nameController.text,
          type: _typeController.text,
          breed: _breedController.text,
          goodAnimals: _goodAnimals,
          goodChildren: _goodChildren,
          mustLeash: _mustLeash,
          availability: _availability,
          story: _storyController.text,
          pic: _picController.text,
        );

        Navigator.pop(context, updatedPetInfo);
      } catch (e) {
        if (kDebugMode) {
          print("Error updating pet: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pet'),
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
                ElevatedButton.icon(
                  onPressed: _updatePet,
                  icon: const Icon(Icons.update),
                  label: const Text('Update'),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
