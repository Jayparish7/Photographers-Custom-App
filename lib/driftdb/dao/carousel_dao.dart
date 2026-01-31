import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart' as transporter;
import 'package:photomall_flutter/traits/utils/screen_utils.dart';

class CarouselDao {
  AppDb database = AppDb();
  Future<int?> insertCarousel(transporter.Carousel carousel ) async {
    int height = 100;
    int width = 1000;
    if(carousel.resolutions!.isNotEmpty){
      for(transporter.Resolution resolution in carousel.resolutions!){
        if(resolution.screenDisplay == currentDevice){
          height = resolution.height!;
          width = resolution.width!;
        }
      }
    }

    CarouselCompanion  entity  = CarouselCompanion(
      interval:drift.Value(carousel.interval!),
      code:drift.Value(carousel.code!),
      lastUpdatedAt:drift.Value(carousel.lastUpdatedAt!),
        width: drift.Value(width),
      height:drift.Value(height)
    );
    try{
      return await database.into(database.carousel).insertOnConflictUpdate(entity);
    }catch(e){
      showLog('problem while insert carousel from db $e');
      return null;
    }
  }
    Future<CarouselData?> getCarousels() async {
    try{
      return await (database.select(database.carousel)..limit(1)).getSingleOrNull();
    }catch(e){
      showLog('problem while getting carousel from db $e');
      return null;
    }
  }

}