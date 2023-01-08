import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:catalinadev/model/blog/blog_model.dart';
import 'package:catalinadev/services/blog_api.dart';
import 'package:uiblock/uiblock.dart';

class BlogProvider with ChangeNotifier {
  List<BlogListModel> listBlog = [];
  List<BlogBanner> blogBanner = [];
  List<CommentList> commentList = [];

  BlogListModel? blog;
  BlogListModel? blogDetail;

  String? slug;

  bool loading = true;
  bool loadMore = false;

  Future<void> getListBlog(context, {String? id, int? page = 1}) async {
    try {
      loadMore = true;
      await BlogApi().getListBlog(id: id, page: page).then((data) {
        var decode = json.decode(data.body);
        if (data.statusCode == 200) {
          print('decode : ' + decode.toString());
          if (page == 1) {
            listBlog = [];
          }
          loadMore = false;
          for (var item in decode) {
            listBlog.add(BlogListModel.fromJson(item));
          }
          notifyListeners();
        }
      });
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future<void> reset() async {
    loading = true;
    notifyListeners();
  }

  Future<List<BlogBanner>> getBanner(context) async {
    try {
      blogBanner = [];
      UIBlock.block(context);
      await BlogApi().getBanner().then((data) {
        var decode = json.decode(data.body);
        if (data.statusCode == 200) {
          for (var item in decode) {
            blogBanner.add(BlogBanner.fromJson(item));
          }
        }
      });
    } catch (e) {
      print(e);
    }
    notifyListeners();
    UIBlock.unblock(context);
    return blogBanner;
  }

  Future<void> getDetailBlog(context, {String? id}) async {
    try {
      await BlogApi().getDetailBlog(id: id).then(
        (data) {
          var decode = json.decode(data.body);
          if (data.statusCode == 200) {
            blogDetail = BlogListModel.fromJson(decode);
          }
        },
      );
    } catch (e) {
      print(e);
      notifyListeners();
    }
    loading = false;
    notifyListeners();
    print(json.encode(blogDetail));
  }

  Future<void> getDetailBlogBySlug(context, {String? slug}) async {
    try {
      await BlogApi().getDetailBlogBySlug(slug: slug).then(
        (data) {
          final responseJson = json.decode(data.body);
          print("responseJson : ${responseJson.toString()}");
          for (Map item in responseJson) {
            blogDetail = BlogListModel.fromJson(item);
          }
          getComment(context, id: blogDetail!.id);
          notifyListeners();
        },
      );
    } catch (e) {
      print(e);
      notifyListeners();
    }
    loading = false;
    notifyListeners();
    print(json.encode(blogDetail));
  }

  Future<void> getComment(context, {int? id}) async {
    try {
      await BlogApi().getComment(id: id).then((data) {
        if (data.statusCode == 200) {
          commentList = [];
          var decode = json.decode(data.body);
          for (var item in decode) {
            commentList.add(CommentList.fromJson(item));
          }
          notifyListeners();
        }
      });
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> sendComment(context, {String? comment}) async {
    try {
      UIBlock.block(context);
      await BlogApi()
          .sendComment(blogID: blogDetail!.id, comment: comment)
          .then((data) {
        getComment(context, id: blogDetail!.id);
      });
    } catch (e) {
      print(e);
    }
    UIBlock.unblock(context);
    notifyListeners();
  }
}
