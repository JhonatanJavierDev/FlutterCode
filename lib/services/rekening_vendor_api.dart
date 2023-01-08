import 'package:catalinadev/session/session.dart';
import 'package:catalinadev/utils/globalURL.dart';

class RekeningVendorAPI {
  sendRekeningVendorAPI({
    String? acName,
    bankName,
    bankAddress,
    acNumber,
    routingNumber,
  }) async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "ac_name": acName,
      "ac_number": acNumber,
      "bank_name": bankName,
      "bank_addr": bankAddress,
      "routing_number": routingNumber,
    };
    var response =
        await baseAPI.postAsync(rekeningVendorURL, data, isCustom: true);
    // print(data);
    // print(rekeningVendorURL);
    // print(response);
    return response;
  }
}
