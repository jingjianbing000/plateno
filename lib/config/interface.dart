class Interface {
  static getRoot() {
    return 'http://10.100.14.173:8000';
  }

  //登录
  static login() {
    return Interface.getRoot() + '/login';
  }

  //注销
  static logout() {
    return Interface.getRoot() + '/logout';
  }

  //检测token
  static checkToken() {
    return Interface.getRoot() + '/check';
  }

  //按新老类型查询投资人
  static getInvestorByType() {
    return Interface.getRoot() + '/investors/conditionalEx';
  }

  //获取投资人详情
  static getInvestorDetail() {
    return Interface.getRoot() + '/investors/detail';
  }

  //获取某个投资人的拜访
  static getAssociatedVisit() {
    return Interface.getRoot() + '/investors/visit';
  }

  //获取拜访详情
  static getVisitDetail() {
    return Interface.getRoot() + '/visit/detail';
  }

  //提交拜访
  static postVisit() {
    return Interface.getRoot() + '/visit/post';
  }

  //查询物业
  static getPropertyByConditional() {
    return Interface.getRoot() + '/property/conditional';
  }
}
