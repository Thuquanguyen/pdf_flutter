import 'package:booklibrary/model/base_model.dart';

class LanguageController {
  static final LanguageController _singleton = LanguageController._internal();

  factory LanguageController() {
    return _singleton;
  }

  LanguageController._internal();

  List<BaseModel> listLanguages = [];

}