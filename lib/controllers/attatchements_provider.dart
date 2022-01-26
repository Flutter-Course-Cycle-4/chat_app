import 'package:flutter/material.dart';

class AttachmentsProvider with ChangeNotifier {
  bool showAtt;

  AttachmentsProvider() : showAtt = false;

  void toggleAttachments() {
    showAtt = !showAtt;
    notifyListeners();
  }
}
