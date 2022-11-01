import 'package:flutter/material.dart';

class ElementOption {
  final String component;
  final String label;
  final dynamic? relations;
  // final InputDecoration decoration;
  final Map<String, dynamic> form;
  final Map<dynamic, dynamic> meta;
  final void Function(String component, dynamic value) onChange;
  final List<FormFieldValidator>? rules;

  const ElementOption(
    this.component,
    this.label,
    // this.decoration,
    this.form,
    this.meta,
    this.onChange, {
    this.relations,
    this.rules = const [],
  });
}
