import 'package:catalinadev/session/session.dart';
import 'package:catalinadev/utils/globalURL.dart';

class VendorAPI {
  registerUpdateVendorApi({
    String? firstStore = '',
    String? city = '',
    String? countryID = '',
    String? address = '',
    String? description = '',
    String? zip = '',
    int? avatarID = 0,
    int? bannerID = 0,
    bool? isUpdate = false,
  }) async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "first_store_name": firstStore,
      // "last_store_name": "- Store",
      "city": city,
      "zip": zip,
      "country_id": countryID,
      "address": address,
      "description": description,
      if (avatarID != null) "avatar_id": avatarID,
      if (bannerID != null) "banner_id": bannerID,
      "is_update": isUpdate,
    };
    print(data);
    var response =
        await baseAPI.postAsync("$createUpdateVendorURL", data, isCustom: true);
    print(response);
    return response;
  }
}
