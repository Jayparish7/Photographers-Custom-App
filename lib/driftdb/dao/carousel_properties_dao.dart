import 'dart:convert';

import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart';
import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;
import 'package:photomall_flutter/driftdb/dao/jvt_file_connector_dao.dart';

class CarouselPropertiesDao {
  AppDb database = AppDb();

  Future<int> insertCarouselProperties(
      CarouselPropertiesCompanion entity) async {
    return await database.into(database.carouselProperties).insert(entity);
  }

  Future<int> insertCarouselProperty(
      transporter.CarouselProperty carouselProperty) async {
    String? image = getCarouselImage(carouselProperty.jvtFileConnectors!);

    CarouselPropertiesCompanion entity = CarouselPropertiesCompanion(
      code: drift.Value(carouselProperty.code!),
      ableType: drift.Value(carouselProperty.ableType),
      ableCode: drift.Value(carouselProperty.ableCode),
      priorityScore: drift.Value(carouselProperty.priority!),
      image: drift.Value(image),
    );
    return await database.into(database.carouselProperties).insert(entity);
  }

  Future<int?> updateCarouselProperty(
      transporter.CarouselProperty? carouselProperty) async {
    showLog(
        "the carousel initiated for update code: ${carouselProperty!.code} p: ${carouselProperty.priority}");
    String? image = getCarouselImage(carouselProperty.jvtFileConnectors!);
    showLog("the carousel initiated for update name ${image}");
    if (image != null) {
      CarouselPropertiesCompanion entity = CarouselPropertiesCompanion(
        code: drift.Value(carouselProperty.code!),
        ableType: drift.Value(carouselProperty.ableType),
        ableCode: drift.Value(carouselProperty.ableCode),
        priorityScore: drift.Value(carouselProperty.priority!),
        image: drift.Value(image),
      );
      return await (database.update(database.carouselProperties)
            ..where((tbl) => tbl.code.equals(carouselProperty.code!)))
          .write(entity);
    }
      return null;
  }

  Future<List<CarouselProperty>?> getCarouselsProperties() async {
    try {
      return (await database.select(database.carouselProperties)
            ..orderBy([
              (t) => drift.OrderingTerm(
                  expression: t.priorityScore, mode: drift.OrderingMode.desc)
            ]))
          .get();
    } catch (e) {
      showLog('problem while getting carousel from db $e');
      return null;
    }
  }

  Future<List<JvtFile?>?> getCarouselsImages() async {
    try {
      var query = (database.select(database.carouselProperties)).join([
        drift.innerJoin(
            database.jvtFileConnectors,
            database.jvtFileConnectors.ableCode
                .equalsExp(database.carouselProperties.code)),
        drift.innerJoin(
            database.jvtFiles,
            database.jvtFiles.code
                .equalsExp(database.jvtFileConnectors.jvtFileCode))
      ]);
      return query.map((R) {
        return R.readTableOrNull(database.jvtFiles);
      }).get();
    } catch (e) {
      showLog('problem while getting carousel from db $e');
      return null;
    }
  }

  Future<int> deleteCarouselProperties(String code) async {
    JvtFileConnectorModelDao jvtFileConnectorModelDao =
        JvtFileConnectorModelDao();
    // delete file connector
    await jvtFileConnectorModelDao.deleteJvtFileConnectorByAbleCodeAndAbleType(
        code, TransportDataKeys.carousel);
    //delete carousel properties
    return await (database.delete(database.carouselProperties)
          ..where((tbl) {
            return tbl.code.equals(code);
          }))
        .go();
  }

  String? getCarouselImage(List<dynamic> jvtFileConnectors) {
    showLog('the getCarouselImage code ${jvtFileConnectors}');
    try {
      // return cover image name
      List<transporter.JvtFileConnectors> jvtFileConnector =
          jvtFileConnectors.map((row) {
        return transporter.JvtFileConnectors.fromJson(
            json.decode(json.encode(row)));
      }).toList();
      transporter.JvtFile? file;
      showLog('the getCarouselImage code ${jvtFileConnector.length}');
      for (transporter.JvtFileConnectors image in jvtFileConnector) {
        showLog('the getCarouselImage code ${image.code}');

        if (image.name == TransportDataKeys.mobileCarousel) {
          file = image.jvtFile!;
          break;
        }
      }
      return file?.name;
    } catch (e) {
      showLog("the error in carousel ${e}");
      return null;
    }
  }
}
