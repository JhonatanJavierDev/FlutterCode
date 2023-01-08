import 'package:flutter/material.dart';
import 'package:catalinadev/model/create_vendor.dart';
import 'package:catalinadev/services/register_update_vendor.dart';

class RegisterUpdateVendor with ChangeNotifier {
  bool isRegistered = false;

  Future<CreateVendor?> createupdateVendor({
    String? firstStore,
    String? city,
    String? countryID,
    String? address,
    String? description,
    String? zip,
    int? avatarID,
    int? bannerID,
    bool? isUpdate,
  }) async {
    CreateVendor? result;
    try {
      await VendorAPI()
          .registerUpdateVendorApi(
        address: address,
        avatarID: avatarID,
        bannerID: bannerID,
        city: city,
        countryID: countryID,
        description: description,
        firstStore: firstStore,
        isUpdate: isUpdate,
        zip: zip,
      )
          .then((data) {
        print(data);
        if (data != null) {
          print("ada");
          // isRegistered = true;
          result = CreateVendor.fromJson(data);
          notifyListeners();
          return result;
        } else {
          print("kosong");
        }
      });
    } catch (e) {
      print(e);
      notifyListeners();
    }
    notifyListeners();
    return result;
  }
}
