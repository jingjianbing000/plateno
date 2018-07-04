import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../page/property/sub.dart';
import '../page/investor/main.dart';

import '../page/visit/view.dart';
import '../page/visit/finish.dart';
import '../page/visit/plan.dart';
import '../page/visit/add.dart';

var propertyDetailHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return new PropertySub(params['data'][0]);
});

var investorDetailHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return new InvestorDetailPage(params['data'][0]);
});

var viewVisitDetailHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return new viewVisit(params['data'][0]);
});

var finishVisitHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return new finishVisit(params['data'][0]);
});

var addVisitPlanHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return new planVisitPage(params['data'][0]);
});

var addTemporaryVisitHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return new addVisitPage(params['data'][0]);
});
