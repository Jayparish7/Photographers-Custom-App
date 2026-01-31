class FoldersRouteModel {
  String? folderCode;
  String? eventCode;
  String? eventCodeForDownload;
  bool isDemoEvent;

  FoldersRouteModel(
      {this.folderCode,
      this.eventCode,
      this.isDemoEvent = false,
      this.eventCodeForDownload});
}
