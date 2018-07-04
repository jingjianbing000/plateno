class Token {
  String account;
  String name;
  String token;
  int identity;

  Token(this.account, this.name, this.token, this.identity);

  Token.map(dynamic obj) {
    this.account = obj['account'];
    this.name = obj['name'];
    this.token = obj['token'];
    this.identity = obj['identity'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['account'] = account;
    map['name'] = name;
    map['token'] = token;
    map['identity'] = identity;

    return map;
  }
}
