import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'route_handlers.dart';

class Routes {
  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("未找到路由定义 !!!");
    });

    //物业详情
    router.define("/property/detail/:data", handler: propertyDetailHandler);

    //投资人详情
    router.define('/investor/detail/:data', handler: investorDetailHandler);

    //拜访详情
    router.define("/visit/detail/:data", handler: viewVisitDetailHandler);

    //完成拜访
    router.define("/visit/finish/:data", handler: finishVisitHandler);

    //新增拜访计划
    router.define("/visit/plan/:data", handler: addVisitPlanHandler);

    //新增临时拜访
    router.define("/visit/add/:data", handler: addTemporaryVisitHandler);
  }
}
