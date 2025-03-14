import 'dart:io';
import 'package:recase/recase.dart';
import 'vi_VN.dart';

List<String> getAllKeys() {
  List<String> keys = vi_VN.keys.map((e) => e).toList();
  return keys;
}

Future<void> gen(List<String> keys) async {
  Directory current = Directory.current;
  File _file = File('${current.path}/lib/language/i18n.g.dart');
  String properties = keys.map((e) => """\tString ${(e + '_str').camelCase} = '$e';""").toList().join('\n');

  await _file.writeAsString('''
class I18n {
  factory I18n() => _instance;
  I18n._();
  static final _instance = I18n._();
  
$properties
}
''');
}

Future<void> start() async {
  print('***[I18n] STARTED ***');
  List<String> keys = getAllKeys();
  await gen(keys);
  print('***[I18n] GENERATED ${keys.length} items ***');
}

main() {
  start();
}
