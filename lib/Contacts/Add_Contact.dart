import 'dart:io';
import 'package:contacts/Contacts/Contact_Model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class AddContact extends StatefulWidget {
  AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends State<AddContact> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _imagePath;
  bool _imageError = false;

  @override
  void initState() {
    super.initState();
    for (final c in [_nameCtrl, _emailCtrl, _phoneCtrl]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagePath = picked.path;
        _imageError = false;
      });
    }
  }

  void _submit() {
    final formOk = _formKey.currentState!.validate();

    if (_imagePath == null) {
      setState(() => _imageError = true);
      return;
    }
    if (!formOk) return;

    Navigator.pop(
      context,
      ContactModel(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        imagePath: _imagePath!,
      ),
    );
  }

  InputDecoration _decoration(String hint) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: c, width: 1),
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 16, color: Color(0xFFE2F4F6)),
      filled: true,
      fillColor: Color(0xFF29384D),
      contentPadding: EdgeInsets.all(16),
      enabledBorder: border(Color(0xFFE2F4F6)),
      focusedBorder: border(Color(0xFFFFF1D4)),
      errorBorder: border(Color(0xFFFF3D3D)),
      focusedErrorBorder: border(Color(0xFFFF3D3D)),
    );
  }
  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;
    final sheetHeight =
    isKeyboardOpen ? 0.0 : MediaQuery.of(context).size.height * 0.55;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: sheetHeight > 32 ? sheetHeight - 32 : 0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPreview(),
                Column(
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      cursorColor: Color(0xFFFFF1D4),
                      style: TextStyle(color: Color(0xFFFFF1D4)),
                      decoration: _decoration('Enter User Name'),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Name is required'
                          : null,
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Color(0xFFFFF1D4),
                      style: TextStyle(color: Color(0xFFFFF1D4)),
                      decoration: _decoration('Enter User Email'),
                      validator: (v) {
                        final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                            .hasMatch(v?.trim() ?? '');
                        return ok ? null : 'Enter a valid email';
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      cursorColor: Color(0xFFFFF1D4),
                      style:  TextStyle(color: Color(0xFFFFF1D4)),
                      decoration: _decoration('Enter User Phone'),
                      validator: (v) => (v == null || v.trim().length < 8)
                          ? 'Enter a valid phone'
                          : null,
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFF1D4),
                      foregroundColor:  Color(0xFF26304D),
                      textStyle: TextStyle(fontSize: 20),
                      padding:  EdgeInsets.all(16),
                      overlayColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('Enter user'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildPreview() {
    return Row(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 100,
            height: 100,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _imageError
                      ? Color(0xFFFF3D3D)
                      :  Color(0xFFE2F4F6),
                ),
              ),
            child: _imagePath == null
                ? Padding(
              padding: EdgeInsets.all(12),
              child: Lottie.asset('assets/animation/empty_list12.json'),
            )
                : Image.file(File(_imagePath!), fit: BoxFit.cover),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              _previewLine(_nameCtrl.text, 'User Name'),
              _previewLine(_emailCtrl.text, 'example@email.com'),
              _previewLine(_phoneCtrl.text, '+200000000000'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _previewLine(String text, String placeholder) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Color(0xFFE2F4F6), width: 0.5)),
      ),
      child: Text(
        text.isEmpty ? placeholder : text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }
}