import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:woofme/screens/admin_screens/all_pets_screen.dart';

class NewPetScreen extends StatefulWidget {
  const NewPetScreen({super.key});

  @override
  State<NewPetScreen> createState() => _NewPetScreenState();
}

class _NewPetScreenState extends State<NewPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _breedController = TextEditingController();
  late var _availability = 'Available';
  final _storyController = TextEditingController();
  final _picController = TextEditingController();
  bool _goodAnimals = false;
  bool _goodChildren = false;
  bool _mustLeash = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a Pet')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                InkWell(
                    onTap: _pickImage,
                    child: _picController.text.isNotEmpty
                        ? Image.network(
                            _picController.text,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          )
                        : const SizedBox(
                            height: 50,
                            child: Icon(
                              Icons.add_a_photo_outlined,
                            ))),
                buildTextField(
                  controller: _nameController,
                  label: "Pet Name",
                  validator: notEmptyValidator,
                ),
                buildTextField(
                    controller: _typeController,
                    label: 'Pet Type',
                    validator: notEmptyValidator),
                buildTextField(controller: _breedController, label: 'Breed'),
                buildTextField(controller: _storyController, label: 'Story'),
                const SizedBox(height: 20),
                buildDispositionCheckboxes(),
                const SizedBox(height: 20),
                buildAvailabilityRadios(),
                const SizedBox(height: 20),
                buildAddPetButton(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      {required TextEditingController controller,
      required String label,
      Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter some text';
          }
          return null; // Explicitly return null when there's no error
        },
      ),
    );
  }

  String? notEmptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter $value';
    }
    return null;
  }

  Widget buildDispositionCheckboxes() {
    return Column(
      children: [
        buildCheckboxListTile(
            "Good with Animals", _goodAnimals, (value) => _goodAnimals = value),
        buildCheckboxListTile("Good with Children", _goodChildren,
            (value) => _goodChildren = value),
        buildCheckboxListTile(
            "Must Leash", _mustLeash, (value) => _mustLeash = value),
      ],
    );
  }

  Widget buildCheckboxListTile(
      String title, bool value, Function(bool) onChanged) {
    return CheckboxListTile(
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      value: value,
      activeColor: Colors.green,
      onChanged: (bool? val) => setState(() => onChanged(val ?? false)),
    );
  }

  Widget buildAvailabilityRadios() {
    return Column(
      children:
          ["Available", "Not Available", "Pending", "Adopted"].map((status) {
        return RadioListTile<String>(
          title: Text(status, style: Theme.of(context).textTheme.bodyMedium),
          value: status,
          groupValue: _availability,
          onChanged: (String? value) {
            setState(() {
              _availability = value!;
            });
          },
        );
      }).toList(),
    );
  }

  Widget buildAddPetButton() {
    return FilledButton.icon(
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50.0)),
      icon: const Icon(Icons.save_alt_rounded),
      onPressed: _addPet,
      label: Text('Add Pet', style: Theme.of(context).textTheme.displayMedium),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      uploadImageToFirebase(image);
    }
  }

  Future<String?> uploadImageToFirebase(File image) async {
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference storageReference =
        FirebaseStorage.instance.ref().child('pets/$imageName');

    try {
      TaskSnapshot snapshot = await storageReference.putFile(image);
      String imageUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _picController.text = imageUrl;
      });

      return null;
    } on FirebaseException catch (e) {
      return e.message ??
          'An unexpected error occurred.'; // Return a user-friendly error message
    }
  }

  void _addPet() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('pets').add({
        'name': _nameController.text,
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
      _typeController.clear();
      _breedController.clear();
      _goodAnimals = false;
      _goodChildren = false;
      _mustLeash = false;
      _storyController.clear();
      _picController.clear();

      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AllPetsScreen()),
        );
      }
    }
  }
}
