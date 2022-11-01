class FormView {
  int _sectionIndex = 0;
  int get sectionIndex => _sectionIndex;
  List<Map<String, String>> _sections = [];
  List<Map<String, String>> get sections => _sections;
  Map<String, dynamic> _model = Map<String, dynamic>();
  Map<String, dynamic> get model => _model;

  void netx() {
    _sectionIndex++;
  }

  void pre() {
    _sectionIndex--;
  }
}
