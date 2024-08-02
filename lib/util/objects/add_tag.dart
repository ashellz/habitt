import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/util/functions/validate_text.dart';

GlobalKey<FormState> formKey = GlobalKey<FormState>();

class AddTagWidget extends StatefulWidget {
  const AddTagWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddTagWidgetState createState() => _AddTagWidgetState();
}

class _AddTagWidgetState extends State<AddTagWidget> {
  final TextEditingController tagNameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasFocused = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasFocused) {
      Future.microtask(() {
        FocusScope.of(context).requestFocus(_focusNode);
      });
      _hasFocused = true;
    }
  }

  @override
  void dispose() {
    tagNameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: theGreen,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Add tag",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Transform.translate(
                  offset: const Offset(12, 0),
                  child: IconButton(
                    iconSize: 25,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      child: TextFormField(
                        validator: validateText,
                        focusNode: _focusNode,
                        inputFormatters: [LengthLimitingTextInputFormatter(25)],
                        style: TextStyle(color: Colors.grey.shade900),
                        cursorColor: Colors.grey.shade900,
                        controller: tagNameController,
                        keyboardType: TextInputType.text,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          hintText: 'Tag name',
                          errorStyle: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      style: ButtonStyle(
                          fixedSize: const WidgetStatePropertyAll(
                            Size(100, 55),
                          ),
                          backgroundColor:
                              WidgetStateProperty.all(theLightGreen)),
                      child: const Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        tagsBox.add(tagNameController.text);
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
