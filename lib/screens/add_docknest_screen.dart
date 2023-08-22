import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:docknest/api/api_service.dart';
import 'package:docknest/models/add_docknest_screen.dart';
import 'package:docknest/providers/docknests_provider.dart';

class AddDocknestScreen extends ConsumerWidget {
  AddDocknestScreen({super.key, this.docknestToEdit});

  final Docknest? docknestToEdit;
  final _formKey = GlobalKey<FormState>();
  final _api = ApiService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editing = docknestToEdit != null;
    final appBarTitle = editing ? 'Edit docknest' : 'Add docknest';
    var ip = docknestToEdit?.ip ?? '';
    var port = docknestToEdit?.port ?? '';
    var name = docknestToEdit?.name ?? '';
    var testingConnection = false;

    void testConnectionPressed() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      _formKey.currentState!.save();
      testingConnection = true;
      final response = await _api.testConnection(ip, port);

      if (!context.mounted) {
        // if context has changed, do not do anything
        return;
      }

      testingConnection = false;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response ? 'Success!' : 'Failed')));
    }

    void savePressed() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      _formKey.currentState!.save();
      if (editing) {
        ref.read(docknestsProvider.notifier).updateShipyard(
            Docknest(ip: ip, name: name, port: port, id: docknestToEdit!.id));
      } else {
        ref.read(docknestsProvider.notifier).addShipyard(name, ip, port);
      }

      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                maxLength: 32,
                textCapitalization: TextCapitalization.words,
                initialValue: name,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().length <= 1 ||
                      value.trim().length > 32) {
                    return "Please enter a name between 1 and 32 characters";
                  }
                  return null;
                },
                onSaved: (newValue) => name = newValue!,
              ),
              TextFormField(
                initialValue: ip,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                decoration: InputDecoration(labelText: 'IP'),
                maxLength: 128,
                validator: (value) {
                  if (value == null || value.trim().length <= 6) {
                    return "Please enter a valid IP/host";
                  }
                  return null;
                },
                onSaved: (newValue) => ip = newValue!,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 64,
                    child: TextFormField(
                      initialValue: port,
                      keyboardType: TextInputType.number,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      decoration: InputDecoration(labelText: 'Port'),
                      maxLength: 5,
                      validator: (value) {
                        if (value == null ||
                            value.trim().length <= 1 ||
                            int.tryParse(value) == null) {
                          return "Invalid";
                        }
                        return null;
                      },
                      onSaved: (newValue) => port = newValue!,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: savePressed,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                    child: Text('Save'),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                    onPressed: testingConnection ? null : testConnectionPressed,
                    child: Text('Test connection'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
