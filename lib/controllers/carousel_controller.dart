import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/carousel_properties_dao.dart';

class CarouselController {
  CarouselPropertiesDao carouselPropertiesDao = CarouselPropertiesDao();

  Future<void> upsertCarousel(
      {required List<transporter.CarouselProperty>? carouselProperties}) async {
    List<String> apiCarousel = [];
    for (transporter.CarouselProperty carouselProperty in carouselProperties!) {
      apiCarousel.add(carouselProperty.code!);
    }
    List<String> existingCarousel = [];
    if (apiCarousel.isNotEmpty) {
      List create = []; // insert this event
      List delete = []; // delete this event
      List update = []; // change update required as true
      /// get local event

      List<appDb.CarouselProperty>? carousels =
          await carouselPropertiesDao.getCarouselsProperties();
      if (carousels != null && carousels.isNotEmpty) {
        carousels.forEach((carousel) {
          showLog('the carousel want to be deleted 6 ${carousel.code} ');

          existingCarousel.add(carousel.code);
        });
      }
      for (int i = 0; i < apiCarousel.length; i++) {
        if (existingCarousel.contains(apiCarousel[i])) {
          showLog('the carousel want to be deleted 6 ${apiCarousel[i]} ');

          update.add(apiCarousel[i]);
        }
        if (!existingCarousel.contains(apiCarousel[i])) {
          create.add(apiCarousel[i]);
        }
      }
      for (int i = 0; i < existingCarousel.length; i++) {
        if (!apiCarousel.contains(existingCarousel[i])) {
          delete.add(existingCarousel[i]);
        }
      }
      //   List<transporterModel.Order> _ordersNew =
      //   Orders.where((obj) => obj.code == create[i]).toList();
      /// INSERT New Carousel properties
      if (create.isNotEmpty) {
        for (int i = 0; i < create.length; i++) {
          List<transporter.CarouselProperty> _newCarousel =
              carouselProperties.where((obj) => obj.code == create[i]).toList();
          await carouselPropertiesDao
              .insertCarouselProperty(_newCarousel.first);
        }
      }

      /// UPDATE Existing Carousel carousel properties
      if (update.isNotEmpty) {
        for (int i = 0; i < update.length; i++) {
          List<transporter.CarouselProperty> _updateCarousel =
              carouselProperties.where((obj) => obj.code == update[i]).toList();

          carouselPropertiesDao.updateCarouselProperty(_updateCarousel.first);
        }
      }

      /// DELETE Carousel At Carousel Properties NEED TO BE DELETED
      if (delete.isNotEmpty) {
        for (int i = 0; i < delete.length; i++) {
          showLog('the carousel want to be deleted${delete[i]}');
          carouselPropertiesDao.deleteCarouselProperties(delete[i]);
        }
      }
    }
  }
}
