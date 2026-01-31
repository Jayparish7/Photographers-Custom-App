import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/print_users_response_model.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;

import '../driftdb/app_db.dart';
import '../driftdb/dao/print_status_dao.dart';

class PrintStatusController {
  Future<void> upsertPrintStatus(
      {List<Datum>? PrintStatusData, String? eventCode}) async {
    PrintStatusDao printStatusDao = PrintStatusDao();
    List create = []; // insert this event
    List delete = []; // delete this event
    List update = []; // change update required as true
    List<String> apiPrint = [];
    List<String> notify = [];
    List<String> existingPrints = [];
    List<appDb.PrintTableCompanion> printStatusCompanionsInsertOrUpdate = [];
    showLog('PrintStatusData $PrintStatusData');

    if (PrintStatusData != null && PrintStatusData.isNotEmpty) {
      showLog('PrintStatusData 1');

      for (Datum printData in PrintStatusData) {
        List<Datum>? prints = PrintStatusData;
        showLog('print $printData');

        //String eventCode = aIData.code!;
        if (prints.isNotEmpty) {
          for (Datum print in prints) {
            apiPrint.add(print.ableCode!);
            showLog('api print is ${apiPrint.length}');
          }
          if (apiPrint.isNotEmpty) {
            /// get local print event

            List<PrintTableData> printStatus = await printStatusDao
                .getPrintStatusByEventCode(eventCode: eventCode!);
            showLog('local print $printStatus');
            if ( printStatus.isNotEmpty) {
              printStatus.forEach((_print) {
                existingPrints.add(_print.ableCode);
              });
            }
            for (int i = 0; i < apiPrint.length; i++) {
              if (existingPrints.contains(apiPrint[i])) {
                update.add(apiPrint[i]);
              }
              if (!existingPrints.contains(apiPrint[i])) {
                notify.add(apiPrint[i]);
                create.add(apiPrint[i]);
              }
            }
            for (int i = 0; i < existingPrints.length; i++) {
              if (!apiPrint.contains(existingPrints[i])) {
                delete.add(existingPrints[i]);
              }
            }

            /// INSERT New Folder
            if (create.isNotEmpty) {
              for (int i = 0; i < create.length; i++) {
                List<Datum?>? _newPrints =
                    prints.where((obj) => obj.ableCode == create[i]).toList();
                if (_newPrints.isNotEmpty &&
                    _newPrints.first != null) {
                  printStatusCompanionsInsertOrUpdate
                      .add(appDb.PrintTableCompanion(
                    code: drift.Value(_newPrints.first!.code!),
                    ableCode: drift.Value(_newPrints.first!.ableCode!),
                    ableType: drift.Value(_newPrints.first!.ableType!),
                    eventCode: drift.Value(eventCode),
                    status: drift.Value(_newPrints.first!.status!),
                  ));
                  showLog(
                      'upsertPrint 5 :  ${printStatusCompanionsInsertOrUpdate[0]}');
                }
              }
            }

            /// UPDATE Existing Folder
            if (update.isNotEmpty) {
              for (int i = 0; i < update.length; i++) {
                List<Datum?>? _updatePrints =
                    prints.where((obj) => obj.ableCode == update[i]).toList();

                // update all
                if (_updatePrints.isNotEmpty &&
                    _updatePrints.first != null) {
                  printStatusCompanionsInsertOrUpdate
                      .add(appDb.PrintTableCompanion(
                    code: drift.Value(_updatePrints.first!.code!),
                    ableCode: drift.Value(_updatePrints.first!.ableCode!),
                    ableType: drift.Value(_updatePrints.first!.ableType!),
                    eventCode: drift.Value(eventCode),
                    status: drift.Value(_updatePrints.first!.status!),
                  ));
                }
              }
            }

            /// DELETE Folder NEED TO BE DELETED
            if (delete.isNotEmpty) {
              for (int i = 0; i < delete.length; i++) {
                await printStatusDao.deletePrintStatus(code: delete[i]);
              }
            }
          }
        }
      }
      if (printStatusCompanionsInsertOrUpdate.isNotEmpty) {
        await printStatusDao
            .insertPrintStatus(printStatusCompanionsInsertOrUpdate);
      }
      showLog('upsertPrint :  ${create.length}');
      showLog('upsertPrintStatus11 :  ${update.length}');
      showLog('upsertPrint12 :  ${delete.length}');
      showLog('upsertPrints:  ${printStatusCompanionsInsertOrUpdate.length}');
    }
  }
}
