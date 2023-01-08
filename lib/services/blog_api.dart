import 'package:catalinadev/session/session.dart';
import 'package:catalinadev/utils/globalURL.dart';

class BlogApi {
  getListBlog({String? id, int? page = 1, int perPage = 10}) async {
    var response = await baseAPI.getAsync(
        '$blogListURL?per_page=$perPage&page=$page&_embed',
        isCustom: true,
        version: 22);

    return response;
  }

  getBanner() async {
    var response = await baseAPI.getAsync('$homeMiniBanner?blog_banner=true',
        isCustom: true);
    return response;
  }

  getDetailBlog({String? id}) async {
    var response = await baseAPI.getAsync('$blogListURL/$id?_embed=true',
        isCustom: true, version: 22);

    return response;
  }

  getDetailBlogBySlug({String? slug}) async {
    print("slug api : ${slug.toString()}");
    var response = await baseAPI.getAsync('$blogListURL/?_embed&slug=$slug',
        isCustom: true, version: 22);
    return response;
  }

  getComment({int? id}) async {
    var response = await baseAPI.getAsync('$listCommentURL?post=$id',
        isCustom: true, version: 22);

    return response;
  }

  sendComment({int? blogID, String? comment}) async {
    Map data = {
      "cookie": Session.data.getString('cookie'),
      "post": blogID,
      "comment": comment,
    };

    var response =
        await baseAPI.postAsync(sendCommentURL, data, isCustom: true);

    return response;
  }
}
