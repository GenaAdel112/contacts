import 'dart:io';
import 'package:contacts/Contacts/Contact_Model.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback onDelete;

   ContactCard({super.key, required this.contact, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: Color(0xFFFFF1D4),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(contact.imagePath), fit: BoxFit.cover),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF1D4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        contact.name,
                        style: TextStyle(
                            fontSize: 10, color: Color(0xFF29384D)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 6),
              child: Column(
                children: [
                  _infoRow(Icons.email, contact.email),
                  SizedBox(height: 16),
                  _infoRow(Icons.phone, contact.phone),
                ],
              ),
            ),
            InkWell(
              onTap: onDelete,
              child: Container(
                margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                height: 28,
                decoration: BoxDecoration(
                  color: Color(0xFFFF3D3D),
                  borderRadius: BorderRadius.circular(6),
                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text('Delete',
                        style: TextStyle(fontSize: 11, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Color(0xFF29384D)),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10, color: Color(0xFF29384D)),
          ),
        ),
      ],
    );
  }
}