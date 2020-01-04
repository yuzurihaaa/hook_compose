import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormDropDown extends StatelessWidget {
  final String attribute;
  final List<String> options;

  const FormDropDown({Key key, this.attribute, this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderCustomField(
      attribute: attribute,
      validators: [
        FormBuilderValidators.required(),
      ],
      formField: FormField(
        enabled: true,
        builder: (FormFieldState<dynamic> field) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: "Select option",
              errorText: field.errorText,
              contentPadding: EdgeInsets.only(top: 10.0, bottom: 0.0),
              border: InputBorder.none,
            ),
            child: DropdownButton(
              isExpanded: true,
              items: options
                  .map((option) => DropdownMenuItem(
                        key: Key('$attribute-$option'),
                        child: Text("$option"),
                        value: option,
                      ))
                  .toList(),
              value: field.value,
              onChanged: (value) {
                field.didChange(value);
              },
            ),
          );
        },
      ),
    );
  }
}
