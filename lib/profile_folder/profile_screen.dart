import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

final dbRef = FirebaseDatabase.instance.ref();

class ProfileScreen extends StatefulWidget {

  final VoidCallback openBottomNav;
  const ProfileScreen({super.key, required this.openBottomNav});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userId;
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  String selectedGender = "";
  Color selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    init();
  }
  Future<void> init()async{
    await userInit();
  }


  Future<void> _saveProfile() async {
    if (userId == null) {
      final k = dbRef.child('users').push().key;
      if (k == null) return;
      userId = k;
    }
    await dbRef.child('users/$userId').update({'name': nameCtrl.text, 'age': ageCtrl.text, 'height': heightCtrl.text, 'gender': selectedGender});
  }

  Future<void> userInit() async {
    if (userId == null){
      return;
    }
    final u = await dbRef.child('users/$userId').get();
    final data = u.value as Map<dynamic,dynamic>;
    setState(() {
      nameCtrl.text = data["name"];
      ageCtrl.text = data["age"];
      selectedGender = data["gender"];
      heightCtrl.text = data["height"];
    });


  }

  @override
  Widget build(BuildContext context) => Column(children: [
    Container(width: double.infinity, margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), padding: const EdgeInsets.symmetric(vertical: 12), child: const Center(child: Text('Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        _field(nameCtrl, 'Name'),
        const SizedBox(height: 12),
        _field(ageCtrl, 'Age', num: true),
        const SizedBox(height: 12),
        _field(heightCtrl, 'Height (cm)', num: true),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
          value: (selectedGender == 'Male' || selectedGender == 'Female') ? selectedGender : null,
          items: const ['Male', 'Female'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
          onChanged: (v) {
            if (v != null) {
              setState(() => selectedGender = v);
            }
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<Color>(
          decoration: const InputDecoration(labelText: 'Tab colour', border: OutlineInputBorder()),
          value: selectedColor,
          items: {'Blue': Colors.blue, 'Red': Colors.red, 'Green': Colors.green, 'Purple': Colors.purple, 'Orange': Colors.orange}.entries.map((e) => DropdownMenuItem(value: e.value, child: Text(e.key))).toList(),
          onChanged: (c) {
            if (c != null) {
              setState(() => selectedColor = c);

            }
          },
        ),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: () async {
          FocusScope.of(context).unfocus();
          await _saveProfile();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved!')));
          widget.openBottomNav();
        },
            child: const Text('Confirm')),
        const SizedBox(height: 24),
        const Text('Daily Calorie Requirement:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text("", style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
        const SizedBox(height: 20),
      ]),
    ),
  ]);

  Widget _field(TextEditingController c, String l,  {ValueChanged<String>? onChg, bool num = false}) =>
      TextField(
          controller: c,
          decoration: InputDecoration(labelText: l, border: const OutlineInputBorder()),
          keyboardType: num ? TextInputType.number : null,
          onChanged: onChg);
}
