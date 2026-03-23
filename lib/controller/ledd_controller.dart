import 'package:flutter/material.dart';

import '../model/lead_model.dart';
import '../service/lead_service.dart';

class LeadController extends ChangeNotifier {
  final LeadService _service = LeadService();

  List<LeadModel> leads = [];
  bool isLoading = false;
  String error = "";

  Future<void> fetchLeads(String mobile) async {
    try {
      isLoading = true;
      error = "";
      notifyListeners();

      leads = await _service.getLeads(mobile);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
