import 'package:flutter/cupertino.dart';
import 'package:fluttertransport/services/service_method.dart';

class HomeModel {
  double totalWeight;
  List<Car> cars;
  int carsNum;
  double avgWeight;
  HomeModel({this.totalWeight, this.cars, this.carsNum, this.avgWeight});
  setHistogram(data) {
    if (data != null) {
      cars = new List<Car>();
      for (var val in data) {
        cars.add(new Car.set(val[0], val[1]));
      }
    }
  }
}

class Car {
  String name;
  double weight;

  Car({this.name, this.weight});
  Car.set(n, w) {
    this.name = n;
    this.weight = w;
  }
}
