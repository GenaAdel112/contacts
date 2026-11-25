import 'package:contacts/Contacts/Add_Contact.dart';
import 'package:contacts/Contacts/Contact_Card.dart';
import 'package:contacts/Contacts/Contact_Model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static int _maxContacts = 6;
  final List<ContactModel> _contacts = [];

  Future<void> _openAddSheet() async {
    final contact = await showModalBottomSheet<ContactModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFF29384D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (_) => AddContact(),
    );

    if (contact != null) {
      setState(() => _contacts.add(contact));
    }
  }

  void _deleteAt(int index) => setState(() => _contacts.removeAt(index));

  void _deleteLast() {
    if (_contacts.isNotEmpty) setState(() => _contacts.removeLast());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF29384D),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Image.asset('assets/images/Route.png', height: 40),
              SizedBox(height: 27),
              Expanded(
                child: _contacts.isEmpty ? _buildEmpty() : _buildGrid(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFabs(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/animation/empty_list.json', width: 200),
          SizedBox(height: 12),
          Text(
            'There is No Contacts Added Here',
            style: TextStyle(fontSize: 14, color: Color(0xFFFFF1D4)),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: EdgeInsets.only(bottom: 140),
      itemCount: _contacts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.63,
      ),
      itemBuilder: (_, i) => ContactCard(
        contact: _contacts[i],
        onDelete: () => _deleteAt(i),
      ),
    );
  }

  Widget _buildFabs() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_contacts.isNotEmpty)
          FloatingActionButton(
            heroTag: 'delete_fab',
            backgroundColor: Color(0xFFFF3D3D),
            foregroundColor: Colors.white,
            onPressed: _deleteLast,
            child: Icon(Icons.delete),
          ),
        SizedBox(height: 12),

        if (_contacts.length < _maxContacts)
          FloatingActionButton(
            heroTag: 'add_fab',
            backgroundColor: Color(0xFFFFF1D4),
            foregroundColor: Color(0xFF29384D),
            onPressed: _openAddSheet,
            child: Icon(Icons.add),
          ),
      ],
    );
  }
}