class UserModel {
  int? id;
  String? username,
      niceName,
      email,
      url,
      registered,
      displayName,
      firstname,
      lastname,
      nickname,
      description,
      // capabilities,
      avatar,
      statusApprovalVendor;

  List<String>? role;

  UserModel(
      {this.id,
      this.username,
      this.niceName,
      this.email,
      this.url,
      this.registered,
      this.displayName,
      this.firstname,
      this.lastname,
      this.nickname,
      this.description,
      // this.capabilities,
      this.avatar,
      this.role,
      this.statusApprovalVendor,
      });

  Map toJson() => {
        'id': id,
        'username': username,
        'nicename': niceName,
        'email': email,
        'url': url,
        'registered': registered,
        'displayname': displayName,
        'firstname': firstname,
        'lastname': lastname,
        'nickname': nickname,
        'description': description,
        // 'capabilities': capabilities,
        'avatar': avatar,
        'role': role,
        'status_approval_vendor': statusApprovalVendor
      };

  UserModel.fromJson(Map json) {
    id = json['id'] ?? json['ID'];
    username = json['username'];
    nickname = json['nickname'];
    niceName = json['nicename'];
    email = json['email'];
    url = json['url'];
    registered = json['registered'];
    displayName = json['displayname'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    description = json['description'];
    // capabilities = json['capabilities'];
    avatar = json['avatar'];
    statusApprovalVendor = json['status_approval_vendor'];

    if (json['role'] != null) {
      role = [];
      json['role'].forEach((v) {
        role!.add(v);
      });
    }
  }
}
