import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathprovider;
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  Future initializeHive() async {
    final appDocumentDirectory =
        await pathprovider.getApplicationDocumentsDirectory();
    Hive.initFlutter(appDocumentDirectory.path);
    debugPrint('[LOG] From hiveservice class => Hive Initialized');
  }

  // a function to add key,value pairs in a box of given boxname
  Future addDataInBox(String _key, String _value, String boxname) async {
    final Box box = await Hive.openBox<String>(boxname);
    if (box.containsKey(_key)) {
      debugPrint(
          "[LOG] From hiveservice class => Hive already contains this key-value pair, so deleting it and updating it");
      box.delete(_key);
      box.put(_key, _value);
    } else {
      debugPrint(
          "[LOG] From hive service class => Adding new key-value pair into hive");
      box.put(_key, _value);
    }
  }

  //this function returns the value corresponding to the given key in the given boxname
  Future getData(String keyname, String boxname) async {
    final Box box = await Hive.openBox<String>(boxname);
    final valuename = await box.get(keyname);
    debugPrint(
        "[LOG] From hiveservice class  => Tried to fetch value with a key. KV pair is $keyname - $valuename");
    return await valuename;
  }
}
