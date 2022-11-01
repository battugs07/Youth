import 'package:flutter/material.dart';
import 'checkbox.dart';
import 'element_option.dart';
import 'input.dart';
import 'map.dart';
import 'select.dart';
import 'radio.dart';
import 'dateTime.dart';
import 'image.dart';
import 'subForm/subForm.dart';
import '../rule.dart';

Widget element(
    Map<String, dynamic> form,
    Map<dynamic, dynamic> meta,
    /*InputDecoration decoration,*/ void Function(
            String component, dynamic value)
        onChange,
    {String type = "",
    String key = "",
    String label = "",
    List<FormFieldValidator>? rules,
    dynamic? relations}) {
  switch (type) {
    case "SubForm":
      {
        return new SubformWidget(ElementOption(
          key,
          label,
          form,
          meta,
          onChange,
          rules: rules,
        ));
      }
      break;
    case "Text":
      {
        return new InputWidget(ElementOption(
          key,
          label,
// decoration,
          form,
          meta,

          onChange,
          rules: rules,
        ));
      }
      break;
    case "Geographic":
      {
        return new MapWidget(ElementOption(
          key,
          label,
// decoration,
          form,
          meta,

          onChange,
          rules: rules,
        ));
      }
      break;
    case "Textarea":
      {
        return new InputWidget(
          ElementOption(
            key,
            label,
// decoration,
            form,
            meta,

            onChange,
            rules: rules,
          ),
          maxLines: 4,
        );
      }
      break;
    case "CK":
      {
        return new InputWidget(
          ElementOption(
            key,
            label,
            //     decoration,
            form,
            meta,

            onChange,
            rules: rules,
          ),
          maxLines: 4,
        );
      }
      break;
    case "Number":
      {
        return new InputWidget(
          ElementOption(
            key,
            label,
// decoration,
            form,
            meta,

            onChange,
            rules: rules,
          ),
          keyboardType: TextInputType.number,
        );
      }
      break;
    case "Password":
      {
        return new InputWidget(
          ElementOption(
            key,
            label,
// decoration,
            form,
            meta,

            onChange,
            rules: rules,
          ),
          obscureText: true,
        );
      }
      break;
    case "Email":
      {
        var emailValidation = getRule("email");
        return new InputWidget(ElementOption(
          key,
          label,
          //    decoration,
          form,
          meta,

          onChange,
          rules:
              rules != null ? [...rules, emailValidation] : [emailValidation],
        ));
      }
      break;
    case "Select":
      {
        return new SelectWidget(ElementOption(
          key,
          label,
          //    decoration,
          form,
          meta,

          onChange,
          rules: rules,
          relations: relations,
        ));
      }
      break;
    case "ISelect":
      {
        return new SelectWidget(ElementOption(
          key,
          label,
          //    decoration,
          form,
          meta,

          onChange,
          rules: rules,
          relations: relations,
        ));
      }
      break;
    case "Radio":
      {
        return new RadioWidget(ElementOption(
          key,
          label,
          //    decoration,
          form,
          meta,

          onChange,
          rules: rules,
        ));
      }
      break;
    case "Checkbox":
      {
        return new CheckboxWidget(ElementOption(
          key,
          label,
          //     decoration,
          form,
          meta,

          onChange,
          rules: rules,
        ));
      }
      break;
    case "Date":
      {
        return new DateTimePickerWidget(ElementOption(
          key,
          label,
          //      decoration,
          form,
          meta,

          onChange,
          rules: rules,
        ));
      }
      break;
    case "DateTime":
      {
        return new DateTimePickerWidget(
          ElementOption(
            key,
            label,
            //      decoration,
            form,
            meta,

            onChange,
            rules: rules,
          ),
          dateTimeMode: true,
        );
      }
      break;
    case "Image":
      {
        return new ImageUploadWidget(ElementOption(
          key,
          label,
          //     decoration,
          form,
          meta,

          onChange,
          rules: rules,
        ));
      }
      break;
    default:
      {
        return Container();
      }
      break;
  }
}
