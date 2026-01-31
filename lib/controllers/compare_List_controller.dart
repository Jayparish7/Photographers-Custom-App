import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporterModel;

class CompareListController {
  CompareListStatus compareOrder(
      {required List<transporterModel.Order> newOrders,
      required List<transporterModel.Order> oldOrders}) {
    CompareListStatus falseStatus = CompareListStatus(count: 0, status: false);
    List<String> apiOrders = [];
    List<String> existingOrders = [];
    newOrders.forEach((element) {
      apiOrders.add(element.code!);
    });
    if (apiOrders.isNotEmpty) {
      List create = []; // insert this event
      List delete = []; // delete this event
      List update = []; // change update required as true

      if (oldOrders.isNotEmpty) {
        oldOrders.forEach((localOrder) {
          existingOrders.add(localOrder.code!);
        });
      }

      for (int i = 0; i < apiOrders.length; i++) {
        if (existingOrders.contains(apiOrders[i])) {
          update.add(apiOrders[i]);
        }
        if (!existingOrders.contains(apiOrders[i])) {
          create.add(apiOrders[i]);
        }
      }
      for (int i = 0; i < existingOrders.length; i++) {
        if (!apiOrders.contains(existingOrders[i])) {
          delete.add(existingOrders[i]);
        }
      }

      /// INSERT NEW order
      if (create.isNotEmpty) {
        // some new orders available also we can calculate how many images
        // by [create.length]
        return CompareListStatus(status: true, count: create.length);
      } else {
        return falseStatus; // no new orders
      }
    } else {
      return falseStatus; // no new orders
    }
  }

  CompareListStatus compareFolder({
    required String newFolder,
    required String oldFolder,
  }) {
    CompareListStatus compare = CompareListStatus(
      count: 0,
      status: false,
    );
    List<String> newFolderList = newFolder.split(',');
    List<String> oldFolderList = oldFolder.split(',');

    if (newFolderList.isNotEmpty) {
      List create = []; // insert this event
      List delete = []; // delete this event
      List update = []; // change update required as true
      /// get local event

      for (int i = 0; i < newFolderList.length; i++) {
        if (oldFolderList.contains(newFolderList[i])) {
          update.add(newFolderList[i]);
        }
        if (!oldFolderList.contains(newFolderList[i])) {
          create.add(newFolderList[i]);
        }
      }
      for (int i = 0; i < oldFolderList.length; i++) {
        if (!newFolderList.contains(oldFolderList[i])) {
          delete.add(oldFolderList[i]);
        }
      }
      if (create.isNotEmpty) {
        return CompareListStatus(
          status: true,
          count: create.length,
        );
      } else {
        return compare;
      }
    }
    return compare;
  }
}

class CompareListStatus {
  bool status;

  int count;

  CompareListStatus({this.status = false, this.count = 0});
}
