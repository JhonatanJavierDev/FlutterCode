import 'package:catalinadev/session/session.dart';
import 'package:catalinadev/utils/globalURL.dart';
import 'package:catalinadev/utils/utility.dart';

class OrderAPI {
  checkoutOrder(order) async {
    var response =
        await baseAPI.getAsync('$orderApi?order=$order', isOrder: true);
    return response;
  }

  listMyOrder(String? status, String? search) async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "status": status,
      "search": search
    };
    printLog(data.toString());
    var response = await baseAPI.postAsync(
      '$listOrders',
      data,
      isCustom: true,
    );
    return response;
  }

  detailOrder(String? orderId) async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "order_id": orderId
    };
    printLog(data.toString());
    var response = await baseAPI.postAsync(
      '$listOrders',
      data,
      isCustom: true,
    );
    return response;
  }

  listOrderVendor(int? page) async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "cookie_name": Session.data.getString('cookie_name'),
      "limit": 8,
      "page": page
    };
    print(data.toString());
    var response = await baseAPI.postAsync(
      '$listOrdersVendorUrl',
      data,
      isCustom: true,
    );
    return response;
  }

  updateOrderStatus(int? orderId, String? status) async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "cookie_name": Session.data.getString('cookie_name'),
      "order_id": orderId,
      "status": status
    };
    printLog(data.toString());
    var response = await baseAPI.postAsync(
      '$updateOrderUrl',
      data,
      isCustom: true,
    );
    return response;
  }
}
