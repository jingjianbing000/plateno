import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

class Position {
  String address;
  String country;
  String province;
  String city;
  String district;
  String street;
  String streetNumber;
  String direction;
  PositionSub loc;

  Position({
    @required this.address,
    @required this.country,
    @required this.province,
    @required this.city,
    @required this.district,
    @required this.street,
    @required this.streetNumber,
    @required this.direction,
    @required this.loc,
  });

  static getAddressByLngAndLat(double lng, double lat) async {
    final String ak = 'wrA630tdZQO9zRjwoKuAMGG8ClxC6sH5';
    final String api = 'https://api.map.baidu.com/geocoder/v2/';
    final String type = 'json';

    String url = api +
        '?ak=' +
        ak +
        '&output=' +
        type +
        '&location=' +
        lat.toString() +
        ',' +
        lng.toString();

    Dio dio = new Dio();
    Response response = await dio.get(url);
    Map data = JSON.decode(response.data);
    return Position.fromMap(data['result']);
  }

  static Position fromMap(Map data) {
    return new Position(
      address: data['formatted_address'],
      country: data['addressComponent']['country'],
      province: data['addressComponent']['province'],
      city: data['addressComponent']['city'],
      district: data['addressComponent']['district'],
      street: data['addressComponent']['street'],
      streetNumber: data['addressComponent']['street_number'],
      direction: data['addressComponent']['direction'],
      loc: PositionSub.fromMap(data['location']),
    );
  }
}

class PositionSub {
  final double lng;
  final double lat;

  PositionSub({@required this.lng, @required this.lat});

  static PositionSub fromMap(Map map) {
    return new PositionSub(
      lng: map['lng'],
      lat: map['lat'],
    );
  }
}
