import 'package:flutter/foundation.dart';
import 'package:notebook/models/note.dart';

class HomePageProvider extends ChangeNotifier{
  List<NoteBook> _notebooks = [];
  bool _isLoading = true;

  List<NoteBook> get notebooks => _notebooks;

  set notebooks(List<NoteBook> value) {
    _notebooks = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}