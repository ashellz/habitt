import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habitt/data/tags.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/validate_text.dart';

GlobalKey<FormState> formKey = GlobalKey<FormState>();

class AddTagWidget extends StatefulWidget {
  const AddTagWidget({super.key, required this.mystate});

  final StateSetter mystate;

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
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Colors.grey.shade900,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(25)
                          ],
                          keyboardAppearance:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Brightness.dark
                                  : Brightness.light,
                          validator: validateTag,
                          focusNode: _focusNode,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          cursorColor: Colors.white,
                          cursorWidth: 2.0,
                          cursorHeight: 22.0,
                          cursorRadius: const Radius.circular(10.0),
                          cursorOpacityAnimates: true,
                          enableInteractiveSelection: true,
                          controller: tagNameController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            prefixIcon: const Icon(Icons.bookmark_rounded,
                                color: Colors.white),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 25, horizontal: 20),
                            labelStyle: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white38,
                                fontWeight: FontWeight.bold),
                            labelText: "TAG",
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: 'Tag name',
                            hintStyle: const TextStyle(color: Colors.white38),
                            filled: true,
                            fillColor: Colors.grey.shade900,
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
                          widget.mystate(() {
                            tagBox.add(TagData(tag: tagNameController.text));
                          });

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
      ),
    );
  }
}
