import 'package:petitparser/petitparser.dart';

void doFormula(List<dynamic> formula, String model, Map<String, dynamic> model_,
    List<Map<String, dynamic>> schema, String subFormModelName) async {
  if (formula.length >= 1) {
    int formulaIndex =
        formula.indexWhere((formula) => formula["model"] == model);

    print(model);
    print("=====================");
    print(formulaIndex);

    if (formulaIndex <= -1) {
      for (dynamic _formula in formula) {
        if (_formula["template"].contains(model)) {
          doFormula2(_formula, model, model_, schema, subFormModelName);
        }
      }
    } else {
      doFormula2(
          formula[formulaIndex], model, model_, schema, subFormModelName);
    }
  }
}

void doFormula2(
    Map<String, dynamic> _formula,
    String model,
    Map<String, dynamic> model_,
    List<Map<String, dynamic>> schema,
    String subFormModelName) async {
  bool useFormula = false;
  if (_formula['form'] != null) {
    if (_formula['form'] == 'main')
      useFormula = true;
    else if (subFormModelName != "") {
      if (_formula['form'] == subFormModelName) useFormula = true;
    }
  } else {
    useFormula = true;
  }

  if (useFormula) {
    for (dynamic target in _formula["targets"]) {
      var schemaIndex = getSchemaIndex(schema, target["field"]);

      if (schemaIndex >= 0) {
        if (target['prop'] == 'value') {
          model_[target["field"]] =
              formulaParse(_formula["template"].toString(), model_);
        } else {
          if (target["prop"] == 'hidden') {
            schema[schemaIndex][target["prop"]] =
                parseShowHide(_formula["template"].toString(), model_);
          }
        }
      }
    }
  }
}

int getSchemaIndex(schema_, model) {
  return schema_.indexWhere((item) => item["model"] == model);
}

double formulaParse(String template, Map<String, dynamic> model_) {
  var preFormula = dataFromTemplate(template, model_);
  final builder = ExpressionBuilder();
  builder.group()
    ..primitive(digit()
        .plus()
        .seq(char('.').seq(digit().plus()).optional())
        .flatten()
        .trim()
        .map((a) => num.tryParse(a)))
    ..wrapper(char('(').trim(), char(')').trim(), (l, a, r) => a);
// negation is a prefix operator
//   builder.group()..prefix(char('-').trim(), (op, a) => -a);

// multiplication and addition are left-associative
//   builder.group()
//     ..left(char('*').trim(), (a, op, b) => a * b)
//     ..left(char('/').trim(), (a, op, b) => a / b);
//   builder.group()
//     ..left(char('+').trim(), (a, op, b) => a + b)
//     ..left(char('-').trim(), (a, op, b) => a - b);

  builder.group()..right(string('==').trim(), (a, op, b) => a == b);

  final parser = builder.build().end();

  var parsed = parser.parse(preFormula);

  return parsed.value;
}

bool parseShowHide(String template, Map<String, dynamic> model_) {
  var preFormula = dataFromTemplate(template, model_);

  print("=================================");
  print(preFormula);
  final builder = ExpressionBuilder();
  builder.group()
    ..primitive(digit()
        .plus()
        .seq(char('.').seq(digit().plus()).optional())
        .flatten()
        .trim()
        .map((a) => num.tryParse(a)))
    ..wrapper(char('(').trim(), char(')').trim(), (l, a, r) => a);
// negation is a prefix operator
//   builder.group()..prefix(char('-').trim(), (op, a) => -a);

// multiplication and addition are left-associative
/*  builder.group()
    ..left(char('*').trim(), (a, op, b) => a * b)
    ..left(char('/').trim(), (a, op, b) => a / b);
  builder.group()
    ..left(char('+').trim(), (a, op, b) => a + b)
    ..left(char('-').trim(), (a, op, b) => a - b);*/

  builder.group()..right(string('==').trim(), (a, op, b) => a == b);
  builder.group()..right(string('!=').trim(), (a, op, b) => a != b);
/*  builder.group()..right(string('<=').trim(), (a, op, b) => a <= b);
  builder.group()..right(string('>=').trim(), (a, op, b) => a >= b);*/

  final parser = builder.build().end();

  var parsed = parser.parse(preFormula);

  return parsed.value;
}

String dataFromTemplate(template, Map<String, dynamic> values) {
  for (String key in values.keys) {
    template = template.replaceAll(
        new RegExp(r"{" + key + "}"), values[key].toString());
  }
  template = template.replaceAll(new RegExp(r"'"), '');
  return template;
}
