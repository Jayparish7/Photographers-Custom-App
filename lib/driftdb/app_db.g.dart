// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// ignore_for_file: type=lint
class $TransportDataTable extends TransportData
    with TableInfo<$TransportDataTable, TransportDataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransportDataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
      'tag', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _lastUpdatedAtMeta =
      const VerificationMeta('lastUpdatedAt');
  @override
  late final GeneratedColumn<int> lastUpdatedAt = GeneratedColumn<int>(
      'last_updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updateRequiredMeta =
      const VerificationMeta('updateRequired');
  @override
  late final GeneratedColumn<int> updateRequired = GeneratedColumn<int>(
      'update_required', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
      'type', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, code, tag, lastUpdatedAt, updateRequired, type, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transport_data';
  @override
  VerificationContext validateIntegrity(Insertable<TransportDataData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    }
    if (data.containsKey('tag')) {
      context.handle(
          _tagMeta, tag.isAcceptableOrUnknown(data['tag']!, _tagMeta));
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
          _lastUpdatedAtMeta,
          lastUpdatedAt.isAcceptableOrUnknown(
              data['last_updated_at']!, _lastUpdatedAtMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedAtMeta);
    }
    if (data.containsKey('update_required')) {
      context.handle(
          _updateRequiredMeta,
          updateRequired.isAcceptableOrUnknown(
              data['update_required']!, _updateRequiredMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransportDataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransportDataData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code']),
      tag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tag']),
      lastUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_updated_at'])!,
      updateRequired: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}update_required'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type']),
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data']),
    );
  }

  @override
  $TransportDataTable createAlias(String alias) {
    return $TransportDataTable(attachedDatabase, alias);
  }
}

class TransportDataData extends DataClass
    implements Insertable<TransportDataData> {
  final int id;
  final String? code;
  final String? tag;
  final int lastUpdatedAt;
  final int updateRequired;
  final int? type;
  final String? data;
  const TransportDataData(
      {required this.id,
      this.code,
      this.tag,
      required this.lastUpdatedAt,
      required this.updateRequired,
      this.type,
      this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || tag != null) {
      map['tag'] = Variable<String>(tag);
    }
    map['last_updated_at'] = Variable<int>(lastUpdatedAt);
    map['update_required'] = Variable<int>(updateRequired);
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<int>(type);
    }
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
    }
    return map;
  }

  TransportDataCompanion toCompanion(bool nullToAbsent) {
    return TransportDataCompanion(
      id: Value(id),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      tag: tag == null && nullToAbsent ? const Value.absent() : Value(tag),
      lastUpdatedAt: Value(lastUpdatedAt),
      updateRequired: Value(updateRequired),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
    );
  }

  factory TransportDataData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransportDataData(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String?>(json['code']),
      tag: serializer.fromJson<String?>(json['tag']),
      lastUpdatedAt: serializer.fromJson<int>(json['lastUpdatedAt']),
      updateRequired: serializer.fromJson<int>(json['updateRequired']),
      type: serializer.fromJson<int?>(json['type']),
      data: serializer.fromJson<String?>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String?>(code),
      'tag': serializer.toJson<String?>(tag),
      'lastUpdatedAt': serializer.toJson<int>(lastUpdatedAt),
      'updateRequired': serializer.toJson<int>(updateRequired),
      'type': serializer.toJson<int?>(type),
      'data': serializer.toJson<String?>(data),
    };
  }

  TransportDataData copyWith(
          {int? id,
          Value<String?> code = const Value.absent(),
          Value<String?> tag = const Value.absent(),
          int? lastUpdatedAt,
          int? updateRequired,
          Value<int?> type = const Value.absent(),
          Value<String?> data = const Value.absent()}) =>
      TransportDataData(
        id: id ?? this.id,
        code: code.present ? code.value : this.code,
        tag: tag.present ? tag.value : this.tag,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
        updateRequired: updateRequired ?? this.updateRequired,
        type: type.present ? type.value : this.type,
        data: data.present ? data.value : this.data,
      );
  TransportDataData copyWithCompanion(TransportDataCompanion data) {
    return TransportDataData(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      tag: data.tag.present ? data.tag.value : this.tag,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
      updateRequired: data.updateRequired.present
          ? data.updateRequired.value
          : this.updateRequired,
      type: data.type.present ? data.type.value : this.type,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransportDataData(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('tag: $tag, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('updateRequired: $updateRequired, ')
          ..write('type: $type, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, tag, lastUpdatedAt, updateRequired, type, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransportDataData &&
          other.id == this.id &&
          other.code == this.code &&
          other.tag == this.tag &&
          other.lastUpdatedAt == this.lastUpdatedAt &&
          other.updateRequired == this.updateRequired &&
          other.type == this.type &&
          other.data == this.data);
}

class TransportDataCompanion extends UpdateCompanion<TransportDataData> {
  final Value<int> id;
  final Value<String?> code;
  final Value<String?> tag;
  final Value<int> lastUpdatedAt;
  final Value<int> updateRequired;
  final Value<int?> type;
  final Value<String?> data;
  const TransportDataCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.tag = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.updateRequired = const Value.absent(),
    this.type = const Value.absent(),
    this.data = const Value.absent(),
  });
  TransportDataCompanion.insert({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.tag = const Value.absent(),
    required int lastUpdatedAt,
    this.updateRequired = const Value.absent(),
    this.type = const Value.absent(),
    this.data = const Value.absent(),
  }) : lastUpdatedAt = Value(lastUpdatedAt);
  static Insertable<TransportDataData> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? tag,
    Expression<int>? lastUpdatedAt,
    Expression<int>? updateRequired,
    Expression<int>? type,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (tag != null) 'tag': tag,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (updateRequired != null) 'update_required': updateRequired,
      if (type != null) 'type': type,
      if (data != null) 'data': data,
    });
  }

  TransportDataCompanion copyWith(
      {Value<int>? id,
      Value<String?>? code,
      Value<String?>? tag,
      Value<int>? lastUpdatedAt,
      Value<int>? updateRequired,
      Value<int?>? type,
      Value<String?>? data}) {
    return TransportDataCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      tag: tag ?? this.tag,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      updateRequired: updateRequired ?? this.updateRequired,
      type: type ?? this.type,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<int>(lastUpdatedAt.value);
    }
    if (updateRequired.present) {
      map['update_required'] = Variable<int>(updateRequired.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransportDataCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('tag: $tag, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('updateRequired: $updateRequired, ')
          ..write('type: $type, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryNameMeta =
      const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
      'category_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _publishedMeta =
      const VerificationMeta('published');
  @override
  late final GeneratedColumn<bool> published = GeneratedColumn<bool>(
      'published', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("published" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
      'type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _loginRequiredMeta =
      const VerificationMeta('loginRequired');
  @override
  late final GeneratedColumn<bool> loginRequired = GeneratedColumn<bool>(
      'login_required', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("login_required" IN (0, 1))'));
  static const VerificationMeta _newlyAddedMeta =
      const VerificationMeta('newlyAdded');
  @override
  late final GeneratedColumn<bool> newlyAdded = GeneratedColumn<bool>(
      'newly_added', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("newly_added" IN (0, 1))'));
  static const VerificationMeta _archivedMeta =
      const VerificationMeta('archived');
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
      'archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("archived" IN (0, 1))'));
  static const VerificationMeta _ownedByUserMeta =
      const VerificationMeta('ownedByUser');
  @override
  late final GeneratedColumn<bool> ownedByUser = GeneratedColumn<bool>(
      'owned_by_user', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("owned_by_user" IN (0, 1))'));
  static const VerificationMeta _downloadableMeta =
      const VerificationMeta('downloadable');
  @override
  late final GeneratedColumn<bool> downloadable = GeneratedColumn<bool>(
      'downloadable', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("downloadable" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _withIconMeta =
      const VerificationMeta('withIcon');
  @override
  late final GeneratedColumn<bool> withIcon = GeneratedColumn<bool>(
      'with_icon', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("with_icon" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _withWaterMarkMeta =
      const VerificationMeta('withWaterMark');
  @override
  late final GeneratedColumn<bool> withWaterMark = GeneratedColumn<bool>(
      'with_water_mark', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("with_water_mark" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _priorityScoreMeta =
      const VerificationMeta('priorityScore');
  @override
  late final GeneratedColumn<int> priorityScore = GeneratedColumn<int>(
      'priority_score', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _personStatusMeta =
      const VerificationMeta('personStatus');
  @override
  late final GeneratedColumn<bool> personStatus = GeneratedColumn<bool>(
      'person_status', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("person_status" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _isAlbumDownloadableMeta =
      const VerificationMeta('isAlbumDownloadable');
  @override
  late final GeneratedColumn<bool> isAlbumDownloadable = GeneratedColumn<bool>(
      'isAlbumDownloadable', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("isAlbumDownloadable" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _studioCodeMeta =
      const VerificationMeta('studioCode');
  @override
  late final GeneratedColumn<String> studioCode = GeneratedColumn<String>(
      'studio_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _shareDateMeta =
      const VerificationMeta('shareDate');
  @override
  late final GeneratedColumn<String> shareDate = GeneratedColumn<String>(
      'share_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _myPhotosDownloadableMeta =
      const VerificationMeta('myPhotosDownloadable');
  @override
  late final GeneratedColumn<bool> myPhotosDownloadable = GeneratedColumn<bool>(
      'my_photos_downloadable', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("my_photos_downloadable" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _hideMediaMeta =
      const VerificationMeta('hideMedia');
  @override
  late final GeneratedColumn<bool> hideMedia = GeneratedColumn<bool>(
      'hide_media', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("hide_media" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _ownerDownloadMeta =
      const VerificationMeta('ownerDownload');
  @override
  late final GeneratedColumn<bool> ownerDownload = GeneratedColumn<bool>(
      'owner_download', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("owner_download" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _printStatusMeta =
      const VerificationMeta('printStatus');
  @override
  late final GeneratedColumn<bool> printStatus = GeneratedColumn<bool>(
      'print_status', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("print_status" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        code,
        name,
        categoryName,
        published,
        type,
        loginRequired,
        newlyAdded,
        archived,
        ownedByUser,
        downloadable,
        withIcon,
        withWaterMark,
        priorityScore,
        personStatus,
        isAlbumDownloadable,
        studioCode,
        shareDate,
        myPhotosDownloadable,
        hideMedia,
        ownerDownload,
        printStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(Insertable<Event> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('category_name')) {
      context.handle(
          _categoryNameMeta,
          categoryName.isAcceptableOrUnknown(
              data['category_name']!, _categoryNameMeta));
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
    }
    if (data.containsKey('published')) {
      context.handle(_publishedMeta,
          published.isAcceptableOrUnknown(data['published']!, _publishedMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('login_required')) {
      context.handle(
          _loginRequiredMeta,
          loginRequired.isAcceptableOrUnknown(
              data['login_required']!, _loginRequiredMeta));
    } else if (isInserting) {
      context.missing(_loginRequiredMeta);
    }
    if (data.containsKey('newly_added')) {
      context.handle(
          _newlyAddedMeta,
          newlyAdded.isAcceptableOrUnknown(
              data['newly_added']!, _newlyAddedMeta));
    } else if (isInserting) {
      context.missing(_newlyAddedMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(_archivedMeta,
          archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta));
    } else if (isInserting) {
      context.missing(_archivedMeta);
    }
    if (data.containsKey('owned_by_user')) {
      context.handle(
          _ownedByUserMeta,
          ownedByUser.isAcceptableOrUnknown(
              data['owned_by_user']!, _ownedByUserMeta));
    } else if (isInserting) {
      context.missing(_ownedByUserMeta);
    }
    if (data.containsKey('downloadable')) {
      context.handle(
          _downloadableMeta,
          downloadable.isAcceptableOrUnknown(
              data['downloadable']!, _downloadableMeta));
    }
    if (data.containsKey('with_icon')) {
      context.handle(_withIconMeta,
          withIcon.isAcceptableOrUnknown(data['with_icon']!, _withIconMeta));
    }
    if (data.containsKey('with_water_mark')) {
      context.handle(
          _withWaterMarkMeta,
          withWaterMark.isAcceptableOrUnknown(
              data['with_water_mark']!, _withWaterMarkMeta));
    }
    if (data.containsKey('priority_score')) {
      context.handle(
          _priorityScoreMeta,
          priorityScore.isAcceptableOrUnknown(
              data['priority_score']!, _priorityScoreMeta));
    }
    if (data.containsKey('person_status')) {
      context.handle(
          _personStatusMeta,
          personStatus.isAcceptableOrUnknown(
              data['person_status']!, _personStatusMeta));
    }
    if (data.containsKey('isAlbumDownloadable')) {
      context.handle(
          _isAlbumDownloadableMeta,
          isAlbumDownloadable.isAcceptableOrUnknown(
              data['isAlbumDownloadable']!, _isAlbumDownloadableMeta));
    }
    if (data.containsKey('studio_code')) {
      context.handle(
          _studioCodeMeta,
          studioCode.isAcceptableOrUnknown(
              data['studio_code']!, _studioCodeMeta));
    }
    if (data.containsKey('share_date')) {
      context.handle(_shareDateMeta,
          shareDate.isAcceptableOrUnknown(data['share_date']!, _shareDateMeta));
    }
    if (data.containsKey('my_photos_downloadable')) {
      context.handle(
          _myPhotosDownloadableMeta,
          myPhotosDownloadable.isAcceptableOrUnknown(
              data['my_photos_downloadable']!, _myPhotosDownloadableMeta));
    }
    if (data.containsKey('hide_media')) {
      context.handle(_hideMediaMeta,
          hideMedia.isAcceptableOrUnknown(data['hide_media']!, _hideMediaMeta));
    }
    if (data.containsKey('owner_download')) {
      context.handle(
          _ownerDownloadMeta,
          ownerDownload.isAcceptableOrUnknown(
              data['owner_download']!, _ownerDownloadMeta));
    }
    if (data.containsKey('print_status')) {
      context.handle(
          _printStatusMeta,
          printStatus.isAcceptableOrUnknown(
              data['print_status']!, _printStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      categoryName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_name'])!,
      published: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}published'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!,
      loginRequired: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}login_required'])!,
      newlyAdded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}newly_added'])!,
      archived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}archived'])!,
      ownedByUser: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}owned_by_user'])!,
      downloadable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}downloadable'])!,
      withIcon: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}with_icon'])!,
      withWaterMark: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}with_water_mark'])!,
      priorityScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority_score']),
      personStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}person_status'])!,
      isAlbumDownloadable: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}isAlbumDownloadable'])!,
      studioCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}studio_code']),
      shareDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}share_date']),
      myPhotosDownloadable: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}my_photos_downloadable'])!,
      hideMedia: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}hide_media'])!,
      ownerDownload: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}owner_download'])!,
      printStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}print_status'])!,
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class Event extends DataClass implements Insertable<Event> {
  final String code;
  final String? name;
  final String categoryName;
  final bool published;
  final int type;
  final bool loginRequired;
  final bool newlyAdded;
  final bool archived;
  final bool ownedByUser;
  final bool downloadable;
  final bool withIcon;
  final bool withWaterMark;
  final int? priorityScore;
  final bool personStatus;
  final bool isAlbumDownloadable;
  final String? studioCode;
  final String? shareDate;
  final bool myPhotosDownloadable;
  final bool hideMedia;
  final bool ownerDownload;
  final bool printStatus;
  const Event(
      {required this.code,
      this.name,
      required this.categoryName,
      required this.published,
      required this.type,
      required this.loginRequired,
      required this.newlyAdded,
      required this.archived,
      required this.ownedByUser,
      required this.downloadable,
      required this.withIcon,
      required this.withWaterMark,
      this.priorityScore,
      required this.personStatus,
      required this.isAlbumDownloadable,
      this.studioCode,
      this.shareDate,
      required this.myPhotosDownloadable,
      required this.hideMedia,
      required this.ownerDownload,
      required this.printStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['category_name'] = Variable<String>(categoryName);
    map['published'] = Variable<bool>(published);
    map['type'] = Variable<int>(type);
    map['login_required'] = Variable<bool>(loginRequired);
    map['newly_added'] = Variable<bool>(newlyAdded);
    map['archived'] = Variable<bool>(archived);
    map['owned_by_user'] = Variable<bool>(ownedByUser);
    map['downloadable'] = Variable<bool>(downloadable);
    map['with_icon'] = Variable<bool>(withIcon);
    map['with_water_mark'] = Variable<bool>(withWaterMark);
    if (!nullToAbsent || priorityScore != null) {
      map['priority_score'] = Variable<int>(priorityScore);
    }
    map['person_status'] = Variable<bool>(personStatus);
    map['isAlbumDownloadable'] = Variable<bool>(isAlbumDownloadable);
    if (!nullToAbsent || studioCode != null) {
      map['studio_code'] = Variable<String>(studioCode);
    }
    if (!nullToAbsent || shareDate != null) {
      map['share_date'] = Variable<String>(shareDate);
    }
    map['my_photos_downloadable'] = Variable<bool>(myPhotosDownloadable);
    map['hide_media'] = Variable<bool>(hideMedia);
    map['owner_download'] = Variable<bool>(ownerDownload);
    map['print_status'] = Variable<bool>(printStatus);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      code: Value(code),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      categoryName: Value(categoryName),
      published: Value(published),
      type: Value(type),
      loginRequired: Value(loginRequired),
      newlyAdded: Value(newlyAdded),
      archived: Value(archived),
      ownedByUser: Value(ownedByUser),
      downloadable: Value(downloadable),
      withIcon: Value(withIcon),
      withWaterMark: Value(withWaterMark),
      priorityScore: priorityScore == null && nullToAbsent
          ? const Value.absent()
          : Value(priorityScore),
      personStatus: Value(personStatus),
      isAlbumDownloadable: Value(isAlbumDownloadable),
      studioCode: studioCode == null && nullToAbsent
          ? const Value.absent()
          : Value(studioCode),
      shareDate: shareDate == null && nullToAbsent
          ? const Value.absent()
          : Value(shareDate),
      myPhotosDownloadable: Value(myPhotosDownloadable),
      hideMedia: Value(hideMedia),
      ownerDownload: Value(ownerDownload),
      printStatus: Value(printStatus),
    );
  }

  factory Event.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String?>(json['name']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      published: serializer.fromJson<bool>(json['published']),
      type: serializer.fromJson<int>(json['type']),
      loginRequired: serializer.fromJson<bool>(json['loginRequired']),
      newlyAdded: serializer.fromJson<bool>(json['newlyAdded']),
      archived: serializer.fromJson<bool>(json['archived']),
      ownedByUser: serializer.fromJson<bool>(json['ownedByUser']),
      downloadable: serializer.fromJson<bool>(json['downloadable']),
      withIcon: serializer.fromJson<bool>(json['withIcon']),
      withWaterMark: serializer.fromJson<bool>(json['withWaterMark']),
      priorityScore: serializer.fromJson<int?>(json['priorityScore']),
      personStatus: serializer.fromJson<bool>(json['personStatus']),
      isAlbumDownloadable:
          serializer.fromJson<bool>(json['isAlbumDownloadable']),
      studioCode: serializer.fromJson<String?>(json['studioCode']),
      shareDate: serializer.fromJson<String?>(json['shareDate']),
      myPhotosDownloadable:
          serializer.fromJson<bool>(json['myPhotosDownloadable']),
      hideMedia: serializer.fromJson<bool>(json['hideMedia']),
      ownerDownload: serializer.fromJson<bool>(json['ownerDownload']),
      printStatus: serializer.fromJson<bool>(json['printStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String?>(name),
      'categoryName': serializer.toJson<String>(categoryName),
      'published': serializer.toJson<bool>(published),
      'type': serializer.toJson<int>(type),
      'loginRequired': serializer.toJson<bool>(loginRequired),
      'newlyAdded': serializer.toJson<bool>(newlyAdded),
      'archived': serializer.toJson<bool>(archived),
      'ownedByUser': serializer.toJson<bool>(ownedByUser),
      'downloadable': serializer.toJson<bool>(downloadable),
      'withIcon': serializer.toJson<bool>(withIcon),
      'withWaterMark': serializer.toJson<bool>(withWaterMark),
      'priorityScore': serializer.toJson<int?>(priorityScore),
      'personStatus': serializer.toJson<bool>(personStatus),
      'isAlbumDownloadable': serializer.toJson<bool>(isAlbumDownloadable),
      'studioCode': serializer.toJson<String?>(studioCode),
      'shareDate': serializer.toJson<String?>(shareDate),
      'myPhotosDownloadable': serializer.toJson<bool>(myPhotosDownloadable),
      'hideMedia': serializer.toJson<bool>(hideMedia),
      'ownerDownload': serializer.toJson<bool>(ownerDownload),
      'printStatus': serializer.toJson<bool>(printStatus),
    };
  }

  Event copyWith(
          {String? code,
          Value<String?> name = const Value.absent(),
          String? categoryName,
          bool? published,
          int? type,
          bool? loginRequired,
          bool? newlyAdded,
          bool? archived,
          bool? ownedByUser,
          bool? downloadable,
          bool? withIcon,
          bool? withWaterMark,
          Value<int?> priorityScore = const Value.absent(),
          bool? personStatus,
          bool? isAlbumDownloadable,
          Value<String?> studioCode = const Value.absent(),
          Value<String?> shareDate = const Value.absent(),
          bool? myPhotosDownloadable,
          bool? hideMedia,
          bool? ownerDownload,
          bool? printStatus}) =>
      Event(
        code: code ?? this.code,
        name: name.present ? name.value : this.name,
        categoryName: categoryName ?? this.categoryName,
        published: published ?? this.published,
        type: type ?? this.type,
        loginRequired: loginRequired ?? this.loginRequired,
        newlyAdded: newlyAdded ?? this.newlyAdded,
        archived: archived ?? this.archived,
        ownedByUser: ownedByUser ?? this.ownedByUser,
        downloadable: downloadable ?? this.downloadable,
        withIcon: withIcon ?? this.withIcon,
        withWaterMark: withWaterMark ?? this.withWaterMark,
        priorityScore:
            priorityScore.present ? priorityScore.value : this.priorityScore,
        personStatus: personStatus ?? this.personStatus,
        isAlbumDownloadable: isAlbumDownloadable ?? this.isAlbumDownloadable,
        studioCode: studioCode.present ? studioCode.value : this.studioCode,
        shareDate: shareDate.present ? shareDate.value : this.shareDate,
        myPhotosDownloadable: myPhotosDownloadable ?? this.myPhotosDownloadable,
        hideMedia: hideMedia ?? this.hideMedia,
        ownerDownload: ownerDownload ?? this.ownerDownload,
        printStatus: printStatus ?? this.printStatus,
      );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      published: data.published.present ? data.published.value : this.published,
      type: data.type.present ? data.type.value : this.type,
      loginRequired: data.loginRequired.present
          ? data.loginRequired.value
          : this.loginRequired,
      newlyAdded:
          data.newlyAdded.present ? data.newlyAdded.value : this.newlyAdded,
      archived: data.archived.present ? data.archived.value : this.archived,
      ownedByUser:
          data.ownedByUser.present ? data.ownedByUser.value : this.ownedByUser,
      downloadable: data.downloadable.present
          ? data.downloadable.value
          : this.downloadable,
      withIcon: data.withIcon.present ? data.withIcon.value : this.withIcon,
      withWaterMark: data.withWaterMark.present
          ? data.withWaterMark.value
          : this.withWaterMark,
      priorityScore: data.priorityScore.present
          ? data.priorityScore.value
          : this.priorityScore,
      personStatus: data.personStatus.present
          ? data.personStatus.value
          : this.personStatus,
      isAlbumDownloadable: data.isAlbumDownloadable.present
          ? data.isAlbumDownloadable.value
          : this.isAlbumDownloadable,
      studioCode:
          data.studioCode.present ? data.studioCode.value : this.studioCode,
      shareDate: data.shareDate.present ? data.shareDate.value : this.shareDate,
      myPhotosDownloadable: data.myPhotosDownloadable.present
          ? data.myPhotosDownloadable.value
          : this.myPhotosDownloadable,
      hideMedia: data.hideMedia.present ? data.hideMedia.value : this.hideMedia,
      ownerDownload: data.ownerDownload.present
          ? data.ownerDownload.value
          : this.ownerDownload,
      printStatus:
          data.printStatus.present ? data.printStatus.value : this.printStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('categoryName: $categoryName, ')
          ..write('published: $published, ')
          ..write('type: $type, ')
          ..write('loginRequired: $loginRequired, ')
          ..write('newlyAdded: $newlyAdded, ')
          ..write('archived: $archived, ')
          ..write('ownedByUser: $ownedByUser, ')
          ..write('downloadable: $downloadable, ')
          ..write('withIcon: $withIcon, ')
          ..write('withWaterMark: $withWaterMark, ')
          ..write('priorityScore: $priorityScore, ')
          ..write('personStatus: $personStatus, ')
          ..write('isAlbumDownloadable: $isAlbumDownloadable, ')
          ..write('studioCode: $studioCode, ')
          ..write('shareDate: $shareDate, ')
          ..write('myPhotosDownloadable: $myPhotosDownloadable, ')
          ..write('hideMedia: $hideMedia, ')
          ..write('ownerDownload: $ownerDownload, ')
          ..write('printStatus: $printStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        code,
        name,
        categoryName,
        published,
        type,
        loginRequired,
        newlyAdded,
        archived,
        ownedByUser,
        downloadable,
        withIcon,
        withWaterMark,
        priorityScore,
        personStatus,
        isAlbumDownloadable,
        studioCode,
        shareDate,
        myPhotosDownloadable,
        hideMedia,
        ownerDownload,
        printStatus
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.code == this.code &&
          other.name == this.name &&
          other.categoryName == this.categoryName &&
          other.published == this.published &&
          other.type == this.type &&
          other.loginRequired == this.loginRequired &&
          other.newlyAdded == this.newlyAdded &&
          other.archived == this.archived &&
          other.ownedByUser == this.ownedByUser &&
          other.downloadable == this.downloadable &&
          other.withIcon == this.withIcon &&
          other.withWaterMark == this.withWaterMark &&
          other.priorityScore == this.priorityScore &&
          other.personStatus == this.personStatus &&
          other.isAlbumDownloadable == this.isAlbumDownloadable &&
          other.studioCode == this.studioCode &&
          other.shareDate == this.shareDate &&
          other.myPhotosDownloadable == this.myPhotosDownloadable &&
          other.hideMedia == this.hideMedia &&
          other.ownerDownload == this.ownerDownload &&
          other.printStatus == this.printStatus);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<String> code;
  final Value<String?> name;
  final Value<String> categoryName;
  final Value<bool> published;
  final Value<int> type;
  final Value<bool> loginRequired;
  final Value<bool> newlyAdded;
  final Value<bool> archived;
  final Value<bool> ownedByUser;
  final Value<bool> downloadable;
  final Value<bool> withIcon;
  final Value<bool> withWaterMark;
  final Value<int?> priorityScore;
  final Value<bool> personStatus;
  final Value<bool> isAlbumDownloadable;
  final Value<String?> studioCode;
  final Value<String?> shareDate;
  final Value<bool> myPhotosDownloadable;
  final Value<bool> hideMedia;
  final Value<bool> ownerDownload;
  final Value<bool> printStatus;
  final Value<int> rowid;
  const EventsCompanion({
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.published = const Value.absent(),
    this.type = const Value.absent(),
    this.loginRequired = const Value.absent(),
    this.newlyAdded = const Value.absent(),
    this.archived = const Value.absent(),
    this.ownedByUser = const Value.absent(),
    this.downloadable = const Value.absent(),
    this.withIcon = const Value.absent(),
    this.withWaterMark = const Value.absent(),
    this.priorityScore = const Value.absent(),
    this.personStatus = const Value.absent(),
    this.isAlbumDownloadable = const Value.absent(),
    this.studioCode = const Value.absent(),
    this.shareDate = const Value.absent(),
    this.myPhotosDownloadable = const Value.absent(),
    this.hideMedia = const Value.absent(),
    this.ownerDownload = const Value.absent(),
    this.printStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    required String code,
    this.name = const Value.absent(),
    required String categoryName,
    this.published = const Value.absent(),
    required int type,
    required bool loginRequired,
    required bool newlyAdded,
    required bool archived,
    required bool ownedByUser,
    this.downloadable = const Value.absent(),
    this.withIcon = const Value.absent(),
    this.withWaterMark = const Value.absent(),
    this.priorityScore = const Value.absent(),
    this.personStatus = const Value.absent(),
    this.isAlbumDownloadable = const Value.absent(),
    this.studioCode = const Value.absent(),
    this.shareDate = const Value.absent(),
    this.myPhotosDownloadable = const Value.absent(),
    this.hideMedia = const Value.absent(),
    this.ownerDownload = const Value.absent(),
    this.printStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        categoryName = Value(categoryName),
        type = Value(type),
        loginRequired = Value(loginRequired),
        newlyAdded = Value(newlyAdded),
        archived = Value(archived),
        ownedByUser = Value(ownedByUser);
  static Insertable<Event> custom({
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? categoryName,
    Expression<bool>? published,
    Expression<int>? type,
    Expression<bool>? loginRequired,
    Expression<bool>? newlyAdded,
    Expression<bool>? archived,
    Expression<bool>? ownedByUser,
    Expression<bool>? downloadable,
    Expression<bool>? withIcon,
    Expression<bool>? withWaterMark,
    Expression<int>? priorityScore,
    Expression<bool>? personStatus,
    Expression<bool>? isAlbumDownloadable,
    Expression<String>? studioCode,
    Expression<String>? shareDate,
    Expression<bool>? myPhotosDownloadable,
    Expression<bool>? hideMedia,
    Expression<bool>? ownerDownload,
    Expression<bool>? printStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (categoryName != null) 'category_name': categoryName,
      if (published != null) 'published': published,
      if (type != null) 'type': type,
      if (loginRequired != null) 'login_required': loginRequired,
      if (newlyAdded != null) 'newly_added': newlyAdded,
      if (archived != null) 'archived': archived,
      if (ownedByUser != null) 'owned_by_user': ownedByUser,
      if (downloadable != null) 'downloadable': downloadable,
      if (withIcon != null) 'with_icon': withIcon,
      if (withWaterMark != null) 'with_water_mark': withWaterMark,
      if (priorityScore != null) 'priority_score': priorityScore,
      if (personStatus != null) 'person_status': personStatus,
      if (isAlbumDownloadable != null)
        'isAlbumDownloadable': isAlbumDownloadable,
      if (studioCode != null) 'studio_code': studioCode,
      if (shareDate != null) 'share_date': shareDate,
      if (myPhotosDownloadable != null)
        'my_photos_downloadable': myPhotosDownloadable,
      if (hideMedia != null) 'hide_media': hideMedia,
      if (ownerDownload != null) 'owner_download': ownerDownload,
      if (printStatus != null) 'print_status': printStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith(
      {Value<String>? code,
      Value<String?>? name,
      Value<String>? categoryName,
      Value<bool>? published,
      Value<int>? type,
      Value<bool>? loginRequired,
      Value<bool>? newlyAdded,
      Value<bool>? archived,
      Value<bool>? ownedByUser,
      Value<bool>? downloadable,
      Value<bool>? withIcon,
      Value<bool>? withWaterMark,
      Value<int?>? priorityScore,
      Value<bool>? personStatus,
      Value<bool>? isAlbumDownloadable,
      Value<String?>? studioCode,
      Value<String?>? shareDate,
      Value<bool>? myPhotosDownloadable,
      Value<bool>? hideMedia,
      Value<bool>? ownerDownload,
      Value<bool>? printStatus,
      Value<int>? rowid}) {
    return EventsCompanion(
      code: code ?? this.code,
      name: name ?? this.name,
      categoryName: categoryName ?? this.categoryName,
      published: published ?? this.published,
      type: type ?? this.type,
      loginRequired: loginRequired ?? this.loginRequired,
      newlyAdded: newlyAdded ?? this.newlyAdded,
      archived: archived ?? this.archived,
      ownedByUser: ownedByUser ?? this.ownedByUser,
      downloadable: downloadable ?? this.downloadable,
      withIcon: withIcon ?? this.withIcon,
      withWaterMark: withWaterMark ?? this.withWaterMark,
      priorityScore: priorityScore ?? this.priorityScore,
      personStatus: personStatus ?? this.personStatus,
      isAlbumDownloadable: isAlbumDownloadable ?? this.isAlbumDownloadable,
      studioCode: studioCode ?? this.studioCode,
      shareDate: shareDate ?? this.shareDate,
      myPhotosDownloadable: myPhotosDownloadable ?? this.myPhotosDownloadable,
      hideMedia: hideMedia ?? this.hideMedia,
      ownerDownload: ownerDownload ?? this.ownerDownload,
      printStatus: printStatus ?? this.printStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (published.present) {
      map['published'] = Variable<bool>(published.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (loginRequired.present) {
      map['login_required'] = Variable<bool>(loginRequired.value);
    }
    if (newlyAdded.present) {
      map['newly_added'] = Variable<bool>(newlyAdded.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (ownedByUser.present) {
      map['owned_by_user'] = Variable<bool>(ownedByUser.value);
    }
    if (downloadable.present) {
      map['downloadable'] = Variable<bool>(downloadable.value);
    }
    if (withIcon.present) {
      map['with_icon'] = Variable<bool>(withIcon.value);
    }
    if (withWaterMark.present) {
      map['with_water_mark'] = Variable<bool>(withWaterMark.value);
    }
    if (priorityScore.present) {
      map['priority_score'] = Variable<int>(priorityScore.value);
    }
    if (personStatus.present) {
      map['person_status'] = Variable<bool>(personStatus.value);
    }
    if (isAlbumDownloadable.present) {
      map['isAlbumDownloadable'] = Variable<bool>(isAlbumDownloadable.value);
    }
    if (studioCode.present) {
      map['studio_code'] = Variable<String>(studioCode.value);
    }
    if (shareDate.present) {
      map['share_date'] = Variable<String>(shareDate.value);
    }
    if (myPhotosDownloadable.present) {
      map['my_photos_downloadable'] =
          Variable<bool>(myPhotosDownloadable.value);
    }
    if (hideMedia.present) {
      map['hide_media'] = Variable<bool>(hideMedia.value);
    }
    if (ownerDownload.present) {
      map['owner_download'] = Variable<bool>(ownerDownload.value);
    }
    if (printStatus.present) {
      map['print_status'] = Variable<bool>(printStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('categoryName: $categoryName, ')
          ..write('published: $published, ')
          ..write('type: $type, ')
          ..write('loginRequired: $loginRequired, ')
          ..write('newlyAdded: $newlyAdded, ')
          ..write('archived: $archived, ')
          ..write('ownedByUser: $ownedByUser, ')
          ..write('downloadable: $downloadable, ')
          ..write('withIcon: $withIcon, ')
          ..write('withWaterMark: $withWaterMark, ')
          ..write('priorityScore: $priorityScore, ')
          ..write('personStatus: $personStatus, ')
          ..write('isAlbumDownloadable: $isAlbumDownloadable, ')
          ..write('studioCode: $studioCode, ')
          ..write('shareDate: $shareDate, ')
          ..write('myPhotosDownloadable: $myPhotosDownloadable, ')
          ..write('hideMedia: $hideMedia, ')
          ..write('ownerDownload: $ownerDownload, ')
          ..write('printStatus: $printStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlbumsTable extends Albums with TableInfo<$AlbumsTable, Album> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlbumsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _eventCodeMeta =
      const VerificationMeta('eventCode');
  @override
  late final GeneratedColumn<String> eventCode = GeneratedColumn<String>(
      'event_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NULL REFERENCES events(code)');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
      'type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<String> size = GeneratedColumn<String>(
      'size', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _publishedMeta =
      const VerificationMeta('published');
  @override
  late final GeneratedColumn<bool> published = GeneratedColumn<bool>(
      'published', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("published" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _visibilityMeta =
      const VerificationMeta('visibility');
  @override
  late final GeneratedColumn<int> visibility = GeneratedColumn<int>(
      'visibility', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _priorityScoreMeta =
      const VerificationMeta('priorityScore');
  @override
  late final GeneratedColumn<int> priorityScore = GeneratedColumn<int>(
      'priority_score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastSeenIndexMeta =
      const VerificationMeta('lastSeenIndex');
  @override
  late final GeneratedColumn<String> lastSeenIndex = GeneratedColumn<String>(
      'last_seen_index', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ordersMeta = const VerificationMeta('orders');
  @override
  late final GeneratedColumn<String> orders = GeneratedColumn<String>(
      'orders', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _oldOrdersMeta =
      const VerificationMeta('oldOrders');
  @override
  late final GeneratedColumn<String> oldOrders = GeneratedColumn<String>(
      'old_orders', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _coverImageMeta =
      const VerificationMeta('coverImage');
  @override
  late final GeneratedColumn<String> coverImage = GeneratedColumn<String>(
      'cover_image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _musicMeta = const VerificationMeta('music');
  @override
  late final GeneratedColumn<String> music = GeneratedColumn<String>(
      'music', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        code,
        eventCode,
        name,
        type,
        size,
        published,
        visibility,
        priorityScore,
        lastSeenIndex,
        orders,
        oldOrders,
        coverImage,
        music
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'albums';
  @override
  VerificationContext validateIntegrity(Insertable<Album> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('event_code')) {
      context.handle(_eventCodeMeta,
          eventCode.isAcceptableOrUnknown(data['event_code']!, _eventCodeMeta));
    } else if (isInserting) {
      context.missing(_eventCodeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
          _sizeMeta, size.isAcceptableOrUnknown(data['size']!, _sizeMeta));
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    if (data.containsKey('published')) {
      context.handle(_publishedMeta,
          published.isAcceptableOrUnknown(data['published']!, _publishedMeta));
    }
    if (data.containsKey('visibility')) {
      context.handle(
          _visibilityMeta,
          visibility.isAcceptableOrUnknown(
              data['visibility']!, _visibilityMeta));
    }
    if (data.containsKey('priority_score')) {
      context.handle(
          _priorityScoreMeta,
          priorityScore.isAcceptableOrUnknown(
              data['priority_score']!, _priorityScoreMeta));
    } else if (isInserting) {
      context.missing(_priorityScoreMeta);
    }
    if (data.containsKey('last_seen_index')) {
      context.handle(
          _lastSeenIndexMeta,
          lastSeenIndex.isAcceptableOrUnknown(
              data['last_seen_index']!, _lastSeenIndexMeta));
    }
    if (data.containsKey('orders')) {
      context.handle(_ordersMeta,
          orders.isAcceptableOrUnknown(data['orders']!, _ordersMeta));
    }
    if (data.containsKey('old_orders')) {
      context.handle(_oldOrdersMeta,
          oldOrders.isAcceptableOrUnknown(data['old_orders']!, _oldOrdersMeta));
    }
    if (data.containsKey('cover_image')) {
      context.handle(
          _coverImageMeta,
          coverImage.isAcceptableOrUnknown(
              data['cover_image']!, _coverImageMeta));
    }
    if (data.containsKey('music')) {
      context.handle(
          _musicMeta, music.isAcceptableOrUnknown(data['music']!, _musicMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  Album map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Album(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      eventCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!,
      size: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}size'])!,
      published: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}published'])!,
      visibility: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}visibility']),
      priorityScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority_score'])!,
      lastSeenIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_seen_index']),
      orders: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}orders']),
      oldOrders: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}old_orders']),
      coverImage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover_image']),
      music: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}music']),
    );
  }

  @override
  $AlbumsTable createAlias(String alias) {
    return $AlbumsTable(attachedDatabase, alias);
  }
}

class Album extends DataClass implements Insertable<Album> {
  final String code;
  final String eventCode;
  final String name;
  final int type;
  final String size;
  final bool published;
  final int? visibility;
  final int priorityScore;
  final String? lastSeenIndex;
  final String? orders;
  final String? oldOrders;
  final String? coverImage;
  final String? music;
  const Album(
      {required this.code,
      required this.eventCode,
      required this.name,
      required this.type,
      required this.size,
      required this.published,
      this.visibility,
      required this.priorityScore,
      this.lastSeenIndex,
      this.orders,
      this.oldOrders,
      this.coverImage,
      this.music});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['event_code'] = Variable<String>(eventCode);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<int>(type);
    map['size'] = Variable<String>(size);
    map['published'] = Variable<bool>(published);
    if (!nullToAbsent || visibility != null) {
      map['visibility'] = Variable<int>(visibility);
    }
    map['priority_score'] = Variable<int>(priorityScore);
    if (!nullToAbsent || lastSeenIndex != null) {
      map['last_seen_index'] = Variable<String>(lastSeenIndex);
    }
    if (!nullToAbsent || orders != null) {
      map['orders'] = Variable<String>(orders);
    }
    if (!nullToAbsent || oldOrders != null) {
      map['old_orders'] = Variable<String>(oldOrders);
    }
    if (!nullToAbsent || coverImage != null) {
      map['cover_image'] = Variable<String>(coverImage);
    }
    if (!nullToAbsent || music != null) {
      map['music'] = Variable<String>(music);
    }
    return map;
  }

  AlbumsCompanion toCompanion(bool nullToAbsent) {
    return AlbumsCompanion(
      code: Value(code),
      eventCode: Value(eventCode),
      name: Value(name),
      type: Value(type),
      size: Value(size),
      published: Value(published),
      visibility: visibility == null && nullToAbsent
          ? const Value.absent()
          : Value(visibility),
      priorityScore: Value(priorityScore),
      lastSeenIndex: lastSeenIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeenIndex),
      orders:
          orders == null && nullToAbsent ? const Value.absent() : Value(orders),
      oldOrders: oldOrders == null && nullToAbsent
          ? const Value.absent()
          : Value(oldOrders),
      coverImage: coverImage == null && nullToAbsent
          ? const Value.absent()
          : Value(coverImage),
      music:
          music == null && nullToAbsent ? const Value.absent() : Value(music),
    );
  }

  factory Album.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Album(
      code: serializer.fromJson<String>(json['code']),
      eventCode: serializer.fromJson<String>(json['eventCode']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<int>(json['type']),
      size: serializer.fromJson<String>(json['size']),
      published: serializer.fromJson<bool>(json['published']),
      visibility: serializer.fromJson<int?>(json['visibility']),
      priorityScore: serializer.fromJson<int>(json['priorityScore']),
      lastSeenIndex: serializer.fromJson<String?>(json['lastSeenIndex']),
      orders: serializer.fromJson<String?>(json['orders']),
      oldOrders: serializer.fromJson<String?>(json['oldOrders']),
      coverImage: serializer.fromJson<String?>(json['coverImage']),
      music: serializer.fromJson<String?>(json['music']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'eventCode': serializer.toJson<String>(eventCode),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<int>(type),
      'size': serializer.toJson<String>(size),
      'published': serializer.toJson<bool>(published),
      'visibility': serializer.toJson<int?>(visibility),
      'priorityScore': serializer.toJson<int>(priorityScore),
      'lastSeenIndex': serializer.toJson<String?>(lastSeenIndex),
      'orders': serializer.toJson<String?>(orders),
      'oldOrders': serializer.toJson<String?>(oldOrders),
      'coverImage': serializer.toJson<String?>(coverImage),
      'music': serializer.toJson<String?>(music),
    };
  }

  Album copyWith(
          {String? code,
          String? eventCode,
          String? name,
          int? type,
          String? size,
          bool? published,
          Value<int?> visibility = const Value.absent(),
          int? priorityScore,
          Value<String?> lastSeenIndex = const Value.absent(),
          Value<String?> orders = const Value.absent(),
          Value<String?> oldOrders = const Value.absent(),
          Value<String?> coverImage = const Value.absent(),
          Value<String?> music = const Value.absent()}) =>
      Album(
        code: code ?? this.code,
        eventCode: eventCode ?? this.eventCode,
        name: name ?? this.name,
        type: type ?? this.type,
        size: size ?? this.size,
        published: published ?? this.published,
        visibility: visibility.present ? visibility.value : this.visibility,
        priorityScore: priorityScore ?? this.priorityScore,
        lastSeenIndex:
            lastSeenIndex.present ? lastSeenIndex.value : this.lastSeenIndex,
        orders: orders.present ? orders.value : this.orders,
        oldOrders: oldOrders.present ? oldOrders.value : this.oldOrders,
        coverImage: coverImage.present ? coverImage.value : this.coverImage,
        music: music.present ? music.value : this.music,
      );
  Album copyWithCompanion(AlbumsCompanion data) {
    return Album(
      code: data.code.present ? data.code.value : this.code,
      eventCode: data.eventCode.present ? data.eventCode.value : this.eventCode,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      size: data.size.present ? data.size.value : this.size,
      published: data.published.present ? data.published.value : this.published,
      visibility:
          data.visibility.present ? data.visibility.value : this.visibility,
      priorityScore: data.priorityScore.present
          ? data.priorityScore.value
          : this.priorityScore,
      lastSeenIndex: data.lastSeenIndex.present
          ? data.lastSeenIndex.value
          : this.lastSeenIndex,
      orders: data.orders.present ? data.orders.value : this.orders,
      oldOrders: data.oldOrders.present ? data.oldOrders.value : this.oldOrders,
      coverImage:
          data.coverImage.present ? data.coverImage.value : this.coverImage,
      music: data.music.present ? data.music.value : this.music,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Album(')
          ..write('code: $code, ')
          ..write('eventCode: $eventCode, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('size: $size, ')
          ..write('published: $published, ')
          ..write('visibility: $visibility, ')
          ..write('priorityScore: $priorityScore, ')
          ..write('lastSeenIndex: $lastSeenIndex, ')
          ..write('orders: $orders, ')
          ..write('oldOrders: $oldOrders, ')
          ..write('coverImage: $coverImage, ')
          ..write('music: $music')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      code,
      eventCode,
      name,
      type,
      size,
      published,
      visibility,
      priorityScore,
      lastSeenIndex,
      orders,
      oldOrders,
      coverImage,
      music);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Album &&
          other.code == this.code &&
          other.eventCode == this.eventCode &&
          other.name == this.name &&
          other.type == this.type &&
          other.size == this.size &&
          other.published == this.published &&
          other.visibility == this.visibility &&
          other.priorityScore == this.priorityScore &&
          other.lastSeenIndex == this.lastSeenIndex &&
          other.orders == this.orders &&
          other.oldOrders == this.oldOrders &&
          other.coverImage == this.coverImage &&
          other.music == this.music);
}

class AlbumsCompanion extends UpdateCompanion<Album> {
  final Value<String> code;
  final Value<String> eventCode;
  final Value<String> name;
  final Value<int> type;
  final Value<String> size;
  final Value<bool> published;
  final Value<int?> visibility;
  final Value<int> priorityScore;
  final Value<String?> lastSeenIndex;
  final Value<String?> orders;
  final Value<String?> oldOrders;
  final Value<String?> coverImage;
  final Value<String?> music;
  final Value<int> rowid;
  const AlbumsCompanion({
    this.code = const Value.absent(),
    this.eventCode = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.size = const Value.absent(),
    this.published = const Value.absent(),
    this.visibility = const Value.absent(),
    this.priorityScore = const Value.absent(),
    this.lastSeenIndex = const Value.absent(),
    this.orders = const Value.absent(),
    this.oldOrders = const Value.absent(),
    this.coverImage = const Value.absent(),
    this.music = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlbumsCompanion.insert({
    required String code,
    required String eventCode,
    required String name,
    required int type,
    required String size,
    this.published = const Value.absent(),
    this.visibility = const Value.absent(),
    required int priorityScore,
    this.lastSeenIndex = const Value.absent(),
    this.orders = const Value.absent(),
    this.oldOrders = const Value.absent(),
    this.coverImage = const Value.absent(),
    this.music = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        eventCode = Value(eventCode),
        name = Value(name),
        type = Value(type),
        size = Value(size),
        priorityScore = Value(priorityScore);
  static Insertable<Album> custom({
    Expression<String>? code,
    Expression<String>? eventCode,
    Expression<String>? name,
    Expression<int>? type,
    Expression<String>? size,
    Expression<bool>? published,
    Expression<int>? visibility,
    Expression<int>? priorityScore,
    Expression<String>? lastSeenIndex,
    Expression<String>? orders,
    Expression<String>? oldOrders,
    Expression<String>? coverImage,
    Expression<String>? music,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (eventCode != null) 'event_code': eventCode,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (size != null) 'size': size,
      if (published != null) 'published': published,
      if (visibility != null) 'visibility': visibility,
      if (priorityScore != null) 'priority_score': priorityScore,
      if (lastSeenIndex != null) 'last_seen_index': lastSeenIndex,
      if (orders != null) 'orders': orders,
      if (oldOrders != null) 'old_orders': oldOrders,
      if (coverImage != null) 'cover_image': coverImage,
      if (music != null) 'music': music,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlbumsCompanion copyWith(
      {Value<String>? code,
      Value<String>? eventCode,
      Value<String>? name,
      Value<int>? type,
      Value<String>? size,
      Value<bool>? published,
      Value<int?>? visibility,
      Value<int>? priorityScore,
      Value<String?>? lastSeenIndex,
      Value<String?>? orders,
      Value<String?>? oldOrders,
      Value<String?>? coverImage,
      Value<String?>? music,
      Value<int>? rowid}) {
    return AlbumsCompanion(
      code: code ?? this.code,
      eventCode: eventCode ?? this.eventCode,
      name: name ?? this.name,
      type: type ?? this.type,
      size: size ?? this.size,
      published: published ?? this.published,
      visibility: visibility ?? this.visibility,
      priorityScore: priorityScore ?? this.priorityScore,
      lastSeenIndex: lastSeenIndex ?? this.lastSeenIndex,
      orders: orders ?? this.orders,
      oldOrders: oldOrders ?? this.oldOrders,
      coverImage: coverImage ?? this.coverImage,
      music: music ?? this.music,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (size.present) {
      map['size'] = Variable<String>(size.value);
    }
    if (published.present) {
      map['published'] = Variable<bool>(published.value);
    }
    if (visibility.present) {
      map['visibility'] = Variable<int>(visibility.value);
    }
    if (priorityScore.present) {
      map['priority_score'] = Variable<int>(priorityScore.value);
    }
    if (lastSeenIndex.present) {
      map['last_seen_index'] = Variable<String>(lastSeenIndex.value);
    }
    if (orders.present) {
      map['orders'] = Variable<String>(orders.value);
    }
    if (oldOrders.present) {
      map['old_orders'] = Variable<String>(oldOrders.value);
    }
    if (coverImage.present) {
      map['cover_image'] = Variable<String>(coverImage.value);
    }
    if (music.present) {
      map['music'] = Variable<String>(music.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumsCompanion(')
          ..write('code: $code, ')
          ..write('eventCode: $eventCode, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('size: $size, ')
          ..write('published: $published, ')
          ..write('visibility: $visibility, ')
          ..write('priorityScore: $priorityScore, ')
          ..write('lastSeenIndex: $lastSeenIndex, ')
          ..write('orders: $orders, ')
          ..write('oldOrders: $oldOrders, ')
          ..write('coverImage: $coverImage, ')
          ..write('music: $music, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JvtFilesTable extends JvtFiles with TableInfo<$JvtFilesTable, JvtFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JvtFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<int> mode = GeneratedColumn<int>(
      'mode', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _extensionMeta =
      const VerificationMeta('extension');
  @override
  late final GeneratedColumn<String> extension = GeneratedColumn<String>(
      'extension', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _downloadedMeta =
      const VerificationMeta('downloaded');
  @override
  late final GeneratedColumn<int> downloaded = GeneratedColumn<int>(
      'downloaded', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
      'size', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _attemptMeta =
      const VerificationMeta('attempt');
  @override
  late final GeneratedColumn<int> attempt = GeneratedColumn<int>(
      'attempt', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _isNetworkImageMeta =
      const VerificationMeta('isNetworkImage');
  @override
  late final GeneratedColumn<bool> isNetworkImage = GeneratedColumn<bool>(
      'is_network_image', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_network_image" IN (0, 1))'),
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        code,
        name,
        mode,
        extension,
        downloaded,
        size,
        attempt,
        priority,
        isNetworkImage
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'jvt_files';
  @override
  VerificationContext validateIntegrity(Insertable<JvtFile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
          _modeMeta, mode.isAcceptableOrUnknown(data['mode']!, _modeMeta));
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('extension')) {
      context.handle(_extensionMeta,
          extension.isAcceptableOrUnknown(data['extension']!, _extensionMeta));
    } else if (isInserting) {
      context.missing(_extensionMeta);
    }
    if (data.containsKey('downloaded')) {
      context.handle(
          _downloadedMeta,
          downloaded.isAcceptableOrUnknown(
              data['downloaded']!, _downloadedMeta));
    }
    if (data.containsKey('size')) {
      context.handle(
          _sizeMeta, size.isAcceptableOrUnknown(data['size']!, _sizeMeta));
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    if (data.containsKey('attempt')) {
      context.handle(_attemptMeta,
          attempt.isAcceptableOrUnknown(data['attempt']!, _attemptMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('is_network_image')) {
      context.handle(
          _isNetworkImageMeta,
          isNetworkImage.isAcceptableOrUnknown(
              data['is_network_image']!, _isNetworkImageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  JvtFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JvtFile(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      mode: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mode'])!,
      extension: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extension'])!,
      downloaded: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}downloaded'])!,
      size: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size'])!,
      attempt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempt'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      isNetworkImage: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_network_image']),
    );
  }

  @override
  $JvtFilesTable createAlias(String alias) {
    return $JvtFilesTable(attachedDatabase, alias);
  }
}

class JvtFile extends DataClass implements Insertable<JvtFile> {
  final String code;
  final String name;
  final int mode;
  final String extension;
  final int downloaded;
  final int size;
  final int attempt;
  final int priority;
  final bool? isNetworkImage;
  const JvtFile(
      {required this.code,
      required this.name,
      required this.mode,
      required this.extension,
      required this.downloaded,
      required this.size,
      required this.attempt,
      required this.priority,
      this.isNetworkImage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['mode'] = Variable<int>(mode);
    map['extension'] = Variable<String>(extension);
    map['downloaded'] = Variable<int>(downloaded);
    map['size'] = Variable<int>(size);
    map['attempt'] = Variable<int>(attempt);
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || isNetworkImage != null) {
      map['is_network_image'] = Variable<bool>(isNetworkImage);
    }
    return map;
  }

  JvtFilesCompanion toCompanion(bool nullToAbsent) {
    return JvtFilesCompanion(
      code: Value(code),
      name: Value(name),
      mode: Value(mode),
      extension: Value(extension),
      downloaded: Value(downloaded),
      size: Value(size),
      attempt: Value(attempt),
      priority: Value(priority),
      isNetworkImage: isNetworkImage == null && nullToAbsent
          ? const Value.absent()
          : Value(isNetworkImage),
    );
  }

  factory JvtFile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JvtFile(
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      mode: serializer.fromJson<int>(json['mode']),
      extension: serializer.fromJson<String>(json['extension']),
      downloaded: serializer.fromJson<int>(json['downloaded']),
      size: serializer.fromJson<int>(json['size']),
      attempt: serializer.fromJson<int>(json['attempt']),
      priority: serializer.fromJson<int>(json['priority']),
      isNetworkImage: serializer.fromJson<bool?>(json['isNetworkImage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'mode': serializer.toJson<int>(mode),
      'extension': serializer.toJson<String>(extension),
      'downloaded': serializer.toJson<int>(downloaded),
      'size': serializer.toJson<int>(size),
      'attempt': serializer.toJson<int>(attempt),
      'priority': serializer.toJson<int>(priority),
      'isNetworkImage': serializer.toJson<bool?>(isNetworkImage),
    };
  }

  JvtFile copyWith(
          {String? code,
          String? name,
          int? mode,
          String? extension,
          int? downloaded,
          int? size,
          int? attempt,
          int? priority,
          Value<bool?> isNetworkImage = const Value.absent()}) =>
      JvtFile(
        code: code ?? this.code,
        name: name ?? this.name,
        mode: mode ?? this.mode,
        extension: extension ?? this.extension,
        downloaded: downloaded ?? this.downloaded,
        size: size ?? this.size,
        attempt: attempt ?? this.attempt,
        priority: priority ?? this.priority,
        isNetworkImage:
            isNetworkImage.present ? isNetworkImage.value : this.isNetworkImage,
      );
  JvtFile copyWithCompanion(JvtFilesCompanion data) {
    return JvtFile(
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      mode: data.mode.present ? data.mode.value : this.mode,
      extension: data.extension.present ? data.extension.value : this.extension,
      downloaded:
          data.downloaded.present ? data.downloaded.value : this.downloaded,
      size: data.size.present ? data.size.value : this.size,
      attempt: data.attempt.present ? data.attempt.value : this.attempt,
      priority: data.priority.present ? data.priority.value : this.priority,
      isNetworkImage: data.isNetworkImage.present
          ? data.isNetworkImage.value
          : this.isNetworkImage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JvtFile(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('mode: $mode, ')
          ..write('extension: $extension, ')
          ..write('downloaded: $downloaded, ')
          ..write('size: $size, ')
          ..write('attempt: $attempt, ')
          ..write('priority: $priority, ')
          ..write('isNetworkImage: $isNetworkImage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, name, mode, extension, downloaded, size,
      attempt, priority, isNetworkImage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JvtFile &&
          other.code == this.code &&
          other.name == this.name &&
          other.mode == this.mode &&
          other.extension == this.extension &&
          other.downloaded == this.downloaded &&
          other.size == this.size &&
          other.attempt == this.attempt &&
          other.priority == this.priority &&
          other.isNetworkImage == this.isNetworkImage);
}

class JvtFilesCompanion extends UpdateCompanion<JvtFile> {
  final Value<String> code;
  final Value<String> name;
  final Value<int> mode;
  final Value<String> extension;
  final Value<int> downloaded;
  final Value<int> size;
  final Value<int> attempt;
  final Value<int> priority;
  final Value<bool?> isNetworkImage;
  final Value<int> rowid;
  const JvtFilesCompanion({
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.mode = const Value.absent(),
    this.extension = const Value.absent(),
    this.downloaded = const Value.absent(),
    this.size = const Value.absent(),
    this.attempt = const Value.absent(),
    this.priority = const Value.absent(),
    this.isNetworkImage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JvtFilesCompanion.insert({
    required String code,
    required String name,
    required int mode,
    required String extension,
    this.downloaded = const Value.absent(),
    required int size,
    this.attempt = const Value.absent(),
    this.priority = const Value.absent(),
    this.isNetworkImage = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        name = Value(name),
        mode = Value(mode),
        extension = Value(extension),
        size = Value(size);
  static Insertable<JvtFile> custom({
    Expression<String>? code,
    Expression<String>? name,
    Expression<int>? mode,
    Expression<String>? extension,
    Expression<int>? downloaded,
    Expression<int>? size,
    Expression<int>? attempt,
    Expression<int>? priority,
    Expression<bool>? isNetworkImage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (mode != null) 'mode': mode,
      if (extension != null) 'extension': extension,
      if (downloaded != null) 'downloaded': downloaded,
      if (size != null) 'size': size,
      if (attempt != null) 'attempt': attempt,
      if (priority != null) 'priority': priority,
      if (isNetworkImage != null) 'is_network_image': isNetworkImage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JvtFilesCompanion copyWith(
      {Value<String>? code,
      Value<String>? name,
      Value<int>? mode,
      Value<String>? extension,
      Value<int>? downloaded,
      Value<int>? size,
      Value<int>? attempt,
      Value<int>? priority,
      Value<bool?>? isNetworkImage,
      Value<int>? rowid}) {
    return JvtFilesCompanion(
      code: code ?? this.code,
      name: name ?? this.name,
      mode: mode ?? this.mode,
      extension: extension ?? this.extension,
      downloaded: downloaded ?? this.downloaded,
      size: size ?? this.size,
      attempt: attempt ?? this.attempt,
      priority: priority ?? this.priority,
      isNetworkImage: isNetworkImage ?? this.isNetworkImage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mode.present) {
      map['mode'] = Variable<int>(mode.value);
    }
    if (extension.present) {
      map['extension'] = Variable<String>(extension.value);
    }
    if (downloaded.present) {
      map['downloaded'] = Variable<int>(downloaded.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (attempt.present) {
      map['attempt'] = Variable<int>(attempt.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (isNetworkImage.present) {
      map['is_network_image'] = Variable<bool>(isNetworkImage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JvtFilesCompanion(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('mode: $mode, ')
          ..write('extension: $extension, ')
          ..write('downloaded: $downloaded, ')
          ..write('size: $size, ')
          ..write('attempt: $attempt, ')
          ..write('priority: $priority, ')
          ..write('isNetworkImage: $isNetworkImage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JvtFileConnectorsTable extends JvtFileConnectors
    with TableInfo<$JvtFileConnectorsTable, JvtFileConnector> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JvtFileConnectorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _ableCodeMeta =
      const VerificationMeta('ableCode');
  @override
  late final GeneratedColumn<String> ableCode = GeneratedColumn<String>(
      'able_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _ableTypeMeta =
      const VerificationMeta('ableType');
  @override
  late final GeneratedColumn<String> ableType = GeneratedColumn<String>(
      'able_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
      'tag', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _jvtFileCodeMeta =
      const VerificationMeta('jvtFileCode');
  @override
  late final GeneratedColumn<String> jvtFileCode = GeneratedColumn<String>(
      'jvt_file_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NULL REFERENCES jvt_files(code)');
  @override
  List<GeneratedColumn> get $columns =>
      [code, ableCode, ableType, tag, jvtFileCode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'jvt_file_connectors';
  @override
  VerificationContext validateIntegrity(Insertable<JvtFileConnector> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('able_code')) {
      context.handle(_ableCodeMeta,
          ableCode.isAcceptableOrUnknown(data['able_code']!, _ableCodeMeta));
    } else if (isInserting) {
      context.missing(_ableCodeMeta);
    }
    if (data.containsKey('able_type')) {
      context.handle(_ableTypeMeta,
          ableType.isAcceptableOrUnknown(data['able_type']!, _ableTypeMeta));
    } else if (isInserting) {
      context.missing(_ableTypeMeta);
    }
    if (data.containsKey('tag')) {
      context.handle(
          _tagMeta, tag.isAcceptableOrUnknown(data['tag']!, _tagMeta));
    }
    if (data.containsKey('jvt_file_code')) {
      context.handle(
          _jvtFileCodeMeta,
          jvtFileCode.isAcceptableOrUnknown(
              data['jvt_file_code']!, _jvtFileCodeMeta));
    } else if (isInserting) {
      context.missing(_jvtFileCodeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  JvtFileConnector map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JvtFileConnector(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      ableCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}able_code'])!,
      ableType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}able_type'])!,
      tag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tag']),
      jvtFileCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}jvt_file_code'])!,
    );
  }

  @override
  $JvtFileConnectorsTable createAlias(String alias) {
    return $JvtFileConnectorsTable(attachedDatabase, alias);
  }
}

class JvtFileConnector extends DataClass
    implements Insertable<JvtFileConnector> {
  final String code;
  final String ableCode;
  final String ableType;
  final String? tag;
  final String jvtFileCode;
  const JvtFileConnector(
      {required this.code,
      required this.ableCode,
      required this.ableType,
      this.tag,
      required this.jvtFileCode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['able_code'] = Variable<String>(ableCode);
    map['able_type'] = Variable<String>(ableType);
    if (!nullToAbsent || tag != null) {
      map['tag'] = Variable<String>(tag);
    }
    map['jvt_file_code'] = Variable<String>(jvtFileCode);
    return map;
  }

  JvtFileConnectorsCompanion toCompanion(bool nullToAbsent) {
    return JvtFileConnectorsCompanion(
      code: Value(code),
      ableCode: Value(ableCode),
      ableType: Value(ableType),
      tag: tag == null && nullToAbsent ? const Value.absent() : Value(tag),
      jvtFileCode: Value(jvtFileCode),
    );
  }

  factory JvtFileConnector.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JvtFileConnector(
      code: serializer.fromJson<String>(json['code']),
      ableCode: serializer.fromJson<String>(json['ableCode']),
      ableType: serializer.fromJson<String>(json['ableType']),
      tag: serializer.fromJson<String?>(json['tag']),
      jvtFileCode: serializer.fromJson<String>(json['jvtFileCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'ableCode': serializer.toJson<String>(ableCode),
      'ableType': serializer.toJson<String>(ableType),
      'tag': serializer.toJson<String?>(tag),
      'jvtFileCode': serializer.toJson<String>(jvtFileCode),
    };
  }

  JvtFileConnector copyWith(
          {String? code,
          String? ableCode,
          String? ableType,
          Value<String?> tag = const Value.absent(),
          String? jvtFileCode}) =>
      JvtFileConnector(
        code: code ?? this.code,
        ableCode: ableCode ?? this.ableCode,
        ableType: ableType ?? this.ableType,
        tag: tag.present ? tag.value : this.tag,
        jvtFileCode: jvtFileCode ?? this.jvtFileCode,
      );
  JvtFileConnector copyWithCompanion(JvtFileConnectorsCompanion data) {
    return JvtFileConnector(
      code: data.code.present ? data.code.value : this.code,
      ableCode: data.ableCode.present ? data.ableCode.value : this.ableCode,
      ableType: data.ableType.present ? data.ableType.value : this.ableType,
      tag: data.tag.present ? data.tag.value : this.tag,
      jvtFileCode:
          data.jvtFileCode.present ? data.jvtFileCode.value : this.jvtFileCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JvtFileConnector(')
          ..write('code: $code, ')
          ..write('ableCode: $ableCode, ')
          ..write('ableType: $ableType, ')
          ..write('tag: $tag, ')
          ..write('jvtFileCode: $jvtFileCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, ableCode, ableType, tag, jvtFileCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JvtFileConnector &&
          other.code == this.code &&
          other.ableCode == this.ableCode &&
          other.ableType == this.ableType &&
          other.tag == this.tag &&
          other.jvtFileCode == this.jvtFileCode);
}

class JvtFileConnectorsCompanion extends UpdateCompanion<JvtFileConnector> {
  final Value<String> code;
  final Value<String> ableCode;
  final Value<String> ableType;
  final Value<String?> tag;
  final Value<String> jvtFileCode;
  final Value<int> rowid;
  const JvtFileConnectorsCompanion({
    this.code = const Value.absent(),
    this.ableCode = const Value.absent(),
    this.ableType = const Value.absent(),
    this.tag = const Value.absent(),
    this.jvtFileCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JvtFileConnectorsCompanion.insert({
    required String code,
    required String ableCode,
    required String ableType,
    this.tag = const Value.absent(),
    required String jvtFileCode,
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        ableCode = Value(ableCode),
        ableType = Value(ableType),
        jvtFileCode = Value(jvtFileCode);
  static Insertable<JvtFileConnector> custom({
    Expression<String>? code,
    Expression<String>? ableCode,
    Expression<String>? ableType,
    Expression<String>? tag,
    Expression<String>? jvtFileCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (ableCode != null) 'able_code': ableCode,
      if (ableType != null) 'able_type': ableType,
      if (tag != null) 'tag': tag,
      if (jvtFileCode != null) 'jvt_file_code': jvtFileCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JvtFileConnectorsCompanion copyWith(
      {Value<String>? code,
      Value<String>? ableCode,
      Value<String>? ableType,
      Value<String?>? tag,
      Value<String>? jvtFileCode,
      Value<int>? rowid}) {
    return JvtFileConnectorsCompanion(
      code: code ?? this.code,
      ableCode: ableCode ?? this.ableCode,
      ableType: ableType ?? this.ableType,
      tag: tag ?? this.tag,
      jvtFileCode: jvtFileCode ?? this.jvtFileCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (ableCode.present) {
      map['able_code'] = Variable<String>(ableCode.value);
    }
    if (ableType.present) {
      map['able_type'] = Variable<String>(ableType.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    if (jvtFileCode.present) {
      map['jvt_file_code'] = Variable<String>(jvtFileCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JvtFileConnectorsCompanion(')
          ..write('code: $code, ')
          ..write('ableCode: $ableCode, ')
          ..write('ableType: $ableType, ')
          ..write('tag: $tag, ')
          ..write('jvtFileCode: $jvtFileCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoldersTable extends Folders with TableInfo<$FoldersTable, Folder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoldersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentCodeMeta =
      const VerificationMeta('parentCode');
  @override
  late final GeneratedColumn<String> parentCode = GeneratedColumn<String>(
      'parent_code', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULL REFERENCES folders(code)');
  static const VerificationMeta _eventCodeMeta =
      const VerificationMeta('eventCode');
  @override
  late final GeneratedColumn<String> eventCode = GeneratedColumn<String>(
      'event_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NULL REFERENCES events(code)');
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<String> size = GeneratedColumn<String>(
      'size', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _publishedMeta =
      const VerificationMeta('published');
  @override
  late final GeneratedColumn<bool> published = GeneratedColumn<bool>(
      'published', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("published" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _submittedMeta =
      const VerificationMeta('submitted');
  @override
  late final GeneratedColumn<bool> submitted = GeneratedColumn<bool>(
      'submitted', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("submitted" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _lastUpdatedAtMeta =
      const VerificationMeta('lastUpdatedAt');
  @override
  late final GeneratedColumn<int> lastUpdatedAt = GeneratedColumn<int>(
      'lastUpdatedAt', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        code,
        name,
        parentCode,
        eventCode,
        size,
        published,
        submitted,
        lastUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'folders';
  @override
  VerificationContext validateIntegrity(Insertable<Folder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_code')) {
      context.handle(
          _parentCodeMeta,
          parentCode.isAcceptableOrUnknown(
              data['parent_code']!, _parentCodeMeta));
    }
    if (data.containsKey('event_code')) {
      context.handle(_eventCodeMeta,
          eventCode.isAcceptableOrUnknown(data['event_code']!, _eventCodeMeta));
    } else if (isInserting) {
      context.missing(_eventCodeMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
          _sizeMeta, size.isAcceptableOrUnknown(data['size']!, _sizeMeta));
    }
    if (data.containsKey('published')) {
      context.handle(_publishedMeta,
          published.isAcceptableOrUnknown(data['published']!, _publishedMeta));
    }
    if (data.containsKey('submitted')) {
      context.handle(_submittedMeta,
          submitted.isAcceptableOrUnknown(data['submitted']!, _submittedMeta));
    }
    if (data.containsKey('lastUpdatedAt')) {
      context.handle(
          _lastUpdatedAtMeta,
          lastUpdatedAt.isAcceptableOrUnknown(
              data['lastUpdatedAt']!, _lastUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  Folder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Folder(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      parentCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_code']),
      eventCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_code'])!,
      size: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}size']),
      published: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}published']),
      submitted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}submitted']),
      lastUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lastUpdatedAt'])!,
    );
  }

  @override
  $FoldersTable createAlias(String alias) {
    return $FoldersTable(attachedDatabase, alias);
  }
}

class Folder extends DataClass implements Insertable<Folder> {
  final String code;
  final String name;
  final String? parentCode;
  final String eventCode;
  final String? size;
  final bool? published;
  final bool? submitted;
  final int lastUpdatedAt;
  const Folder(
      {required this.code,
      required this.name,
      this.parentCode,
      required this.eventCode,
      this.size,
      this.published,
      this.submitted,
      required this.lastUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentCode != null) {
      map['parent_code'] = Variable<String>(parentCode);
    }
    map['event_code'] = Variable<String>(eventCode);
    if (!nullToAbsent || size != null) {
      map['size'] = Variable<String>(size);
    }
    if (!nullToAbsent || published != null) {
      map['published'] = Variable<bool>(published);
    }
    if (!nullToAbsent || submitted != null) {
      map['submitted'] = Variable<bool>(submitted);
    }
    map['lastUpdatedAt'] = Variable<int>(lastUpdatedAt);
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      code: Value(code),
      name: Value(name),
      parentCode: parentCode == null && nullToAbsent
          ? const Value.absent()
          : Value(parentCode),
      eventCode: Value(eventCode),
      size: size == null && nullToAbsent ? const Value.absent() : Value(size),
      published: published == null && nullToAbsent
          ? const Value.absent()
          : Value(published),
      submitted: submitted == null && nullToAbsent
          ? const Value.absent()
          : Value(submitted),
      lastUpdatedAt: Value(lastUpdatedAt),
    );
  }

  factory Folder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Folder(
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      parentCode: serializer.fromJson<String?>(json['parentCode']),
      eventCode: serializer.fromJson<String>(json['eventCode']),
      size: serializer.fromJson<String?>(json['size']),
      published: serializer.fromJson<bool?>(json['published']),
      submitted: serializer.fromJson<bool?>(json['submitted']),
      lastUpdatedAt: serializer.fromJson<int>(json['lastUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'parentCode': serializer.toJson<String?>(parentCode),
      'eventCode': serializer.toJson<String>(eventCode),
      'size': serializer.toJson<String?>(size),
      'published': serializer.toJson<bool?>(published),
      'submitted': serializer.toJson<bool?>(submitted),
      'lastUpdatedAt': serializer.toJson<int>(lastUpdatedAt),
    };
  }

  Folder copyWith(
          {String? code,
          String? name,
          Value<String?> parentCode = const Value.absent(),
          String? eventCode,
          Value<String?> size = const Value.absent(),
          Value<bool?> published = const Value.absent(),
          Value<bool?> submitted = const Value.absent(),
          int? lastUpdatedAt}) =>
      Folder(
        code: code ?? this.code,
        name: name ?? this.name,
        parentCode: parentCode.present ? parentCode.value : this.parentCode,
        eventCode: eventCode ?? this.eventCode,
        size: size.present ? size.value : this.size,
        published: published.present ? published.value : this.published,
        submitted: submitted.present ? submitted.value : this.submitted,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      );
  Folder copyWithCompanion(FoldersCompanion data) {
    return Folder(
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      parentCode:
          data.parentCode.present ? data.parentCode.value : this.parentCode,
      eventCode: data.eventCode.present ? data.eventCode.value : this.eventCode,
      size: data.size.present ? data.size.value : this.size,
      published: data.published.present ? data.published.value : this.published,
      submitted: data.submitted.present ? data.submitted.value : this.submitted,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Folder(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('parentCode: $parentCode, ')
          ..write('eventCode: $eventCode, ')
          ..write('size: $size, ')
          ..write('published: $published, ')
          ..write('submitted: $submitted, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, name, parentCode, eventCode, size,
      published, submitted, lastUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Folder &&
          other.code == this.code &&
          other.name == this.name &&
          other.parentCode == this.parentCode &&
          other.eventCode == this.eventCode &&
          other.size == this.size &&
          other.published == this.published &&
          other.submitted == this.submitted &&
          other.lastUpdatedAt == this.lastUpdatedAt);
}

class FoldersCompanion extends UpdateCompanion<Folder> {
  final Value<String> code;
  final Value<String> name;
  final Value<String?> parentCode;
  final Value<String> eventCode;
  final Value<String?> size;
  final Value<bool?> published;
  final Value<bool?> submitted;
  final Value<int> lastUpdatedAt;
  final Value<int> rowid;
  const FoldersCompanion({
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.parentCode = const Value.absent(),
    this.eventCode = const Value.absent(),
    this.size = const Value.absent(),
    this.published = const Value.absent(),
    this.submitted = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoldersCompanion.insert({
    required String code,
    required String name,
    this.parentCode = const Value.absent(),
    required String eventCode,
    this.size = const Value.absent(),
    this.published = const Value.absent(),
    this.submitted = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        name = Value(name),
        eventCode = Value(eventCode);
  static Insertable<Folder> custom({
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? parentCode,
    Expression<String>? eventCode,
    Expression<String>? size,
    Expression<bool>? published,
    Expression<bool>? submitted,
    Expression<int>? lastUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (parentCode != null) 'parent_code': parentCode,
      if (eventCode != null) 'event_code': eventCode,
      if (size != null) 'size': size,
      if (published != null) 'published': published,
      if (submitted != null) 'submitted': submitted,
      if (lastUpdatedAt != null) 'lastUpdatedAt': lastUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoldersCompanion copyWith(
      {Value<String>? code,
      Value<String>? name,
      Value<String?>? parentCode,
      Value<String>? eventCode,
      Value<String?>? size,
      Value<bool?>? published,
      Value<bool?>? submitted,
      Value<int>? lastUpdatedAt,
      Value<int>? rowid}) {
    return FoldersCompanion(
      code: code ?? this.code,
      name: name ?? this.name,
      parentCode: parentCode ?? this.parentCode,
      eventCode: eventCode ?? this.eventCode,
      size: size ?? this.size,
      published: published ?? this.published,
      submitted: submitted ?? this.submitted,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentCode.present) {
      map['parent_code'] = Variable<String>(parentCode.value);
    }
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (size.present) {
      map['size'] = Variable<String>(size.value);
    }
    if (published.present) {
      map['published'] = Variable<bool>(published.value);
    }
    if (submitted.present) {
      map['submitted'] = Variable<bool>(submitted.value);
    }
    if (lastUpdatedAt.present) {
      map['lastUpdatedAt'] = Variable<int>(lastUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('parentCode: $parentCode, ')
          ..write('eventCode: $eventCode, ')
          ..write('size: $size, ')
          ..write('published: $published, ')
          ..write('submitted: $submitted, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FolderStatusesTable extends FolderStatuses
    with TableInfo<$FolderStatusesTable, FolderStatuse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FolderStatusesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _folderCodeMeta =
      const VerificationMeta('folderCode');
  @override
  late final GeneratedColumn<String> folderCode = GeneratedColumn<String>(
      'folder_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NULL REFERENCES folders(code)');
  static const VerificationMeta _combinedMeta =
      const VerificationMeta('combined');
  @override
  late final GeneratedColumn<bool> combined = GeneratedColumn<bool>(
      'combined', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("combined" IN (0, 1))'));
  static const VerificationMeta _selectedMeta =
      const VerificationMeta('selected');
  @override
  late final GeneratedColumn<int> selected = GeneratedColumn<int>(
      'selected', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _rejectedMeta =
      const VerificationMeta('rejected');
  @override
  late final GeneratedColumn<int> rejected = GeneratedColumn<int>(
      'rejected', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _waitingListedMeta =
      const VerificationMeta('waitingListed');
  @override
  late final GeneratedColumn<int> waitingListed = GeneratedColumn<int>(
      'waiting_listed', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, folderCode, combined, selected, rejected, waitingListed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'folder_status';
  @override
  VerificationContext validateIntegrity(Insertable<FolderStatuse> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('folder_code')) {
      context.handle(
          _folderCodeMeta,
          folderCode.isAcceptableOrUnknown(
              data['folder_code']!, _folderCodeMeta));
    } else if (isInserting) {
      context.missing(_folderCodeMeta);
    }
    if (data.containsKey('combined')) {
      context.handle(_combinedMeta,
          combined.isAcceptableOrUnknown(data['combined']!, _combinedMeta));
    } else if (isInserting) {
      context.missing(_combinedMeta);
    }
    if (data.containsKey('selected')) {
      context.handle(_selectedMeta,
          selected.isAcceptableOrUnknown(data['selected']!, _selectedMeta));
    } else if (isInserting) {
      context.missing(_selectedMeta);
    }
    if (data.containsKey('rejected')) {
      context.handle(_rejectedMeta,
          rejected.isAcceptableOrUnknown(data['rejected']!, _rejectedMeta));
    } else if (isInserting) {
      context.missing(_rejectedMeta);
    }
    if (data.containsKey('waiting_listed')) {
      context.handle(
          _waitingListedMeta,
          waitingListed.isAcceptableOrUnknown(
              data['waiting_listed']!, _waitingListedMeta));
    } else if (isInserting) {
      context.missing(_waitingListedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FolderStatuse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FolderStatuse(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      folderCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}folder_code'])!,
      combined: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}combined'])!,
      selected: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}selected'])!,
      rejected: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rejected'])!,
      waitingListed: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}waiting_listed'])!,
    );
  }

  @override
  $FolderStatusesTable createAlias(String alias) {
    return $FolderStatusesTable(attachedDatabase, alias);
  }
}

class FolderStatuse extends DataClass implements Insertable<FolderStatuse> {
  final int id;
  final String folderCode;
  final bool combined;
  final int selected;
  final int rejected;
  final int waitingListed;
  const FolderStatuse(
      {required this.id,
      required this.folderCode,
      required this.combined,
      required this.selected,
      required this.rejected,
      required this.waitingListed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['folder_code'] = Variable<String>(folderCode);
    map['combined'] = Variable<bool>(combined);
    map['selected'] = Variable<int>(selected);
    map['rejected'] = Variable<int>(rejected);
    map['waiting_listed'] = Variable<int>(waitingListed);
    return map;
  }

  FolderStatusesCompanion toCompanion(bool nullToAbsent) {
    return FolderStatusesCompanion(
      id: Value(id),
      folderCode: Value(folderCode),
      combined: Value(combined),
      selected: Value(selected),
      rejected: Value(rejected),
      waitingListed: Value(waitingListed),
    );
  }

  factory FolderStatuse.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FolderStatuse(
      id: serializer.fromJson<int>(json['id']),
      folderCode: serializer.fromJson<String>(json['folderCode']),
      combined: serializer.fromJson<bool>(json['combined']),
      selected: serializer.fromJson<int>(json['selected']),
      rejected: serializer.fromJson<int>(json['rejected']),
      waitingListed: serializer.fromJson<int>(json['waitingListed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'folderCode': serializer.toJson<String>(folderCode),
      'combined': serializer.toJson<bool>(combined),
      'selected': serializer.toJson<int>(selected),
      'rejected': serializer.toJson<int>(rejected),
      'waitingListed': serializer.toJson<int>(waitingListed),
    };
  }

  FolderStatuse copyWith(
          {int? id,
          String? folderCode,
          bool? combined,
          int? selected,
          int? rejected,
          int? waitingListed}) =>
      FolderStatuse(
        id: id ?? this.id,
        folderCode: folderCode ?? this.folderCode,
        combined: combined ?? this.combined,
        selected: selected ?? this.selected,
        rejected: rejected ?? this.rejected,
        waitingListed: waitingListed ?? this.waitingListed,
      );
  FolderStatuse copyWithCompanion(FolderStatusesCompanion data) {
    return FolderStatuse(
      id: data.id.present ? data.id.value : this.id,
      folderCode:
          data.folderCode.present ? data.folderCode.value : this.folderCode,
      combined: data.combined.present ? data.combined.value : this.combined,
      selected: data.selected.present ? data.selected.value : this.selected,
      rejected: data.rejected.present ? data.rejected.value : this.rejected,
      waitingListed: data.waitingListed.present
          ? data.waitingListed.value
          : this.waitingListed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FolderStatuse(')
          ..write('id: $id, ')
          ..write('folderCode: $folderCode, ')
          ..write('combined: $combined, ')
          ..write('selected: $selected, ')
          ..write('rejected: $rejected, ')
          ..write('waitingListed: $waitingListed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, folderCode, combined, selected, rejected, waitingListed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FolderStatuse &&
          other.id == this.id &&
          other.folderCode == this.folderCode &&
          other.combined == this.combined &&
          other.selected == this.selected &&
          other.rejected == this.rejected &&
          other.waitingListed == this.waitingListed);
}

class FolderStatusesCompanion extends UpdateCompanion<FolderStatuse> {
  final Value<int> id;
  final Value<String> folderCode;
  final Value<bool> combined;
  final Value<int> selected;
  final Value<int> rejected;
  final Value<int> waitingListed;
  const FolderStatusesCompanion({
    this.id = const Value.absent(),
    this.folderCode = const Value.absent(),
    this.combined = const Value.absent(),
    this.selected = const Value.absent(),
    this.rejected = const Value.absent(),
    this.waitingListed = const Value.absent(),
  });
  FolderStatusesCompanion.insert({
    this.id = const Value.absent(),
    required String folderCode,
    required bool combined,
    required int selected,
    required int rejected,
    required int waitingListed,
  })  : folderCode = Value(folderCode),
        combined = Value(combined),
        selected = Value(selected),
        rejected = Value(rejected),
        waitingListed = Value(waitingListed);
  static Insertable<FolderStatuse> custom({
    Expression<int>? id,
    Expression<String>? folderCode,
    Expression<bool>? combined,
    Expression<int>? selected,
    Expression<int>? rejected,
    Expression<int>? waitingListed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderCode != null) 'folder_code': folderCode,
      if (combined != null) 'combined': combined,
      if (selected != null) 'selected': selected,
      if (rejected != null) 'rejected': rejected,
      if (waitingListed != null) 'waiting_listed': waitingListed,
    });
  }

  FolderStatusesCompanion copyWith(
      {Value<int>? id,
      Value<String>? folderCode,
      Value<bool>? combined,
      Value<int>? selected,
      Value<int>? rejected,
      Value<int>? waitingListed}) {
    return FolderStatusesCompanion(
      id: id ?? this.id,
      folderCode: folderCode ?? this.folderCode,
      combined: combined ?? this.combined,
      selected: selected ?? this.selected,
      rejected: rejected ?? this.rejected,
      waitingListed: waitingListed ?? this.waitingListed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (folderCode.present) {
      map['folder_code'] = Variable<String>(folderCode.value);
    }
    if (combined.present) {
      map['combined'] = Variable<bool>(combined.value);
    }
    if (selected.present) {
      map['selected'] = Variable<int>(selected.value);
    }
    if (rejected.present) {
      map['rejected'] = Variable<int>(rejected.value);
    }
    if (waitingListed.present) {
      map['waiting_listed'] = Variable<int>(waitingListed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FolderStatusesCompanion(')
          ..write('id: $id, ')
          ..write('folderCode: $folderCode, ')
          ..write('combined: $combined, ')
          ..write('selected: $selected, ')
          ..write('rejected: $rejected, ')
          ..write('waitingListed: $waitingListed')
          ..write(')'))
        .toString();
  }
}

class $FolderRulesTable extends FolderRules
    with TableInfo<$FolderRulesTable, FolderRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FolderRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _folderCodeMeta =
      const VerificationMeta('folderCode');
  @override
  late final GeneratedColumn<String> folderCode = GeneratedColumn<String>(
      'folder_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NULL REFERENCES folders(code)');
  static const VerificationMeta _minimumSelectionImagesMeta =
      const VerificationMeta('minimumSelectionImages');
  @override
  late final GeneratedColumn<int> minimumSelectionImages = GeneratedColumn<int>(
      'minimum_selection_images', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _maximumSelectionImagesMeta =
      const VerificationMeta('maximumSelectionImages');
  @override
  late final GeneratedColumn<int> maximumSelectionImages = GeneratedColumn<int>(
      'maximum_selection_images', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<int> result = GeneratedColumn<int>(
      'result', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        code,
        folderCode,
        minimumSelectionImages,
        maximumSelectionImages,
        result
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'folder_rules';
  @override
  VerificationContext validateIntegrity(Insertable<FolderRule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('folder_code')) {
      context.handle(
          _folderCodeMeta,
          folderCode.isAcceptableOrUnknown(
              data['folder_code']!, _folderCodeMeta));
    } else if (isInserting) {
      context.missing(_folderCodeMeta);
    }
    if (data.containsKey('minimum_selection_images')) {
      context.handle(
          _minimumSelectionImagesMeta,
          minimumSelectionImages.isAcceptableOrUnknown(
              data['minimum_selection_images']!, _minimumSelectionImagesMeta));
    } else if (isInserting) {
      context.missing(_minimumSelectionImagesMeta);
    }
    if (data.containsKey('maximum_selection_images')) {
      context.handle(
          _maximumSelectionImagesMeta,
          maximumSelectionImages.isAcceptableOrUnknown(
              data['maximum_selection_images']!, _maximumSelectionImagesMeta));
    } else if (isInserting) {
      context.missing(_maximumSelectionImagesMeta);
    }
    if (data.containsKey('result')) {
      context.handle(_resultMeta,
          result.isAcceptableOrUnknown(data['result']!, _resultMeta));
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  FolderRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FolderRule(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      folderCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}folder_code'])!,
      minimumSelectionImages: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}minimum_selection_images'])!,
      maximumSelectionImages: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}maximum_selection_images'])!,
      result: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}result'])!,
    );
  }

  @override
  $FolderRulesTable createAlias(String alias) {
    return $FolderRulesTable(attachedDatabase, alias);
  }
}

class FolderRule extends DataClass implements Insertable<FolderRule> {
  final String code;
  final String folderCode;
  final int minimumSelectionImages;
  final int maximumSelectionImages;
  final int result;
  const FolderRule(
      {required this.code,
      required this.folderCode,
      required this.minimumSelectionImages,
      required this.maximumSelectionImages,
      required this.result});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['folder_code'] = Variable<String>(folderCode);
    map['minimum_selection_images'] = Variable<int>(minimumSelectionImages);
    map['maximum_selection_images'] = Variable<int>(maximumSelectionImages);
    map['result'] = Variable<int>(result);
    return map;
  }

  FolderRulesCompanion toCompanion(bool nullToAbsent) {
    return FolderRulesCompanion(
      code: Value(code),
      folderCode: Value(folderCode),
      minimumSelectionImages: Value(minimumSelectionImages),
      maximumSelectionImages: Value(maximumSelectionImages),
      result: Value(result),
    );
  }

  factory FolderRule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FolderRule(
      code: serializer.fromJson<String>(json['code']),
      folderCode: serializer.fromJson<String>(json['folderCode']),
      minimumSelectionImages:
          serializer.fromJson<int>(json['minimumSelectionImages']),
      maximumSelectionImages:
          serializer.fromJson<int>(json['maximumSelectionImages']),
      result: serializer.fromJson<int>(json['result']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'folderCode': serializer.toJson<String>(folderCode),
      'minimumSelectionImages': serializer.toJson<int>(minimumSelectionImages),
      'maximumSelectionImages': serializer.toJson<int>(maximumSelectionImages),
      'result': serializer.toJson<int>(result),
    };
  }

  FolderRule copyWith(
          {String? code,
          String? folderCode,
          int? minimumSelectionImages,
          int? maximumSelectionImages,
          int? result}) =>
      FolderRule(
        code: code ?? this.code,
        folderCode: folderCode ?? this.folderCode,
        minimumSelectionImages:
            minimumSelectionImages ?? this.minimumSelectionImages,
        maximumSelectionImages:
            maximumSelectionImages ?? this.maximumSelectionImages,
        result: result ?? this.result,
      );
  FolderRule copyWithCompanion(FolderRulesCompanion data) {
    return FolderRule(
      code: data.code.present ? data.code.value : this.code,
      folderCode:
          data.folderCode.present ? data.folderCode.value : this.folderCode,
      minimumSelectionImages: data.minimumSelectionImages.present
          ? data.minimumSelectionImages.value
          : this.minimumSelectionImages,
      maximumSelectionImages: data.maximumSelectionImages.present
          ? data.maximumSelectionImages.value
          : this.maximumSelectionImages,
      result: data.result.present ? data.result.value : this.result,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FolderRule(')
          ..write('code: $code, ')
          ..write('folderCode: $folderCode, ')
          ..write('minimumSelectionImages: $minimumSelectionImages, ')
          ..write('maximumSelectionImages: $maximumSelectionImages, ')
          ..write('result: $result')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      code, folderCode, minimumSelectionImages, maximumSelectionImages, result);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FolderRule &&
          other.code == this.code &&
          other.folderCode == this.folderCode &&
          other.minimumSelectionImages == this.minimumSelectionImages &&
          other.maximumSelectionImages == this.maximumSelectionImages &&
          other.result == this.result);
}

class FolderRulesCompanion extends UpdateCompanion<FolderRule> {
  final Value<String> code;
  final Value<String> folderCode;
  final Value<int> minimumSelectionImages;
  final Value<int> maximumSelectionImages;
  final Value<int> result;
  final Value<int> rowid;
  const FolderRulesCompanion({
    this.code = const Value.absent(),
    this.folderCode = const Value.absent(),
    this.minimumSelectionImages = const Value.absent(),
    this.maximumSelectionImages = const Value.absent(),
    this.result = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FolderRulesCompanion.insert({
    required String code,
    required String folderCode,
    required int minimumSelectionImages,
    required int maximumSelectionImages,
    required int result,
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        folderCode = Value(folderCode),
        minimumSelectionImages = Value(minimumSelectionImages),
        maximumSelectionImages = Value(maximumSelectionImages),
        result = Value(result);
  static Insertable<FolderRule> custom({
    Expression<String>? code,
    Expression<String>? folderCode,
    Expression<int>? minimumSelectionImages,
    Expression<int>? maximumSelectionImages,
    Expression<int>? result,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (folderCode != null) 'folder_code': folderCode,
      if (minimumSelectionImages != null)
        'minimum_selection_images': minimumSelectionImages,
      if (maximumSelectionImages != null)
        'maximum_selection_images': maximumSelectionImages,
      if (result != null) 'result': result,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FolderRulesCompanion copyWith(
      {Value<String>? code,
      Value<String>? folderCode,
      Value<int>? minimumSelectionImages,
      Value<int>? maximumSelectionImages,
      Value<int>? result,
      Value<int>? rowid}) {
    return FolderRulesCompanion(
      code: code ?? this.code,
      folderCode: folderCode ?? this.folderCode,
      minimumSelectionImages:
          minimumSelectionImages ?? this.minimumSelectionImages,
      maximumSelectionImages:
          maximumSelectionImages ?? this.maximumSelectionImages,
      result: result ?? this.result,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (folderCode.present) {
      map['folder_code'] = Variable<String>(folderCode.value);
    }
    if (minimumSelectionImages.present) {
      map['minimum_selection_images'] =
          Variable<int>(minimumSelectionImages.value);
    }
    if (maximumSelectionImages.present) {
      map['maximum_selection_images'] =
          Variable<int>(maximumSelectionImages.value);
    }
    if (result.present) {
      map['result'] = Variable<int>(result.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FolderRulesCompanion(')
          ..write('code: $code, ')
          ..write('folderCode: $folderCode, ')
          ..write('minimumSelectionImages: $minimumSelectionImages, ')
          ..write('maximumSelectionImages: $maximumSelectionImages, ')
          ..write('result: $result, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PhotoSelectionImagesTable extends PhotoSelectionImages
    with TableInfo<$PhotoSelectionImagesTable, PhotoSelectionImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotoSelectionImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<int> lastUpdated = GeneratedColumn<int>(
      'last_updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _folderCodeMeta =
      const VerificationMeta('folderCode');
  @override
  late final GeneratedColumn<String> folderCode = GeneratedColumn<String>(
      'folder_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NULL REFERENCES folders(code)');
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
      'rating', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _originalNameMeta =
      const VerificationMeta('originalName');
  @override
  late final GeneratedColumn<String> originalName = GeneratedColumn<String>(
      'originalName', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        code,
        lastUpdated,
        folderCode,
        status,
        synced,
        comment,
        rating,
        originalName
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photo_selection_images';
  @override
  VerificationContext validateIntegrity(
      Insertable<PhotoSelectionImage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated_at']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    if (data.containsKey('folder_code')) {
      context.handle(
          _folderCodeMeta,
          folderCode.isAcceptableOrUnknown(
              data['folder_code']!, _folderCodeMeta));
    } else if (isInserting) {
      context.missing(_folderCodeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    } else if (isInserting) {
      context.missing(_commentMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('originalName')) {
      context.handle(
          _originalNameMeta,
          originalName.isAcceptableOrUnknown(
              data['originalName']!, _originalNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  PhotoSelectionImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhotoSelectionImage(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_updated_at'])!,
      folderCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}folder_code'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment'])!,
      rating: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rating'])!,
      originalName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}originalName']),
    );
  }

  @override
  $PhotoSelectionImagesTable createAlias(String alias) {
    return $PhotoSelectionImagesTable(attachedDatabase, alias);
  }
}

class PhotoSelectionImage extends DataClass
    implements Insertable<PhotoSelectionImage> {
  final String code;
  final int lastUpdated;
  final String folderCode;
  final int status;
  final bool synced;
  final String comment;
  final int rating;
  final String? originalName;
  const PhotoSelectionImage(
      {required this.code,
      required this.lastUpdated,
      required this.folderCode,
      required this.status,
      required this.synced,
      required this.comment,
      required this.rating,
      this.originalName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['last_updated_at'] = Variable<int>(lastUpdated);
    map['folder_code'] = Variable<String>(folderCode);
    map['status'] = Variable<int>(status);
    map['synced'] = Variable<bool>(synced);
    map['comment'] = Variable<String>(comment);
    map['rating'] = Variable<int>(rating);
    if (!nullToAbsent || originalName != null) {
      map['originalName'] = Variable<String>(originalName);
    }
    return map;
  }

  PhotoSelectionImagesCompanion toCompanion(bool nullToAbsent) {
    return PhotoSelectionImagesCompanion(
      code: Value(code),
      lastUpdated: Value(lastUpdated),
      folderCode: Value(folderCode),
      status: Value(status),
      synced: Value(synced),
      comment: Value(comment),
      rating: Value(rating),
      originalName: originalName == null && nullToAbsent
          ? const Value.absent()
          : Value(originalName),
    );
  }

  factory PhotoSelectionImage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhotoSelectionImage(
      code: serializer.fromJson<String>(json['code']),
      lastUpdated: serializer.fromJson<int>(json['lastUpdated']),
      folderCode: serializer.fromJson<String>(json['folderCode']),
      status: serializer.fromJson<int>(json['status']),
      synced: serializer.fromJson<bool>(json['synced']),
      comment: serializer.fromJson<String>(json['comment']),
      rating: serializer.fromJson<int>(json['rating']),
      originalName: serializer.fromJson<String?>(json['originalName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'lastUpdated': serializer.toJson<int>(lastUpdated),
      'folderCode': serializer.toJson<String>(folderCode),
      'status': serializer.toJson<int>(status),
      'synced': serializer.toJson<bool>(synced),
      'comment': serializer.toJson<String>(comment),
      'rating': serializer.toJson<int>(rating),
      'originalName': serializer.toJson<String?>(originalName),
    };
  }

  PhotoSelectionImage copyWith(
          {String? code,
          int? lastUpdated,
          String? folderCode,
          int? status,
          bool? synced,
          String? comment,
          int? rating,
          Value<String?> originalName = const Value.absent()}) =>
      PhotoSelectionImage(
        code: code ?? this.code,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        folderCode: folderCode ?? this.folderCode,
        status: status ?? this.status,
        synced: synced ?? this.synced,
        comment: comment ?? this.comment,
        rating: rating ?? this.rating,
        originalName:
            originalName.present ? originalName.value : this.originalName,
      );
  PhotoSelectionImage copyWithCompanion(PhotoSelectionImagesCompanion data) {
    return PhotoSelectionImage(
      code: data.code.present ? data.code.value : this.code,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      folderCode:
          data.folderCode.present ? data.folderCode.value : this.folderCode,
      status: data.status.present ? data.status.value : this.status,
      synced: data.synced.present ? data.synced.value : this.synced,
      comment: data.comment.present ? data.comment.value : this.comment,
      rating: data.rating.present ? data.rating.value : this.rating,
      originalName: data.originalName.present
          ? data.originalName.value
          : this.originalName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhotoSelectionImage(')
          ..write('code: $code, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('folderCode: $folderCode, ')
          ..write('status: $status, ')
          ..write('synced: $synced, ')
          ..write('comment: $comment, ')
          ..write('rating: $rating, ')
          ..write('originalName: $originalName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, lastUpdated, folderCode, status, synced,
      comment, rating, originalName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhotoSelectionImage &&
          other.code == this.code &&
          other.lastUpdated == this.lastUpdated &&
          other.folderCode == this.folderCode &&
          other.status == this.status &&
          other.synced == this.synced &&
          other.comment == this.comment &&
          other.rating == this.rating &&
          other.originalName == this.originalName);
}

class PhotoSelectionImagesCompanion
    extends UpdateCompanion<PhotoSelectionImage> {
  final Value<String> code;
  final Value<int> lastUpdated;
  final Value<String> folderCode;
  final Value<int> status;
  final Value<bool> synced;
  final Value<String> comment;
  final Value<int> rating;
  final Value<String?> originalName;
  final Value<int> rowid;
  const PhotoSelectionImagesCompanion({
    this.code = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.folderCode = const Value.absent(),
    this.status = const Value.absent(),
    this.synced = const Value.absent(),
    this.comment = const Value.absent(),
    this.rating = const Value.absent(),
    this.originalName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhotoSelectionImagesCompanion.insert({
    required String code,
    required int lastUpdated,
    required String folderCode,
    required int status,
    this.synced = const Value.absent(),
    required String comment,
    required int rating,
    this.originalName = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        lastUpdated = Value(lastUpdated),
        folderCode = Value(folderCode),
        status = Value(status),
        comment = Value(comment),
        rating = Value(rating);
  static Insertable<PhotoSelectionImage> custom({
    Expression<String>? code,
    Expression<int>? lastUpdated,
    Expression<String>? folderCode,
    Expression<int>? status,
    Expression<bool>? synced,
    Expression<String>? comment,
    Expression<int>? rating,
    Expression<String>? originalName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (lastUpdated != null) 'last_updated_at': lastUpdated,
      if (folderCode != null) 'folder_code': folderCode,
      if (status != null) 'status': status,
      if (synced != null) 'synced': synced,
      if (comment != null) 'comment': comment,
      if (rating != null) 'rating': rating,
      if (originalName != null) 'originalName': originalName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhotoSelectionImagesCompanion copyWith(
      {Value<String>? code,
      Value<int>? lastUpdated,
      Value<String>? folderCode,
      Value<int>? status,
      Value<bool>? synced,
      Value<String>? comment,
      Value<int>? rating,
      Value<String?>? originalName,
      Value<int>? rowid}) {
    return PhotoSelectionImagesCompanion(
      code: code ?? this.code,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      folderCode: folderCode ?? this.folderCode,
      status: status ?? this.status,
      synced: synced ?? this.synced,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
      originalName: originalName ?? this.originalName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (lastUpdated.present) {
      map['last_updated_at'] = Variable<int>(lastUpdated.value);
    }
    if (folderCode.present) {
      map['folder_code'] = Variable<String>(folderCode.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (originalName.present) {
      map['originalName'] = Variable<String>(originalName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotoSelectionImagesCompanion(')
          ..write('code: $code, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('folderCode: $folderCode, ')
          ..write('status: $status, ')
          ..write('synced: $synced, ')
          ..write('comment: $comment, ')
          ..write('rating: $rating, ')
          ..write('originalName: $originalName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventInfoTable extends EventInfo
    with TableInfo<$EventInfoTable, EventInfoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventInfoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _eventCodeMeta =
      const VerificationMeta('eventCode');
  @override
  late final GeneratedColumn<String> eventCode = GeneratedColumn<String>(
      'event_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NULL REFERENCES events(code)');
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, eventCode, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_info';
  @override
  VerificationContext validateIntegrity(Insertable<EventInfoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_code')) {
      context.handle(_eventCodeMeta,
          eventCode.isAcceptableOrUnknown(data['event_code']!, _eventCodeMeta));
    } else if (isInserting) {
      context.missing(_eventCodeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventInfoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventInfoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      eventCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_code'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $EventInfoTable createAlias(String alias) {
    return $EventInfoTable(attachedDatabase, alias);
  }
}

class EventInfoData extends DataClass implements Insertable<EventInfoData> {
  final int id;
  final String eventCode;
  final String value;
  const EventInfoData(
      {required this.id, required this.eventCode, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_code'] = Variable<String>(eventCode);
    map['value'] = Variable<String>(value);
    return map;
  }

  EventInfoCompanion toCompanion(bool nullToAbsent) {
    return EventInfoCompanion(
      id: Value(id),
      eventCode: Value(eventCode),
      value: Value(value),
    );
  }

  factory EventInfoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventInfoData(
      id: serializer.fromJson<int>(json['id']),
      eventCode: serializer.fromJson<String>(json['eventCode']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventCode': serializer.toJson<String>(eventCode),
      'value': serializer.toJson<String>(value),
    };
  }

  EventInfoData copyWith({int? id, String? eventCode, String? value}) =>
      EventInfoData(
        id: id ?? this.id,
        eventCode: eventCode ?? this.eventCode,
        value: value ?? this.value,
      );
  EventInfoData copyWithCompanion(EventInfoCompanion data) {
    return EventInfoData(
      id: data.id.present ? data.id.value : this.id,
      eventCode: data.eventCode.present ? data.eventCode.value : this.eventCode,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventInfoData(')
          ..write('id: $id, ')
          ..write('eventCode: $eventCode, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eventCode, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventInfoData &&
          other.id == this.id &&
          other.eventCode == this.eventCode &&
          other.value == this.value);
}

class EventInfoCompanion extends UpdateCompanion<EventInfoData> {
  final Value<int> id;
  final Value<String> eventCode;
  final Value<String> value;
  const EventInfoCompanion({
    this.id = const Value.absent(),
    this.eventCode = const Value.absent(),
    this.value = const Value.absent(),
  });
  EventInfoCompanion.insert({
    this.id = const Value.absent(),
    required String eventCode,
    required String value,
  })  : eventCode = Value(eventCode),
        value = Value(value);
  static Insertable<EventInfoData> custom({
    Expression<int>? id,
    Expression<String>? eventCode,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventCode != null) 'event_code': eventCode,
      if (value != null) 'value': value,
    });
  }

  EventInfoCompanion copyWith(
      {Value<int>? id, Value<String>? eventCode, Value<String>? value}) {
    return EventInfoCompanion(
      id: id ?? this.id,
      eventCode: eventCode ?? this.eventCode,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventInfoCompanion(')
          ..write('id: $id, ')
          ..write('eventCode: $eventCode, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $StudioPackageTable extends StudioPackage
    with TableInfo<$StudioPackageTable, StudioPackageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudioPackageTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _publishedMeta =
      const VerificationMeta('published');
  @override
  late final GeneratedColumn<bool> published = GeneratedColumn<bool>(
      'published', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("published" IN (0, 1))'));
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
      'price', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _discountValueMeta =
      const VerificationMeta('discountValue');
  @override
  late final GeneratedColumn<int> discountValue = GeneratedColumn<int>(
      'discount_value', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _discountTermMeta =
      const VerificationMeta('discountTerm');
  @override
  late final GeneratedColumn<int> discountTerm = GeneratedColumn<int>(
      'discount_term', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [code, name, description, published, price, discountValue, discountTerm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'studio_package';
  @override
  VerificationContext validateIntegrity(Insertable<StudioPackageData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('published')) {
      context.handle(_publishedMeta,
          published.isAcceptableOrUnknown(data['published']!, _publishedMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('discount_value')) {
      context.handle(
          _discountValueMeta,
          discountValue.isAcceptableOrUnknown(
              data['discount_value']!, _discountValueMeta));
    }
    if (data.containsKey('discount_term')) {
      context.handle(
          _discountTermMeta,
          discountTerm.isAcceptableOrUnknown(
              data['discount_term']!, _discountTermMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  StudioPackageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudioPackageData(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      published: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}published']),
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}price']),
      discountValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount_value']),
      discountTerm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount_term']),
    );
  }

  @override
  $StudioPackageTable createAlias(String alias) {
    return $StudioPackageTable(attachedDatabase, alias);
  }
}

class StudioPackageData extends DataClass
    implements Insertable<StudioPackageData> {
  final String code;
  final String? name;
  final String? description;
  final bool? published;
  final int? price;
  final int? discountValue;
  final int? discountTerm;
  const StudioPackageData(
      {required this.code,
      this.name,
      this.description,
      this.published,
      this.price,
      this.discountValue,
      this.discountTerm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || published != null) {
      map['published'] = Variable<bool>(published);
    }
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<int>(price);
    }
    if (!nullToAbsent || discountValue != null) {
      map['discount_value'] = Variable<int>(discountValue);
    }
    if (!nullToAbsent || discountTerm != null) {
      map['discount_term'] = Variable<int>(discountTerm);
    }
    return map;
  }

  StudioPackageCompanion toCompanion(bool nullToAbsent) {
    return StudioPackageCompanion(
      code: Value(code),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      published: published == null && nullToAbsent
          ? const Value.absent()
          : Value(published),
      price:
          price == null && nullToAbsent ? const Value.absent() : Value(price),
      discountValue: discountValue == null && nullToAbsent
          ? const Value.absent()
          : Value(discountValue),
      discountTerm: discountTerm == null && nullToAbsent
          ? const Value.absent()
          : Value(discountTerm),
    );
  }

  factory StudioPackageData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudioPackageData(
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String?>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      published: serializer.fromJson<bool?>(json['published']),
      price: serializer.fromJson<int?>(json['price']),
      discountValue: serializer.fromJson<int?>(json['discountValue']),
      discountTerm: serializer.fromJson<int?>(json['discountTerm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String?>(name),
      'description': serializer.toJson<String?>(description),
      'published': serializer.toJson<bool?>(published),
      'price': serializer.toJson<int?>(price),
      'discountValue': serializer.toJson<int?>(discountValue),
      'discountTerm': serializer.toJson<int?>(discountTerm),
    };
  }

  StudioPackageData copyWith(
          {String? code,
          Value<String?> name = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<bool?> published = const Value.absent(),
          Value<int?> price = const Value.absent(),
          Value<int?> discountValue = const Value.absent(),
          Value<int?> discountTerm = const Value.absent()}) =>
      StudioPackageData(
        code: code ?? this.code,
        name: name.present ? name.value : this.name,
        description: description.present ? description.value : this.description,
        published: published.present ? published.value : this.published,
        price: price.present ? price.value : this.price,
        discountValue:
            discountValue.present ? discountValue.value : this.discountValue,
        discountTerm:
            discountTerm.present ? discountTerm.value : this.discountTerm,
      );
  StudioPackageData copyWithCompanion(StudioPackageCompanion data) {
    return StudioPackageData(
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      published: data.published.present ? data.published.value : this.published,
      price: data.price.present ? data.price.value : this.price,
      discountValue: data.discountValue.present
          ? data.discountValue.value
          : this.discountValue,
      discountTerm: data.discountTerm.present
          ? data.discountTerm.value
          : this.discountTerm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudioPackageData(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('published: $published, ')
          ..write('price: $price, ')
          ..write('discountValue: $discountValue, ')
          ..write('discountTerm: $discountTerm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      code, name, description, published, price, discountValue, discountTerm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudioPackageData &&
          other.code == this.code &&
          other.name == this.name &&
          other.description == this.description &&
          other.published == this.published &&
          other.price == this.price &&
          other.discountValue == this.discountValue &&
          other.discountTerm == this.discountTerm);
}

class StudioPackageCompanion extends UpdateCompanion<StudioPackageData> {
  final Value<String> code;
  final Value<String?> name;
  final Value<String?> description;
  final Value<bool?> published;
  final Value<int?> price;
  final Value<int?> discountValue;
  final Value<int?> discountTerm;
  final Value<int> rowid;
  const StudioPackageCompanion({
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.published = const Value.absent(),
    this.price = const Value.absent(),
    this.discountValue = const Value.absent(),
    this.discountTerm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudioPackageCompanion.insert({
    required String code,
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.published = const Value.absent(),
    this.price = const Value.absent(),
    this.discountValue = const Value.absent(),
    this.discountTerm = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : code = Value(code);
  static Insertable<StudioPackageData> custom({
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? description,
    Expression<bool>? published,
    Expression<int>? price,
    Expression<int>? discountValue,
    Expression<int>? discountTerm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (published != null) 'published': published,
      if (price != null) 'price': price,
      if (discountValue != null) 'discount_value': discountValue,
      if (discountTerm != null) 'discount_term': discountTerm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudioPackageCompanion copyWith(
      {Value<String>? code,
      Value<String?>? name,
      Value<String?>? description,
      Value<bool?>? published,
      Value<int?>? price,
      Value<int?>? discountValue,
      Value<int?>? discountTerm,
      Value<int>? rowid}) {
    return StudioPackageCompanion(
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      published: published ?? this.published,
      price: price ?? this.price,
      discountValue: discountValue ?? this.discountValue,
      discountTerm: discountTerm ?? this.discountTerm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (published.present) {
      map['published'] = Variable<bool>(published.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (discountValue.present) {
      map['discount_value'] = Variable<int>(discountValue.value);
    }
    if (discountTerm.present) {
      map['discount_term'] = Variable<int>(discountTerm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudioPackageCompanion(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('published: $published, ')
          ..write('price: $price, ')
          ..write('discountValue: $discountValue, ')
          ..write('discountTerm: $discountTerm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudioPackageValueTable extends StudioPackageValue
    with TableInfo<$StudioPackageValueTable, StudioPackageValueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudioPackageValueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ableCodeMeta =
      const VerificationMeta('ableCode');
  @override
  late final GeneratedColumn<String> ableCode = GeneratedColumn<String>(
      'able_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [code, key, value, ableCode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'studio_package_value';
  @override
  VerificationContext validateIntegrity(
      Insertable<StudioPackageValueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('able_code')) {
      context.handle(_ableCodeMeta,
          ableCode.isAcceptableOrUnknown(data['able_code']!, _ableCodeMeta));
    } else if (isInserting) {
      context.missing(_ableCodeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  StudioPackageValueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudioPackageValueData(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      ableCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}able_code'])!,
    );
  }

  @override
  $StudioPackageValueTable createAlias(String alias) {
    return $StudioPackageValueTable(attachedDatabase, alias);
  }
}

class StudioPackageValueData extends DataClass
    implements Insertable<StudioPackageValueData> {
  final String code;
  final String key;
  final String value;
  final String ableCode;
  const StudioPackageValueData(
      {required this.code,
      required this.key,
      required this.value,
      required this.ableCode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['able_code'] = Variable<String>(ableCode);
    return map;
  }

  StudioPackageValueCompanion toCompanion(bool nullToAbsent) {
    return StudioPackageValueCompanion(
      code: Value(code),
      key: Value(key),
      value: Value(value),
      ableCode: Value(ableCode),
    );
  }

  factory StudioPackageValueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudioPackageValueData(
      code: serializer.fromJson<String>(json['code']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      ableCode: serializer.fromJson<String>(json['ableCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'ableCode': serializer.toJson<String>(ableCode),
    };
  }

  StudioPackageValueData copyWith(
          {String? code, String? key, String? value, String? ableCode}) =>
      StudioPackageValueData(
        code: code ?? this.code,
        key: key ?? this.key,
        value: value ?? this.value,
        ableCode: ableCode ?? this.ableCode,
      );
  StudioPackageValueData copyWithCompanion(StudioPackageValueCompanion data) {
    return StudioPackageValueData(
      code: data.code.present ? data.code.value : this.code,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      ableCode: data.ableCode.present ? data.ableCode.value : this.ableCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudioPackageValueData(')
          ..write('code: $code, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('ableCode: $ableCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, key, value, ableCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudioPackageValueData &&
          other.code == this.code &&
          other.key == this.key &&
          other.value == this.value &&
          other.ableCode == this.ableCode);
}

class StudioPackageValueCompanion
    extends UpdateCompanion<StudioPackageValueData> {
  final Value<String> code;
  final Value<String> key;
  final Value<String> value;
  final Value<String> ableCode;
  final Value<int> rowid;
  const StudioPackageValueCompanion({
    this.code = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.ableCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudioPackageValueCompanion.insert({
    required String code,
    required String key,
    required String value,
    required String ableCode,
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        key = Value(key),
        value = Value(value),
        ableCode = Value(ableCode);
  static Insertable<StudioPackageValueData> custom({
    Expression<String>? code,
    Expression<String>? key,
    Expression<String>? value,
    Expression<String>? ableCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (ableCode != null) 'able_code': ableCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudioPackageValueCompanion copyWith(
      {Value<String>? code,
      Value<String>? key,
      Value<String>? value,
      Value<String>? ableCode,
      Value<int>? rowid}) {
    return StudioPackageValueCompanion(
      code: code ?? this.code,
      key: key ?? this.key,
      value: value ?? this.value,
      ableCode: ableCode ?? this.ableCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (ableCode.present) {
      map['able_code'] = Variable<String>(ableCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudioPackageValueCompanion(')
          ..write('code: $code, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('ableCode: $ableCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VideosTable extends Videos with TableInfo<$VideosTable, Video> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VideosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _eventCodeMeta =
      const VerificationMeta('eventCode');
  @override
  late final GeneratedColumn<String> eventCode = GeneratedColumn<String>(
      'event_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NULL REFERENCES events(code)');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priorityScoreMeta =
      const VerificationMeta('priorityScore');
  @override
  late final GeneratedColumn<int> priorityScore = GeneratedColumn<int>(
      'priority_score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _publishedMeta =
      const VerificationMeta('published');
  @override
  late final GeneratedColumn<bool> published = GeneratedColumn<bool>(
      'published', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("published" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _visibilityMeta =
      const VerificationMeta('visibility');
  @override
  late final GeneratedColumn<int> visibility = GeneratedColumn<int>(
      'visibility', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [code, eventCode, name, url, priorityScore, published, visibility];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'videos';
  @override
  VerificationContext validateIntegrity(Insertable<Video> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('event_code')) {
      context.handle(_eventCodeMeta,
          eventCode.isAcceptableOrUnknown(data['event_code']!, _eventCodeMeta));
    } else if (isInserting) {
      context.missing(_eventCodeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('priority_score')) {
      context.handle(
          _priorityScoreMeta,
          priorityScore.isAcceptableOrUnknown(
              data['priority_score']!, _priorityScoreMeta));
    } else if (isInserting) {
      context.missing(_priorityScoreMeta);
    }
    if (data.containsKey('published')) {
      context.handle(_publishedMeta,
          published.isAcceptableOrUnknown(data['published']!, _publishedMeta));
    }
    if (data.containsKey('visibility')) {
      context.handle(
          _visibilityMeta,
          visibility.isAcceptableOrUnknown(
              data['visibility']!, _visibilityMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  Video map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Video(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      eventCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      priorityScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority_score'])!,
      published: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}published'])!,
      visibility: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}visibility']),
    );
  }

  @override
  $VideosTable createAlias(String alias) {
    return $VideosTable(attachedDatabase, alias);
  }
}

class Video extends DataClass implements Insertable<Video> {
  final String code;
  final String eventCode;
  final String name;
  final String url;
  final int priorityScore;
  final bool published;
  final int? visibility;
  const Video(
      {required this.code,
      required this.eventCode,
      required this.name,
      required this.url,
      required this.priorityScore,
      required this.published,
      this.visibility});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['event_code'] = Variable<String>(eventCode);
    map['name'] = Variable<String>(name);
    map['url'] = Variable<String>(url);
    map['priority_score'] = Variable<int>(priorityScore);
    map['published'] = Variable<bool>(published);
    if (!nullToAbsent || visibility != null) {
      map['visibility'] = Variable<int>(visibility);
    }
    return map;
  }

  VideosCompanion toCompanion(bool nullToAbsent) {
    return VideosCompanion(
      code: Value(code),
      eventCode: Value(eventCode),
      name: Value(name),
      url: Value(url),
      priorityScore: Value(priorityScore),
      published: Value(published),
      visibility: visibility == null && nullToAbsent
          ? const Value.absent()
          : Value(visibility),
    );
  }

  factory Video.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Video(
      code: serializer.fromJson<String>(json['code']),
      eventCode: serializer.fromJson<String>(json['eventCode']),
      name: serializer.fromJson<String>(json['name']),
      url: serializer.fromJson<String>(json['url']),
      priorityScore: serializer.fromJson<int>(json['priorityScore']),
      published: serializer.fromJson<bool>(json['published']),
      visibility: serializer.fromJson<int?>(json['visibility']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'eventCode': serializer.toJson<String>(eventCode),
      'name': serializer.toJson<String>(name),
      'url': serializer.toJson<String>(url),
      'priorityScore': serializer.toJson<int>(priorityScore),
      'published': serializer.toJson<bool>(published),
      'visibility': serializer.toJson<int?>(visibility),
    };
  }

  Video copyWith(
          {String? code,
          String? eventCode,
          String? name,
          String? url,
          int? priorityScore,
          bool? published,
          Value<int?> visibility = const Value.absent()}) =>
      Video(
        code: code ?? this.code,
        eventCode: eventCode ?? this.eventCode,
        name: name ?? this.name,
        url: url ?? this.url,
        priorityScore: priorityScore ?? this.priorityScore,
        published: published ?? this.published,
        visibility: visibility.present ? visibility.value : this.visibility,
      );
  Video copyWithCompanion(VideosCompanion data) {
    return Video(
      code: data.code.present ? data.code.value : this.code,
      eventCode: data.eventCode.present ? data.eventCode.value : this.eventCode,
      name: data.name.present ? data.name.value : this.name,
      url: data.url.present ? data.url.value : this.url,
      priorityScore: data.priorityScore.present
          ? data.priorityScore.value
          : this.priorityScore,
      published: data.published.present ? data.published.value : this.published,
      visibility:
          data.visibility.present ? data.visibility.value : this.visibility,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Video(')
          ..write('code: $code, ')
          ..write('eventCode: $eventCode, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('priorityScore: $priorityScore, ')
          ..write('published: $published, ')
          ..write('visibility: $visibility')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      code, eventCode, name, url, priorityScore, published, visibility);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Video &&
          other.code == this.code &&
          other.eventCode == this.eventCode &&
          other.name == this.name &&
          other.url == this.url &&
          other.priorityScore == this.priorityScore &&
          other.published == this.published &&
          other.visibility == this.visibility);
}

class VideosCompanion extends UpdateCompanion<Video> {
  final Value<String> code;
  final Value<String> eventCode;
  final Value<String> name;
  final Value<String> url;
  final Value<int> priorityScore;
  final Value<bool> published;
  final Value<int?> visibility;
  final Value<int> rowid;
  const VideosCompanion({
    this.code = const Value.absent(),
    this.eventCode = const Value.absent(),
    this.name = const Value.absent(),
    this.url = const Value.absent(),
    this.priorityScore = const Value.absent(),
    this.published = const Value.absent(),
    this.visibility = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VideosCompanion.insert({
    required String code,
    required String eventCode,
    required String name,
    required String url,
    required int priorityScore,
    this.published = const Value.absent(),
    this.visibility = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        eventCode = Value(eventCode),
        name = Value(name),
        url = Value(url),
        priorityScore = Value(priorityScore);
  static Insertable<Video> custom({
    Expression<String>? code,
    Expression<String>? eventCode,
    Expression<String>? name,
    Expression<String>? url,
    Expression<int>? priorityScore,
    Expression<bool>? published,
    Expression<int>? visibility,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (eventCode != null) 'event_code': eventCode,
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (priorityScore != null) 'priority_score': priorityScore,
      if (published != null) 'published': published,
      if (visibility != null) 'visibility': visibility,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VideosCompanion copyWith(
      {Value<String>? code,
      Value<String>? eventCode,
      Value<String>? name,
      Value<String>? url,
      Value<int>? priorityScore,
      Value<bool>? published,
      Value<int?>? visibility,
      Value<int>? rowid}) {
    return VideosCompanion(
      code: code ?? this.code,
      eventCode: eventCode ?? this.eventCode,
      name: name ?? this.name,
      url: url ?? this.url,
      priorityScore: priorityScore ?? this.priorityScore,
      published: published ?? this.published,
      visibility: visibility ?? this.visibility,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (priorityScore.present) {
      map['priority_score'] = Variable<int>(priorityScore.value);
    }
    if (published.present) {
      map['published'] = Variable<bool>(published.value);
    }
    if (visibility.present) {
      map['visibility'] = Variable<int>(visibility.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VideosCompanion(')
          ..write('code: $code, ')
          ..write('eventCode: $eventCode, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('priorityScore: $priorityScore, ')
          ..write('published: $published, ')
          ..write('visibility: $visibility, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CarouselPropertiesTable extends CarouselProperties
    with TableInfo<$CarouselPropertiesTable, CarouselProperty> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CarouselPropertiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _priorityScoreMeta =
      const VerificationMeta('priorityScore');
  @override
  late final GeneratedColumn<int> priorityScore = GeneratedColumn<int>(
      'priority_score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _ableCodeMeta =
      const VerificationMeta('ableCode');
  @override
  late final GeneratedColumn<String> ableCode = GeneratedColumn<String>(
      'able_code', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _ableTypeMeta =
      const VerificationMeta('ableType');
  @override
  late final GeneratedColumn<String> ableType = GeneratedColumn<String>(
      'able_type', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [code, priorityScore, ableCode, ableType, image];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'carousel_properties';
  @override
  VerificationContext validateIntegrity(Insertable<CarouselProperty> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('priority_score')) {
      context.handle(
          _priorityScoreMeta,
          priorityScore.isAcceptableOrUnknown(
              data['priority_score']!, _priorityScoreMeta));
    } else if (isInserting) {
      context.missing(_priorityScoreMeta);
    }
    if (data.containsKey('able_code')) {
      context.handle(_ableCodeMeta,
          ableCode.isAcceptableOrUnknown(data['able_code']!, _ableCodeMeta));
    }
    if (data.containsKey('able_type')) {
      context.handle(_ableTypeMeta,
          ableType.isAcceptableOrUnknown(data['able_type']!, _ableTypeMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  CarouselProperty map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CarouselProperty(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      priorityScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority_score'])!,
      ableCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}able_code']),
      ableType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}able_type']),
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
    );
  }

  @override
  $CarouselPropertiesTable createAlias(String alias) {
    return $CarouselPropertiesTable(attachedDatabase, alias);
  }
}

class CarouselProperty extends DataClass
    implements Insertable<CarouselProperty> {
  final String code;
  final int priorityScore;
  final String? ableCode;
  final String? ableType;
  final String? image;
  const CarouselProperty(
      {required this.code,
      required this.priorityScore,
      this.ableCode,
      this.ableType,
      this.image});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['priority_score'] = Variable<int>(priorityScore);
    if (!nullToAbsent || ableCode != null) {
      map['able_code'] = Variable<String>(ableCode);
    }
    if (!nullToAbsent || ableType != null) {
      map['able_type'] = Variable<String>(ableType);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    return map;
  }

  CarouselPropertiesCompanion toCompanion(bool nullToAbsent) {
    return CarouselPropertiesCompanion(
      code: Value(code),
      priorityScore: Value(priorityScore),
      ableCode: ableCode == null && nullToAbsent
          ? const Value.absent()
          : Value(ableCode),
      ableType: ableType == null && nullToAbsent
          ? const Value.absent()
          : Value(ableType),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
    );
  }

  factory CarouselProperty.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CarouselProperty(
      code: serializer.fromJson<String>(json['code']),
      priorityScore: serializer.fromJson<int>(json['priorityScore']),
      ableCode: serializer.fromJson<String?>(json['ableCode']),
      ableType: serializer.fromJson<String?>(json['ableType']),
      image: serializer.fromJson<String?>(json['image']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'priorityScore': serializer.toJson<int>(priorityScore),
      'ableCode': serializer.toJson<String?>(ableCode),
      'ableType': serializer.toJson<String?>(ableType),
      'image': serializer.toJson<String?>(image),
    };
  }

  CarouselProperty copyWith(
          {String? code,
          int? priorityScore,
          Value<String?> ableCode = const Value.absent(),
          Value<String?> ableType = const Value.absent(),
          Value<String?> image = const Value.absent()}) =>
      CarouselProperty(
        code: code ?? this.code,
        priorityScore: priorityScore ?? this.priorityScore,
        ableCode: ableCode.present ? ableCode.value : this.ableCode,
        ableType: ableType.present ? ableType.value : this.ableType,
        image: image.present ? image.value : this.image,
      );
  CarouselProperty copyWithCompanion(CarouselPropertiesCompanion data) {
    return CarouselProperty(
      code: data.code.present ? data.code.value : this.code,
      priorityScore: data.priorityScore.present
          ? data.priorityScore.value
          : this.priorityScore,
      ableCode: data.ableCode.present ? data.ableCode.value : this.ableCode,
      ableType: data.ableType.present ? data.ableType.value : this.ableType,
      image: data.image.present ? data.image.value : this.image,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CarouselProperty(')
          ..write('code: $code, ')
          ..write('priorityScore: $priorityScore, ')
          ..write('ableCode: $ableCode, ')
          ..write('ableType: $ableType, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(code, priorityScore, ableCode, ableType, image);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CarouselProperty &&
          other.code == this.code &&
          other.priorityScore == this.priorityScore &&
          other.ableCode == this.ableCode &&
          other.ableType == this.ableType &&
          other.image == this.image);
}

class CarouselPropertiesCompanion extends UpdateCompanion<CarouselProperty> {
  final Value<String> code;
  final Value<int> priorityScore;
  final Value<String?> ableCode;
  final Value<String?> ableType;
  final Value<String?> image;
  final Value<int> rowid;
  const CarouselPropertiesCompanion({
    this.code = const Value.absent(),
    this.priorityScore = const Value.absent(),
    this.ableCode = const Value.absent(),
    this.ableType = const Value.absent(),
    this.image = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CarouselPropertiesCompanion.insert({
    required String code,
    required int priorityScore,
    this.ableCode = const Value.absent(),
    this.ableType = const Value.absent(),
    this.image = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        priorityScore = Value(priorityScore);
  static Insertable<CarouselProperty> custom({
    Expression<String>? code,
    Expression<int>? priorityScore,
    Expression<String>? ableCode,
    Expression<String>? ableType,
    Expression<String>? image,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (priorityScore != null) 'priority_score': priorityScore,
      if (ableCode != null) 'able_code': ableCode,
      if (ableType != null) 'able_type': ableType,
      if (image != null) 'image': image,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CarouselPropertiesCompanion copyWith(
      {Value<String>? code,
      Value<int>? priorityScore,
      Value<String?>? ableCode,
      Value<String?>? ableType,
      Value<String?>? image,
      Value<int>? rowid}) {
    return CarouselPropertiesCompanion(
      code: code ?? this.code,
      priorityScore: priorityScore ?? this.priorityScore,
      ableCode: ableCode ?? this.ableCode,
      ableType: ableType ?? this.ableType,
      image: image ?? this.image,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (priorityScore.present) {
      map['priority_score'] = Variable<int>(priorityScore.value);
    }
    if (ableCode.present) {
      map['able_code'] = Variable<String>(ableCode.value);
    }
    if (ableType.present) {
      map['able_type'] = Variable<String>(ableType.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarouselPropertiesCompanion(')
          ..write('code: $code, ')
          ..write('priorityScore: $priorityScore, ')
          ..write('ableCode: $ableCode, ')
          ..write('ableType: $ableType, ')
          ..write('image: $image, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CarouselTable extends Carousel
    with TableInfo<$CarouselTable, CarouselData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CarouselTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _intervalMeta =
      const VerificationMeta('interval');
  @override
  late final GeneratedColumn<int> interval = GeneratedColumn<int>(
      'interval', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
      'height', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
      'width', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedAtMeta =
      const VerificationMeta('lastUpdatedAt');
  @override
  late final GeneratedColumn<int> lastUpdatedAt = GeneratedColumn<int>(
      'last_updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [code, interval, height, width, lastUpdatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'carousel';
  @override
  VerificationContext validateIntegrity(Insertable<CarouselData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('interval')) {
      context.handle(_intervalMeta,
          interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta));
    } else if (isInserting) {
      context.missing(_intervalMeta);
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
          _widthMeta, width.isAcceptableOrUnknown(data['width']!, _widthMeta));
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
          _lastUpdatedAtMeta,
          lastUpdatedAt.isAcceptableOrUnknown(
              data['last_updated_at']!, _lastUpdatedAtMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  CarouselData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CarouselData(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      interval: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval'])!,
      height: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}height'])!,
      width: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}width'])!,
      lastUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_updated_at'])!,
    );
  }

  @override
  $CarouselTable createAlias(String alias) {
    return $CarouselTable(attachedDatabase, alias);
  }
}

class CarouselData extends DataClass implements Insertable<CarouselData> {
  final String code;
  final int interval;
  final int height;
  final int width;
  final int lastUpdatedAt;
  const CarouselData(
      {required this.code,
      required this.interval,
      required this.height,
      required this.width,
      required this.lastUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['interval'] = Variable<int>(interval);
    map['height'] = Variable<int>(height);
    map['width'] = Variable<int>(width);
    map['last_updated_at'] = Variable<int>(lastUpdatedAt);
    return map;
  }

  CarouselCompanion toCompanion(bool nullToAbsent) {
    return CarouselCompanion(
      code: Value(code),
      interval: Value(interval),
      height: Value(height),
      width: Value(width),
      lastUpdatedAt: Value(lastUpdatedAt),
    );
  }

  factory CarouselData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CarouselData(
      code: serializer.fromJson<String>(json['code']),
      interval: serializer.fromJson<int>(json['interval']),
      height: serializer.fromJson<int>(json['height']),
      width: serializer.fromJson<int>(json['width']),
      lastUpdatedAt: serializer.fromJson<int>(json['lastUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'interval': serializer.toJson<int>(interval),
      'height': serializer.toJson<int>(height),
      'width': serializer.toJson<int>(width),
      'lastUpdatedAt': serializer.toJson<int>(lastUpdatedAt),
    };
  }

  CarouselData copyWith(
          {String? code,
          int? interval,
          int? height,
          int? width,
          int? lastUpdatedAt}) =>
      CarouselData(
        code: code ?? this.code,
        interval: interval ?? this.interval,
        height: height ?? this.height,
        width: width ?? this.width,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      );
  CarouselData copyWithCompanion(CarouselCompanion data) {
    return CarouselData(
      code: data.code.present ? data.code.value : this.code,
      interval: data.interval.present ? data.interval.value : this.interval,
      height: data.height.present ? data.height.value : this.height,
      width: data.width.present ? data.width.value : this.width,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CarouselData(')
          ..write('code: $code, ')
          ..write('interval: $interval, ')
          ..write('height: $height, ')
          ..write('width: $width, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, interval, height, width, lastUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CarouselData &&
          other.code == this.code &&
          other.interval == this.interval &&
          other.height == this.height &&
          other.width == this.width &&
          other.lastUpdatedAt == this.lastUpdatedAt);
}

class CarouselCompanion extends UpdateCompanion<CarouselData> {
  final Value<String> code;
  final Value<int> interval;
  final Value<int> height;
  final Value<int> width;
  final Value<int> lastUpdatedAt;
  final Value<int> rowid;
  const CarouselCompanion({
    this.code = const Value.absent(),
    this.interval = const Value.absent(),
    this.height = const Value.absent(),
    this.width = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CarouselCompanion.insert({
    required String code,
    required int interval,
    required int height,
    required int width,
    required int lastUpdatedAt,
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        interval = Value(interval),
        height = Value(height),
        width = Value(width),
        lastUpdatedAt = Value(lastUpdatedAt);
  static Insertable<CarouselData> custom({
    Expression<String>? code,
    Expression<int>? interval,
    Expression<int>? height,
    Expression<int>? width,
    Expression<int>? lastUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (interval != null) 'interval': interval,
      if (height != null) 'height': height,
      if (width != null) 'width': width,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CarouselCompanion copyWith(
      {Value<String>? code,
      Value<int>? interval,
      Value<int>? height,
      Value<int>? width,
      Value<int>? lastUpdatedAt,
      Value<int>? rowid}) {
    return CarouselCompanion(
      code: code ?? this.code,
      interval: interval ?? this.interval,
      height: height ?? this.height,
      width: width ?? this.width,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (interval.present) {
      map['interval'] = Variable<int>(interval.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<int>(lastUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarouselCompanion(')
          ..write('code: $code, ')
          ..write('interval: $interval, ')
          ..write('height: $height, ')
          ..write('width: $width, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaTable extends Media with TableInfo<$MediaTable, MediaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _eventCodeMeta =
      const VerificationMeta('eventCode');
  @override
  late final GeneratedColumn<String> eventCode = GeneratedColumn<String>(
      'event_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _ableTypeMeta =
      const VerificationMeta('ableType');
  @override
  late final GeneratedColumn<String> ableType = GeneratedColumn<String>(
      'able_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ableCodeMeta =
      const VerificationMeta('ableCode');
  @override
  late final GeneratedColumn<String> ableCode = GeneratedColumn<String>(
      'able_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priorityScoreMeta =
      const VerificationMeta('priorityScore');
  @override
  late final GeneratedColumn<int> priorityScore = GeneratedColumn<int>(
      'priority_score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _publishedMeta =
      const VerificationMeta('published');
  @override
  late final GeneratedColumn<bool> published = GeneratedColumn<bool>(
      'published', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("published" IN (0, 1))'));
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<int> lastUpdated = GeneratedColumn<int>(
      'last_updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        code,
        eventCode,
        ableType,
        ableCode,
        priorityScore,
        published,
        lastUpdated
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media';
  @override
  VerificationContext validateIntegrity(Insertable<MediaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('event_code')) {
      context.handle(_eventCodeMeta,
          eventCode.isAcceptableOrUnknown(data['event_code']!, _eventCodeMeta));
    } else if (isInserting) {
      context.missing(_eventCodeMeta);
    }
    if (data.containsKey('able_type')) {
      context.handle(_ableTypeMeta,
          ableType.isAcceptableOrUnknown(data['able_type']!, _ableTypeMeta));
    } else if (isInserting) {
      context.missing(_ableTypeMeta);
    }
    if (data.containsKey('able_code')) {
      context.handle(_ableCodeMeta,
          ableCode.isAcceptableOrUnknown(data['able_code']!, _ableCodeMeta));
    } else if (isInserting) {
      context.missing(_ableCodeMeta);
    }
    if (data.containsKey('priority_score')) {
      context.handle(
          _priorityScoreMeta,
          priorityScore.isAcceptableOrUnknown(
              data['priority_score']!, _priorityScoreMeta));
    } else if (isInserting) {
      context.missing(_priorityScoreMeta);
    }
    if (data.containsKey('published')) {
      context.handle(_publishedMeta,
          published.isAcceptableOrUnknown(data['published']!, _publishedMeta));
    } else if (isInserting) {
      context.missing(_publishedMeta);
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated_at']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  MediaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaData(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      eventCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_code'])!,
      ableType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}able_type'])!,
      ableCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}able_code'])!,
      priorityScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority_score'])!,
      published: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}published'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_updated_at'])!,
    );
  }

  @override
  $MediaTable createAlias(String alias) {
    return $MediaTable(attachedDatabase, alias);
  }
}

class MediaData extends DataClass implements Insertable<MediaData> {
  final String code;
  final String eventCode;
  final String ableType;
  final String ableCode;
  final int priorityScore;
  final bool published;
  final int lastUpdated;
  const MediaData(
      {required this.code,
      required this.eventCode,
      required this.ableType,
      required this.ableCode,
      required this.priorityScore,
      required this.published,
      required this.lastUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['event_code'] = Variable<String>(eventCode);
    map['able_type'] = Variable<String>(ableType);
    map['able_code'] = Variable<String>(ableCode);
    map['priority_score'] = Variable<int>(priorityScore);
    map['published'] = Variable<bool>(published);
    map['last_updated_at'] = Variable<int>(lastUpdated);
    return map;
  }

  MediaCompanion toCompanion(bool nullToAbsent) {
    return MediaCompanion(
      code: Value(code),
      eventCode: Value(eventCode),
      ableType: Value(ableType),
      ableCode: Value(ableCode),
      priorityScore: Value(priorityScore),
      published: Value(published),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory MediaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaData(
      code: serializer.fromJson<String>(json['code']),
      eventCode: serializer.fromJson<String>(json['eventCode']),
      ableType: serializer.fromJson<String>(json['ableType']),
      ableCode: serializer.fromJson<String>(json['ableCode']),
      priorityScore: serializer.fromJson<int>(json['priorityScore']),
      published: serializer.fromJson<bool>(json['published']),
      lastUpdated: serializer.fromJson<int>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'eventCode': serializer.toJson<String>(eventCode),
      'ableType': serializer.toJson<String>(ableType),
      'ableCode': serializer.toJson<String>(ableCode),
      'priorityScore': serializer.toJson<int>(priorityScore),
      'published': serializer.toJson<bool>(published),
      'lastUpdated': serializer.toJson<int>(lastUpdated),
    };
  }

  MediaData copyWith(
          {String? code,
          String? eventCode,
          String? ableType,
          String? ableCode,
          int? priorityScore,
          bool? published,
          int? lastUpdated}) =>
      MediaData(
        code: code ?? this.code,
        eventCode: eventCode ?? this.eventCode,
        ableType: ableType ?? this.ableType,
        ableCode: ableCode ?? this.ableCode,
        priorityScore: priorityScore ?? this.priorityScore,
        published: published ?? this.published,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  MediaData copyWithCompanion(MediaCompanion data) {
    return MediaData(
      code: data.code.present ? data.code.value : this.code,
      eventCode: data.eventCode.present ? data.eventCode.value : this.eventCode,
      ableType: data.ableType.present ? data.ableType.value : this.ableType,
      ableCode: data.ableCode.present ? data.ableCode.value : this.ableCode,
      priorityScore: data.priorityScore.present
          ? data.priorityScore.value
          : this.priorityScore,
      published: data.published.present ? data.published.value : this.published,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaData(')
          ..write('code: $code, ')
          ..write('eventCode: $eventCode, ')
          ..write('ableType: $ableType, ')
          ..write('ableCode: $ableCode, ')
          ..write('priorityScore: $priorityScore, ')
          ..write('published: $published, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, eventCode, ableType, ableCode,
      priorityScore, published, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaData &&
          other.code == this.code &&
          other.eventCode == this.eventCode &&
          other.ableType == this.ableType &&
          other.ableCode == this.ableCode &&
          other.priorityScore == this.priorityScore &&
          other.published == this.published &&
          other.lastUpdated == this.lastUpdated);
}

class MediaCompanion extends UpdateCompanion<MediaData> {
  final Value<String> code;
  final Value<String> eventCode;
  final Value<String> ableType;
  final Value<String> ableCode;
  final Value<int> priorityScore;
  final Value<bool> published;
  final Value<int> lastUpdated;
  final Value<int> rowid;
  const MediaCompanion({
    this.code = const Value.absent(),
    this.eventCode = const Value.absent(),
    this.ableType = const Value.absent(),
    this.ableCode = const Value.absent(),
    this.priorityScore = const Value.absent(),
    this.published = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaCompanion.insert({
    required String code,
    required String eventCode,
    required String ableType,
    required String ableCode,
    required int priorityScore,
    required bool published,
    required int lastUpdated,
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        eventCode = Value(eventCode),
        ableType = Value(ableType),
        ableCode = Value(ableCode),
        priorityScore = Value(priorityScore),
        published = Value(published),
        lastUpdated = Value(lastUpdated);
  static Insertable<MediaData> custom({
    Expression<String>? code,
    Expression<String>? eventCode,
    Expression<String>? ableType,
    Expression<String>? ableCode,
    Expression<int>? priorityScore,
    Expression<bool>? published,
    Expression<int>? lastUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (eventCode != null) 'event_code': eventCode,
      if (ableType != null) 'able_type': ableType,
      if (ableCode != null) 'able_code': ableCode,
      if (priorityScore != null) 'priority_score': priorityScore,
      if (published != null) 'published': published,
      if (lastUpdated != null) 'last_updated_at': lastUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaCompanion copyWith(
      {Value<String>? code,
      Value<String>? eventCode,
      Value<String>? ableType,
      Value<String>? ableCode,
      Value<int>? priorityScore,
      Value<bool>? published,
      Value<int>? lastUpdated,
      Value<int>? rowid}) {
    return MediaCompanion(
      code: code ?? this.code,
      eventCode: eventCode ?? this.eventCode,
      ableType: ableType ?? this.ableType,
      ableCode: ableCode ?? this.ableCode,
      priorityScore: priorityScore ?? this.priorityScore,
      published: published ?? this.published,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (ableType.present) {
      map['able_type'] = Variable<String>(ableType.value);
    }
    if (ableCode.present) {
      map['able_code'] = Variable<String>(ableCode.value);
    }
    if (priorityScore.present) {
      map['priority_score'] = Variable<int>(priorityScore.value);
    }
    if (published.present) {
      map['published'] = Variable<bool>(published.value);
    }
    if (lastUpdated.present) {
      map['last_updated_at'] = Variable<int>(lastUpdated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaCompanion(')
          ..write('code: $code, ')
          ..write('eventCode: $eventCode, ')
          ..write('ableType: $ableType, ')
          ..write('ableCode: $ableCode, ')
          ..write('priorityScore: $priorityScore, ')
          ..write('published: $published, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PhotoSelectionCurrentIndexTable extends PhotoSelectionCurrentIndex
    with
        TableInfo<$PhotoSelectionCurrentIndexTable,
            PhotoSelectionCurrentIndexData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotoSelectionCurrentIndexTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _folderCodeMeta =
      const VerificationMeta('folderCode');
  @override
  late final GeneratedColumn<String> folderCode = GeneratedColumn<String>(
      'folder_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _photoSelectionCodeMeta =
      const VerificationMeta('photoSelectionCode');
  @override
  late final GeneratedColumn<String> photoSelectionCode =
      GeneratedColumn<String>('photo_selection_code', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, folderCode, status, photoSelectionCode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'Photo_selection_current_index';
  @override
  VerificationContext validateIntegrity(
      Insertable<PhotoSelectionCurrentIndexData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('folder_code')) {
      context.handle(
          _folderCodeMeta,
          folderCode.isAcceptableOrUnknown(
              data['folder_code']!, _folderCodeMeta));
    } else if (isInserting) {
      context.missing(_folderCodeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('photo_selection_code')) {
      context.handle(
          _photoSelectionCodeMeta,
          photoSelectionCode.isAcceptableOrUnknown(
              data['photo_selection_code']!, _photoSelectionCodeMeta));
    } else if (isInserting) {
      context.missing(_photoSelectionCodeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PhotoSelectionCurrentIndexData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhotoSelectionCurrentIndexData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      folderCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}folder_code'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      photoSelectionCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}photo_selection_code'])!,
    );
  }

  @override
  $PhotoSelectionCurrentIndexTable createAlias(String alias) {
    return $PhotoSelectionCurrentIndexTable(attachedDatabase, alias);
  }
}

class PhotoSelectionCurrentIndexData extends DataClass
    implements Insertable<PhotoSelectionCurrentIndexData> {
  final int id;
  final String folderCode;
  final int status;
  final String photoSelectionCode;
  const PhotoSelectionCurrentIndexData(
      {required this.id,
      required this.folderCode,
      required this.status,
      required this.photoSelectionCode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['folder_code'] = Variable<String>(folderCode);
    map['status'] = Variable<int>(status);
    map['photo_selection_code'] = Variable<String>(photoSelectionCode);
    return map;
  }

  PhotoSelectionCurrentIndexCompanion toCompanion(bool nullToAbsent) {
    return PhotoSelectionCurrentIndexCompanion(
      id: Value(id),
      folderCode: Value(folderCode),
      status: Value(status),
      photoSelectionCode: Value(photoSelectionCode),
    );
  }

  factory PhotoSelectionCurrentIndexData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhotoSelectionCurrentIndexData(
      id: serializer.fromJson<int>(json['id']),
      folderCode: serializer.fromJson<String>(json['folderCode']),
      status: serializer.fromJson<int>(json['status']),
      photoSelectionCode:
          serializer.fromJson<String>(json['photoSelectionCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'folderCode': serializer.toJson<String>(folderCode),
      'status': serializer.toJson<int>(status),
      'photoSelectionCode': serializer.toJson<String>(photoSelectionCode),
    };
  }

  PhotoSelectionCurrentIndexData copyWith(
          {int? id,
          String? folderCode,
          int? status,
          String? photoSelectionCode}) =>
      PhotoSelectionCurrentIndexData(
        id: id ?? this.id,
        folderCode: folderCode ?? this.folderCode,
        status: status ?? this.status,
        photoSelectionCode: photoSelectionCode ?? this.photoSelectionCode,
      );
  PhotoSelectionCurrentIndexData copyWithCompanion(
      PhotoSelectionCurrentIndexCompanion data) {
    return PhotoSelectionCurrentIndexData(
      id: data.id.present ? data.id.value : this.id,
      folderCode:
          data.folderCode.present ? data.folderCode.value : this.folderCode,
      status: data.status.present ? data.status.value : this.status,
      photoSelectionCode: data.photoSelectionCode.present
          ? data.photoSelectionCode.value
          : this.photoSelectionCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhotoSelectionCurrentIndexData(')
          ..write('id: $id, ')
          ..write('folderCode: $folderCode, ')
          ..write('status: $status, ')
          ..write('photoSelectionCode: $photoSelectionCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, folderCode, status, photoSelectionCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhotoSelectionCurrentIndexData &&
          other.id == this.id &&
          other.folderCode == this.folderCode &&
          other.status == this.status &&
          other.photoSelectionCode == this.photoSelectionCode);
}

class PhotoSelectionCurrentIndexCompanion
    extends UpdateCompanion<PhotoSelectionCurrentIndexData> {
  final Value<int> id;
  final Value<String> folderCode;
  final Value<int> status;
  final Value<String> photoSelectionCode;
  const PhotoSelectionCurrentIndexCompanion({
    this.id = const Value.absent(),
    this.folderCode = const Value.absent(),
    this.status = const Value.absent(),
    this.photoSelectionCode = const Value.absent(),
  });
  PhotoSelectionCurrentIndexCompanion.insert({
    this.id = const Value.absent(),
    required String folderCode,
    required int status,
    required String photoSelectionCode,
  })  : folderCode = Value(folderCode),
        status = Value(status),
        photoSelectionCode = Value(photoSelectionCode);
  static Insertable<PhotoSelectionCurrentIndexData> custom({
    Expression<int>? id,
    Expression<String>? folderCode,
    Expression<int>? status,
    Expression<String>? photoSelectionCode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderCode != null) 'folder_code': folderCode,
      if (status != null) 'status': status,
      if (photoSelectionCode != null)
        'photo_selection_code': photoSelectionCode,
    });
  }

  PhotoSelectionCurrentIndexCompanion copyWith(
      {Value<int>? id,
      Value<String>? folderCode,
      Value<int>? status,
      Value<String>? photoSelectionCode}) {
    return PhotoSelectionCurrentIndexCompanion(
      id: id ?? this.id,
      folderCode: folderCode ?? this.folderCode,
      status: status ?? this.status,
      photoSelectionCode: photoSelectionCode ?? this.photoSelectionCode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (folderCode.present) {
      map['folder_code'] = Variable<String>(folderCode.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (photoSelectionCode.present) {
      map['photo_selection_code'] = Variable<String>(photoSelectionCode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotoSelectionCurrentIndexCompanion(')
          ..write('id: $id, ')
          ..write('folderCode: $folderCode, ')
          ..write('status: $status, ')
          ..write('photoSelectionCode: $photoSelectionCode')
          ..write(')'))
        .toString();
  }
}

class $PhotoSelectionsTable extends PhotoSelections
    with TableInfo<$PhotoSelectionsTable, PhotoSelection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotoSelectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _eventCodeMeta =
      const VerificationMeta('eventCode');
  @override
  late final GeneratedColumn<String> eventCode = GeneratedColumn<String>(
      'event_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _publishedMeta =
      const VerificationMeta('published');
  @override
  late final GeneratedColumn<bool> published = GeneratedColumn<bool>(
      'published', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("published" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _confirmationStatusMeta =
      const VerificationMeta('confirmationStatus');
  @override
  late final GeneratedColumn<bool> confirmationStatus = GeneratedColumn<bool>(
      'confirmation_status', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("confirmation_status" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _lastUpdatedAtMeta =
      const VerificationMeta('lastUpdatedAt');
  @override
  late final GeneratedColumn<int> lastUpdatedAt = GeneratedColumn<int>(
      'last_updated_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [code, eventCode, published, confirmationStatus, lastUpdatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photo_selections';
  @override
  VerificationContext validateIntegrity(Insertable<PhotoSelection> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    }
    if (data.containsKey('event_code')) {
      context.handle(_eventCodeMeta,
          eventCode.isAcceptableOrUnknown(data['event_code']!, _eventCodeMeta));
    } else if (isInserting) {
      context.missing(_eventCodeMeta);
    }
    if (data.containsKey('published')) {
      context.handle(_publishedMeta,
          published.isAcceptableOrUnknown(data['published']!, _publishedMeta));
    }
    if (data.containsKey('confirmation_status')) {
      context.handle(
          _confirmationStatusMeta,
          confirmationStatus.isAcceptableOrUnknown(
              data['confirmation_status']!, _confirmationStatusMeta));
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
          _lastUpdatedAtMeta,
          lastUpdatedAt.isAcceptableOrUnknown(
              data['last_updated_at']!, _lastUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventCode};
  @override
  PhotoSelection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhotoSelection(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code']),
      eventCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_code'])!,
      published: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}published'])!,
      confirmationStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}confirmation_status'])!,
      lastUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_updated_at']),
    );
  }

  @override
  $PhotoSelectionsTable createAlias(String alias) {
    return $PhotoSelectionsTable(attachedDatabase, alias);
  }
}

class PhotoSelection extends DataClass implements Insertable<PhotoSelection> {
  final String? code;
  final String eventCode;
  final bool published;
  final bool confirmationStatus;
  final int? lastUpdatedAt;
  const PhotoSelection(
      {this.code,
      required this.eventCode,
      required this.published,
      required this.confirmationStatus,
      this.lastUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    map['event_code'] = Variable<String>(eventCode);
    map['published'] = Variable<bool>(published);
    map['confirmation_status'] = Variable<bool>(confirmationStatus);
    if (!nullToAbsent || lastUpdatedAt != null) {
      map['last_updated_at'] = Variable<int>(lastUpdatedAt);
    }
    return map;
  }

  PhotoSelectionsCompanion toCompanion(bool nullToAbsent) {
    return PhotoSelectionsCompanion(
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      eventCode: Value(eventCode),
      published: Value(published),
      confirmationStatus: Value(confirmationStatus),
      lastUpdatedAt: lastUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdatedAt),
    );
  }

  factory PhotoSelection.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhotoSelection(
      code: serializer.fromJson<String?>(json['code']),
      eventCode: serializer.fromJson<String>(json['eventCode']),
      published: serializer.fromJson<bool>(json['published']),
      confirmationStatus: serializer.fromJson<bool>(json['confirmationStatus']),
      lastUpdatedAt: serializer.fromJson<int?>(json['lastUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String?>(code),
      'eventCode': serializer.toJson<String>(eventCode),
      'published': serializer.toJson<bool>(published),
      'confirmationStatus': serializer.toJson<bool>(confirmationStatus),
      'lastUpdatedAt': serializer.toJson<int?>(lastUpdatedAt),
    };
  }

  PhotoSelection copyWith(
          {Value<String?> code = const Value.absent(),
          String? eventCode,
          bool? published,
          bool? confirmationStatus,
          Value<int?> lastUpdatedAt = const Value.absent()}) =>
      PhotoSelection(
        code: code.present ? code.value : this.code,
        eventCode: eventCode ?? this.eventCode,
        published: published ?? this.published,
        confirmationStatus: confirmationStatus ?? this.confirmationStatus,
        lastUpdatedAt:
            lastUpdatedAt.present ? lastUpdatedAt.value : this.lastUpdatedAt,
      );
  PhotoSelection copyWithCompanion(PhotoSelectionsCompanion data) {
    return PhotoSelection(
      code: data.code.present ? data.code.value : this.code,
      eventCode: data.eventCode.present ? data.eventCode.value : this.eventCode,
      published: data.published.present ? data.published.value : this.published,
      confirmationStatus: data.confirmationStatus.present
          ? data.confirmationStatus.value
          : this.confirmationStatus,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhotoSelection(')
          ..write('code: $code, ')
          ..write('eventCode: $eventCode, ')
          ..write('published: $published, ')
          ..write('confirmationStatus: $confirmationStatus, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      code, eventCode, published, confirmationStatus, lastUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhotoSelection &&
          other.code == this.code &&
          other.eventCode == this.eventCode &&
          other.published == this.published &&
          other.confirmationStatus == this.confirmationStatus &&
          other.lastUpdatedAt == this.lastUpdatedAt);
}

class PhotoSelectionsCompanion extends UpdateCompanion<PhotoSelection> {
  final Value<String?> code;
  final Value<String> eventCode;
  final Value<bool> published;
  final Value<bool> confirmationStatus;
  final Value<int?> lastUpdatedAt;
  final Value<int> rowid;
  const PhotoSelectionsCompanion({
    this.code = const Value.absent(),
    this.eventCode = const Value.absent(),
    this.published = const Value.absent(),
    this.confirmationStatus = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhotoSelectionsCompanion.insert({
    this.code = const Value.absent(),
    required String eventCode,
    this.published = const Value.absent(),
    this.confirmationStatus = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : eventCode = Value(eventCode);
  static Insertable<PhotoSelection> custom({
    Expression<String>? code,
    Expression<String>? eventCode,
    Expression<bool>? published,
    Expression<bool>? confirmationStatus,
    Expression<int>? lastUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (eventCode != null) 'event_code': eventCode,
      if (published != null) 'published': published,
      if (confirmationStatus != null) 'confirmation_status': confirmationStatus,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhotoSelectionsCompanion copyWith(
      {Value<String?>? code,
      Value<String>? eventCode,
      Value<bool>? published,
      Value<bool>? confirmationStatus,
      Value<int?>? lastUpdatedAt,
      Value<int>? rowid}) {
    return PhotoSelectionsCompanion(
      code: code ?? this.code,
      eventCode: eventCode ?? this.eventCode,
      published: published ?? this.published,
      confirmationStatus: confirmationStatus ?? this.confirmationStatus,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (published.present) {
      map['published'] = Variable<bool>(published.value);
    }
    if (confirmationStatus.present) {
      map['confirmation_status'] = Variable<bool>(confirmationStatus.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<int>(lastUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotoSelectionsCompanion(')
          ..write('code: $code, ')
          ..write('eventCode: $eventCode, ')
          ..write('published: $published, ')
          ..write('confirmationStatus: $confirmationStatus, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonsPhotoSelectionsTable extends PersonsPhotoSelections
    with TableInfo<$PersonsPhotoSelectionsTable, PersonsPhotoSelection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonsPhotoSelectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _eventCodeMeta =
      const VerificationMeta('eventCode');
  @override
  late final GeneratedColumn<String> eventCode = GeneratedColumn<String>(
      'event_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _imagesMeta = const VerificationMeta('images');
  @override
  late final GeneratedColumn<String> images = GeneratedColumn<String>(
      'images', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [code, eventCode, image, score, images];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'persons_photo_selections';
  @override
  VerificationContext validateIntegrity(
      Insertable<PersonsPhotoSelection> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('event_code')) {
      context.handle(_eventCodeMeta,
          eventCode.isAcceptableOrUnknown(data['event_code']!, _eventCodeMeta));
    } else if (isInserting) {
      context.missing(_eventCodeMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('images')) {
      context.handle(_imagesMeta,
          images.isAcceptableOrUnknown(data['images']!, _imagesMeta));
    } else if (isInserting) {
      context.missing(_imagesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  PersonsPhotoSelection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonsPhotoSelection(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      eventCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_code'])!,
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score'])!,
      images: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}images'])!,
    );
  }

  @override
  $PersonsPhotoSelectionsTable createAlias(String alias) {
    return $PersonsPhotoSelectionsTable(attachedDatabase, alias);
  }
}

class PersonsPhotoSelection extends DataClass
    implements Insertable<PersonsPhotoSelection> {
  final String code;
  final String eventCode;
  final String image;
  final int score;
  final String images;
  const PersonsPhotoSelection(
      {required this.code,
      required this.eventCode,
      required this.image,
      required this.score,
      required this.images});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['event_code'] = Variable<String>(eventCode);
    map['image'] = Variable<String>(image);
    map['score'] = Variable<int>(score);
    map['images'] = Variable<String>(images);
    return map;
  }

  PersonsPhotoSelectionsCompanion toCompanion(bool nullToAbsent) {
    return PersonsPhotoSelectionsCompanion(
      code: Value(code),
      eventCode: Value(eventCode),
      image: Value(image),
      score: Value(score),
      images: Value(images),
    );
  }

  factory PersonsPhotoSelection.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonsPhotoSelection(
      code: serializer.fromJson<String>(json['code']),
      eventCode: serializer.fromJson<String>(json['eventCode']),
      image: serializer.fromJson<String>(json['image']),
      score: serializer.fromJson<int>(json['score']),
      images: serializer.fromJson<String>(json['images']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'eventCode': serializer.toJson<String>(eventCode),
      'image': serializer.toJson<String>(image),
      'score': serializer.toJson<int>(score),
      'images': serializer.toJson<String>(images),
    };
  }

  PersonsPhotoSelection copyWith(
          {String? code,
          String? eventCode,
          String? image,
          int? score,
          String? images}) =>
      PersonsPhotoSelection(
        code: code ?? this.code,
        eventCode: eventCode ?? this.eventCode,
        image: image ?? this.image,
        score: score ?? this.score,
        images: images ?? this.images,
      );
  PersonsPhotoSelection copyWithCompanion(
      PersonsPhotoSelectionsCompanion data) {
    return PersonsPhotoSelection(
      code: data.code.present ? data.code.value : this.code,
      eventCode: data.eventCode.present ? data.eventCode.value : this.eventCode,
      image: data.image.present ? data.image.value : this.image,
      score: data.score.present ? data.score.value : this.score,
      images: data.images.present ? data.images.value : this.images,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonsPhotoSelection(')
          ..write('code: $code, ')
          ..write('eventCode: $eventCode, ')
          ..write('image: $image, ')
          ..write('score: $score, ')
          ..write('images: $images')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, eventCode, image, score, images);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonsPhotoSelection &&
          other.code == this.code &&
          other.eventCode == this.eventCode &&
          other.image == this.image &&
          other.score == this.score &&
          other.images == this.images);
}

class PersonsPhotoSelectionsCompanion
    extends UpdateCompanion<PersonsPhotoSelection> {
  final Value<String> code;
  final Value<String> eventCode;
  final Value<String> image;
  final Value<int> score;
  final Value<String> images;
  final Value<int> rowid;
  const PersonsPhotoSelectionsCompanion({
    this.code = const Value.absent(),
    this.eventCode = const Value.absent(),
    this.image = const Value.absent(),
    this.score = const Value.absent(),
    this.images = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonsPhotoSelectionsCompanion.insert({
    required String code,
    required String eventCode,
    required String image,
    required int score,
    required String images,
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        eventCode = Value(eventCode),
        image = Value(image),
        score = Value(score),
        images = Value(images);
  static Insertable<PersonsPhotoSelection> custom({
    Expression<String>? code,
    Expression<String>? eventCode,
    Expression<String>? image,
    Expression<int>? score,
    Expression<String>? images,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (eventCode != null) 'event_code': eventCode,
      if (image != null) 'image': image,
      if (score != null) 'score': score,
      if (images != null) 'images': images,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonsPhotoSelectionsCompanion copyWith(
      {Value<String>? code,
      Value<String>? eventCode,
      Value<String>? image,
      Value<int>? score,
      Value<String>? images,
      Value<int>? rowid}) {
    return PersonsPhotoSelectionsCompanion(
      code: code ?? this.code,
      eventCode: eventCode ?? this.eventCode,
      image: image ?? this.image,
      score: score ?? this.score,
      images: images ?? this.images,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (images.present) {
      map['images'] = Variable<String>(images.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonsPhotoSelectionsCompanion(')
          ..write('code: $code, ')
          ..write('eventCode: $eventCode, ')
          ..write('image: $image, ')
          ..write('score: $score, ')
          ..write('images: $images, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonsAlbumsTable extends PersonsAlbums
    with TableInfo<$PersonsAlbumsTable, PersonsAlbum> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonsAlbumsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _eventCodeMeta =
      const VerificationMeta('eventCode');
  @override
  late final GeneratedColumn<String> eventCode = GeneratedColumn<String>(
      'event_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _imagesMeta = const VerificationMeta('images');
  @override
  late final GeneratedColumn<String> images = GeneratedColumn<String>(
      'images', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [code, eventCode, image, score, images];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'persons_albums';
  @override
  VerificationContext validateIntegrity(Insertable<PersonsAlbum> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('event_code')) {
      context.handle(_eventCodeMeta,
          eventCode.isAcceptableOrUnknown(data['event_code']!, _eventCodeMeta));
    } else if (isInserting) {
      context.missing(_eventCodeMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('images')) {
      context.handle(_imagesMeta,
          images.isAcceptableOrUnknown(data['images']!, _imagesMeta));
    } else if (isInserting) {
      context.missing(_imagesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  PersonsAlbum map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonsAlbum(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      eventCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_code'])!,
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score'])!,
      images: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}images'])!,
    );
  }

  @override
  $PersonsAlbumsTable createAlias(String alias) {
    return $PersonsAlbumsTable(attachedDatabase, alias);
  }
}

class PersonsAlbum extends DataClass implements Insertable<PersonsAlbum> {
  final String code;
  final String eventCode;
  final String image;
  final int score;
  final String images;
  const PersonsAlbum(
      {required this.code,
      required this.eventCode,
      required this.image,
      required this.score,
      required this.images});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['event_code'] = Variable<String>(eventCode);
    map['image'] = Variable<String>(image);
    map['score'] = Variable<int>(score);
    map['images'] = Variable<String>(images);
    return map;
  }

  PersonsAlbumsCompanion toCompanion(bool nullToAbsent) {
    return PersonsAlbumsCompanion(
      code: Value(code),
      eventCode: Value(eventCode),
      image: Value(image),
      score: Value(score),
      images: Value(images),
    );
  }

  factory PersonsAlbum.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonsAlbum(
      code: serializer.fromJson<String>(json['code']),
      eventCode: serializer.fromJson<String>(json['eventCode']),
      image: serializer.fromJson<String>(json['image']),
      score: serializer.fromJson<int>(json['score']),
      images: serializer.fromJson<String>(json['images']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'eventCode': serializer.toJson<String>(eventCode),
      'image': serializer.toJson<String>(image),
      'score': serializer.toJson<int>(score),
      'images': serializer.toJson<String>(images),
    };
  }

  PersonsAlbum copyWith(
          {String? code,
          String? eventCode,
          String? image,
          int? score,
          String? images}) =>
      PersonsAlbum(
        code: code ?? this.code,
        eventCode: eventCode ?? this.eventCode,
        image: image ?? this.image,
        score: score ?? this.score,
        images: images ?? this.images,
      );
  PersonsAlbum copyWithCompanion(PersonsAlbumsCompanion data) {
    return PersonsAlbum(
      code: data.code.present ? data.code.value : this.code,
      eventCode: data.eventCode.present ? data.eventCode.value : this.eventCode,
      image: data.image.present ? data.image.value : this.image,
      score: data.score.present ? data.score.value : this.score,
      images: data.images.present ? data.images.value : this.images,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonsAlbum(')
          ..write('code: $code, ')
          ..write('eventCode: $eventCode, ')
          ..write('image: $image, ')
          ..write('score: $score, ')
          ..write('images: $images')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, eventCode, image, score, images);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonsAlbum &&
          other.code == this.code &&
          other.eventCode == this.eventCode &&
          other.image == this.image &&
          other.score == this.score &&
          other.images == this.images);
}

class PersonsAlbumsCompanion extends UpdateCompanion<PersonsAlbum> {
  final Value<String> code;
  final Value<String> eventCode;
  final Value<String> image;
  final Value<int> score;
  final Value<String> images;
  final Value<int> rowid;
  const PersonsAlbumsCompanion({
    this.code = const Value.absent(),
    this.eventCode = const Value.absent(),
    this.image = const Value.absent(),
    this.score = const Value.absent(),
    this.images = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonsAlbumsCompanion.insert({
    required String code,
    required String eventCode,
    required String image,
    required int score,
    required String images,
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        eventCode = Value(eventCode),
        image = Value(image),
        score = Value(score),
        images = Value(images);
  static Insertable<PersonsAlbum> custom({
    Expression<String>? code,
    Expression<String>? eventCode,
    Expression<String>? image,
    Expression<int>? score,
    Expression<String>? images,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (eventCode != null) 'event_code': eventCode,
      if (image != null) 'image': image,
      if (score != null) 'score': score,
      if (images != null) 'images': images,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonsAlbumsCompanion copyWith(
      {Value<String>? code,
      Value<String>? eventCode,
      Value<String>? image,
      Value<int>? score,
      Value<String>? images,
      Value<int>? rowid}) {
    return PersonsAlbumsCompanion(
      code: code ?? this.code,
      eventCode: eventCode ?? this.eventCode,
      image: image ?? this.image,
      score: score ?? this.score,
      images: images ?? this.images,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (images.present) {
      map['images'] = Variable<String>(images.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonsAlbumsCompanion(')
          ..write('code: $code, ')
          ..write('eventCode: $eventCode, ')
          ..write('image: $image, ')
          ..write('score: $score, ')
          ..write('images: $images, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FolderNotificationTable extends FolderNotification
    with TableInfo<$FolderNotificationTable, FolderNotificationData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FolderNotificationTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventCodeMeta =
      const VerificationMeta('eventCode');
  @override
  late final GeneratedColumn<String> eventCode = GeneratedColumn<String>(
      'event_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _folderCodesMeta =
      const VerificationMeta('folderCodes');
  @override
  late final GeneratedColumn<String> folderCodes = GeneratedColumn<String>(
      'folder_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _oldFolderCodesMeta =
      const VerificationMeta('oldFolderCodes');
  @override
  late final GeneratedColumn<String> oldFolderCodes = GeneratedColumn<String>(
      'old_folder_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [eventCode, folderCodes, oldFolderCodes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'folder_notification';
  @override
  VerificationContext validateIntegrity(
      Insertable<FolderNotificationData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_code')) {
      context.handle(_eventCodeMeta,
          eventCode.isAcceptableOrUnknown(data['event_code']!, _eventCodeMeta));
    } else if (isInserting) {
      context.missing(_eventCodeMeta);
    }
    if (data.containsKey('folder_code')) {
      context.handle(
          _folderCodesMeta,
          folderCodes.isAcceptableOrUnknown(
              data['folder_code']!, _folderCodesMeta));
    } else if (isInserting) {
      context.missing(_folderCodesMeta);
    }
    if (data.containsKey('old_folder_code')) {
      context.handle(
          _oldFolderCodesMeta,
          oldFolderCodes.isAcceptableOrUnknown(
              data['old_folder_code']!, _oldFolderCodesMeta));
    } else if (isInserting) {
      context.missing(_oldFolderCodesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventCode};
  @override
  FolderNotificationData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FolderNotificationData(
      eventCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_code'])!,
      folderCodes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}folder_code'])!,
      oldFolderCodes: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}old_folder_code'])!,
    );
  }

  @override
  $FolderNotificationTable createAlias(String alias) {
    return $FolderNotificationTable(attachedDatabase, alias);
  }
}

class FolderNotificationData extends DataClass
    implements Insertable<FolderNotificationData> {
  final String eventCode;
  final String folderCodes;
  final String oldFolderCodes;
  const FolderNotificationData(
      {required this.eventCode,
      required this.folderCodes,
      required this.oldFolderCodes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_code'] = Variable<String>(eventCode);
    map['folder_code'] = Variable<String>(folderCodes);
    map['old_folder_code'] = Variable<String>(oldFolderCodes);
    return map;
  }

  FolderNotificationCompanion toCompanion(bool nullToAbsent) {
    return FolderNotificationCompanion(
      eventCode: Value(eventCode),
      folderCodes: Value(folderCodes),
      oldFolderCodes: Value(oldFolderCodes),
    );
  }

  factory FolderNotificationData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FolderNotificationData(
      eventCode: serializer.fromJson<String>(json['eventCode']),
      folderCodes: serializer.fromJson<String>(json['folderCodes']),
      oldFolderCodes: serializer.fromJson<String>(json['oldFolderCodes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventCode': serializer.toJson<String>(eventCode),
      'folderCodes': serializer.toJson<String>(folderCodes),
      'oldFolderCodes': serializer.toJson<String>(oldFolderCodes),
    };
  }

  FolderNotificationData copyWith(
          {String? eventCode, String? folderCodes, String? oldFolderCodes}) =>
      FolderNotificationData(
        eventCode: eventCode ?? this.eventCode,
        folderCodes: folderCodes ?? this.folderCodes,
        oldFolderCodes: oldFolderCodes ?? this.oldFolderCodes,
      );
  FolderNotificationData copyWithCompanion(FolderNotificationCompanion data) {
    return FolderNotificationData(
      eventCode: data.eventCode.present ? data.eventCode.value : this.eventCode,
      folderCodes:
          data.folderCodes.present ? data.folderCodes.value : this.folderCodes,
      oldFolderCodes: data.oldFolderCodes.present
          ? data.oldFolderCodes.value
          : this.oldFolderCodes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FolderNotificationData(')
          ..write('eventCode: $eventCode, ')
          ..write('folderCodes: $folderCodes, ')
          ..write('oldFolderCodes: $oldFolderCodes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(eventCode, folderCodes, oldFolderCodes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FolderNotificationData &&
          other.eventCode == this.eventCode &&
          other.folderCodes == this.folderCodes &&
          other.oldFolderCodes == this.oldFolderCodes);
}

class FolderNotificationCompanion
    extends UpdateCompanion<FolderNotificationData> {
  final Value<String> eventCode;
  final Value<String> folderCodes;
  final Value<String> oldFolderCodes;
  final Value<int> rowid;
  const FolderNotificationCompanion({
    this.eventCode = const Value.absent(),
    this.folderCodes = const Value.absent(),
    this.oldFolderCodes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FolderNotificationCompanion.insert({
    required String eventCode,
    required String folderCodes,
    required String oldFolderCodes,
    this.rowid = const Value.absent(),
  })  : eventCode = Value(eventCode),
        folderCodes = Value(folderCodes),
        oldFolderCodes = Value(oldFolderCodes);
  static Insertable<FolderNotificationData> custom({
    Expression<String>? eventCode,
    Expression<String>? folderCodes,
    Expression<String>? oldFolderCodes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventCode != null) 'event_code': eventCode,
      if (folderCodes != null) 'folder_code': folderCodes,
      if (oldFolderCodes != null) 'old_folder_code': oldFolderCodes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FolderNotificationCompanion copyWith(
      {Value<String>? eventCode,
      Value<String>? folderCodes,
      Value<String>? oldFolderCodes,
      Value<int>? rowid}) {
    return FolderNotificationCompanion(
      eventCode: eventCode ?? this.eventCode,
      folderCodes: folderCodes ?? this.folderCodes,
      oldFolderCodes: oldFolderCodes ?? this.oldFolderCodes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (folderCodes.present) {
      map['folder_code'] = Variable<String>(folderCodes.value);
    }
    if (oldFolderCodes.present) {
      map['old_folder_code'] = Variable<String>(oldFolderCodes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FolderNotificationCompanion(')
          ..write('eventCode: $eventCode, ')
          ..write('folderCodes: $folderCodes, ')
          ..write('oldFolderCodes: $oldFolderCodes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WithOutPersonsAlbumsTable extends WithOutPersonsAlbums
    with TableInfo<$WithOutPersonsAlbumsTable, WithOutPersonsAlbum> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WithOutPersonsAlbumsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventCodeMeta =
      const VerificationMeta('eventCode');
  @override
  late final GeneratedColumn<String> eventCode = GeneratedColumn<String>(
      'event_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _imagesMeta = const VerificationMeta('images');
  @override
  late final GeneratedColumn<String> images = GeneratedColumn<String>(
      'images', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [eventCode, images];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'without_persons_albums';
  @override
  VerificationContext validateIntegrity(
      Insertable<WithOutPersonsAlbum> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_code')) {
      context.handle(_eventCodeMeta,
          eventCode.isAcceptableOrUnknown(data['event_code']!, _eventCodeMeta));
    } else if (isInserting) {
      context.missing(_eventCodeMeta);
    }
    if (data.containsKey('images')) {
      context.handle(_imagesMeta,
          images.isAcceptableOrUnknown(data['images']!, _imagesMeta));
    } else if (isInserting) {
      context.missing(_imagesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventCode};
  @override
  WithOutPersonsAlbum map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WithOutPersonsAlbum(
      eventCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_code'])!,
      images: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}images'])!,
    );
  }

  @override
  $WithOutPersonsAlbumsTable createAlias(String alias) {
    return $WithOutPersonsAlbumsTable(attachedDatabase, alias);
  }
}

class WithOutPersonsAlbum extends DataClass
    implements Insertable<WithOutPersonsAlbum> {
  final String eventCode;
  final String images;
  const WithOutPersonsAlbum({required this.eventCode, required this.images});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_code'] = Variable<String>(eventCode);
    map['images'] = Variable<String>(images);
    return map;
  }

  WithOutPersonsAlbumsCompanion toCompanion(bool nullToAbsent) {
    return WithOutPersonsAlbumsCompanion(
      eventCode: Value(eventCode),
      images: Value(images),
    );
  }

  factory WithOutPersonsAlbum.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WithOutPersonsAlbum(
      eventCode: serializer.fromJson<String>(json['eventCode']),
      images: serializer.fromJson<String>(json['images']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventCode': serializer.toJson<String>(eventCode),
      'images': serializer.toJson<String>(images),
    };
  }

  WithOutPersonsAlbum copyWith({String? eventCode, String? images}) =>
      WithOutPersonsAlbum(
        eventCode: eventCode ?? this.eventCode,
        images: images ?? this.images,
      );
  WithOutPersonsAlbum copyWithCompanion(WithOutPersonsAlbumsCompanion data) {
    return WithOutPersonsAlbum(
      eventCode: data.eventCode.present ? data.eventCode.value : this.eventCode,
      images: data.images.present ? data.images.value : this.images,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WithOutPersonsAlbum(')
          ..write('eventCode: $eventCode, ')
          ..write('images: $images')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(eventCode, images);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WithOutPersonsAlbum &&
          other.eventCode == this.eventCode &&
          other.images == this.images);
}

class WithOutPersonsAlbumsCompanion
    extends UpdateCompanion<WithOutPersonsAlbum> {
  final Value<String> eventCode;
  final Value<String> images;
  final Value<int> rowid;
  const WithOutPersonsAlbumsCompanion({
    this.eventCode = const Value.absent(),
    this.images = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WithOutPersonsAlbumsCompanion.insert({
    required String eventCode,
    required String images,
    this.rowid = const Value.absent(),
  })  : eventCode = Value(eventCode),
        images = Value(images);
  static Insertable<WithOutPersonsAlbum> custom({
    Expression<String>? eventCode,
    Expression<String>? images,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventCode != null) 'event_code': eventCode,
      if (images != null) 'images': images,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WithOutPersonsAlbumsCompanion copyWith(
      {Value<String>? eventCode, Value<String>? images, Value<int>? rowid}) {
    return WithOutPersonsAlbumsCompanion(
      eventCode: eventCode ?? this.eventCode,
      images: images ?? this.images,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (images.present) {
      map['images'] = Variable<String>(images.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WithOutPersonsAlbumsCompanion(')
          ..write('eventCode: $eventCode, ')
          ..write('images: $images, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WithOutPersonsPhotoSelectionTable extends WithOutPersonsPhotoSelection
    with
        TableInfo<$WithOutPersonsPhotoSelectionTable,
            WithOutPersonsPhotoSelectionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WithOutPersonsPhotoSelectionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventCodeMeta =
      const VerificationMeta('eventCode');
  @override
  late final GeneratedColumn<String> eventCode = GeneratedColumn<String>(
      'event_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _imagesMeta = const VerificationMeta('images');
  @override
  late final GeneratedColumn<String> images = GeneratedColumn<String>(
      'images', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [eventCode, images];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'without_persons_photo_`selection';
  @override
  VerificationContext validateIntegrity(
      Insertable<WithOutPersonsPhotoSelectionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_code')) {
      context.handle(_eventCodeMeta,
          eventCode.isAcceptableOrUnknown(data['event_code']!, _eventCodeMeta));
    } else if (isInserting) {
      context.missing(_eventCodeMeta);
    }
    if (data.containsKey('images')) {
      context.handle(_imagesMeta,
          images.isAcceptableOrUnknown(data['images']!, _imagesMeta));
    } else if (isInserting) {
      context.missing(_imagesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventCode};
  @override
  WithOutPersonsPhotoSelectionData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WithOutPersonsPhotoSelectionData(
      eventCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_code'])!,
      images: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}images'])!,
    );
  }

  @override
  $WithOutPersonsPhotoSelectionTable createAlias(String alias) {
    return $WithOutPersonsPhotoSelectionTable(attachedDatabase, alias);
  }
}

class WithOutPersonsPhotoSelectionData extends DataClass
    implements Insertable<WithOutPersonsPhotoSelectionData> {
  final String eventCode;
  final String images;
  const WithOutPersonsPhotoSelectionData(
      {required this.eventCode, required this.images});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_code'] = Variable<String>(eventCode);
    map['images'] = Variable<String>(images);
    return map;
  }

  WithOutPersonsPhotoSelectionCompanion toCompanion(bool nullToAbsent) {
    return WithOutPersonsPhotoSelectionCompanion(
      eventCode: Value(eventCode),
      images: Value(images),
    );
  }

  factory WithOutPersonsPhotoSelectionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WithOutPersonsPhotoSelectionData(
      eventCode: serializer.fromJson<String>(json['eventCode']),
      images: serializer.fromJson<String>(json['images']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventCode': serializer.toJson<String>(eventCode),
      'images': serializer.toJson<String>(images),
    };
  }

  WithOutPersonsPhotoSelectionData copyWith(
          {String? eventCode, String? images}) =>
      WithOutPersonsPhotoSelectionData(
        eventCode: eventCode ?? this.eventCode,
        images: images ?? this.images,
      );
  WithOutPersonsPhotoSelectionData copyWithCompanion(
      WithOutPersonsPhotoSelectionCompanion data) {
    return WithOutPersonsPhotoSelectionData(
      eventCode: data.eventCode.present ? data.eventCode.value : this.eventCode,
      images: data.images.present ? data.images.value : this.images,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WithOutPersonsPhotoSelectionData(')
          ..write('eventCode: $eventCode, ')
          ..write('images: $images')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(eventCode, images);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WithOutPersonsPhotoSelectionData &&
          other.eventCode == this.eventCode &&
          other.images == this.images);
}

class WithOutPersonsPhotoSelectionCompanion
    extends UpdateCompanion<WithOutPersonsPhotoSelectionData> {
  final Value<String> eventCode;
  final Value<String> images;
  final Value<int> rowid;
  const WithOutPersonsPhotoSelectionCompanion({
    this.eventCode = const Value.absent(),
    this.images = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WithOutPersonsPhotoSelectionCompanion.insert({
    required String eventCode,
    required String images,
    this.rowid = const Value.absent(),
  })  : eventCode = Value(eventCode),
        images = Value(images);
  static Insertable<WithOutPersonsPhotoSelectionData> custom({
    Expression<String>? eventCode,
    Expression<String>? images,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventCode != null) 'event_code': eventCode,
      if (images != null) 'images': images,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WithOutPersonsPhotoSelectionCompanion copyWith(
      {Value<String>? eventCode, Value<String>? images, Value<int>? rowid}) {
    return WithOutPersonsPhotoSelectionCompanion(
      eventCode: eventCode ?? this.eventCode,
      images: images ?? this.images,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (images.present) {
      map['images'] = Variable<String>(images.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WithOutPersonsPhotoSelectionCompanion(')
          ..write('eventCode: $eventCode, ')
          ..write('images: $images, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PhotomallStudioInfoTable extends PhotomallStudioInfo
    with TableInfo<$PhotomallStudioInfoTable, PhotomallStudioInfoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotomallStudioInfoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NULL REFERENCES events(code)');
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedAtMeta =
      const VerificationMeta('lastUpdatedAt');
  @override
  late final GeneratedColumn<int> lastUpdatedAt = GeneratedColumn<int>(
      'last_updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [code, value, lastUpdatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'Photomall_studio_Info';
  @override
  VerificationContext validateIntegrity(
      Insertable<PhotomallStudioInfoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
          _lastUpdatedAtMeta,
          lastUpdatedAt.isAcceptableOrUnknown(
              data['last_updated_at']!, _lastUpdatedAtMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  PhotomallStudioInfoData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhotomallStudioInfoData(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      lastUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_updated_at'])!,
    );
  }

  @override
  $PhotomallStudioInfoTable createAlias(String alias) {
    return $PhotomallStudioInfoTable(attachedDatabase, alias);
  }
}

class PhotomallStudioInfoData extends DataClass
    implements Insertable<PhotomallStudioInfoData> {
  final String code;
  final String value;
  final int lastUpdatedAt;
  const PhotomallStudioInfoData(
      {required this.code, required this.value, required this.lastUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['value'] = Variable<String>(value);
    map['last_updated_at'] = Variable<int>(lastUpdatedAt);
    return map;
  }

  PhotomallStudioInfoCompanion toCompanion(bool nullToAbsent) {
    return PhotomallStudioInfoCompanion(
      code: Value(code),
      value: Value(value),
      lastUpdatedAt: Value(lastUpdatedAt),
    );
  }

  factory PhotomallStudioInfoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhotomallStudioInfoData(
      code: serializer.fromJson<String>(json['code']),
      value: serializer.fromJson<String>(json['value']),
      lastUpdatedAt: serializer.fromJson<int>(json['lastUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'value': serializer.toJson<String>(value),
      'lastUpdatedAt': serializer.toJson<int>(lastUpdatedAt),
    };
  }

  PhotomallStudioInfoData copyWith(
          {String? code, String? value, int? lastUpdatedAt}) =>
      PhotomallStudioInfoData(
        code: code ?? this.code,
        value: value ?? this.value,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      );
  PhotomallStudioInfoData copyWithCompanion(PhotomallStudioInfoCompanion data) {
    return PhotomallStudioInfoData(
      code: data.code.present ? data.code.value : this.code,
      value: data.value.present ? data.value.value : this.value,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhotomallStudioInfoData(')
          ..write('code: $code, ')
          ..write('value: $value, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, value, lastUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhotomallStudioInfoData &&
          other.code == this.code &&
          other.value == this.value &&
          other.lastUpdatedAt == this.lastUpdatedAt);
}

class PhotomallStudioInfoCompanion
    extends UpdateCompanion<PhotomallStudioInfoData> {
  final Value<String> code;
  final Value<String> value;
  final Value<int> lastUpdatedAt;
  final Value<int> rowid;
  const PhotomallStudioInfoCompanion({
    this.code = const Value.absent(),
    this.value = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhotomallStudioInfoCompanion.insert({
    required String code,
    required String value,
    required int lastUpdatedAt,
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        value = Value(value),
        lastUpdatedAt = Value(lastUpdatedAt);
  static Insertable<PhotomallStudioInfoData> custom({
    Expression<String>? code,
    Expression<String>? value,
    Expression<int>? lastUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (value != null) 'value': value,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhotomallStudioInfoCompanion copyWith(
      {Value<String>? code,
      Value<String>? value,
      Value<int>? lastUpdatedAt,
      Value<int>? rowid}) {
    return PhotomallStudioInfoCompanion(
      code: code ?? this.code,
      value: value ?? this.value,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<int>(lastUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotomallStudioInfoCompanion(')
          ..write('code: $code, ')
          ..write('value: $value, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CommonTableTable extends CommonTable
    with TableInfo<$CommonTableTable, CommonTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommonTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'common_table';
  @override
  VerificationContext validateIntegrity(Insertable<CommonTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  CommonTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommonTableData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $CommonTableTable createAlias(String alias) {
    return $CommonTableTable(attachedDatabase, alias);
  }
}

class CommonTableData extends DataClass implements Insertable<CommonTableData> {
  final String key;
  final String value;
  const CommonTableData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  CommonTableCompanion toCompanion(bool nullToAbsent) {
    return CommonTableCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory CommonTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommonTableData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  CommonTableData copyWith({String? key, String? value}) => CommonTableData(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  CommonTableData copyWithCompanion(CommonTableCompanion data) {
    return CommonTableData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CommonTableData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommonTableData &&
          other.key == this.key &&
          other.value == this.value);
}

class CommonTableCompanion extends UpdateCompanion<CommonTableData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const CommonTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CommonTableCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<CommonTableData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CommonTableCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return CommonTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommonTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RealPersonsAlbumsTable extends RealPersonsAlbums
    with TableInfo<$RealPersonsAlbumsTable, RealPersonsAlbum> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RealPersonsAlbumsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _eventCodeMeta =
      const VerificationMeta('eventCode');
  @override
  late final GeneratedColumn<String> eventCode = GeneratedColumn<String>(
      'event_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _personsMeta =
      const VerificationMeta('persons');
  @override
  late final GeneratedColumn<String> persons = GeneratedColumn<String>(
      'persons', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [code, eventCode, image, score, persons];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'real_persons_albums';
  @override
  VerificationContext validateIntegrity(Insertable<RealPersonsAlbum> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('event_code')) {
      context.handle(_eventCodeMeta,
          eventCode.isAcceptableOrUnknown(data['event_code']!, _eventCodeMeta));
    } else if (isInserting) {
      context.missing(_eventCodeMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('persons')) {
      context.handle(_personsMeta,
          persons.isAcceptableOrUnknown(data['persons']!, _personsMeta));
    } else if (isInserting) {
      context.missing(_personsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  RealPersonsAlbum map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RealPersonsAlbum(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      eventCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_code'])!,
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score'])!,
      persons: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}persons'])!,
    );
  }

  @override
  $RealPersonsAlbumsTable createAlias(String alias) {
    return $RealPersonsAlbumsTable(attachedDatabase, alias);
  }
}

class RealPersonsAlbum extends DataClass
    implements Insertable<RealPersonsAlbum> {
  final String code;
  final String eventCode;
  final String image;
  final int score;
  final String persons;
  const RealPersonsAlbum(
      {required this.code,
      required this.eventCode,
      required this.image,
      required this.score,
      required this.persons});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['event_code'] = Variable<String>(eventCode);
    map['image'] = Variable<String>(image);
    map['score'] = Variable<int>(score);
    map['persons'] = Variable<String>(persons);
    return map;
  }

  RealPersonsAlbumsCompanion toCompanion(bool nullToAbsent) {
    return RealPersonsAlbumsCompanion(
      code: Value(code),
      eventCode: Value(eventCode),
      image: Value(image),
      score: Value(score),
      persons: Value(persons),
    );
  }

  factory RealPersonsAlbum.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RealPersonsAlbum(
      code: serializer.fromJson<String>(json['code']),
      eventCode: serializer.fromJson<String>(json['eventCode']),
      image: serializer.fromJson<String>(json['image']),
      score: serializer.fromJson<int>(json['score']),
      persons: serializer.fromJson<String>(json['persons']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'eventCode': serializer.toJson<String>(eventCode),
      'image': serializer.toJson<String>(image),
      'score': serializer.toJson<int>(score),
      'persons': serializer.toJson<String>(persons),
    };
  }

  RealPersonsAlbum copyWith(
          {String? code,
          String? eventCode,
          String? image,
          int? score,
          String? persons}) =>
      RealPersonsAlbum(
        code: code ?? this.code,
        eventCode: eventCode ?? this.eventCode,
        image: image ?? this.image,
        score: score ?? this.score,
        persons: persons ?? this.persons,
      );
  RealPersonsAlbum copyWithCompanion(RealPersonsAlbumsCompanion data) {
    return RealPersonsAlbum(
      code: data.code.present ? data.code.value : this.code,
      eventCode: data.eventCode.present ? data.eventCode.value : this.eventCode,
      image: data.image.present ? data.image.value : this.image,
      score: data.score.present ? data.score.value : this.score,
      persons: data.persons.present ? data.persons.value : this.persons,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RealPersonsAlbum(')
          ..write('code: $code, ')
          ..write('eventCode: $eventCode, ')
          ..write('image: $image, ')
          ..write('score: $score, ')
          ..write('persons: $persons')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, eventCode, image, score, persons);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RealPersonsAlbum &&
          other.code == this.code &&
          other.eventCode == this.eventCode &&
          other.image == this.image &&
          other.score == this.score &&
          other.persons == this.persons);
}

class RealPersonsAlbumsCompanion extends UpdateCompanion<RealPersonsAlbum> {
  final Value<String> code;
  final Value<String> eventCode;
  final Value<String> image;
  final Value<int> score;
  final Value<String> persons;
  final Value<int> rowid;
  const RealPersonsAlbumsCompanion({
    this.code = const Value.absent(),
    this.eventCode = const Value.absent(),
    this.image = const Value.absent(),
    this.score = const Value.absent(),
    this.persons = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RealPersonsAlbumsCompanion.insert({
    required String code,
    required String eventCode,
    required String image,
    required int score,
    required String persons,
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        eventCode = Value(eventCode),
        image = Value(image),
        score = Value(score),
        persons = Value(persons);
  static Insertable<RealPersonsAlbum> custom({
    Expression<String>? code,
    Expression<String>? eventCode,
    Expression<String>? image,
    Expression<int>? score,
    Expression<String>? persons,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (eventCode != null) 'event_code': eventCode,
      if (image != null) 'image': image,
      if (score != null) 'score': score,
      if (persons != null) 'persons': persons,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RealPersonsAlbumsCompanion copyWith(
      {Value<String>? code,
      Value<String>? eventCode,
      Value<String>? image,
      Value<int>? score,
      Value<String>? persons,
      Value<int>? rowid}) {
    return RealPersonsAlbumsCompanion(
      code: code ?? this.code,
      eventCode: eventCode ?? this.eventCode,
      image: image ?? this.image,
      score: score ?? this.score,
      persons: persons ?? this.persons,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (persons.present) {
      map['persons'] = Variable<String>(persons.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RealPersonsAlbumsCompanion(')
          ..write('code: $code, ')
          ..write('eventCode: $eventCode, ')
          ..write('image: $image, ')
          ..write('score: $score, ')
          ..write('persons: $persons, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DownloadTable extends Download
    with TableInfo<$DownloadTable, DownloadData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ableCodeMeta =
      const VerificationMeta('ableCode');
  @override
  late final GeneratedColumn<String> ableCode = GeneratedColumn<String>(
      'able_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ableTypeMeta =
      const VerificationMeta('ableType');
  @override
  late final GeneratedColumn<String> ableType = GeneratedColumn<String>(
      'able_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _downloadedStatusMeta =
      const VerificationMeta('downloadedStatus');
  @override
  late final GeneratedColumn<bool> downloadedStatus = GeneratedColumn<bool>(
      'downloaded_status', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("downloaded_status" IN (0, 1))'),
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns => [ableCode, ableType, downloadedStatus];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'download_status';
  @override
  VerificationContext validateIntegrity(Insertable<DownloadData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('able_code')) {
      context.handle(_ableCodeMeta,
          ableCode.isAcceptableOrUnknown(data['able_code']!, _ableCodeMeta));
    } else if (isInserting) {
      context.missing(_ableCodeMeta);
    }
    if (data.containsKey('able_type')) {
      context.handle(_ableTypeMeta,
          ableType.isAcceptableOrUnknown(data['able_type']!, _ableTypeMeta));
    } else if (isInserting) {
      context.missing(_ableTypeMeta);
    }
    if (data.containsKey('downloaded_status')) {
      context.handle(
          _downloadedStatusMeta,
          downloadedStatus.isAcceptableOrUnknown(
              data['downloaded_status']!, _downloadedStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ableCode};
  @override
  DownloadData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadData(
      ableCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}able_code'])!,
      ableType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}able_type'])!,
      downloadedStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}downloaded_status'])!,
    );
  }

  @override
  $DownloadTable createAlias(String alias) {
    return $DownloadTable(attachedDatabase, alias);
  }
}

class DownloadData extends DataClass implements Insertable<DownloadData> {
  final String ableCode;
  final String ableType;
  final bool downloadedStatus;
  const DownloadData(
      {required this.ableCode,
      required this.ableType,
      required this.downloadedStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['able_code'] = Variable<String>(ableCode);
    map['able_type'] = Variable<String>(ableType);
    map['downloaded_status'] = Variable<bool>(downloadedStatus);
    return map;
  }

  DownloadCompanion toCompanion(bool nullToAbsent) {
    return DownloadCompanion(
      ableCode: Value(ableCode),
      ableType: Value(ableType),
      downloadedStatus: Value(downloadedStatus),
    );
  }

  factory DownloadData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadData(
      ableCode: serializer.fromJson<String>(json['ableCode']),
      ableType: serializer.fromJson<String>(json['ableType']),
      downloadedStatus: serializer.fromJson<bool>(json['downloadedStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ableCode': serializer.toJson<String>(ableCode),
      'ableType': serializer.toJson<String>(ableType),
      'downloadedStatus': serializer.toJson<bool>(downloadedStatus),
    };
  }

  DownloadData copyWith(
          {String? ableCode, String? ableType, bool? downloadedStatus}) =>
      DownloadData(
        ableCode: ableCode ?? this.ableCode,
        ableType: ableType ?? this.ableType,
        downloadedStatus: downloadedStatus ?? this.downloadedStatus,
      );
  DownloadData copyWithCompanion(DownloadCompanion data) {
    return DownloadData(
      ableCode: data.ableCode.present ? data.ableCode.value : this.ableCode,
      ableType: data.ableType.present ? data.ableType.value : this.ableType,
      downloadedStatus: data.downloadedStatus.present
          ? data.downloadedStatus.value
          : this.downloadedStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadData(')
          ..write('ableCode: $ableCode, ')
          ..write('ableType: $ableType, ')
          ..write('downloadedStatus: $downloadedStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ableCode, ableType, downloadedStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadData &&
          other.ableCode == this.ableCode &&
          other.ableType == this.ableType &&
          other.downloadedStatus == this.downloadedStatus);
}

class DownloadCompanion extends UpdateCompanion<DownloadData> {
  final Value<String> ableCode;
  final Value<String> ableType;
  final Value<bool> downloadedStatus;
  final Value<int> rowid;
  const DownloadCompanion({
    this.ableCode = const Value.absent(),
    this.ableType = const Value.absent(),
    this.downloadedStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DownloadCompanion.insert({
    required String ableCode,
    required String ableType,
    this.downloadedStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : ableCode = Value(ableCode),
        ableType = Value(ableType);
  static Insertable<DownloadData> custom({
    Expression<String>? ableCode,
    Expression<String>? ableType,
    Expression<bool>? downloadedStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ableCode != null) 'able_code': ableCode,
      if (ableType != null) 'able_type': ableType,
      if (downloadedStatus != null) 'downloaded_status': downloadedStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DownloadCompanion copyWith(
      {Value<String>? ableCode,
      Value<String>? ableType,
      Value<bool>? downloadedStatus,
      Value<int>? rowid}) {
    return DownloadCompanion(
      ableCode: ableCode ?? this.ableCode,
      ableType: ableType ?? this.ableType,
      downloadedStatus: downloadedStatus ?? this.downloadedStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ableCode.present) {
      map['able_code'] = Variable<String>(ableCode.value);
    }
    if (ableType.present) {
      map['able_type'] = Variable<String>(ableType.value);
    }
    if (downloadedStatus.present) {
      map['downloaded_status'] = Variable<bool>(downloadedStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadCompanion(')
          ..write('ableCode: $ableCode, ')
          ..write('ableType: $ableType, ')
          ..write('downloadedStatus: $downloadedStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PhotoSelectionImageFolderTable extends PhotoSelectionImageFolder
    with
        TableInfo<$PhotoSelectionImageFolderTable,
            PhotoSelectionImageFolderData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotoSelectionImageFolderTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventCodeMeta =
      const VerificationMeta('eventCode');
  @override
  late final GeneratedColumn<String> eventCode = GeneratedColumn<String>(
      'event_code', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _lastUpdatedAtMeta =
      const VerificationMeta('lastUpdatedAt');
  @override
  late final GeneratedColumn<int> lastUpdatedAt = GeneratedColumn<int>(
      'last_updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [eventCode, lastUpdatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photo_selection_image_folder_status';
  @override
  VerificationContext validateIntegrity(
      Insertable<PhotoSelectionImageFolderData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_code')) {
      context.handle(_eventCodeMeta,
          eventCode.isAcceptableOrUnknown(data['event_code']!, _eventCodeMeta));
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
          _lastUpdatedAtMeta,
          lastUpdatedAt.isAcceptableOrUnknown(
              data['last_updated_at']!, _lastUpdatedAtMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventCode};
  @override
  PhotoSelectionImageFolderData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhotoSelectionImageFolderData(
      eventCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_code']),
      lastUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_updated_at'])!,
    );
  }

  @override
  $PhotoSelectionImageFolderTable createAlias(String alias) {
    return $PhotoSelectionImageFolderTable(attachedDatabase, alias);
  }
}

class PhotoSelectionImageFolderData extends DataClass
    implements Insertable<PhotoSelectionImageFolderData> {
  final String? eventCode;
  final int lastUpdatedAt;
  const PhotoSelectionImageFolderData(
      {this.eventCode, required this.lastUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || eventCode != null) {
      map['event_code'] = Variable<String>(eventCode);
    }
    map['last_updated_at'] = Variable<int>(lastUpdatedAt);
    return map;
  }

  PhotoSelectionImageFolderCompanion toCompanion(bool nullToAbsent) {
    return PhotoSelectionImageFolderCompanion(
      eventCode: eventCode == null && nullToAbsent
          ? const Value.absent()
          : Value(eventCode),
      lastUpdatedAt: Value(lastUpdatedAt),
    );
  }

  factory PhotoSelectionImageFolderData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhotoSelectionImageFolderData(
      eventCode: serializer.fromJson<String?>(json['eventCode']),
      lastUpdatedAt: serializer.fromJson<int>(json['lastUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventCode': serializer.toJson<String?>(eventCode),
      'lastUpdatedAt': serializer.toJson<int>(lastUpdatedAt),
    };
  }

  PhotoSelectionImageFolderData copyWith(
          {Value<String?> eventCode = const Value.absent(),
          int? lastUpdatedAt}) =>
      PhotoSelectionImageFolderData(
        eventCode: eventCode.present ? eventCode.value : this.eventCode,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      );
  PhotoSelectionImageFolderData copyWithCompanion(
      PhotoSelectionImageFolderCompanion data) {
    return PhotoSelectionImageFolderData(
      eventCode: data.eventCode.present ? data.eventCode.value : this.eventCode,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhotoSelectionImageFolderData(')
          ..write('eventCode: $eventCode, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(eventCode, lastUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhotoSelectionImageFolderData &&
          other.eventCode == this.eventCode &&
          other.lastUpdatedAt == this.lastUpdatedAt);
}

class PhotoSelectionImageFolderCompanion
    extends UpdateCompanion<PhotoSelectionImageFolderData> {
  final Value<String?> eventCode;
  final Value<int> lastUpdatedAt;
  final Value<int> rowid;
  const PhotoSelectionImageFolderCompanion({
    this.eventCode = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PhotoSelectionImageFolderCompanion.insert({
    this.eventCode = const Value.absent(),
    required int lastUpdatedAt,
    this.rowid = const Value.absent(),
  }) : lastUpdatedAt = Value(lastUpdatedAt);
  static Insertable<PhotoSelectionImageFolderData> custom({
    Expression<String>? eventCode,
    Expression<int>? lastUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventCode != null) 'event_code': eventCode,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PhotoSelectionImageFolderCompanion copyWith(
      {Value<String?>? eventCode,
      Value<int>? lastUpdatedAt,
      Value<int>? rowid}) {
    return PhotoSelectionImageFolderCompanion(
      eventCode: eventCode ?? this.eventCode,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<int>(lastUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotoSelectionImageFolderCompanion(')
          ..write('eventCode: $eventCode, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RealPersonsPhotoSelectionsTable extends RealPersonsPhotoSelections
    with
        TableInfo<$RealPersonsPhotoSelectionsTable, RealPersonsPhotoSelection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RealPersonsPhotoSelectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _eventCodeMeta =
      const VerificationMeta('eventCode');
  @override
  late final GeneratedColumn<String> eventCode = GeneratedColumn<String>(
      'event_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _personsMeta =
      const VerificationMeta('persons');
  @override
  late final GeneratedColumn<String> persons = GeneratedColumn<String>(
      'persons', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [code, eventCode, image, score, persons];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'real_persons_photo_selections';
  @override
  VerificationContext validateIntegrity(
      Insertable<RealPersonsPhotoSelection> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('event_code')) {
      context.handle(_eventCodeMeta,
          eventCode.isAcceptableOrUnknown(data['event_code']!, _eventCodeMeta));
    } else if (isInserting) {
      context.missing(_eventCodeMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('persons')) {
      context.handle(_personsMeta,
          persons.isAcceptableOrUnknown(data['persons']!, _personsMeta));
    } else if (isInserting) {
      context.missing(_personsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  RealPersonsPhotoSelection map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RealPersonsPhotoSelection(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      eventCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_code'])!,
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score'])!,
      persons: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}persons'])!,
    );
  }

  @override
  $RealPersonsPhotoSelectionsTable createAlias(String alias) {
    return $RealPersonsPhotoSelectionsTable(attachedDatabase, alias);
  }
}

class RealPersonsPhotoSelection extends DataClass
    implements Insertable<RealPersonsPhotoSelection> {
  final String code;
  final String eventCode;
  final String image;
  final int score;
  final String persons;
  const RealPersonsPhotoSelection(
      {required this.code,
      required this.eventCode,
      required this.image,
      required this.score,
      required this.persons});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['event_code'] = Variable<String>(eventCode);
    map['image'] = Variable<String>(image);
    map['score'] = Variable<int>(score);
    map['persons'] = Variable<String>(persons);
    return map;
  }

  RealPersonsPhotoSelectionsCompanion toCompanion(bool nullToAbsent) {
    return RealPersonsPhotoSelectionsCompanion(
      code: Value(code),
      eventCode: Value(eventCode),
      image: Value(image),
      score: Value(score),
      persons: Value(persons),
    );
  }

  factory RealPersonsPhotoSelection.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RealPersonsPhotoSelection(
      code: serializer.fromJson<String>(json['code']),
      eventCode: serializer.fromJson<String>(json['eventCode']),
      image: serializer.fromJson<String>(json['image']),
      score: serializer.fromJson<int>(json['score']),
      persons: serializer.fromJson<String>(json['persons']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'eventCode': serializer.toJson<String>(eventCode),
      'image': serializer.toJson<String>(image),
      'score': serializer.toJson<int>(score),
      'persons': serializer.toJson<String>(persons),
    };
  }

  RealPersonsPhotoSelection copyWith(
          {String? code,
          String? eventCode,
          String? image,
          int? score,
          String? persons}) =>
      RealPersonsPhotoSelection(
        code: code ?? this.code,
        eventCode: eventCode ?? this.eventCode,
        image: image ?? this.image,
        score: score ?? this.score,
        persons: persons ?? this.persons,
      );
  RealPersonsPhotoSelection copyWithCompanion(
      RealPersonsPhotoSelectionsCompanion data) {
    return RealPersonsPhotoSelection(
      code: data.code.present ? data.code.value : this.code,
      eventCode: data.eventCode.present ? data.eventCode.value : this.eventCode,
      image: data.image.present ? data.image.value : this.image,
      score: data.score.present ? data.score.value : this.score,
      persons: data.persons.present ? data.persons.value : this.persons,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RealPersonsPhotoSelection(')
          ..write('code: $code, ')
          ..write('eventCode: $eventCode, ')
          ..write('image: $image, ')
          ..write('score: $score, ')
          ..write('persons: $persons')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, eventCode, image, score, persons);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RealPersonsPhotoSelection &&
          other.code == this.code &&
          other.eventCode == this.eventCode &&
          other.image == this.image &&
          other.score == this.score &&
          other.persons == this.persons);
}

class RealPersonsPhotoSelectionsCompanion
    extends UpdateCompanion<RealPersonsPhotoSelection> {
  final Value<String> code;
  final Value<String> eventCode;
  final Value<String> image;
  final Value<int> score;
  final Value<String> persons;
  final Value<int> rowid;
  const RealPersonsPhotoSelectionsCompanion({
    this.code = const Value.absent(),
    this.eventCode = const Value.absent(),
    this.image = const Value.absent(),
    this.score = const Value.absent(),
    this.persons = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RealPersonsPhotoSelectionsCompanion.insert({
    required String code,
    required String eventCode,
    required String image,
    required int score,
    required String persons,
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        eventCode = Value(eventCode),
        image = Value(image),
        score = Value(score),
        persons = Value(persons);
  static Insertable<RealPersonsPhotoSelection> custom({
    Expression<String>? code,
    Expression<String>? eventCode,
    Expression<String>? image,
    Expression<int>? score,
    Expression<String>? persons,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (eventCode != null) 'event_code': eventCode,
      if (image != null) 'image': image,
      if (score != null) 'score': score,
      if (persons != null) 'persons': persons,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RealPersonsPhotoSelectionsCompanion copyWith(
      {Value<String>? code,
      Value<String>? eventCode,
      Value<String>? image,
      Value<int>? score,
      Value<String>? persons,
      Value<int>? rowid}) {
    return RealPersonsPhotoSelectionsCompanion(
      code: code ?? this.code,
      eventCode: eventCode ?? this.eventCode,
      image: image ?? this.image,
      score: score ?? this.score,
      persons: persons ?? this.persons,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (persons.present) {
      map['persons'] = Variable<String>(persons.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RealPersonsPhotoSelectionsCompanion(')
          ..write('code: $code, ')
          ..write('eventCode: $eventCode, ')
          ..write('image: $image, ')
          ..write('score: $score, ')
          ..write('persons: $persons, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PrintTableTable extends PrintTable
    with TableInfo<$PrintTableTable, PrintTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrintTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _eventCodeMeta =
      const VerificationMeta('eventCode');
  @override
  late final GeneratedColumn<String> eventCode = GeneratedColumn<String>(
      'event_code', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _ableTypeMeta =
      const VerificationMeta('ableType');
  @override
  late final GeneratedColumn<String> ableType = GeneratedColumn<String>(
      'able_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ableCodeMeta =
      const VerificationMeta('ableCode');
  @override
  late final GeneratedColumn<String> ableCode = GeneratedColumn<String>(
      'able_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [code, eventCode, ableType, ableCode, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'print_table';
  @override
  VerificationContext validateIntegrity(Insertable<PrintTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('event_code')) {
      context.handle(_eventCodeMeta,
          eventCode.isAcceptableOrUnknown(data['event_code']!, _eventCodeMeta));
    } else if (isInserting) {
      context.missing(_eventCodeMeta);
    }
    if (data.containsKey('able_type')) {
      context.handle(_ableTypeMeta,
          ableType.isAcceptableOrUnknown(data['able_type']!, _ableTypeMeta));
    } else if (isInserting) {
      context.missing(_ableTypeMeta);
    }
    if (data.containsKey('able_code')) {
      context.handle(_ableCodeMeta,
          ableCode.isAcceptableOrUnknown(data['able_code']!, _ableCodeMeta));
    } else if (isInserting) {
      context.missing(_ableCodeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ableCode};
  @override
  PrintTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrintTableData(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      eventCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_code'])!,
      ableType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}able_type'])!,
      ableCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}able_code'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $PrintTableTable createAlias(String alias) {
    return $PrintTableTable(attachedDatabase, alias);
  }
}

class PrintTableData extends DataClass implements Insertable<PrintTableData> {
  final String code;
  final String eventCode;
  final String ableType;
  final String ableCode;
  final int status;
  const PrintTableData(
      {required this.code,
      required this.eventCode,
      required this.ableType,
      required this.ableCode,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['event_code'] = Variable<String>(eventCode);
    map['able_type'] = Variable<String>(ableType);
    map['able_code'] = Variable<String>(ableCode);
    map['status'] = Variable<int>(status);
    return map;
  }

  PrintTableCompanion toCompanion(bool nullToAbsent) {
    return PrintTableCompanion(
      code: Value(code),
      eventCode: Value(eventCode),
      ableType: Value(ableType),
      ableCode: Value(ableCode),
      status: Value(status),
    );
  }

  factory PrintTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrintTableData(
      code: serializer.fromJson<String>(json['code']),
      eventCode: serializer.fromJson<String>(json['eventCode']),
      ableType: serializer.fromJson<String>(json['ableType']),
      ableCode: serializer.fromJson<String>(json['ableCode']),
      status: serializer.fromJson<int>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'eventCode': serializer.toJson<String>(eventCode),
      'ableType': serializer.toJson<String>(ableType),
      'ableCode': serializer.toJson<String>(ableCode),
      'status': serializer.toJson<int>(status),
    };
  }

  PrintTableData copyWith(
          {String? code,
          String? eventCode,
          String? ableType,
          String? ableCode,
          int? status}) =>
      PrintTableData(
        code: code ?? this.code,
        eventCode: eventCode ?? this.eventCode,
        ableType: ableType ?? this.ableType,
        ableCode: ableCode ?? this.ableCode,
        status: status ?? this.status,
      );
  PrintTableData copyWithCompanion(PrintTableCompanion data) {
    return PrintTableData(
      code: data.code.present ? data.code.value : this.code,
      eventCode: data.eventCode.present ? data.eventCode.value : this.eventCode,
      ableType: data.ableType.present ? data.ableType.value : this.ableType,
      ableCode: data.ableCode.present ? data.ableCode.value : this.ableCode,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrintTableData(')
          ..write('code: $code, ')
          ..write('eventCode: $eventCode, ')
          ..write('ableType: $ableType, ')
          ..write('ableCode: $ableCode, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, eventCode, ableType, ableCode, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrintTableData &&
          other.code == this.code &&
          other.eventCode == this.eventCode &&
          other.ableType == this.ableType &&
          other.ableCode == this.ableCode &&
          other.status == this.status);
}

class PrintTableCompanion extends UpdateCompanion<PrintTableData> {
  final Value<String> code;
  final Value<String> eventCode;
  final Value<String> ableType;
  final Value<String> ableCode;
  final Value<int> status;
  final Value<int> rowid;
  const PrintTableCompanion({
    this.code = const Value.absent(),
    this.eventCode = const Value.absent(),
    this.ableType = const Value.absent(),
    this.ableCode = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrintTableCompanion.insert({
    required String code,
    required String eventCode,
    required String ableType,
    required String ableCode,
    required int status,
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        eventCode = Value(eventCode),
        ableType = Value(ableType),
        ableCode = Value(ableCode),
        status = Value(status);
  static Insertable<PrintTableData> custom({
    Expression<String>? code,
    Expression<String>? eventCode,
    Expression<String>? ableType,
    Expression<String>? ableCode,
    Expression<int>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (eventCode != null) 'event_code': eventCode,
      if (ableType != null) 'able_type': ableType,
      if (ableCode != null) 'able_code': ableCode,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrintTableCompanion copyWith(
      {Value<String>? code,
      Value<String>? eventCode,
      Value<String>? ableType,
      Value<String>? ableCode,
      Value<int>? status,
      Value<int>? rowid}) {
    return PrintTableCompanion(
      code: code ?? this.code,
      eventCode: eventCode ?? this.eventCode,
      ableType: ableType ?? this.ableType,
      ableCode: ableCode ?? this.ableCode,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (eventCode.present) {
      map['event_code'] = Variable<String>(eventCode.value);
    }
    if (ableType.present) {
      map['able_type'] = Variable<String>(ableType.value);
    }
    if (ableCode.present) {
      map['able_code'] = Variable<String>(ableCode.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrintTableCompanion(')
          ..write('code: $code, ')
          ..write('eventCode: $eventCode, ')
          ..write('ableType: $ableType, ')
          ..write('ableCode: $ableCode, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserPersonsTable extends UserPersons
    with TableInfo<$UserPersonsTable, UserPerson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPersonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _relationshipMeta =
      const VerificationMeta('relationship');
  @override
  late final GeneratedColumn<String> relationship = GeneratedColumn<String>(
      'relationship', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imagesMeta = const VerificationMeta('images');
  @override
  late final GeneratedColumn<String> images = GeneratedColumn<String>(
      'images', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userOwnImageMeta =
      const VerificationMeta('userOwnImage');
  @override
  late final GeneratedColumn<int> userOwnImage = GeneratedColumn<int>(
      'User_own_image', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [code, name, relationship, images, userOwnImage];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_persons_table';
  @override
  VerificationContext validateIntegrity(Insertable<UserPerson> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('relationship')) {
      context.handle(
          _relationshipMeta,
          relationship.isAcceptableOrUnknown(
              data['relationship']!, _relationshipMeta));
    } else if (isInserting) {
      context.missing(_relationshipMeta);
    }
    if (data.containsKey('images')) {
      context.handle(_imagesMeta,
          images.isAcceptableOrUnknown(data['images']!, _imagesMeta));
    } else if (isInserting) {
      context.missing(_imagesMeta);
    }
    if (data.containsKey('User_own_image')) {
      context.handle(
          _userOwnImageMeta,
          userOwnImage.isAcceptableOrUnknown(
              data['User_own_image']!, _userOwnImageMeta));
    } else if (isInserting) {
      context.missing(_userOwnImageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  UserPerson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPerson(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      relationship: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}relationship'])!,
      images: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}images'])!,
      userOwnImage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}User_own_image'])!,
    );
  }

  @override
  $UserPersonsTable createAlias(String alias) {
    return $UserPersonsTable(attachedDatabase, alias);
  }
}

class UserPerson extends DataClass implements Insertable<UserPerson> {
  final String code;
  final String name;
  final String relationship;
  final String images;
  final int userOwnImage;
  const UserPerson(
      {required this.code,
      required this.name,
      required this.relationship,
      required this.images,
      required this.userOwnImage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['relationship'] = Variable<String>(relationship);
    map['images'] = Variable<String>(images);
    map['User_own_image'] = Variable<int>(userOwnImage);
    return map;
  }

  UserPersonsCompanion toCompanion(bool nullToAbsent) {
    return UserPersonsCompanion(
      code: Value(code),
      name: Value(name),
      relationship: Value(relationship),
      images: Value(images),
      userOwnImage: Value(userOwnImage),
    );
  }

  factory UserPerson.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPerson(
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      relationship: serializer.fromJson<String>(json['relationship']),
      images: serializer.fromJson<String>(json['images']),
      userOwnImage: serializer.fromJson<int>(json['userOwnImage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'relationship': serializer.toJson<String>(relationship),
      'images': serializer.toJson<String>(images),
      'userOwnImage': serializer.toJson<int>(userOwnImage),
    };
  }

  UserPerson copyWith(
          {String? code,
          String? name,
          String? relationship,
          String? images,
          int? userOwnImage}) =>
      UserPerson(
        code: code ?? this.code,
        name: name ?? this.name,
        relationship: relationship ?? this.relationship,
        images: images ?? this.images,
        userOwnImage: userOwnImage ?? this.userOwnImage,
      );
  UserPerson copyWithCompanion(UserPersonsCompanion data) {
    return UserPerson(
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      relationship: data.relationship.present
          ? data.relationship.value
          : this.relationship,
      images: data.images.present ? data.images.value : this.images,
      userOwnImage: data.userOwnImage.present
          ? data.userOwnImage.value
          : this.userOwnImage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPerson(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('relationship: $relationship, ')
          ..write('images: $images, ')
          ..write('userOwnImage: $userOwnImage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(code, name, relationship, images, userOwnImage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPerson &&
          other.code == this.code &&
          other.name == this.name &&
          other.relationship == this.relationship &&
          other.images == this.images &&
          other.userOwnImage == this.userOwnImage);
}

class UserPersonsCompanion extends UpdateCompanion<UserPerson> {
  final Value<String> code;
  final Value<String> name;
  final Value<String> relationship;
  final Value<String> images;
  final Value<int> userOwnImage;
  final Value<int> rowid;
  const UserPersonsCompanion({
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.relationship = const Value.absent(),
    this.images = const Value.absent(),
    this.userOwnImage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserPersonsCompanion.insert({
    required String code,
    required String name,
    required String relationship,
    required String images,
    required int userOwnImage,
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        name = Value(name),
        relationship = Value(relationship),
        images = Value(images),
        userOwnImage = Value(userOwnImage);
  static Insertable<UserPerson> custom({
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? relationship,
    Expression<String>? images,
    Expression<int>? userOwnImage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (relationship != null) 'relationship': relationship,
      if (images != null) 'images': images,
      if (userOwnImage != null) 'User_own_image': userOwnImage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserPersonsCompanion copyWith(
      {Value<String>? code,
      Value<String>? name,
      Value<String>? relationship,
      Value<String>? images,
      Value<int>? userOwnImage,
      Value<int>? rowid}) {
    return UserPersonsCompanion(
      code: code ?? this.code,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      images: images ?? this.images,
      userOwnImage: userOwnImage ?? this.userOwnImage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (relationship.present) {
      map['relationship'] = Variable<String>(relationship.value);
    }
    if (images.present) {
      map['images'] = Variable<String>(images.value);
    }
    if (userOwnImage.present) {
      map['User_own_image'] = Variable<int>(userOwnImage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPersonsCompanion(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('relationship: $relationship, ')
          ..write('images: $images, ')
          ..write('userOwnImage: $userOwnImage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $TransportDataTable transportData = $TransportDataTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $AlbumsTable albums = $AlbumsTable(this);
  late final $JvtFilesTable jvtFiles = $JvtFilesTable(this);
  late final $JvtFileConnectorsTable jvtFileConnectors =
      $JvtFileConnectorsTable(this);
  late final $FoldersTable folders = $FoldersTable(this);
  late final $FolderStatusesTable folderStatuses = $FolderStatusesTable(this);
  late final $FolderRulesTable folderRules = $FolderRulesTable(this);
  late final $PhotoSelectionImagesTable photoSelectionImages =
      $PhotoSelectionImagesTable(this);
  late final $EventInfoTable eventInfo = $EventInfoTable(this);
  late final $StudioPackageTable studioPackage = $StudioPackageTable(this);
  late final $StudioPackageValueTable studioPackageValue =
      $StudioPackageValueTable(this);
  late final $VideosTable videos = $VideosTable(this);
  late final $CarouselPropertiesTable carouselProperties =
      $CarouselPropertiesTable(this);
  late final $CarouselTable carousel = $CarouselTable(this);
  late final $MediaTable media = $MediaTable(this);
  late final $PhotoSelectionCurrentIndexTable photoSelectionCurrentIndex =
      $PhotoSelectionCurrentIndexTable(this);
  late final $PhotoSelectionsTable photoSelections =
      $PhotoSelectionsTable(this);
  late final $PersonsPhotoSelectionsTable personsPhotoSelections =
      $PersonsPhotoSelectionsTable(this);
  late final $PersonsAlbumsTable personsAlbums = $PersonsAlbumsTable(this);
  late final $FolderNotificationTable folderNotification =
      $FolderNotificationTable(this);
  late final $WithOutPersonsAlbumsTable withOutPersonsAlbums =
      $WithOutPersonsAlbumsTable(this);
  late final $WithOutPersonsPhotoSelectionTable withOutPersonsPhotoSelection =
      $WithOutPersonsPhotoSelectionTable(this);
  late final $PhotomallStudioInfoTable photomallStudioInfo =
      $PhotomallStudioInfoTable(this);
  late final $CommonTableTable commonTable = $CommonTableTable(this);
  late final $RealPersonsAlbumsTable realPersonsAlbums =
      $RealPersonsAlbumsTable(this);
  late final $DownloadTable download = $DownloadTable(this);
  late final $PhotoSelectionImageFolderTable photoSelectionImageFolder =
      $PhotoSelectionImageFolderTable(this);
  late final $RealPersonsPhotoSelectionsTable realPersonsPhotoSelections =
      $RealPersonsPhotoSelectionsTable(this);
  late final $PrintTableTable printTable = $PrintTableTable(this);
  late final $UserPersonsTable userPersons = $UserPersonsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        transportData,
        events,
        albums,
        jvtFiles,
        jvtFileConnectors,
        folders,
        folderStatuses,
        folderRules,
        photoSelectionImages,
        eventInfo,
        studioPackage,
        studioPackageValue,
        videos,
        carouselProperties,
        carousel,
        media,
        photoSelectionCurrentIndex,
        photoSelections,
        personsPhotoSelections,
        personsAlbums,
        folderNotification,
        withOutPersonsAlbums,
        withOutPersonsPhotoSelection,
        photomallStudioInfo,
        commonTable,
        realPersonsAlbums,
        download,
        photoSelectionImageFolder,
        realPersonsPhotoSelections,
        printTable,
        userPersons
      ];
}

typedef $$TransportDataTableCreateCompanionBuilder = TransportDataCompanion
    Function({
  Value<int> id,
  Value<String?> code,
  Value<String?> tag,
  required int lastUpdatedAt,
  Value<int> updateRequired,
  Value<int?> type,
  Value<String?> data,
});
typedef $$TransportDataTableUpdateCompanionBuilder = TransportDataCompanion
    Function({
  Value<int> id,
  Value<String?> code,
  Value<String?> tag,
  Value<int> lastUpdatedAt,
  Value<int> updateRequired,
  Value<int?> type,
  Value<String?> data,
});

class $$TransportDataTableFilterComposer
    extends Composer<_$AppDb, $TransportDataTable> {
  $$TransportDataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tag => $composableBuilder(
      column: $table.tag, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updateRequired => $composableBuilder(
      column: $table.updateRequired,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));
}

class $$TransportDataTableOrderingComposer
    extends Composer<_$AppDb, $TransportDataTable> {
  $$TransportDataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tag => $composableBuilder(
      column: $table.tag, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updateRequired => $composableBuilder(
      column: $table.updateRequired,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));
}

class $$TransportDataTableAnnotationComposer
    extends Composer<_$AppDb, $TransportDataTable> {
  $$TransportDataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);

  GeneratedColumn<int> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => column);

  GeneratedColumn<int> get updateRequired => $composableBuilder(
      column: $table.updateRequired, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$TransportDataTableTableManager extends RootTableManager<
    _$AppDb,
    $TransportDataTable,
    TransportDataData,
    $$TransportDataTableFilterComposer,
    $$TransportDataTableOrderingComposer,
    $$TransportDataTableAnnotationComposer,
    $$TransportDataTableCreateCompanionBuilder,
    $$TransportDataTableUpdateCompanionBuilder,
    (
      TransportDataData,
      BaseReferences<_$AppDb, $TransportDataTable, TransportDataData>
    ),
    TransportDataData,
    PrefetchHooks Function()> {
  $$TransportDataTableTableManager(_$AppDb db, $TransportDataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransportDataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransportDataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransportDataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> code = const Value.absent(),
            Value<String?> tag = const Value.absent(),
            Value<int> lastUpdatedAt = const Value.absent(),
            Value<int> updateRequired = const Value.absent(),
            Value<int?> type = const Value.absent(),
            Value<String?> data = const Value.absent(),
          }) =>
              TransportDataCompanion(
            id: id,
            code: code,
            tag: tag,
            lastUpdatedAt: lastUpdatedAt,
            updateRequired: updateRequired,
            type: type,
            data: data,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> code = const Value.absent(),
            Value<String?> tag = const Value.absent(),
            required int lastUpdatedAt,
            Value<int> updateRequired = const Value.absent(),
            Value<int?> type = const Value.absent(),
            Value<String?> data = const Value.absent(),
          }) =>
              TransportDataCompanion.insert(
            id: id,
            code: code,
            tag: tag,
            lastUpdatedAt: lastUpdatedAt,
            updateRequired: updateRequired,
            type: type,
            data: data,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransportDataTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $TransportDataTable,
    TransportDataData,
    $$TransportDataTableFilterComposer,
    $$TransportDataTableOrderingComposer,
    $$TransportDataTableAnnotationComposer,
    $$TransportDataTableCreateCompanionBuilder,
    $$TransportDataTableUpdateCompanionBuilder,
    (
      TransportDataData,
      BaseReferences<_$AppDb, $TransportDataTable, TransportDataData>
    ),
    TransportDataData,
    PrefetchHooks Function()>;
typedef $$EventsTableCreateCompanionBuilder = EventsCompanion Function({
  required String code,
  Value<String?> name,
  required String categoryName,
  Value<bool> published,
  required int type,
  required bool loginRequired,
  required bool newlyAdded,
  required bool archived,
  required bool ownedByUser,
  Value<bool> downloadable,
  Value<bool> withIcon,
  Value<bool> withWaterMark,
  Value<int?> priorityScore,
  Value<bool> personStatus,
  Value<bool> isAlbumDownloadable,
  Value<String?> studioCode,
  Value<String?> shareDate,
  Value<bool> myPhotosDownloadable,
  Value<bool> hideMedia,
  Value<bool> ownerDownload,
  Value<bool> printStatus,
  Value<int> rowid,
});
typedef $$EventsTableUpdateCompanionBuilder = EventsCompanion Function({
  Value<String> code,
  Value<String?> name,
  Value<String> categoryName,
  Value<bool> published,
  Value<int> type,
  Value<bool> loginRequired,
  Value<bool> newlyAdded,
  Value<bool> archived,
  Value<bool> ownedByUser,
  Value<bool> downloadable,
  Value<bool> withIcon,
  Value<bool> withWaterMark,
  Value<int?> priorityScore,
  Value<bool> personStatus,
  Value<bool> isAlbumDownloadable,
  Value<String?> studioCode,
  Value<String?> shareDate,
  Value<bool> myPhotosDownloadable,
  Value<bool> hideMedia,
  Value<bool> ownerDownload,
  Value<bool> printStatus,
  Value<int> rowid,
});

final class $$EventsTableReferences
    extends BaseReferences<_$AppDb, $EventsTable, Event> {
  $$EventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AlbumsTable, List<Album>> _albumsRefsTable(
          _$AppDb db) =>
      MultiTypedResultKey.fromTable(db.albums,
          aliasName: $_aliasNameGenerator(db.events.code, db.albums.eventCode));

  $$AlbumsTableProcessedTableManager get albumsRefs {
    final manager = $$AlbumsTableTableManager($_db, $_db.albums).filter(
        (f) => f.eventCode.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_albumsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$FoldersTable, List<Folder>> _foldersRefsTable(
          _$AppDb db) =>
      MultiTypedResultKey.fromTable(db.folders,
          aliasName:
              $_aliasNameGenerator(db.events.code, db.folders.eventCode));

  $$FoldersTableProcessedTableManager get foldersRefs {
    final manager = $$FoldersTableTableManager($_db, $_db.folders).filter(
        (f) => f.eventCode.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_foldersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$EventInfoTable, List<EventInfoData>>
      _eventInfoRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
          db.eventInfo,
          aliasName:
              $_aliasNameGenerator(db.events.code, db.eventInfo.eventCode));

  $$EventInfoTableProcessedTableManager get eventInfoRefs {
    final manager = $$EventInfoTableTableManager($_db, $_db.eventInfo).filter(
        (f) => f.eventCode.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_eventInfoRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$VideosTable, List<Video>> _videosRefsTable(
          _$AppDb db) =>
      MultiTypedResultKey.fromTable(db.videos,
          aliasName: $_aliasNameGenerator(db.events.code, db.videos.eventCode));

  $$VideosTableProcessedTableManager get videosRefs {
    final manager = $$VideosTableTableManager($_db, $_db.videos).filter(
        (f) => f.eventCode.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_videosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PhotomallStudioInfoTable,
      List<PhotomallStudioInfoData>> _photomallStudioInfoRefsTable(
          _$AppDb db) =>
      MultiTypedResultKey.fromTable(db.photomallStudioInfo,
          aliasName: $_aliasNameGenerator(
              db.events.code, db.photomallStudioInfo.code));

  $$PhotomallStudioInfoTableProcessedTableManager get photomallStudioInfoRefs {
    final manager = $$PhotomallStudioInfoTableTableManager(
            $_db, $_db.photomallStudioInfo)
        .filter((f) => f.code.code.sqlEquals($_itemColumn<String>('code')!));

    final cache =
        $_typedResult.readTableOrNull(_photomallStudioInfoRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EventsTableFilterComposer extends Composer<_$AppDb, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get published => $composableBuilder(
      column: $table.published, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get loginRequired => $composableBuilder(
      column: $table.loginRequired, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get newlyAdded => $composableBuilder(
      column: $table.newlyAdded, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get archived => $composableBuilder(
      column: $table.archived, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get ownedByUser => $composableBuilder(
      column: $table.ownedByUser, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get downloadable => $composableBuilder(
      column: $table.downloadable, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get withIcon => $composableBuilder(
      column: $table.withIcon, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get withWaterMark => $composableBuilder(
      column: $table.withWaterMark, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priorityScore => $composableBuilder(
      column: $table.priorityScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get personStatus => $composableBuilder(
      column: $table.personStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAlbumDownloadable => $composableBuilder(
      column: $table.isAlbumDownloadable,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get studioCode => $composableBuilder(
      column: $table.studioCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shareDate => $composableBuilder(
      column: $table.shareDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get myPhotosDownloadable => $composableBuilder(
      column: $table.myPhotosDownloadable,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hideMedia => $composableBuilder(
      column: $table.hideMedia, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get ownerDownload => $composableBuilder(
      column: $table.ownerDownload, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get printStatus => $composableBuilder(
      column: $table.printStatus, builder: (column) => ColumnFilters(column));

  Expression<bool> albumsRefs(
      Expression<bool> Function($$AlbumsTableFilterComposer f) f) {
    final $$AlbumsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.albums,
        getReferencedColumn: (t) => t.eventCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlbumsTableFilterComposer(
              $db: $db,
              $table: $db.albums,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> foldersRefs(
      Expression<bool> Function($$FoldersTableFilterComposer f) f) {
    final $$FoldersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.folders,
        getReferencedColumn: (t) => t.eventCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoldersTableFilterComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> eventInfoRefs(
      Expression<bool> Function($$EventInfoTableFilterComposer f) f) {
    final $$EventInfoTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.eventInfo,
        getReferencedColumn: (t) => t.eventCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventInfoTableFilterComposer(
              $db: $db,
              $table: $db.eventInfo,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> videosRefs(
      Expression<bool> Function($$VideosTableFilterComposer f) f) {
    final $$VideosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.videos,
        getReferencedColumn: (t) => t.eventCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VideosTableFilterComposer(
              $db: $db,
              $table: $db.videos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> photomallStudioInfoRefs(
      Expression<bool> Function($$PhotomallStudioInfoTableFilterComposer f) f) {
    final $$PhotomallStudioInfoTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.photomallStudioInfo,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PhotomallStudioInfoTableFilterComposer(
              $db: $db,
              $table: $db.photomallStudioInfo,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EventsTableOrderingComposer extends Composer<_$AppDb, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryName => $composableBuilder(
      column: $table.categoryName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get published => $composableBuilder(
      column: $table.published, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get loginRequired => $composableBuilder(
      column: $table.loginRequired,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get newlyAdded => $composableBuilder(
      column: $table.newlyAdded, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get archived => $composableBuilder(
      column: $table.archived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get ownedByUser => $composableBuilder(
      column: $table.ownedByUser, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get downloadable => $composableBuilder(
      column: $table.downloadable,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get withIcon => $composableBuilder(
      column: $table.withIcon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get withWaterMark => $composableBuilder(
      column: $table.withWaterMark,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priorityScore => $composableBuilder(
      column: $table.priorityScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get personStatus => $composableBuilder(
      column: $table.personStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAlbumDownloadable => $composableBuilder(
      column: $table.isAlbumDownloadable,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get studioCode => $composableBuilder(
      column: $table.studioCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shareDate => $composableBuilder(
      column: $table.shareDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get myPhotosDownloadable => $composableBuilder(
      column: $table.myPhotosDownloadable,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hideMedia => $composableBuilder(
      column: $table.hideMedia, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get ownerDownload => $composableBuilder(
      column: $table.ownerDownload,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get printStatus => $composableBuilder(
      column: $table.printStatus, builder: (column) => ColumnOrderings(column));
}

class $$EventsTableAnnotationComposer extends Composer<_$AppDb, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => column);

  GeneratedColumn<bool> get published =>
      $composableBuilder(column: $table.published, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get loginRequired => $composableBuilder(
      column: $table.loginRequired, builder: (column) => column);

  GeneratedColumn<bool> get newlyAdded => $composableBuilder(
      column: $table.newlyAdded, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<bool> get ownedByUser => $composableBuilder(
      column: $table.ownedByUser, builder: (column) => column);

  GeneratedColumn<bool> get downloadable => $composableBuilder(
      column: $table.downloadable, builder: (column) => column);

  GeneratedColumn<bool> get withIcon =>
      $composableBuilder(column: $table.withIcon, builder: (column) => column);

  GeneratedColumn<bool> get withWaterMark => $composableBuilder(
      column: $table.withWaterMark, builder: (column) => column);

  GeneratedColumn<int> get priorityScore => $composableBuilder(
      column: $table.priorityScore, builder: (column) => column);

  GeneratedColumn<bool> get personStatus => $composableBuilder(
      column: $table.personStatus, builder: (column) => column);

  GeneratedColumn<bool> get isAlbumDownloadable => $composableBuilder(
      column: $table.isAlbumDownloadable, builder: (column) => column);

  GeneratedColumn<String> get studioCode => $composableBuilder(
      column: $table.studioCode, builder: (column) => column);

  GeneratedColumn<String> get shareDate =>
      $composableBuilder(column: $table.shareDate, builder: (column) => column);

  GeneratedColumn<bool> get myPhotosDownloadable => $composableBuilder(
      column: $table.myPhotosDownloadable, builder: (column) => column);

  GeneratedColumn<bool> get hideMedia =>
      $composableBuilder(column: $table.hideMedia, builder: (column) => column);

  GeneratedColumn<bool> get ownerDownload => $composableBuilder(
      column: $table.ownerDownload, builder: (column) => column);

  GeneratedColumn<bool> get printStatus => $composableBuilder(
      column: $table.printStatus, builder: (column) => column);

  Expression<T> albumsRefs<T extends Object>(
      Expression<T> Function($$AlbumsTableAnnotationComposer a) f) {
    final $$AlbumsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.albums,
        getReferencedColumn: (t) => t.eventCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlbumsTableAnnotationComposer(
              $db: $db,
              $table: $db.albums,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> foldersRefs<T extends Object>(
      Expression<T> Function($$FoldersTableAnnotationComposer a) f) {
    final $$FoldersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.folders,
        getReferencedColumn: (t) => t.eventCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoldersTableAnnotationComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> eventInfoRefs<T extends Object>(
      Expression<T> Function($$EventInfoTableAnnotationComposer a) f) {
    final $$EventInfoTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.eventInfo,
        getReferencedColumn: (t) => t.eventCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventInfoTableAnnotationComposer(
              $db: $db,
              $table: $db.eventInfo,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> videosRefs<T extends Object>(
      Expression<T> Function($$VideosTableAnnotationComposer a) f) {
    final $$VideosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.videos,
        getReferencedColumn: (t) => t.eventCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VideosTableAnnotationComposer(
              $db: $db,
              $table: $db.videos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> photomallStudioInfoRefs<T extends Object>(
      Expression<T> Function($$PhotomallStudioInfoTableAnnotationComposer a)
          f) {
    final $$PhotomallStudioInfoTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.code,
            referencedTable: $db.photomallStudioInfo,
            getReferencedColumn: (t) => t.code,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PhotomallStudioInfoTableAnnotationComposer(
                  $db: $db,
                  $table: $db.photomallStudioInfo,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$EventsTableTableManager extends RootTableManager<
    _$AppDb,
    $EventsTable,
    Event,
    $$EventsTableFilterComposer,
    $$EventsTableOrderingComposer,
    $$EventsTableAnnotationComposer,
    $$EventsTableCreateCompanionBuilder,
    $$EventsTableUpdateCompanionBuilder,
    (Event, $$EventsTableReferences),
    Event,
    PrefetchHooks Function(
        {bool albumsRefs,
        bool foldersRefs,
        bool eventInfoRefs,
        bool videosRefs,
        bool photomallStudioInfoRefs})> {
  $$EventsTableTableManager(_$AppDb db, $EventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String> categoryName = const Value.absent(),
            Value<bool> published = const Value.absent(),
            Value<int> type = const Value.absent(),
            Value<bool> loginRequired = const Value.absent(),
            Value<bool> newlyAdded = const Value.absent(),
            Value<bool> archived = const Value.absent(),
            Value<bool> ownedByUser = const Value.absent(),
            Value<bool> downloadable = const Value.absent(),
            Value<bool> withIcon = const Value.absent(),
            Value<bool> withWaterMark = const Value.absent(),
            Value<int?> priorityScore = const Value.absent(),
            Value<bool> personStatus = const Value.absent(),
            Value<bool> isAlbumDownloadable = const Value.absent(),
            Value<String?> studioCode = const Value.absent(),
            Value<String?> shareDate = const Value.absent(),
            Value<bool> myPhotosDownloadable = const Value.absent(),
            Value<bool> hideMedia = const Value.absent(),
            Value<bool> ownerDownload = const Value.absent(),
            Value<bool> printStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EventsCompanion(
            code: code,
            name: name,
            categoryName: categoryName,
            published: published,
            type: type,
            loginRequired: loginRequired,
            newlyAdded: newlyAdded,
            archived: archived,
            ownedByUser: ownedByUser,
            downloadable: downloadable,
            withIcon: withIcon,
            withWaterMark: withWaterMark,
            priorityScore: priorityScore,
            personStatus: personStatus,
            isAlbumDownloadable: isAlbumDownloadable,
            studioCode: studioCode,
            shareDate: shareDate,
            myPhotosDownloadable: myPhotosDownloadable,
            hideMedia: hideMedia,
            ownerDownload: ownerDownload,
            printStatus: printStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            Value<String?> name = const Value.absent(),
            required String categoryName,
            Value<bool> published = const Value.absent(),
            required int type,
            required bool loginRequired,
            required bool newlyAdded,
            required bool archived,
            required bool ownedByUser,
            Value<bool> downloadable = const Value.absent(),
            Value<bool> withIcon = const Value.absent(),
            Value<bool> withWaterMark = const Value.absent(),
            Value<int?> priorityScore = const Value.absent(),
            Value<bool> personStatus = const Value.absent(),
            Value<bool> isAlbumDownloadable = const Value.absent(),
            Value<String?> studioCode = const Value.absent(),
            Value<String?> shareDate = const Value.absent(),
            Value<bool> myPhotosDownloadable = const Value.absent(),
            Value<bool> hideMedia = const Value.absent(),
            Value<bool> ownerDownload = const Value.absent(),
            Value<bool> printStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EventsCompanion.insert(
            code: code,
            name: name,
            categoryName: categoryName,
            published: published,
            type: type,
            loginRequired: loginRequired,
            newlyAdded: newlyAdded,
            archived: archived,
            ownedByUser: ownedByUser,
            downloadable: downloadable,
            withIcon: withIcon,
            withWaterMark: withWaterMark,
            priorityScore: priorityScore,
            personStatus: personStatus,
            isAlbumDownloadable: isAlbumDownloadable,
            studioCode: studioCode,
            shareDate: shareDate,
            myPhotosDownloadable: myPhotosDownloadable,
            hideMedia: hideMedia,
            ownerDownload: ownerDownload,
            printStatus: printStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$EventsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {albumsRefs = false,
              foldersRefs = false,
              eventInfoRefs = false,
              videosRefs = false,
              photomallStudioInfoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (albumsRefs) db.albums,
                if (foldersRefs) db.folders,
                if (eventInfoRefs) db.eventInfo,
                if (videosRefs) db.videos,
                if (photomallStudioInfoRefs) db.photomallStudioInfo
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (albumsRefs)
                    await $_getPrefetchedData<Event, $EventsTable, Album>(
                        currentTable: table,
                        referencedTable:
                            $$EventsTableReferences._albumsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EventsTableReferences(db, table, p0).albumsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.eventCode == item.code),
                        typedResults: items),
                  if (foldersRefs)
                    await $_getPrefetchedData<Event, $EventsTable, Folder>(
                        currentTable: table,
                        referencedTable:
                            $$EventsTableReferences._foldersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EventsTableReferences(db, table, p0).foldersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.eventCode == item.code),
                        typedResults: items),
                  if (eventInfoRefs)
                    await $_getPrefetchedData<Event, $EventsTable,
                            EventInfoData>(
                        currentTable: table,
                        referencedTable:
                            $$EventsTableReferences._eventInfoRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EventsTableReferences(db, table, p0)
                                .eventInfoRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.eventCode == item.code),
                        typedResults: items),
                  if (videosRefs)
                    await $_getPrefetchedData<Event, $EventsTable, Video>(
                        currentTable: table,
                        referencedTable:
                            $$EventsTableReferences._videosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EventsTableReferences(db, table, p0).videosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.eventCode == item.code),
                        typedResults: items),
                  if (photomallStudioInfoRefs)
                    await $_getPrefetchedData<Event, $EventsTable,
                            PhotomallStudioInfoData>(
                        currentTable: table,
                        referencedTable: $$EventsTableReferences
                            ._photomallStudioInfoRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EventsTableReferences(db, table, p0)
                                .photomallStudioInfoRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.code == item.code),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $EventsTable,
    Event,
    $$EventsTableFilterComposer,
    $$EventsTableOrderingComposer,
    $$EventsTableAnnotationComposer,
    $$EventsTableCreateCompanionBuilder,
    $$EventsTableUpdateCompanionBuilder,
    (Event, $$EventsTableReferences),
    Event,
    PrefetchHooks Function(
        {bool albumsRefs,
        bool foldersRefs,
        bool eventInfoRefs,
        bool videosRefs,
        bool photomallStudioInfoRefs})>;
typedef $$AlbumsTableCreateCompanionBuilder = AlbumsCompanion Function({
  required String code,
  required String eventCode,
  required String name,
  required int type,
  required String size,
  Value<bool> published,
  Value<int?> visibility,
  required int priorityScore,
  Value<String?> lastSeenIndex,
  Value<String?> orders,
  Value<String?> oldOrders,
  Value<String?> coverImage,
  Value<String?> music,
  Value<int> rowid,
});
typedef $$AlbumsTableUpdateCompanionBuilder = AlbumsCompanion Function({
  Value<String> code,
  Value<String> eventCode,
  Value<String> name,
  Value<int> type,
  Value<String> size,
  Value<bool> published,
  Value<int?> visibility,
  Value<int> priorityScore,
  Value<String?> lastSeenIndex,
  Value<String?> orders,
  Value<String?> oldOrders,
  Value<String?> coverImage,
  Value<String?> music,
  Value<int> rowid,
});

final class $$AlbumsTableReferences
    extends BaseReferences<_$AppDb, $AlbumsTable, Album> {
  $$AlbumsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventCodeTable(_$AppDb db) => db.events
      .createAlias($_aliasNameGenerator(db.albums.eventCode, db.events.code));

  $$EventsTableProcessedTableManager get eventCode {
    final $_column = $_itemColumn<String>('event_code')!;

    final manager = $$EventsTableTableManager($_db, $_db.events)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AlbumsTableFilterComposer extends Composer<_$AppDb, $AlbumsTable> {
  $$AlbumsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get size => $composableBuilder(
      column: $table.size, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get published => $composableBuilder(
      column: $table.published, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get visibility => $composableBuilder(
      column: $table.visibility, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priorityScore => $composableBuilder(
      column: $table.priorityScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastSeenIndex => $composableBuilder(
      column: $table.lastSeenIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orders => $composableBuilder(
      column: $table.orders, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get oldOrders => $composableBuilder(
      column: $table.oldOrders, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverImage => $composableBuilder(
      column: $table.coverImage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get music => $composableBuilder(
      column: $table.music, builder: (column) => ColumnFilters(column));

  $$EventsTableFilterComposer get eventCode {
    final $$EventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventCode,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableFilterComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AlbumsTableOrderingComposer extends Composer<_$AppDb, $AlbumsTable> {
  $$AlbumsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get size => $composableBuilder(
      column: $table.size, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get published => $composableBuilder(
      column: $table.published, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get visibility => $composableBuilder(
      column: $table.visibility, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priorityScore => $composableBuilder(
      column: $table.priorityScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastSeenIndex => $composableBuilder(
      column: $table.lastSeenIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orders => $composableBuilder(
      column: $table.orders, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get oldOrders => $composableBuilder(
      column: $table.oldOrders, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverImage => $composableBuilder(
      column: $table.coverImage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get music => $composableBuilder(
      column: $table.music, builder: (column) => ColumnOrderings(column));

  $$EventsTableOrderingComposer get eventCode {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventCode,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableOrderingComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AlbumsTableAnnotationComposer extends Composer<_$AppDb, $AlbumsTable> {
  $$AlbumsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<bool> get published =>
      $composableBuilder(column: $table.published, builder: (column) => column);

  GeneratedColumn<int> get visibility => $composableBuilder(
      column: $table.visibility, builder: (column) => column);

  GeneratedColumn<int> get priorityScore => $composableBuilder(
      column: $table.priorityScore, builder: (column) => column);

  GeneratedColumn<String> get lastSeenIndex => $composableBuilder(
      column: $table.lastSeenIndex, builder: (column) => column);

  GeneratedColumn<String> get orders =>
      $composableBuilder(column: $table.orders, builder: (column) => column);

  GeneratedColumn<String> get oldOrders =>
      $composableBuilder(column: $table.oldOrders, builder: (column) => column);

  GeneratedColumn<String> get coverImage => $composableBuilder(
      column: $table.coverImage, builder: (column) => column);

  GeneratedColumn<String> get music =>
      $composableBuilder(column: $table.music, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventCode {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventCode,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableAnnotationComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AlbumsTableTableManager extends RootTableManager<
    _$AppDb,
    $AlbumsTable,
    Album,
    $$AlbumsTableFilterComposer,
    $$AlbumsTableOrderingComposer,
    $$AlbumsTableAnnotationComposer,
    $$AlbumsTableCreateCompanionBuilder,
    $$AlbumsTableUpdateCompanionBuilder,
    (Album, $$AlbumsTableReferences),
    Album,
    PrefetchHooks Function({bool eventCode})> {
  $$AlbumsTableTableManager(_$AppDb db, $AlbumsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlbumsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlbumsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlbumsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> eventCode = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> type = const Value.absent(),
            Value<String> size = const Value.absent(),
            Value<bool> published = const Value.absent(),
            Value<int?> visibility = const Value.absent(),
            Value<int> priorityScore = const Value.absent(),
            Value<String?> lastSeenIndex = const Value.absent(),
            Value<String?> orders = const Value.absent(),
            Value<String?> oldOrders = const Value.absent(),
            Value<String?> coverImage = const Value.absent(),
            Value<String?> music = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AlbumsCompanion(
            code: code,
            eventCode: eventCode,
            name: name,
            type: type,
            size: size,
            published: published,
            visibility: visibility,
            priorityScore: priorityScore,
            lastSeenIndex: lastSeenIndex,
            orders: orders,
            oldOrders: oldOrders,
            coverImage: coverImage,
            music: music,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String eventCode,
            required String name,
            required int type,
            required String size,
            Value<bool> published = const Value.absent(),
            Value<int?> visibility = const Value.absent(),
            required int priorityScore,
            Value<String?> lastSeenIndex = const Value.absent(),
            Value<String?> orders = const Value.absent(),
            Value<String?> oldOrders = const Value.absent(),
            Value<String?> coverImage = const Value.absent(),
            Value<String?> music = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AlbumsCompanion.insert(
            code: code,
            eventCode: eventCode,
            name: name,
            type: type,
            size: size,
            published: published,
            visibility: visibility,
            priorityScore: priorityScore,
            lastSeenIndex: lastSeenIndex,
            orders: orders,
            oldOrders: oldOrders,
            coverImage: coverImage,
            music: music,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AlbumsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({eventCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (eventCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.eventCode,
                    referencedTable:
                        $$AlbumsTableReferences._eventCodeTable(db),
                    referencedColumn:
                        $$AlbumsTableReferences._eventCodeTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AlbumsTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $AlbumsTable,
    Album,
    $$AlbumsTableFilterComposer,
    $$AlbumsTableOrderingComposer,
    $$AlbumsTableAnnotationComposer,
    $$AlbumsTableCreateCompanionBuilder,
    $$AlbumsTableUpdateCompanionBuilder,
    (Album, $$AlbumsTableReferences),
    Album,
    PrefetchHooks Function({bool eventCode})>;
typedef $$JvtFilesTableCreateCompanionBuilder = JvtFilesCompanion Function({
  required String code,
  required String name,
  required int mode,
  required String extension,
  Value<int> downloaded,
  required int size,
  Value<int> attempt,
  Value<int> priority,
  Value<bool?> isNetworkImage,
  Value<int> rowid,
});
typedef $$JvtFilesTableUpdateCompanionBuilder = JvtFilesCompanion Function({
  Value<String> code,
  Value<String> name,
  Value<int> mode,
  Value<String> extension,
  Value<int> downloaded,
  Value<int> size,
  Value<int> attempt,
  Value<int> priority,
  Value<bool?> isNetworkImage,
  Value<int> rowid,
});

final class $$JvtFilesTableReferences
    extends BaseReferences<_$AppDb, $JvtFilesTable, JvtFile> {
  $$JvtFilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$JvtFileConnectorsTable, List<JvtFileConnector>>
      _jvtFileConnectorsRefsTable(_$AppDb db) =>
          MultiTypedResultKey.fromTable(db.jvtFileConnectors,
              aliasName: $_aliasNameGenerator(
                  db.jvtFiles.code, db.jvtFileConnectors.jvtFileCode));

  $$JvtFileConnectorsTableProcessedTableManager get jvtFileConnectorsRefs {
    final manager = $$JvtFileConnectorsTableTableManager(
            $_db, $_db.jvtFileConnectors)
        .filter(
            (f) => f.jvtFileCode.code.sqlEquals($_itemColumn<String>('code')!));

    final cache =
        $_typedResult.readTableOrNull(_jvtFileConnectorsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$JvtFilesTableFilterComposer extends Composer<_$AppDb, $JvtFilesTable> {
  $$JvtFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get extension => $composableBuilder(
      column: $table.extension, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get downloaded => $composableBuilder(
      column: $table.downloaded, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get size => $composableBuilder(
      column: $table.size, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempt => $composableBuilder(
      column: $table.attempt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isNetworkImage => $composableBuilder(
      column: $table.isNetworkImage,
      builder: (column) => ColumnFilters(column));

  Expression<bool> jvtFileConnectorsRefs(
      Expression<bool> Function($$JvtFileConnectorsTableFilterComposer f) f) {
    final $$JvtFileConnectorsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.jvtFileConnectors,
        getReferencedColumn: (t) => t.jvtFileCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JvtFileConnectorsTableFilterComposer(
              $db: $db,
              $table: $db.jvtFileConnectors,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$JvtFilesTableOrderingComposer
    extends Composer<_$AppDb, $JvtFilesTable> {
  $$JvtFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extension => $composableBuilder(
      column: $table.extension, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get downloaded => $composableBuilder(
      column: $table.downloaded, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get size => $composableBuilder(
      column: $table.size, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempt => $composableBuilder(
      column: $table.attempt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isNetworkImage => $composableBuilder(
      column: $table.isNetworkImage,
      builder: (column) => ColumnOrderings(column));
}

class $$JvtFilesTableAnnotationComposer
    extends Composer<_$AppDb, $JvtFilesTable> {
  $$JvtFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get extension =>
      $composableBuilder(column: $table.extension, builder: (column) => column);

  GeneratedColumn<int> get downloaded => $composableBuilder(
      column: $table.downloaded, builder: (column) => column);

  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<int> get attempt =>
      $composableBuilder(column: $table.attempt, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get isNetworkImage => $composableBuilder(
      column: $table.isNetworkImage, builder: (column) => column);

  Expression<T> jvtFileConnectorsRefs<T extends Object>(
      Expression<T> Function($$JvtFileConnectorsTableAnnotationComposer a) f) {
    final $$JvtFileConnectorsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.code,
            referencedTable: $db.jvtFileConnectors,
            getReferencedColumn: (t) => t.jvtFileCode,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$JvtFileConnectorsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.jvtFileConnectors,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$JvtFilesTableTableManager extends RootTableManager<
    _$AppDb,
    $JvtFilesTable,
    JvtFile,
    $$JvtFilesTableFilterComposer,
    $$JvtFilesTableOrderingComposer,
    $$JvtFilesTableAnnotationComposer,
    $$JvtFilesTableCreateCompanionBuilder,
    $$JvtFilesTableUpdateCompanionBuilder,
    (JvtFile, $$JvtFilesTableReferences),
    JvtFile,
    PrefetchHooks Function({bool jvtFileConnectorsRefs})> {
  $$JvtFilesTableTableManager(_$AppDb db, $JvtFilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JvtFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JvtFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JvtFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> mode = const Value.absent(),
            Value<String> extension = const Value.absent(),
            Value<int> downloaded = const Value.absent(),
            Value<int> size = const Value.absent(),
            Value<int> attempt = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<bool?> isNetworkImage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JvtFilesCompanion(
            code: code,
            name: name,
            mode: mode,
            extension: extension,
            downloaded: downloaded,
            size: size,
            attempt: attempt,
            priority: priority,
            isNetworkImage: isNetworkImage,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String name,
            required int mode,
            required String extension,
            Value<int> downloaded = const Value.absent(),
            required int size,
            Value<int> attempt = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<bool?> isNetworkImage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JvtFilesCompanion.insert(
            code: code,
            name: name,
            mode: mode,
            extension: extension,
            downloaded: downloaded,
            size: size,
            attempt: attempt,
            priority: priority,
            isNetworkImage: isNetworkImage,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$JvtFilesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({jvtFileConnectorsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (jvtFileConnectorsRefs) db.jvtFileConnectors
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (jvtFileConnectorsRefs)
                    await $_getPrefetchedData<JvtFile, $JvtFilesTable,
                            JvtFileConnector>(
                        currentTable: table,
                        referencedTable: $$JvtFilesTableReferences
                            ._jvtFileConnectorsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$JvtFilesTableReferences(db, table, p0)
                                .jvtFileConnectorsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.jvtFileCode == item.code),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$JvtFilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $JvtFilesTable,
    JvtFile,
    $$JvtFilesTableFilterComposer,
    $$JvtFilesTableOrderingComposer,
    $$JvtFilesTableAnnotationComposer,
    $$JvtFilesTableCreateCompanionBuilder,
    $$JvtFilesTableUpdateCompanionBuilder,
    (JvtFile, $$JvtFilesTableReferences),
    JvtFile,
    PrefetchHooks Function({bool jvtFileConnectorsRefs})>;
typedef $$JvtFileConnectorsTableCreateCompanionBuilder
    = JvtFileConnectorsCompanion Function({
  required String code,
  required String ableCode,
  required String ableType,
  Value<String?> tag,
  required String jvtFileCode,
  Value<int> rowid,
});
typedef $$JvtFileConnectorsTableUpdateCompanionBuilder
    = JvtFileConnectorsCompanion Function({
  Value<String> code,
  Value<String> ableCode,
  Value<String> ableType,
  Value<String?> tag,
  Value<String> jvtFileCode,
  Value<int> rowid,
});

final class $$JvtFileConnectorsTableReferences
    extends BaseReferences<_$AppDb, $JvtFileConnectorsTable, JvtFileConnector> {
  $$JvtFileConnectorsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $JvtFilesTable _jvtFileCodeTable(_$AppDb db) =>
      db.jvtFiles.createAlias($_aliasNameGenerator(
          db.jvtFileConnectors.jvtFileCode, db.jvtFiles.code));

  $$JvtFilesTableProcessedTableManager get jvtFileCode {
    final $_column = $_itemColumn<String>('jvt_file_code')!;

    final manager = $$JvtFilesTableTableManager($_db, $_db.jvtFiles)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_jvtFileCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$JvtFileConnectorsTableFilterComposer
    extends Composer<_$AppDb, $JvtFileConnectorsTable> {
  $$JvtFileConnectorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ableCode => $composableBuilder(
      column: $table.ableCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ableType => $composableBuilder(
      column: $table.ableType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tag => $composableBuilder(
      column: $table.tag, builder: (column) => ColumnFilters(column));

  $$JvtFilesTableFilterComposer get jvtFileCode {
    final $$JvtFilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.jvtFileCode,
        referencedTable: $db.jvtFiles,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JvtFilesTableFilterComposer(
              $db: $db,
              $table: $db.jvtFiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$JvtFileConnectorsTableOrderingComposer
    extends Composer<_$AppDb, $JvtFileConnectorsTable> {
  $$JvtFileConnectorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ableCode => $composableBuilder(
      column: $table.ableCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ableType => $composableBuilder(
      column: $table.ableType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tag => $composableBuilder(
      column: $table.tag, builder: (column) => ColumnOrderings(column));

  $$JvtFilesTableOrderingComposer get jvtFileCode {
    final $$JvtFilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.jvtFileCode,
        referencedTable: $db.jvtFiles,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JvtFilesTableOrderingComposer(
              $db: $db,
              $table: $db.jvtFiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$JvtFileConnectorsTableAnnotationComposer
    extends Composer<_$AppDb, $JvtFileConnectorsTable> {
  $$JvtFileConnectorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get ableCode =>
      $composableBuilder(column: $table.ableCode, builder: (column) => column);

  GeneratedColumn<String> get ableType =>
      $composableBuilder(column: $table.ableType, builder: (column) => column);

  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);

  $$JvtFilesTableAnnotationComposer get jvtFileCode {
    final $$JvtFilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.jvtFileCode,
        referencedTable: $db.jvtFiles,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$JvtFilesTableAnnotationComposer(
              $db: $db,
              $table: $db.jvtFiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$JvtFileConnectorsTableTableManager extends RootTableManager<
    _$AppDb,
    $JvtFileConnectorsTable,
    JvtFileConnector,
    $$JvtFileConnectorsTableFilterComposer,
    $$JvtFileConnectorsTableOrderingComposer,
    $$JvtFileConnectorsTableAnnotationComposer,
    $$JvtFileConnectorsTableCreateCompanionBuilder,
    $$JvtFileConnectorsTableUpdateCompanionBuilder,
    (JvtFileConnector, $$JvtFileConnectorsTableReferences),
    JvtFileConnector,
    PrefetchHooks Function({bool jvtFileCode})> {
  $$JvtFileConnectorsTableTableManager(
      _$AppDb db, $JvtFileConnectorsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JvtFileConnectorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JvtFileConnectorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JvtFileConnectorsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> ableCode = const Value.absent(),
            Value<String> ableType = const Value.absent(),
            Value<String?> tag = const Value.absent(),
            Value<String> jvtFileCode = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JvtFileConnectorsCompanion(
            code: code,
            ableCode: ableCode,
            ableType: ableType,
            tag: tag,
            jvtFileCode: jvtFileCode,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String ableCode,
            required String ableType,
            Value<String?> tag = const Value.absent(),
            required String jvtFileCode,
            Value<int> rowid = const Value.absent(),
          }) =>
              JvtFileConnectorsCompanion.insert(
            code: code,
            ableCode: ableCode,
            ableType: ableType,
            tag: tag,
            jvtFileCode: jvtFileCode,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$JvtFileConnectorsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({jvtFileCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (jvtFileCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.jvtFileCode,
                    referencedTable: $$JvtFileConnectorsTableReferences
                        ._jvtFileCodeTable(db),
                    referencedColumn: $$JvtFileConnectorsTableReferences
                        ._jvtFileCodeTable(db)
                        .code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$JvtFileConnectorsTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $JvtFileConnectorsTable,
    JvtFileConnector,
    $$JvtFileConnectorsTableFilterComposer,
    $$JvtFileConnectorsTableOrderingComposer,
    $$JvtFileConnectorsTableAnnotationComposer,
    $$JvtFileConnectorsTableCreateCompanionBuilder,
    $$JvtFileConnectorsTableUpdateCompanionBuilder,
    (JvtFileConnector, $$JvtFileConnectorsTableReferences),
    JvtFileConnector,
    PrefetchHooks Function({bool jvtFileCode})>;
typedef $$FoldersTableCreateCompanionBuilder = FoldersCompanion Function({
  required String code,
  required String name,
  Value<String?> parentCode,
  required String eventCode,
  Value<String?> size,
  Value<bool?> published,
  Value<bool?> submitted,
  Value<int> lastUpdatedAt,
  Value<int> rowid,
});
typedef $$FoldersTableUpdateCompanionBuilder = FoldersCompanion Function({
  Value<String> code,
  Value<String> name,
  Value<String?> parentCode,
  Value<String> eventCode,
  Value<String?> size,
  Value<bool?> published,
  Value<bool?> submitted,
  Value<int> lastUpdatedAt,
  Value<int> rowid,
});

final class $$FoldersTableReferences
    extends BaseReferences<_$AppDb, $FoldersTable, Folder> {
  $$FoldersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventCodeTable(_$AppDb db) => db.events
      .createAlias($_aliasNameGenerator(db.folders.eventCode, db.events.code));

  $$EventsTableProcessedTableManager get eventCode {
    final $_column = $_itemColumn<String>('event_code')!;

    final manager = $$EventsTableTableManager($_db, $_db.events)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$FolderStatusesTable, List<FolderStatuse>>
      _folderStatusesRefsTable(_$AppDb db) =>
          MultiTypedResultKey.fromTable(db.folderStatuses,
              aliasName: $_aliasNameGenerator(
                  db.folders.code, db.folderStatuses.folderCode));

  $$FolderStatusesTableProcessedTableManager get folderStatusesRefs {
    final manager = $$FolderStatusesTableTableManager($_db, $_db.folderStatuses)
        .filter(
            (f) => f.folderCode.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_folderStatusesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$FolderRulesTable, List<FolderRule>>
      _folderRulesRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
          db.folderRules,
          aliasName:
              $_aliasNameGenerator(db.folders.code, db.folderRules.folderCode));

  $$FolderRulesTableProcessedTableManager get folderRulesRefs {
    final manager = $$FolderRulesTableTableManager($_db, $_db.folderRules)
        .filter(
            (f) => f.folderCode.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_folderRulesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PhotoSelectionImagesTable,
      List<PhotoSelectionImage>> _photoSelectionImagesRefsTable(
          _$AppDb db) =>
      MultiTypedResultKey.fromTable(db.photoSelectionImages,
          aliasName: $_aliasNameGenerator(
              db.folders.code, db.photoSelectionImages.folderCode));

  $$PhotoSelectionImagesTableProcessedTableManager
      get photoSelectionImagesRefs {
    final manager = $$PhotoSelectionImagesTableTableManager(
            $_db, $_db.photoSelectionImages)
        .filter(
            (f) => f.folderCode.code.sqlEquals($_itemColumn<String>('code')!));

    final cache =
        $_typedResult.readTableOrNull(_photoSelectionImagesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$FoldersTableFilterComposer extends Composer<_$AppDb, $FoldersTable> {
  $$FoldersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentCode => $composableBuilder(
      column: $table.parentCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get size => $composableBuilder(
      column: $table.size, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get published => $composableBuilder(
      column: $table.published, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get submitted => $composableBuilder(
      column: $table.submitted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => ColumnFilters(column));

  $$EventsTableFilterComposer get eventCode {
    final $$EventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventCode,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableFilterComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> folderStatusesRefs(
      Expression<bool> Function($$FolderStatusesTableFilterComposer f) f) {
    final $$FolderStatusesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.folderStatuses,
        getReferencedColumn: (t) => t.folderCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FolderStatusesTableFilterComposer(
              $db: $db,
              $table: $db.folderStatuses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> folderRulesRefs(
      Expression<bool> Function($$FolderRulesTableFilterComposer f) f) {
    final $$FolderRulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.folderRules,
        getReferencedColumn: (t) => t.folderCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FolderRulesTableFilterComposer(
              $db: $db,
              $table: $db.folderRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> photoSelectionImagesRefs(
      Expression<bool> Function($$PhotoSelectionImagesTableFilterComposer f)
          f) {
    final $$PhotoSelectionImagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.photoSelectionImages,
        getReferencedColumn: (t) => t.folderCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PhotoSelectionImagesTableFilterComposer(
              $db: $db,
              $table: $db.photoSelectionImages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$FoldersTableOrderingComposer extends Composer<_$AppDb, $FoldersTable> {
  $$FoldersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentCode => $composableBuilder(
      column: $table.parentCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get size => $composableBuilder(
      column: $table.size, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get published => $composableBuilder(
      column: $table.published, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get submitted => $composableBuilder(
      column: $table.submitted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  $$EventsTableOrderingComposer get eventCode {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventCode,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableOrderingComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FoldersTableAnnotationComposer
    extends Composer<_$AppDb, $FoldersTable> {
  $$FoldersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentCode => $composableBuilder(
      column: $table.parentCode, builder: (column) => column);

  GeneratedColumn<String> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<bool> get published =>
      $composableBuilder(column: $table.published, builder: (column) => column);

  GeneratedColumn<bool> get submitted =>
      $composableBuilder(column: $table.submitted, builder: (column) => column);

  GeneratedColumn<int> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventCode {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventCode,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableAnnotationComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> folderStatusesRefs<T extends Object>(
      Expression<T> Function($$FolderStatusesTableAnnotationComposer a) f) {
    final $$FolderStatusesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.folderStatuses,
        getReferencedColumn: (t) => t.folderCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FolderStatusesTableAnnotationComposer(
              $db: $db,
              $table: $db.folderStatuses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> folderRulesRefs<T extends Object>(
      Expression<T> Function($$FolderRulesTableAnnotationComposer a) f) {
    final $$FolderRulesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.folderRules,
        getReferencedColumn: (t) => t.folderCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FolderRulesTableAnnotationComposer(
              $db: $db,
              $table: $db.folderRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> photoSelectionImagesRefs<T extends Object>(
      Expression<T> Function($$PhotoSelectionImagesTableAnnotationComposer a)
          f) {
    final $$PhotoSelectionImagesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.code,
            referencedTable: $db.photoSelectionImages,
            getReferencedColumn: (t) => t.folderCode,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PhotoSelectionImagesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.photoSelectionImages,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$FoldersTableTableManager extends RootTableManager<
    _$AppDb,
    $FoldersTable,
    Folder,
    $$FoldersTableFilterComposer,
    $$FoldersTableOrderingComposer,
    $$FoldersTableAnnotationComposer,
    $$FoldersTableCreateCompanionBuilder,
    $$FoldersTableUpdateCompanionBuilder,
    (Folder, $$FoldersTableReferences),
    Folder,
    PrefetchHooks Function(
        {bool eventCode,
        bool folderStatusesRefs,
        bool folderRulesRefs,
        bool photoSelectionImagesRefs})> {
  $$FoldersTableTableManager(_$AppDb db, $FoldersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoldersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoldersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> parentCode = const Value.absent(),
            Value<String> eventCode = const Value.absent(),
            Value<String?> size = const Value.absent(),
            Value<bool?> published = const Value.absent(),
            Value<bool?> submitted = const Value.absent(),
            Value<int> lastUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FoldersCompanion(
            code: code,
            name: name,
            parentCode: parentCode,
            eventCode: eventCode,
            size: size,
            published: published,
            submitted: submitted,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String name,
            Value<String?> parentCode = const Value.absent(),
            required String eventCode,
            Value<String?> size = const Value.absent(),
            Value<bool?> published = const Value.absent(),
            Value<bool?> submitted = const Value.absent(),
            Value<int> lastUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FoldersCompanion.insert(
            code: code,
            name: name,
            parentCode: parentCode,
            eventCode: eventCode,
            size: size,
            published: published,
            submitted: submitted,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$FoldersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {eventCode = false,
              folderStatusesRefs = false,
              folderRulesRefs = false,
              photoSelectionImagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (folderStatusesRefs) db.folderStatuses,
                if (folderRulesRefs) db.folderRules,
                if (photoSelectionImagesRefs) db.photoSelectionImages
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (eventCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.eventCode,
                    referencedTable:
                        $$FoldersTableReferences._eventCodeTable(db),
                    referencedColumn:
                        $$FoldersTableReferences._eventCodeTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (folderStatusesRefs)
                    await $_getPrefetchedData<Folder, $FoldersTable,
                            FolderStatuse>(
                        currentTable: table,
                        referencedTable: $$FoldersTableReferences
                            ._folderStatusesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FoldersTableReferences(db, table, p0)
                                .folderStatusesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.folderCode == item.code),
                        typedResults: items),
                  if (folderRulesRefs)
                    await $_getPrefetchedData<Folder, $FoldersTable,
                            FolderRule>(
                        currentTable: table,
                        referencedTable:
                            $$FoldersTableReferences._folderRulesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FoldersTableReferences(db, table, p0)
                                .folderRulesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.folderCode == item.code),
                        typedResults: items),
                  if (photoSelectionImagesRefs)
                    await $_getPrefetchedData<Folder, $FoldersTable,
                            PhotoSelectionImage>(
                        currentTable: table,
                        referencedTable: $$FoldersTableReferences
                            ._photoSelectionImagesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FoldersTableReferences(db, table, p0)
                                .photoSelectionImagesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.folderCode == item.code),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$FoldersTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $FoldersTable,
    Folder,
    $$FoldersTableFilterComposer,
    $$FoldersTableOrderingComposer,
    $$FoldersTableAnnotationComposer,
    $$FoldersTableCreateCompanionBuilder,
    $$FoldersTableUpdateCompanionBuilder,
    (Folder, $$FoldersTableReferences),
    Folder,
    PrefetchHooks Function(
        {bool eventCode,
        bool folderStatusesRefs,
        bool folderRulesRefs,
        bool photoSelectionImagesRefs})>;
typedef $$FolderStatusesTableCreateCompanionBuilder = FolderStatusesCompanion
    Function({
  Value<int> id,
  required String folderCode,
  required bool combined,
  required int selected,
  required int rejected,
  required int waitingListed,
});
typedef $$FolderStatusesTableUpdateCompanionBuilder = FolderStatusesCompanion
    Function({
  Value<int> id,
  Value<String> folderCode,
  Value<bool> combined,
  Value<int> selected,
  Value<int> rejected,
  Value<int> waitingListed,
});

final class $$FolderStatusesTableReferences
    extends BaseReferences<_$AppDb, $FolderStatusesTable, FolderStatuse> {
  $$FolderStatusesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $FoldersTable _folderCodeTable(_$AppDb db) => db.folders.createAlias(
      $_aliasNameGenerator(db.folderStatuses.folderCode, db.folders.code));

  $$FoldersTableProcessedTableManager get folderCode {
    final $_column = $_itemColumn<String>('folder_code')!;

    final manager = $$FoldersTableTableManager($_db, $_db.folders)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$FolderStatusesTableFilterComposer
    extends Composer<_$AppDb, $FolderStatusesTable> {
  $$FolderStatusesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get combined => $composableBuilder(
      column: $table.combined, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get selected => $composableBuilder(
      column: $table.selected, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rejected => $composableBuilder(
      column: $table.rejected, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get waitingListed => $composableBuilder(
      column: $table.waitingListed, builder: (column) => ColumnFilters(column));

  $$FoldersTableFilterComposer get folderCode {
    final $$FoldersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.folderCode,
        referencedTable: $db.folders,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoldersTableFilterComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FolderStatusesTableOrderingComposer
    extends Composer<_$AppDb, $FolderStatusesTable> {
  $$FolderStatusesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get combined => $composableBuilder(
      column: $table.combined, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get selected => $composableBuilder(
      column: $table.selected, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rejected => $composableBuilder(
      column: $table.rejected, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get waitingListed => $composableBuilder(
      column: $table.waitingListed,
      builder: (column) => ColumnOrderings(column));

  $$FoldersTableOrderingComposer get folderCode {
    final $$FoldersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.folderCode,
        referencedTable: $db.folders,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoldersTableOrderingComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FolderStatusesTableAnnotationComposer
    extends Composer<_$AppDb, $FolderStatusesTable> {
  $$FolderStatusesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get combined =>
      $composableBuilder(column: $table.combined, builder: (column) => column);

  GeneratedColumn<int> get selected =>
      $composableBuilder(column: $table.selected, builder: (column) => column);

  GeneratedColumn<int> get rejected =>
      $composableBuilder(column: $table.rejected, builder: (column) => column);

  GeneratedColumn<int> get waitingListed => $composableBuilder(
      column: $table.waitingListed, builder: (column) => column);

  $$FoldersTableAnnotationComposer get folderCode {
    final $$FoldersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.folderCode,
        referencedTable: $db.folders,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoldersTableAnnotationComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FolderStatusesTableTableManager extends RootTableManager<
    _$AppDb,
    $FolderStatusesTable,
    FolderStatuse,
    $$FolderStatusesTableFilterComposer,
    $$FolderStatusesTableOrderingComposer,
    $$FolderStatusesTableAnnotationComposer,
    $$FolderStatusesTableCreateCompanionBuilder,
    $$FolderStatusesTableUpdateCompanionBuilder,
    (FolderStatuse, $$FolderStatusesTableReferences),
    FolderStatuse,
    PrefetchHooks Function({bool folderCode})> {
  $$FolderStatusesTableTableManager(_$AppDb db, $FolderStatusesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FolderStatusesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FolderStatusesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FolderStatusesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> folderCode = const Value.absent(),
            Value<bool> combined = const Value.absent(),
            Value<int> selected = const Value.absent(),
            Value<int> rejected = const Value.absent(),
            Value<int> waitingListed = const Value.absent(),
          }) =>
              FolderStatusesCompanion(
            id: id,
            folderCode: folderCode,
            combined: combined,
            selected: selected,
            rejected: rejected,
            waitingListed: waitingListed,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String folderCode,
            required bool combined,
            required int selected,
            required int rejected,
            required int waitingListed,
          }) =>
              FolderStatusesCompanion.insert(
            id: id,
            folderCode: folderCode,
            combined: combined,
            selected: selected,
            rejected: rejected,
            waitingListed: waitingListed,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$FolderStatusesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({folderCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (folderCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.folderCode,
                    referencedTable:
                        $$FolderStatusesTableReferences._folderCodeTable(db),
                    referencedColumn: $$FolderStatusesTableReferences
                        ._folderCodeTable(db)
                        .code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$FolderStatusesTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $FolderStatusesTable,
    FolderStatuse,
    $$FolderStatusesTableFilterComposer,
    $$FolderStatusesTableOrderingComposer,
    $$FolderStatusesTableAnnotationComposer,
    $$FolderStatusesTableCreateCompanionBuilder,
    $$FolderStatusesTableUpdateCompanionBuilder,
    (FolderStatuse, $$FolderStatusesTableReferences),
    FolderStatuse,
    PrefetchHooks Function({bool folderCode})>;
typedef $$FolderRulesTableCreateCompanionBuilder = FolderRulesCompanion
    Function({
  required String code,
  required String folderCode,
  required int minimumSelectionImages,
  required int maximumSelectionImages,
  required int result,
  Value<int> rowid,
});
typedef $$FolderRulesTableUpdateCompanionBuilder = FolderRulesCompanion
    Function({
  Value<String> code,
  Value<String> folderCode,
  Value<int> minimumSelectionImages,
  Value<int> maximumSelectionImages,
  Value<int> result,
  Value<int> rowid,
});

final class $$FolderRulesTableReferences
    extends BaseReferences<_$AppDb, $FolderRulesTable, FolderRule> {
  $$FolderRulesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FoldersTable _folderCodeTable(_$AppDb db) => db.folders.createAlias(
      $_aliasNameGenerator(db.folderRules.folderCode, db.folders.code));

  $$FoldersTableProcessedTableManager get folderCode {
    final $_column = $_itemColumn<String>('folder_code')!;

    final manager = $$FoldersTableTableManager($_db, $_db.folders)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$FolderRulesTableFilterComposer
    extends Composer<_$AppDb, $FolderRulesTable> {
  $$FolderRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minimumSelectionImages => $composableBuilder(
      column: $table.minimumSelectionImages,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maximumSelectionImages => $composableBuilder(
      column: $table.maximumSelectionImages,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnFilters(column));

  $$FoldersTableFilterComposer get folderCode {
    final $$FoldersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.folderCode,
        referencedTable: $db.folders,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoldersTableFilterComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FolderRulesTableOrderingComposer
    extends Composer<_$AppDb, $FolderRulesTable> {
  $$FolderRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minimumSelectionImages => $composableBuilder(
      column: $table.minimumSelectionImages,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maximumSelectionImages => $composableBuilder(
      column: $table.maximumSelectionImages,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get result => $composableBuilder(
      column: $table.result, builder: (column) => ColumnOrderings(column));

  $$FoldersTableOrderingComposer get folderCode {
    final $$FoldersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.folderCode,
        referencedTable: $db.folders,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoldersTableOrderingComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FolderRulesTableAnnotationComposer
    extends Composer<_$AppDb, $FolderRulesTable> {
  $$FolderRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get minimumSelectionImages => $composableBuilder(
      column: $table.minimumSelectionImages, builder: (column) => column);

  GeneratedColumn<int> get maximumSelectionImages => $composableBuilder(
      column: $table.maximumSelectionImages, builder: (column) => column);

  GeneratedColumn<int> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  $$FoldersTableAnnotationComposer get folderCode {
    final $$FoldersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.folderCode,
        referencedTable: $db.folders,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoldersTableAnnotationComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FolderRulesTableTableManager extends RootTableManager<
    _$AppDb,
    $FolderRulesTable,
    FolderRule,
    $$FolderRulesTableFilterComposer,
    $$FolderRulesTableOrderingComposer,
    $$FolderRulesTableAnnotationComposer,
    $$FolderRulesTableCreateCompanionBuilder,
    $$FolderRulesTableUpdateCompanionBuilder,
    (FolderRule, $$FolderRulesTableReferences),
    FolderRule,
    PrefetchHooks Function({bool folderCode})> {
  $$FolderRulesTableTableManager(_$AppDb db, $FolderRulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FolderRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FolderRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FolderRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> folderCode = const Value.absent(),
            Value<int> minimumSelectionImages = const Value.absent(),
            Value<int> maximumSelectionImages = const Value.absent(),
            Value<int> result = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FolderRulesCompanion(
            code: code,
            folderCode: folderCode,
            minimumSelectionImages: minimumSelectionImages,
            maximumSelectionImages: maximumSelectionImages,
            result: result,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String folderCode,
            required int minimumSelectionImages,
            required int maximumSelectionImages,
            required int result,
            Value<int> rowid = const Value.absent(),
          }) =>
              FolderRulesCompanion.insert(
            code: code,
            folderCode: folderCode,
            minimumSelectionImages: minimumSelectionImages,
            maximumSelectionImages: maximumSelectionImages,
            result: result,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$FolderRulesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({folderCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (folderCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.folderCode,
                    referencedTable:
                        $$FolderRulesTableReferences._folderCodeTable(db),
                    referencedColumn:
                        $$FolderRulesTableReferences._folderCodeTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$FolderRulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $FolderRulesTable,
    FolderRule,
    $$FolderRulesTableFilterComposer,
    $$FolderRulesTableOrderingComposer,
    $$FolderRulesTableAnnotationComposer,
    $$FolderRulesTableCreateCompanionBuilder,
    $$FolderRulesTableUpdateCompanionBuilder,
    (FolderRule, $$FolderRulesTableReferences),
    FolderRule,
    PrefetchHooks Function({bool folderCode})>;
typedef $$PhotoSelectionImagesTableCreateCompanionBuilder
    = PhotoSelectionImagesCompanion Function({
  required String code,
  required int lastUpdated,
  required String folderCode,
  required int status,
  Value<bool> synced,
  required String comment,
  required int rating,
  Value<String?> originalName,
  Value<int> rowid,
});
typedef $$PhotoSelectionImagesTableUpdateCompanionBuilder
    = PhotoSelectionImagesCompanion Function({
  Value<String> code,
  Value<int> lastUpdated,
  Value<String> folderCode,
  Value<int> status,
  Value<bool> synced,
  Value<String> comment,
  Value<int> rating,
  Value<String?> originalName,
  Value<int> rowid,
});

final class $$PhotoSelectionImagesTableReferences extends BaseReferences<
    _$AppDb, $PhotoSelectionImagesTable, PhotoSelectionImage> {
  $$PhotoSelectionImagesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $FoldersTable _folderCodeTable(_$AppDb db) =>
      db.folders.createAlias($_aliasNameGenerator(
          db.photoSelectionImages.folderCode, db.folders.code));

  $$FoldersTableProcessedTableManager get folderCode {
    final $_column = $_itemColumn<String>('folder_code')!;

    final manager = $$FoldersTableTableManager($_db, $_db.folders)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PhotoSelectionImagesTableFilterComposer
    extends Composer<_$AppDb, $PhotoSelectionImagesTable> {
  $$PhotoSelectionImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originalName => $composableBuilder(
      column: $table.originalName, builder: (column) => ColumnFilters(column));

  $$FoldersTableFilterComposer get folderCode {
    final $$FoldersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.folderCode,
        referencedTable: $db.folders,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoldersTableFilterComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PhotoSelectionImagesTableOrderingComposer
    extends Composer<_$AppDb, $PhotoSelectionImagesTable> {
  $$PhotoSelectionImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalName => $composableBuilder(
      column: $table.originalName,
      builder: (column) => ColumnOrderings(column));

  $$FoldersTableOrderingComposer get folderCode {
    final $$FoldersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.folderCode,
        referencedTable: $db.folders,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoldersTableOrderingComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PhotoSelectionImagesTableAnnotationComposer
    extends Composer<_$AppDb, $PhotoSelectionImagesTable> {
  $$PhotoSelectionImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get originalName => $composableBuilder(
      column: $table.originalName, builder: (column) => column);

  $$FoldersTableAnnotationComposer get folderCode {
    final $$FoldersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.folderCode,
        referencedTable: $db.folders,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoldersTableAnnotationComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PhotoSelectionImagesTableTableManager extends RootTableManager<
    _$AppDb,
    $PhotoSelectionImagesTable,
    PhotoSelectionImage,
    $$PhotoSelectionImagesTableFilterComposer,
    $$PhotoSelectionImagesTableOrderingComposer,
    $$PhotoSelectionImagesTableAnnotationComposer,
    $$PhotoSelectionImagesTableCreateCompanionBuilder,
    $$PhotoSelectionImagesTableUpdateCompanionBuilder,
    (PhotoSelectionImage, $$PhotoSelectionImagesTableReferences),
    PhotoSelectionImage,
    PrefetchHooks Function({bool folderCode})> {
  $$PhotoSelectionImagesTableTableManager(
      _$AppDb db, $PhotoSelectionImagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotoSelectionImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotoSelectionImagesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotoSelectionImagesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<int> lastUpdated = const Value.absent(),
            Value<String> folderCode = const Value.absent(),
            Value<int> status = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<String> comment = const Value.absent(),
            Value<int> rating = const Value.absent(),
            Value<String?> originalName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PhotoSelectionImagesCompanion(
            code: code,
            lastUpdated: lastUpdated,
            folderCode: folderCode,
            status: status,
            synced: synced,
            comment: comment,
            rating: rating,
            originalName: originalName,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required int lastUpdated,
            required String folderCode,
            required int status,
            Value<bool> synced = const Value.absent(),
            required String comment,
            required int rating,
            Value<String?> originalName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PhotoSelectionImagesCompanion.insert(
            code: code,
            lastUpdated: lastUpdated,
            folderCode: folderCode,
            status: status,
            synced: synced,
            comment: comment,
            rating: rating,
            originalName: originalName,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PhotoSelectionImagesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({folderCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (folderCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.folderCode,
                    referencedTable: $$PhotoSelectionImagesTableReferences
                        ._folderCodeTable(db),
                    referencedColumn: $$PhotoSelectionImagesTableReferences
                        ._folderCodeTable(db)
                        .code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PhotoSelectionImagesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDb,
        $PhotoSelectionImagesTable,
        PhotoSelectionImage,
        $$PhotoSelectionImagesTableFilterComposer,
        $$PhotoSelectionImagesTableOrderingComposer,
        $$PhotoSelectionImagesTableAnnotationComposer,
        $$PhotoSelectionImagesTableCreateCompanionBuilder,
        $$PhotoSelectionImagesTableUpdateCompanionBuilder,
        (PhotoSelectionImage, $$PhotoSelectionImagesTableReferences),
        PhotoSelectionImage,
        PrefetchHooks Function({bool folderCode})>;
typedef $$EventInfoTableCreateCompanionBuilder = EventInfoCompanion Function({
  Value<int> id,
  required String eventCode,
  required String value,
});
typedef $$EventInfoTableUpdateCompanionBuilder = EventInfoCompanion Function({
  Value<int> id,
  Value<String> eventCode,
  Value<String> value,
});

final class $$EventInfoTableReferences
    extends BaseReferences<_$AppDb, $EventInfoTable, EventInfoData> {
  $$EventInfoTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventCodeTable(_$AppDb db) => db.events.createAlias(
      $_aliasNameGenerator(db.eventInfo.eventCode, db.events.code));

  $$EventsTableProcessedTableManager get eventCode {
    final $_column = $_itemColumn<String>('event_code')!;

    final manager = $$EventsTableTableManager($_db, $_db.events)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EventInfoTableFilterComposer
    extends Composer<_$AppDb, $EventInfoTable> {
  $$EventInfoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  $$EventsTableFilterComposer get eventCode {
    final $$EventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventCode,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableFilterComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EventInfoTableOrderingComposer
    extends Composer<_$AppDb, $EventInfoTable> {
  $$EventInfoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  $$EventsTableOrderingComposer get eventCode {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventCode,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableOrderingComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EventInfoTableAnnotationComposer
    extends Composer<_$AppDb, $EventInfoTable> {
  $$EventInfoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventCode {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventCode,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableAnnotationComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EventInfoTableTableManager extends RootTableManager<
    _$AppDb,
    $EventInfoTable,
    EventInfoData,
    $$EventInfoTableFilterComposer,
    $$EventInfoTableOrderingComposer,
    $$EventInfoTableAnnotationComposer,
    $$EventInfoTableCreateCompanionBuilder,
    $$EventInfoTableUpdateCompanionBuilder,
    (EventInfoData, $$EventInfoTableReferences),
    EventInfoData,
    PrefetchHooks Function({bool eventCode})> {
  $$EventInfoTableTableManager(_$AppDb db, $EventInfoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventInfoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventInfoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventInfoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> eventCode = const Value.absent(),
            Value<String> value = const Value.absent(),
          }) =>
              EventInfoCompanion(
            id: id,
            eventCode: eventCode,
            value: value,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String eventCode,
            required String value,
          }) =>
              EventInfoCompanion.insert(
            id: id,
            eventCode: eventCode,
            value: value,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EventInfoTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({eventCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (eventCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.eventCode,
                    referencedTable:
                        $$EventInfoTableReferences._eventCodeTable(db),
                    referencedColumn:
                        $$EventInfoTableReferences._eventCodeTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EventInfoTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $EventInfoTable,
    EventInfoData,
    $$EventInfoTableFilterComposer,
    $$EventInfoTableOrderingComposer,
    $$EventInfoTableAnnotationComposer,
    $$EventInfoTableCreateCompanionBuilder,
    $$EventInfoTableUpdateCompanionBuilder,
    (EventInfoData, $$EventInfoTableReferences),
    EventInfoData,
    PrefetchHooks Function({bool eventCode})>;
typedef $$StudioPackageTableCreateCompanionBuilder = StudioPackageCompanion
    Function({
  required String code,
  Value<String?> name,
  Value<String?> description,
  Value<bool?> published,
  Value<int?> price,
  Value<int?> discountValue,
  Value<int?> discountTerm,
  Value<int> rowid,
});
typedef $$StudioPackageTableUpdateCompanionBuilder = StudioPackageCompanion
    Function({
  Value<String> code,
  Value<String?> name,
  Value<String?> description,
  Value<bool?> published,
  Value<int?> price,
  Value<int?> discountValue,
  Value<int?> discountTerm,
  Value<int> rowid,
});

class $$StudioPackageTableFilterComposer
    extends Composer<_$AppDb, $StudioPackageTable> {
  $$StudioPackageTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get published => $composableBuilder(
      column: $table.published, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get discountValue => $composableBuilder(
      column: $table.discountValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get discountTerm => $composableBuilder(
      column: $table.discountTerm, builder: (column) => ColumnFilters(column));
}

class $$StudioPackageTableOrderingComposer
    extends Composer<_$AppDb, $StudioPackageTable> {
  $$StudioPackageTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get published => $composableBuilder(
      column: $table.published, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get discountValue => $composableBuilder(
      column: $table.discountValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get discountTerm => $composableBuilder(
      column: $table.discountTerm,
      builder: (column) => ColumnOrderings(column));
}

class $$StudioPackageTableAnnotationComposer
    extends Composer<_$AppDb, $StudioPackageTable> {
  $$StudioPackageTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<bool> get published =>
      $composableBuilder(column: $table.published, builder: (column) => column);

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get discountValue => $composableBuilder(
      column: $table.discountValue, builder: (column) => column);

  GeneratedColumn<int> get discountTerm => $composableBuilder(
      column: $table.discountTerm, builder: (column) => column);
}

class $$StudioPackageTableTableManager extends RootTableManager<
    _$AppDb,
    $StudioPackageTable,
    StudioPackageData,
    $$StudioPackageTableFilterComposer,
    $$StudioPackageTableOrderingComposer,
    $$StudioPackageTableAnnotationComposer,
    $$StudioPackageTableCreateCompanionBuilder,
    $$StudioPackageTableUpdateCompanionBuilder,
    (
      StudioPackageData,
      BaseReferences<_$AppDb, $StudioPackageTable, StudioPackageData>
    ),
    StudioPackageData,
    PrefetchHooks Function()> {
  $$StudioPackageTableTableManager(_$AppDb db, $StudioPackageTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudioPackageTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudioPackageTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudioPackageTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<bool?> published = const Value.absent(),
            Value<int?> price = const Value.absent(),
            Value<int?> discountValue = const Value.absent(),
            Value<int?> discountTerm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudioPackageCompanion(
            code: code,
            name: name,
            description: description,
            published: published,
            price: price,
            discountValue: discountValue,
            discountTerm: discountTerm,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            Value<String?> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<bool?> published = const Value.absent(),
            Value<int?> price = const Value.absent(),
            Value<int?> discountValue = const Value.absent(),
            Value<int?> discountTerm = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudioPackageCompanion.insert(
            code: code,
            name: name,
            description: description,
            published: published,
            price: price,
            discountValue: discountValue,
            discountTerm: discountTerm,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StudioPackageTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $StudioPackageTable,
    StudioPackageData,
    $$StudioPackageTableFilterComposer,
    $$StudioPackageTableOrderingComposer,
    $$StudioPackageTableAnnotationComposer,
    $$StudioPackageTableCreateCompanionBuilder,
    $$StudioPackageTableUpdateCompanionBuilder,
    (
      StudioPackageData,
      BaseReferences<_$AppDb, $StudioPackageTable, StudioPackageData>
    ),
    StudioPackageData,
    PrefetchHooks Function()>;
typedef $$StudioPackageValueTableCreateCompanionBuilder
    = StudioPackageValueCompanion Function({
  required String code,
  required String key,
  required String value,
  required String ableCode,
  Value<int> rowid,
});
typedef $$StudioPackageValueTableUpdateCompanionBuilder
    = StudioPackageValueCompanion Function({
  Value<String> code,
  Value<String> key,
  Value<String> value,
  Value<String> ableCode,
  Value<int> rowid,
});

class $$StudioPackageValueTableFilterComposer
    extends Composer<_$AppDb, $StudioPackageValueTable> {
  $$StudioPackageValueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ableCode => $composableBuilder(
      column: $table.ableCode, builder: (column) => ColumnFilters(column));
}

class $$StudioPackageValueTableOrderingComposer
    extends Composer<_$AppDb, $StudioPackageValueTable> {
  $$StudioPackageValueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ableCode => $composableBuilder(
      column: $table.ableCode, builder: (column) => ColumnOrderings(column));
}

class $$StudioPackageValueTableAnnotationComposer
    extends Composer<_$AppDb, $StudioPackageValueTable> {
  $$StudioPackageValueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get ableCode =>
      $composableBuilder(column: $table.ableCode, builder: (column) => column);
}

class $$StudioPackageValueTableTableManager extends RootTableManager<
    _$AppDb,
    $StudioPackageValueTable,
    StudioPackageValueData,
    $$StudioPackageValueTableFilterComposer,
    $$StudioPackageValueTableOrderingComposer,
    $$StudioPackageValueTableAnnotationComposer,
    $$StudioPackageValueTableCreateCompanionBuilder,
    $$StudioPackageValueTableUpdateCompanionBuilder,
    (
      StudioPackageValueData,
      BaseReferences<_$AppDb, $StudioPackageValueTable, StudioPackageValueData>
    ),
    StudioPackageValueData,
    PrefetchHooks Function()> {
  $$StudioPackageValueTableTableManager(
      _$AppDb db, $StudioPackageValueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudioPackageValueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudioPackageValueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudioPackageValueTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<String> ableCode = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StudioPackageValueCompanion(
            code: code,
            key: key,
            value: value,
            ableCode: ableCode,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String key,
            required String value,
            required String ableCode,
            Value<int> rowid = const Value.absent(),
          }) =>
              StudioPackageValueCompanion.insert(
            code: code,
            key: key,
            value: value,
            ableCode: ableCode,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StudioPackageValueTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $StudioPackageValueTable,
    StudioPackageValueData,
    $$StudioPackageValueTableFilterComposer,
    $$StudioPackageValueTableOrderingComposer,
    $$StudioPackageValueTableAnnotationComposer,
    $$StudioPackageValueTableCreateCompanionBuilder,
    $$StudioPackageValueTableUpdateCompanionBuilder,
    (
      StudioPackageValueData,
      BaseReferences<_$AppDb, $StudioPackageValueTable, StudioPackageValueData>
    ),
    StudioPackageValueData,
    PrefetchHooks Function()>;
typedef $$VideosTableCreateCompanionBuilder = VideosCompanion Function({
  required String code,
  required String eventCode,
  required String name,
  required String url,
  required int priorityScore,
  Value<bool> published,
  Value<int?> visibility,
  Value<int> rowid,
});
typedef $$VideosTableUpdateCompanionBuilder = VideosCompanion Function({
  Value<String> code,
  Value<String> eventCode,
  Value<String> name,
  Value<String> url,
  Value<int> priorityScore,
  Value<bool> published,
  Value<int?> visibility,
  Value<int> rowid,
});

final class $$VideosTableReferences
    extends BaseReferences<_$AppDb, $VideosTable, Video> {
  $$VideosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventCodeTable(_$AppDb db) => db.events
      .createAlias($_aliasNameGenerator(db.videos.eventCode, db.events.code));

  $$EventsTableProcessedTableManager get eventCode {
    final $_column = $_itemColumn<String>('event_code')!;

    final manager = $$EventsTableTableManager($_db, $_db.events)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$VideosTableFilterComposer extends Composer<_$AppDb, $VideosTable> {
  $$VideosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priorityScore => $composableBuilder(
      column: $table.priorityScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get published => $composableBuilder(
      column: $table.published, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get visibility => $composableBuilder(
      column: $table.visibility, builder: (column) => ColumnFilters(column));

  $$EventsTableFilterComposer get eventCode {
    final $$EventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventCode,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableFilterComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$VideosTableOrderingComposer extends Composer<_$AppDb, $VideosTable> {
  $$VideosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priorityScore => $composableBuilder(
      column: $table.priorityScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get published => $composableBuilder(
      column: $table.published, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get visibility => $composableBuilder(
      column: $table.visibility, builder: (column) => ColumnOrderings(column));

  $$EventsTableOrderingComposer get eventCode {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventCode,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableOrderingComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$VideosTableAnnotationComposer extends Composer<_$AppDb, $VideosTable> {
  $$VideosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<int> get priorityScore => $composableBuilder(
      column: $table.priorityScore, builder: (column) => column);

  GeneratedColumn<bool> get published =>
      $composableBuilder(column: $table.published, builder: (column) => column);

  GeneratedColumn<int> get visibility => $composableBuilder(
      column: $table.visibility, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventCode {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventCode,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableAnnotationComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$VideosTableTableManager extends RootTableManager<
    _$AppDb,
    $VideosTable,
    Video,
    $$VideosTableFilterComposer,
    $$VideosTableOrderingComposer,
    $$VideosTableAnnotationComposer,
    $$VideosTableCreateCompanionBuilder,
    $$VideosTableUpdateCompanionBuilder,
    (Video, $$VideosTableReferences),
    Video,
    PrefetchHooks Function({bool eventCode})> {
  $$VideosTableTableManager(_$AppDb db, $VideosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VideosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VideosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VideosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> eventCode = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<int> priorityScore = const Value.absent(),
            Value<bool> published = const Value.absent(),
            Value<int?> visibility = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VideosCompanion(
            code: code,
            eventCode: eventCode,
            name: name,
            url: url,
            priorityScore: priorityScore,
            published: published,
            visibility: visibility,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String eventCode,
            required String name,
            required String url,
            required int priorityScore,
            Value<bool> published = const Value.absent(),
            Value<int?> visibility = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VideosCompanion.insert(
            code: code,
            eventCode: eventCode,
            name: name,
            url: url,
            priorityScore: priorityScore,
            published: published,
            visibility: visibility,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$VideosTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({eventCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (eventCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.eventCode,
                    referencedTable:
                        $$VideosTableReferences._eventCodeTable(db),
                    referencedColumn:
                        $$VideosTableReferences._eventCodeTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$VideosTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $VideosTable,
    Video,
    $$VideosTableFilterComposer,
    $$VideosTableOrderingComposer,
    $$VideosTableAnnotationComposer,
    $$VideosTableCreateCompanionBuilder,
    $$VideosTableUpdateCompanionBuilder,
    (Video, $$VideosTableReferences),
    Video,
    PrefetchHooks Function({bool eventCode})>;
typedef $$CarouselPropertiesTableCreateCompanionBuilder
    = CarouselPropertiesCompanion Function({
  required String code,
  required int priorityScore,
  Value<String?> ableCode,
  Value<String?> ableType,
  Value<String?> image,
  Value<int> rowid,
});
typedef $$CarouselPropertiesTableUpdateCompanionBuilder
    = CarouselPropertiesCompanion Function({
  Value<String> code,
  Value<int> priorityScore,
  Value<String?> ableCode,
  Value<String?> ableType,
  Value<String?> image,
  Value<int> rowid,
});

class $$CarouselPropertiesTableFilterComposer
    extends Composer<_$AppDb, $CarouselPropertiesTable> {
  $$CarouselPropertiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priorityScore => $composableBuilder(
      column: $table.priorityScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ableCode => $composableBuilder(
      column: $table.ableCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ableType => $composableBuilder(
      column: $table.ableType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));
}

class $$CarouselPropertiesTableOrderingComposer
    extends Composer<_$AppDb, $CarouselPropertiesTable> {
  $$CarouselPropertiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priorityScore => $composableBuilder(
      column: $table.priorityScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ableCode => $composableBuilder(
      column: $table.ableCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ableType => $composableBuilder(
      column: $table.ableType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));
}

class $$CarouselPropertiesTableAnnotationComposer
    extends Composer<_$AppDb, $CarouselPropertiesTable> {
  $$CarouselPropertiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get priorityScore => $composableBuilder(
      column: $table.priorityScore, builder: (column) => column);

  GeneratedColumn<String> get ableCode =>
      $composableBuilder(column: $table.ableCode, builder: (column) => column);

  GeneratedColumn<String> get ableType =>
      $composableBuilder(column: $table.ableType, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);
}

class $$CarouselPropertiesTableTableManager extends RootTableManager<
    _$AppDb,
    $CarouselPropertiesTable,
    CarouselProperty,
    $$CarouselPropertiesTableFilterComposer,
    $$CarouselPropertiesTableOrderingComposer,
    $$CarouselPropertiesTableAnnotationComposer,
    $$CarouselPropertiesTableCreateCompanionBuilder,
    $$CarouselPropertiesTableUpdateCompanionBuilder,
    (
      CarouselProperty,
      BaseReferences<_$AppDb, $CarouselPropertiesTable, CarouselProperty>
    ),
    CarouselProperty,
    PrefetchHooks Function()> {
  $$CarouselPropertiesTableTableManager(
      _$AppDb db, $CarouselPropertiesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CarouselPropertiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CarouselPropertiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CarouselPropertiesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<int> priorityScore = const Value.absent(),
            Value<String?> ableCode = const Value.absent(),
            Value<String?> ableType = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CarouselPropertiesCompanion(
            code: code,
            priorityScore: priorityScore,
            ableCode: ableCode,
            ableType: ableType,
            image: image,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required int priorityScore,
            Value<String?> ableCode = const Value.absent(),
            Value<String?> ableType = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CarouselPropertiesCompanion.insert(
            code: code,
            priorityScore: priorityScore,
            ableCode: ableCode,
            ableType: ableType,
            image: image,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CarouselPropertiesTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $CarouselPropertiesTable,
    CarouselProperty,
    $$CarouselPropertiesTableFilterComposer,
    $$CarouselPropertiesTableOrderingComposer,
    $$CarouselPropertiesTableAnnotationComposer,
    $$CarouselPropertiesTableCreateCompanionBuilder,
    $$CarouselPropertiesTableUpdateCompanionBuilder,
    (
      CarouselProperty,
      BaseReferences<_$AppDb, $CarouselPropertiesTable, CarouselProperty>
    ),
    CarouselProperty,
    PrefetchHooks Function()>;
typedef $$CarouselTableCreateCompanionBuilder = CarouselCompanion Function({
  required String code,
  required int interval,
  required int height,
  required int width,
  required int lastUpdatedAt,
  Value<int> rowid,
});
typedef $$CarouselTableUpdateCompanionBuilder = CarouselCompanion Function({
  Value<String> code,
  Value<int> interval,
  Value<int> height,
  Value<int> width,
  Value<int> lastUpdatedAt,
  Value<int> rowid,
});

class $$CarouselTableFilterComposer extends Composer<_$AppDb, $CarouselTable> {
  $$CarouselTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get interval => $composableBuilder(
      column: $table.interval, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get width => $composableBuilder(
      column: $table.width, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => ColumnFilters(column));
}

class $$CarouselTableOrderingComposer
    extends Composer<_$AppDb, $CarouselTable> {
  $$CarouselTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get interval => $composableBuilder(
      column: $table.interval, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get width => $composableBuilder(
      column: $table.width, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$CarouselTableAnnotationComposer
    extends Composer<_$AppDb, $CarouselTable> {
  $$CarouselTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => column);
}

class $$CarouselTableTableManager extends RootTableManager<
    _$AppDb,
    $CarouselTable,
    CarouselData,
    $$CarouselTableFilterComposer,
    $$CarouselTableOrderingComposer,
    $$CarouselTableAnnotationComposer,
    $$CarouselTableCreateCompanionBuilder,
    $$CarouselTableUpdateCompanionBuilder,
    (CarouselData, BaseReferences<_$AppDb, $CarouselTable, CarouselData>),
    CarouselData,
    PrefetchHooks Function()> {
  $$CarouselTableTableManager(_$AppDb db, $CarouselTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CarouselTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CarouselTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CarouselTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<int> interval = const Value.absent(),
            Value<int> height = const Value.absent(),
            Value<int> width = const Value.absent(),
            Value<int> lastUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CarouselCompanion(
            code: code,
            interval: interval,
            height: height,
            width: width,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required int interval,
            required int height,
            required int width,
            required int lastUpdatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CarouselCompanion.insert(
            code: code,
            interval: interval,
            height: height,
            width: width,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CarouselTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $CarouselTable,
    CarouselData,
    $$CarouselTableFilterComposer,
    $$CarouselTableOrderingComposer,
    $$CarouselTableAnnotationComposer,
    $$CarouselTableCreateCompanionBuilder,
    $$CarouselTableUpdateCompanionBuilder,
    (CarouselData, BaseReferences<_$AppDb, $CarouselTable, CarouselData>),
    CarouselData,
    PrefetchHooks Function()>;
typedef $$MediaTableCreateCompanionBuilder = MediaCompanion Function({
  required String code,
  required String eventCode,
  required String ableType,
  required String ableCode,
  required int priorityScore,
  required bool published,
  required int lastUpdated,
  Value<int> rowid,
});
typedef $$MediaTableUpdateCompanionBuilder = MediaCompanion Function({
  Value<String> code,
  Value<String> eventCode,
  Value<String> ableType,
  Value<String> ableCode,
  Value<int> priorityScore,
  Value<bool> published,
  Value<int> lastUpdated,
  Value<int> rowid,
});

class $$MediaTableFilterComposer extends Composer<_$AppDb, $MediaTable> {
  $$MediaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ableType => $composableBuilder(
      column: $table.ableType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ableCode => $composableBuilder(
      column: $table.ableCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priorityScore => $composableBuilder(
      column: $table.priorityScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get published => $composableBuilder(
      column: $table.published, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));
}

class $$MediaTableOrderingComposer extends Composer<_$AppDb, $MediaTable> {
  $$MediaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ableType => $composableBuilder(
      column: $table.ableType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ableCode => $composableBuilder(
      column: $table.ableCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priorityScore => $composableBuilder(
      column: $table.priorityScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get published => $composableBuilder(
      column: $table.published, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));
}

class $$MediaTableAnnotationComposer extends Composer<_$AppDb, $MediaTable> {
  $$MediaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get eventCode =>
      $composableBuilder(column: $table.eventCode, builder: (column) => column);

  GeneratedColumn<String> get ableType =>
      $composableBuilder(column: $table.ableType, builder: (column) => column);

  GeneratedColumn<String> get ableCode =>
      $composableBuilder(column: $table.ableCode, builder: (column) => column);

  GeneratedColumn<int> get priorityScore => $composableBuilder(
      column: $table.priorityScore, builder: (column) => column);

  GeneratedColumn<bool> get published =>
      $composableBuilder(column: $table.published, builder: (column) => column);

  GeneratedColumn<int> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);
}

class $$MediaTableTableManager extends RootTableManager<
    _$AppDb,
    $MediaTable,
    MediaData,
    $$MediaTableFilterComposer,
    $$MediaTableOrderingComposer,
    $$MediaTableAnnotationComposer,
    $$MediaTableCreateCompanionBuilder,
    $$MediaTableUpdateCompanionBuilder,
    (MediaData, BaseReferences<_$AppDb, $MediaTable, MediaData>),
    MediaData,
    PrefetchHooks Function()> {
  $$MediaTableTableManager(_$AppDb db, $MediaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> eventCode = const Value.absent(),
            Value<String> ableType = const Value.absent(),
            Value<String> ableCode = const Value.absent(),
            Value<int> priorityScore = const Value.absent(),
            Value<bool> published = const Value.absent(),
            Value<int> lastUpdated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MediaCompanion(
            code: code,
            eventCode: eventCode,
            ableType: ableType,
            ableCode: ableCode,
            priorityScore: priorityScore,
            published: published,
            lastUpdated: lastUpdated,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String eventCode,
            required String ableType,
            required String ableCode,
            required int priorityScore,
            required bool published,
            required int lastUpdated,
            Value<int> rowid = const Value.absent(),
          }) =>
              MediaCompanion.insert(
            code: code,
            eventCode: eventCode,
            ableType: ableType,
            ableCode: ableCode,
            priorityScore: priorityScore,
            published: published,
            lastUpdated: lastUpdated,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MediaTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $MediaTable,
    MediaData,
    $$MediaTableFilterComposer,
    $$MediaTableOrderingComposer,
    $$MediaTableAnnotationComposer,
    $$MediaTableCreateCompanionBuilder,
    $$MediaTableUpdateCompanionBuilder,
    (MediaData, BaseReferences<_$AppDb, $MediaTable, MediaData>),
    MediaData,
    PrefetchHooks Function()>;
typedef $$PhotoSelectionCurrentIndexTableCreateCompanionBuilder
    = PhotoSelectionCurrentIndexCompanion Function({
  Value<int> id,
  required String folderCode,
  required int status,
  required String photoSelectionCode,
});
typedef $$PhotoSelectionCurrentIndexTableUpdateCompanionBuilder
    = PhotoSelectionCurrentIndexCompanion Function({
  Value<int> id,
  Value<String> folderCode,
  Value<int> status,
  Value<String> photoSelectionCode,
});

class $$PhotoSelectionCurrentIndexTableFilterComposer
    extends Composer<_$AppDb, $PhotoSelectionCurrentIndexTable> {
  $$PhotoSelectionCurrentIndexTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get folderCode => $composableBuilder(
      column: $table.folderCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoSelectionCode => $composableBuilder(
      column: $table.photoSelectionCode,
      builder: (column) => ColumnFilters(column));
}

class $$PhotoSelectionCurrentIndexTableOrderingComposer
    extends Composer<_$AppDb, $PhotoSelectionCurrentIndexTable> {
  $$PhotoSelectionCurrentIndexTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get folderCode => $composableBuilder(
      column: $table.folderCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoSelectionCode => $composableBuilder(
      column: $table.photoSelectionCode,
      builder: (column) => ColumnOrderings(column));
}

class $$PhotoSelectionCurrentIndexTableAnnotationComposer
    extends Composer<_$AppDb, $PhotoSelectionCurrentIndexTable> {
  $$PhotoSelectionCurrentIndexTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get folderCode => $composableBuilder(
      column: $table.folderCode, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get photoSelectionCode => $composableBuilder(
      column: $table.photoSelectionCode, builder: (column) => column);
}

class $$PhotoSelectionCurrentIndexTableTableManager extends RootTableManager<
    _$AppDb,
    $PhotoSelectionCurrentIndexTable,
    PhotoSelectionCurrentIndexData,
    $$PhotoSelectionCurrentIndexTableFilterComposer,
    $$PhotoSelectionCurrentIndexTableOrderingComposer,
    $$PhotoSelectionCurrentIndexTableAnnotationComposer,
    $$PhotoSelectionCurrentIndexTableCreateCompanionBuilder,
    $$PhotoSelectionCurrentIndexTableUpdateCompanionBuilder,
    (
      PhotoSelectionCurrentIndexData,
      BaseReferences<_$AppDb, $PhotoSelectionCurrentIndexTable,
          PhotoSelectionCurrentIndexData>
    ),
    PhotoSelectionCurrentIndexData,
    PrefetchHooks Function()> {
  $$PhotoSelectionCurrentIndexTableTableManager(
      _$AppDb db, $PhotoSelectionCurrentIndexTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotoSelectionCurrentIndexTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotoSelectionCurrentIndexTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotoSelectionCurrentIndexTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> folderCode = const Value.absent(),
            Value<int> status = const Value.absent(),
            Value<String> photoSelectionCode = const Value.absent(),
          }) =>
              PhotoSelectionCurrentIndexCompanion(
            id: id,
            folderCode: folderCode,
            status: status,
            photoSelectionCode: photoSelectionCode,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String folderCode,
            required int status,
            required String photoSelectionCode,
          }) =>
              PhotoSelectionCurrentIndexCompanion.insert(
            id: id,
            folderCode: folderCode,
            status: status,
            photoSelectionCode: photoSelectionCode,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PhotoSelectionCurrentIndexTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDb,
        $PhotoSelectionCurrentIndexTable,
        PhotoSelectionCurrentIndexData,
        $$PhotoSelectionCurrentIndexTableFilterComposer,
        $$PhotoSelectionCurrentIndexTableOrderingComposer,
        $$PhotoSelectionCurrentIndexTableAnnotationComposer,
        $$PhotoSelectionCurrentIndexTableCreateCompanionBuilder,
        $$PhotoSelectionCurrentIndexTableUpdateCompanionBuilder,
        (
          PhotoSelectionCurrentIndexData,
          BaseReferences<_$AppDb, $PhotoSelectionCurrentIndexTable,
              PhotoSelectionCurrentIndexData>
        ),
        PhotoSelectionCurrentIndexData,
        PrefetchHooks Function()>;
typedef $$PhotoSelectionsTableCreateCompanionBuilder = PhotoSelectionsCompanion
    Function({
  Value<String?> code,
  required String eventCode,
  Value<bool> published,
  Value<bool> confirmationStatus,
  Value<int?> lastUpdatedAt,
  Value<int> rowid,
});
typedef $$PhotoSelectionsTableUpdateCompanionBuilder = PhotoSelectionsCompanion
    Function({
  Value<String?> code,
  Value<String> eventCode,
  Value<bool> published,
  Value<bool> confirmationStatus,
  Value<int?> lastUpdatedAt,
  Value<int> rowid,
});

class $$PhotoSelectionsTableFilterComposer
    extends Composer<_$AppDb, $PhotoSelectionsTable> {
  $$PhotoSelectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get published => $composableBuilder(
      column: $table.published, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get confirmationStatus => $composableBuilder(
      column: $table.confirmationStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => ColumnFilters(column));
}

class $$PhotoSelectionsTableOrderingComposer
    extends Composer<_$AppDb, $PhotoSelectionsTable> {
  $$PhotoSelectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get published => $composableBuilder(
      column: $table.published, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get confirmationStatus => $composableBuilder(
      column: $table.confirmationStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$PhotoSelectionsTableAnnotationComposer
    extends Composer<_$AppDb, $PhotoSelectionsTable> {
  $$PhotoSelectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get eventCode =>
      $composableBuilder(column: $table.eventCode, builder: (column) => column);

  GeneratedColumn<bool> get published =>
      $composableBuilder(column: $table.published, builder: (column) => column);

  GeneratedColumn<bool> get confirmationStatus => $composableBuilder(
      column: $table.confirmationStatus, builder: (column) => column);

  GeneratedColumn<int> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => column);
}

class $$PhotoSelectionsTableTableManager extends RootTableManager<
    _$AppDb,
    $PhotoSelectionsTable,
    PhotoSelection,
    $$PhotoSelectionsTableFilterComposer,
    $$PhotoSelectionsTableOrderingComposer,
    $$PhotoSelectionsTableAnnotationComposer,
    $$PhotoSelectionsTableCreateCompanionBuilder,
    $$PhotoSelectionsTableUpdateCompanionBuilder,
    (
      PhotoSelection,
      BaseReferences<_$AppDb, $PhotoSelectionsTable, PhotoSelection>
    ),
    PhotoSelection,
    PrefetchHooks Function()> {
  $$PhotoSelectionsTableTableManager(_$AppDb db, $PhotoSelectionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotoSelectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotoSelectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotoSelectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String?> code = const Value.absent(),
            Value<String> eventCode = const Value.absent(),
            Value<bool> published = const Value.absent(),
            Value<bool> confirmationStatus = const Value.absent(),
            Value<int?> lastUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PhotoSelectionsCompanion(
            code: code,
            eventCode: eventCode,
            published: published,
            confirmationStatus: confirmationStatus,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String?> code = const Value.absent(),
            required String eventCode,
            Value<bool> published = const Value.absent(),
            Value<bool> confirmationStatus = const Value.absent(),
            Value<int?> lastUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PhotoSelectionsCompanion.insert(
            code: code,
            eventCode: eventCode,
            published: published,
            confirmationStatus: confirmationStatus,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PhotoSelectionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $PhotoSelectionsTable,
    PhotoSelection,
    $$PhotoSelectionsTableFilterComposer,
    $$PhotoSelectionsTableOrderingComposer,
    $$PhotoSelectionsTableAnnotationComposer,
    $$PhotoSelectionsTableCreateCompanionBuilder,
    $$PhotoSelectionsTableUpdateCompanionBuilder,
    (
      PhotoSelection,
      BaseReferences<_$AppDb, $PhotoSelectionsTable, PhotoSelection>
    ),
    PhotoSelection,
    PrefetchHooks Function()>;
typedef $$PersonsPhotoSelectionsTableCreateCompanionBuilder
    = PersonsPhotoSelectionsCompanion Function({
  required String code,
  required String eventCode,
  required String image,
  required int score,
  required String images,
  Value<int> rowid,
});
typedef $$PersonsPhotoSelectionsTableUpdateCompanionBuilder
    = PersonsPhotoSelectionsCompanion Function({
  Value<String> code,
  Value<String> eventCode,
  Value<String> image,
  Value<int> score,
  Value<String> images,
  Value<int> rowid,
});

class $$PersonsPhotoSelectionsTableFilterComposer
    extends Composer<_$AppDb, $PersonsPhotoSelectionsTable> {
  $$PersonsPhotoSelectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get images => $composableBuilder(
      column: $table.images, builder: (column) => ColumnFilters(column));
}

class $$PersonsPhotoSelectionsTableOrderingComposer
    extends Composer<_$AppDb, $PersonsPhotoSelectionsTable> {
  $$PersonsPhotoSelectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get images => $composableBuilder(
      column: $table.images, builder: (column) => ColumnOrderings(column));
}

class $$PersonsPhotoSelectionsTableAnnotationComposer
    extends Composer<_$AppDb, $PersonsPhotoSelectionsTable> {
  $$PersonsPhotoSelectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get eventCode =>
      $composableBuilder(column: $table.eventCode, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get images =>
      $composableBuilder(column: $table.images, builder: (column) => column);
}

class $$PersonsPhotoSelectionsTableTableManager extends RootTableManager<
    _$AppDb,
    $PersonsPhotoSelectionsTable,
    PersonsPhotoSelection,
    $$PersonsPhotoSelectionsTableFilterComposer,
    $$PersonsPhotoSelectionsTableOrderingComposer,
    $$PersonsPhotoSelectionsTableAnnotationComposer,
    $$PersonsPhotoSelectionsTableCreateCompanionBuilder,
    $$PersonsPhotoSelectionsTableUpdateCompanionBuilder,
    (
      PersonsPhotoSelection,
      BaseReferences<_$AppDb, $PersonsPhotoSelectionsTable,
          PersonsPhotoSelection>
    ),
    PersonsPhotoSelection,
    PrefetchHooks Function()> {
  $$PersonsPhotoSelectionsTableTableManager(
      _$AppDb db, $PersonsPhotoSelectionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonsPhotoSelectionsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonsPhotoSelectionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonsPhotoSelectionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> eventCode = const Value.absent(),
            Value<String> image = const Value.absent(),
            Value<int> score = const Value.absent(),
            Value<String> images = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonsPhotoSelectionsCompanion(
            code: code,
            eventCode: eventCode,
            image: image,
            score: score,
            images: images,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String eventCode,
            required String image,
            required int score,
            required String images,
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonsPhotoSelectionsCompanion.insert(
            code: code,
            eventCode: eventCode,
            image: image,
            score: score,
            images: images,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PersonsPhotoSelectionsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDb,
        $PersonsPhotoSelectionsTable,
        PersonsPhotoSelection,
        $$PersonsPhotoSelectionsTableFilterComposer,
        $$PersonsPhotoSelectionsTableOrderingComposer,
        $$PersonsPhotoSelectionsTableAnnotationComposer,
        $$PersonsPhotoSelectionsTableCreateCompanionBuilder,
        $$PersonsPhotoSelectionsTableUpdateCompanionBuilder,
        (
          PersonsPhotoSelection,
          BaseReferences<_$AppDb, $PersonsPhotoSelectionsTable,
              PersonsPhotoSelection>
        ),
        PersonsPhotoSelection,
        PrefetchHooks Function()>;
typedef $$PersonsAlbumsTableCreateCompanionBuilder = PersonsAlbumsCompanion
    Function({
  required String code,
  required String eventCode,
  required String image,
  required int score,
  required String images,
  Value<int> rowid,
});
typedef $$PersonsAlbumsTableUpdateCompanionBuilder = PersonsAlbumsCompanion
    Function({
  Value<String> code,
  Value<String> eventCode,
  Value<String> image,
  Value<int> score,
  Value<String> images,
  Value<int> rowid,
});

class $$PersonsAlbumsTableFilterComposer
    extends Composer<_$AppDb, $PersonsAlbumsTable> {
  $$PersonsAlbumsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get images => $composableBuilder(
      column: $table.images, builder: (column) => ColumnFilters(column));
}

class $$PersonsAlbumsTableOrderingComposer
    extends Composer<_$AppDb, $PersonsAlbumsTable> {
  $$PersonsAlbumsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get images => $composableBuilder(
      column: $table.images, builder: (column) => ColumnOrderings(column));
}

class $$PersonsAlbumsTableAnnotationComposer
    extends Composer<_$AppDb, $PersonsAlbumsTable> {
  $$PersonsAlbumsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get eventCode =>
      $composableBuilder(column: $table.eventCode, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get images =>
      $composableBuilder(column: $table.images, builder: (column) => column);
}

class $$PersonsAlbumsTableTableManager extends RootTableManager<
    _$AppDb,
    $PersonsAlbumsTable,
    PersonsAlbum,
    $$PersonsAlbumsTableFilterComposer,
    $$PersonsAlbumsTableOrderingComposer,
    $$PersonsAlbumsTableAnnotationComposer,
    $$PersonsAlbumsTableCreateCompanionBuilder,
    $$PersonsAlbumsTableUpdateCompanionBuilder,
    (PersonsAlbum, BaseReferences<_$AppDb, $PersonsAlbumsTable, PersonsAlbum>),
    PersonsAlbum,
    PrefetchHooks Function()> {
  $$PersonsAlbumsTableTableManager(_$AppDb db, $PersonsAlbumsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonsAlbumsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonsAlbumsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonsAlbumsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> eventCode = const Value.absent(),
            Value<String> image = const Value.absent(),
            Value<int> score = const Value.absent(),
            Value<String> images = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonsAlbumsCompanion(
            code: code,
            eventCode: eventCode,
            image: image,
            score: score,
            images: images,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String eventCode,
            required String image,
            required int score,
            required String images,
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonsAlbumsCompanion.insert(
            code: code,
            eventCode: eventCode,
            image: image,
            score: score,
            images: images,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PersonsAlbumsTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $PersonsAlbumsTable,
    PersonsAlbum,
    $$PersonsAlbumsTableFilterComposer,
    $$PersonsAlbumsTableOrderingComposer,
    $$PersonsAlbumsTableAnnotationComposer,
    $$PersonsAlbumsTableCreateCompanionBuilder,
    $$PersonsAlbumsTableUpdateCompanionBuilder,
    (PersonsAlbum, BaseReferences<_$AppDb, $PersonsAlbumsTable, PersonsAlbum>),
    PersonsAlbum,
    PrefetchHooks Function()>;
typedef $$FolderNotificationTableCreateCompanionBuilder
    = FolderNotificationCompanion Function({
  required String eventCode,
  required String folderCodes,
  required String oldFolderCodes,
  Value<int> rowid,
});
typedef $$FolderNotificationTableUpdateCompanionBuilder
    = FolderNotificationCompanion Function({
  Value<String> eventCode,
  Value<String> folderCodes,
  Value<String> oldFolderCodes,
  Value<int> rowid,
});

class $$FolderNotificationTableFilterComposer
    extends Composer<_$AppDb, $FolderNotificationTable> {
  $$FolderNotificationTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get folderCodes => $composableBuilder(
      column: $table.folderCodes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get oldFolderCodes => $composableBuilder(
      column: $table.oldFolderCodes,
      builder: (column) => ColumnFilters(column));
}

class $$FolderNotificationTableOrderingComposer
    extends Composer<_$AppDb, $FolderNotificationTable> {
  $$FolderNotificationTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get folderCodes => $composableBuilder(
      column: $table.folderCodes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get oldFolderCodes => $composableBuilder(
      column: $table.oldFolderCodes,
      builder: (column) => ColumnOrderings(column));
}

class $$FolderNotificationTableAnnotationComposer
    extends Composer<_$AppDb, $FolderNotificationTable> {
  $$FolderNotificationTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get eventCode =>
      $composableBuilder(column: $table.eventCode, builder: (column) => column);

  GeneratedColumn<String> get folderCodes => $composableBuilder(
      column: $table.folderCodes, builder: (column) => column);

  GeneratedColumn<String> get oldFolderCodes => $composableBuilder(
      column: $table.oldFolderCodes, builder: (column) => column);
}

class $$FolderNotificationTableTableManager extends RootTableManager<
    _$AppDb,
    $FolderNotificationTable,
    FolderNotificationData,
    $$FolderNotificationTableFilterComposer,
    $$FolderNotificationTableOrderingComposer,
    $$FolderNotificationTableAnnotationComposer,
    $$FolderNotificationTableCreateCompanionBuilder,
    $$FolderNotificationTableUpdateCompanionBuilder,
    (
      FolderNotificationData,
      BaseReferences<_$AppDb, $FolderNotificationTable, FolderNotificationData>
    ),
    FolderNotificationData,
    PrefetchHooks Function()> {
  $$FolderNotificationTableTableManager(
      _$AppDb db, $FolderNotificationTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FolderNotificationTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FolderNotificationTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FolderNotificationTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> eventCode = const Value.absent(),
            Value<String> folderCodes = const Value.absent(),
            Value<String> oldFolderCodes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FolderNotificationCompanion(
            eventCode: eventCode,
            folderCodes: folderCodes,
            oldFolderCodes: oldFolderCodes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String eventCode,
            required String folderCodes,
            required String oldFolderCodes,
            Value<int> rowid = const Value.absent(),
          }) =>
              FolderNotificationCompanion.insert(
            eventCode: eventCode,
            folderCodes: folderCodes,
            oldFolderCodes: oldFolderCodes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FolderNotificationTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $FolderNotificationTable,
    FolderNotificationData,
    $$FolderNotificationTableFilterComposer,
    $$FolderNotificationTableOrderingComposer,
    $$FolderNotificationTableAnnotationComposer,
    $$FolderNotificationTableCreateCompanionBuilder,
    $$FolderNotificationTableUpdateCompanionBuilder,
    (
      FolderNotificationData,
      BaseReferences<_$AppDb, $FolderNotificationTable, FolderNotificationData>
    ),
    FolderNotificationData,
    PrefetchHooks Function()>;
typedef $$WithOutPersonsAlbumsTableCreateCompanionBuilder
    = WithOutPersonsAlbumsCompanion Function({
  required String eventCode,
  required String images,
  Value<int> rowid,
});
typedef $$WithOutPersonsAlbumsTableUpdateCompanionBuilder
    = WithOutPersonsAlbumsCompanion Function({
  Value<String> eventCode,
  Value<String> images,
  Value<int> rowid,
});

class $$WithOutPersonsAlbumsTableFilterComposer
    extends Composer<_$AppDb, $WithOutPersonsAlbumsTable> {
  $$WithOutPersonsAlbumsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get images => $composableBuilder(
      column: $table.images, builder: (column) => ColumnFilters(column));
}

class $$WithOutPersonsAlbumsTableOrderingComposer
    extends Composer<_$AppDb, $WithOutPersonsAlbumsTable> {
  $$WithOutPersonsAlbumsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get images => $composableBuilder(
      column: $table.images, builder: (column) => ColumnOrderings(column));
}

class $$WithOutPersonsAlbumsTableAnnotationComposer
    extends Composer<_$AppDb, $WithOutPersonsAlbumsTable> {
  $$WithOutPersonsAlbumsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get eventCode =>
      $composableBuilder(column: $table.eventCode, builder: (column) => column);

  GeneratedColumn<String> get images =>
      $composableBuilder(column: $table.images, builder: (column) => column);
}

class $$WithOutPersonsAlbumsTableTableManager extends RootTableManager<
    _$AppDb,
    $WithOutPersonsAlbumsTable,
    WithOutPersonsAlbum,
    $$WithOutPersonsAlbumsTableFilterComposer,
    $$WithOutPersonsAlbumsTableOrderingComposer,
    $$WithOutPersonsAlbumsTableAnnotationComposer,
    $$WithOutPersonsAlbumsTableCreateCompanionBuilder,
    $$WithOutPersonsAlbumsTableUpdateCompanionBuilder,
    (
      WithOutPersonsAlbum,
      BaseReferences<_$AppDb, $WithOutPersonsAlbumsTable, WithOutPersonsAlbum>
    ),
    WithOutPersonsAlbum,
    PrefetchHooks Function()> {
  $$WithOutPersonsAlbumsTableTableManager(
      _$AppDb db, $WithOutPersonsAlbumsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WithOutPersonsAlbumsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WithOutPersonsAlbumsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WithOutPersonsAlbumsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> eventCode = const Value.absent(),
            Value<String> images = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WithOutPersonsAlbumsCompanion(
            eventCode: eventCode,
            images: images,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String eventCode,
            required String images,
            Value<int> rowid = const Value.absent(),
          }) =>
              WithOutPersonsAlbumsCompanion.insert(
            eventCode: eventCode,
            images: images,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WithOutPersonsAlbumsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDb,
        $WithOutPersonsAlbumsTable,
        WithOutPersonsAlbum,
        $$WithOutPersonsAlbumsTableFilterComposer,
        $$WithOutPersonsAlbumsTableOrderingComposer,
        $$WithOutPersonsAlbumsTableAnnotationComposer,
        $$WithOutPersonsAlbumsTableCreateCompanionBuilder,
        $$WithOutPersonsAlbumsTableUpdateCompanionBuilder,
        (
          WithOutPersonsAlbum,
          BaseReferences<_$AppDb, $WithOutPersonsAlbumsTable,
              WithOutPersonsAlbum>
        ),
        WithOutPersonsAlbum,
        PrefetchHooks Function()>;
typedef $$WithOutPersonsPhotoSelectionTableCreateCompanionBuilder
    = WithOutPersonsPhotoSelectionCompanion Function({
  required String eventCode,
  required String images,
  Value<int> rowid,
});
typedef $$WithOutPersonsPhotoSelectionTableUpdateCompanionBuilder
    = WithOutPersonsPhotoSelectionCompanion Function({
  Value<String> eventCode,
  Value<String> images,
  Value<int> rowid,
});

class $$WithOutPersonsPhotoSelectionTableFilterComposer
    extends Composer<_$AppDb, $WithOutPersonsPhotoSelectionTable> {
  $$WithOutPersonsPhotoSelectionTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get images => $composableBuilder(
      column: $table.images, builder: (column) => ColumnFilters(column));
}

class $$WithOutPersonsPhotoSelectionTableOrderingComposer
    extends Composer<_$AppDb, $WithOutPersonsPhotoSelectionTable> {
  $$WithOutPersonsPhotoSelectionTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get images => $composableBuilder(
      column: $table.images, builder: (column) => ColumnOrderings(column));
}

class $$WithOutPersonsPhotoSelectionTableAnnotationComposer
    extends Composer<_$AppDb, $WithOutPersonsPhotoSelectionTable> {
  $$WithOutPersonsPhotoSelectionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get eventCode =>
      $composableBuilder(column: $table.eventCode, builder: (column) => column);

  GeneratedColumn<String> get images =>
      $composableBuilder(column: $table.images, builder: (column) => column);
}

class $$WithOutPersonsPhotoSelectionTableTableManager extends RootTableManager<
    _$AppDb,
    $WithOutPersonsPhotoSelectionTable,
    WithOutPersonsPhotoSelectionData,
    $$WithOutPersonsPhotoSelectionTableFilterComposer,
    $$WithOutPersonsPhotoSelectionTableOrderingComposer,
    $$WithOutPersonsPhotoSelectionTableAnnotationComposer,
    $$WithOutPersonsPhotoSelectionTableCreateCompanionBuilder,
    $$WithOutPersonsPhotoSelectionTableUpdateCompanionBuilder,
    (
      WithOutPersonsPhotoSelectionData,
      BaseReferences<_$AppDb, $WithOutPersonsPhotoSelectionTable,
          WithOutPersonsPhotoSelectionData>
    ),
    WithOutPersonsPhotoSelectionData,
    PrefetchHooks Function()> {
  $$WithOutPersonsPhotoSelectionTableTableManager(
      _$AppDb db, $WithOutPersonsPhotoSelectionTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WithOutPersonsPhotoSelectionTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$WithOutPersonsPhotoSelectionTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WithOutPersonsPhotoSelectionTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> eventCode = const Value.absent(),
            Value<String> images = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WithOutPersonsPhotoSelectionCompanion(
            eventCode: eventCode,
            images: images,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String eventCode,
            required String images,
            Value<int> rowid = const Value.absent(),
          }) =>
              WithOutPersonsPhotoSelectionCompanion.insert(
            eventCode: eventCode,
            images: images,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WithOutPersonsPhotoSelectionTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDb,
        $WithOutPersonsPhotoSelectionTable,
        WithOutPersonsPhotoSelectionData,
        $$WithOutPersonsPhotoSelectionTableFilterComposer,
        $$WithOutPersonsPhotoSelectionTableOrderingComposer,
        $$WithOutPersonsPhotoSelectionTableAnnotationComposer,
        $$WithOutPersonsPhotoSelectionTableCreateCompanionBuilder,
        $$WithOutPersonsPhotoSelectionTableUpdateCompanionBuilder,
        (
          WithOutPersonsPhotoSelectionData,
          BaseReferences<_$AppDb, $WithOutPersonsPhotoSelectionTable,
              WithOutPersonsPhotoSelectionData>
        ),
        WithOutPersonsPhotoSelectionData,
        PrefetchHooks Function()>;
typedef $$PhotomallStudioInfoTableCreateCompanionBuilder
    = PhotomallStudioInfoCompanion Function({
  required String code,
  required String value,
  required int lastUpdatedAt,
  Value<int> rowid,
});
typedef $$PhotomallStudioInfoTableUpdateCompanionBuilder
    = PhotomallStudioInfoCompanion Function({
  Value<String> code,
  Value<String> value,
  Value<int> lastUpdatedAt,
  Value<int> rowid,
});

final class $$PhotomallStudioInfoTableReferences extends BaseReferences<_$AppDb,
    $PhotomallStudioInfoTable, PhotomallStudioInfoData> {
  $$PhotomallStudioInfoTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _codeTable(_$AppDb db) => db.events.createAlias(
      $_aliasNameGenerator(db.photomallStudioInfo.code, db.events.code));

  $$EventsTableProcessedTableManager get code {
    final $_column = $_itemColumn<String>('code')!;

    final manager = $$EventsTableTableManager($_db, $_db.events)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_codeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PhotomallStudioInfoTableFilterComposer
    extends Composer<_$AppDb, $PhotomallStudioInfoTable> {
  $$PhotomallStudioInfoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => ColumnFilters(column));

  $$EventsTableFilterComposer get code {
    final $$EventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableFilterComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PhotomallStudioInfoTableOrderingComposer
    extends Composer<_$AppDb, $PhotomallStudioInfoTable> {
  $$PhotomallStudioInfoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  $$EventsTableOrderingComposer get code {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableOrderingComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PhotomallStudioInfoTableAnnotationComposer
    extends Composer<_$AppDb, $PhotomallStudioInfoTable> {
  $$PhotomallStudioInfoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => column);

  $$EventsTableAnnotationComposer get code {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableAnnotationComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PhotomallStudioInfoTableTableManager extends RootTableManager<
    _$AppDb,
    $PhotomallStudioInfoTable,
    PhotomallStudioInfoData,
    $$PhotomallStudioInfoTableFilterComposer,
    $$PhotomallStudioInfoTableOrderingComposer,
    $$PhotomallStudioInfoTableAnnotationComposer,
    $$PhotomallStudioInfoTableCreateCompanionBuilder,
    $$PhotomallStudioInfoTableUpdateCompanionBuilder,
    (PhotomallStudioInfoData, $$PhotomallStudioInfoTableReferences),
    PhotomallStudioInfoData,
    PrefetchHooks Function({bool code})> {
  $$PhotomallStudioInfoTableTableManager(
      _$AppDb db, $PhotomallStudioInfoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotomallStudioInfoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotomallStudioInfoTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotomallStudioInfoTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> lastUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PhotomallStudioInfoCompanion(
            code: code,
            value: value,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String value,
            required int lastUpdatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PhotomallStudioInfoCompanion.insert(
            code: code,
            value: value,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PhotomallStudioInfoTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({code = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (code) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.code,
                    referencedTable:
                        $$PhotomallStudioInfoTableReferences._codeTable(db),
                    referencedColumn: $$PhotomallStudioInfoTableReferences
                        ._codeTable(db)
                        .code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PhotomallStudioInfoTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $PhotomallStudioInfoTable,
    PhotomallStudioInfoData,
    $$PhotomallStudioInfoTableFilterComposer,
    $$PhotomallStudioInfoTableOrderingComposer,
    $$PhotomallStudioInfoTableAnnotationComposer,
    $$PhotomallStudioInfoTableCreateCompanionBuilder,
    $$PhotomallStudioInfoTableUpdateCompanionBuilder,
    (PhotomallStudioInfoData, $$PhotomallStudioInfoTableReferences),
    PhotomallStudioInfoData,
    PrefetchHooks Function({bool code})>;
typedef $$CommonTableTableCreateCompanionBuilder = CommonTableCompanion
    Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$CommonTableTableUpdateCompanionBuilder = CommonTableCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$CommonTableTableFilterComposer
    extends Composer<_$AppDb, $CommonTableTable> {
  $$CommonTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$CommonTableTableOrderingComposer
    extends Composer<_$AppDb, $CommonTableTable> {
  $$CommonTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$CommonTableTableAnnotationComposer
    extends Composer<_$AppDb, $CommonTableTable> {
  $$CommonTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$CommonTableTableTableManager extends RootTableManager<
    _$AppDb,
    $CommonTableTable,
    CommonTableData,
    $$CommonTableTableFilterComposer,
    $$CommonTableTableOrderingComposer,
    $$CommonTableTableAnnotationComposer,
    $$CommonTableTableCreateCompanionBuilder,
    $$CommonTableTableUpdateCompanionBuilder,
    (
      CommonTableData,
      BaseReferences<_$AppDb, $CommonTableTable, CommonTableData>
    ),
    CommonTableData,
    PrefetchHooks Function()> {
  $$CommonTableTableTableManager(_$AppDb db, $CommonTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CommonTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CommonTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CommonTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CommonTableCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              CommonTableCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CommonTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $CommonTableTable,
    CommonTableData,
    $$CommonTableTableFilterComposer,
    $$CommonTableTableOrderingComposer,
    $$CommonTableTableAnnotationComposer,
    $$CommonTableTableCreateCompanionBuilder,
    $$CommonTableTableUpdateCompanionBuilder,
    (
      CommonTableData,
      BaseReferences<_$AppDb, $CommonTableTable, CommonTableData>
    ),
    CommonTableData,
    PrefetchHooks Function()>;
typedef $$RealPersonsAlbumsTableCreateCompanionBuilder
    = RealPersonsAlbumsCompanion Function({
  required String code,
  required String eventCode,
  required String image,
  required int score,
  required String persons,
  Value<int> rowid,
});
typedef $$RealPersonsAlbumsTableUpdateCompanionBuilder
    = RealPersonsAlbumsCompanion Function({
  Value<String> code,
  Value<String> eventCode,
  Value<String> image,
  Value<int> score,
  Value<String> persons,
  Value<int> rowid,
});

class $$RealPersonsAlbumsTableFilterComposer
    extends Composer<_$AppDb, $RealPersonsAlbumsTable> {
  $$RealPersonsAlbumsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get persons => $composableBuilder(
      column: $table.persons, builder: (column) => ColumnFilters(column));
}

class $$RealPersonsAlbumsTableOrderingComposer
    extends Composer<_$AppDb, $RealPersonsAlbumsTable> {
  $$RealPersonsAlbumsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get persons => $composableBuilder(
      column: $table.persons, builder: (column) => ColumnOrderings(column));
}

class $$RealPersonsAlbumsTableAnnotationComposer
    extends Composer<_$AppDb, $RealPersonsAlbumsTable> {
  $$RealPersonsAlbumsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get eventCode =>
      $composableBuilder(column: $table.eventCode, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get persons =>
      $composableBuilder(column: $table.persons, builder: (column) => column);
}

class $$RealPersonsAlbumsTableTableManager extends RootTableManager<
    _$AppDb,
    $RealPersonsAlbumsTable,
    RealPersonsAlbum,
    $$RealPersonsAlbumsTableFilterComposer,
    $$RealPersonsAlbumsTableOrderingComposer,
    $$RealPersonsAlbumsTableAnnotationComposer,
    $$RealPersonsAlbumsTableCreateCompanionBuilder,
    $$RealPersonsAlbumsTableUpdateCompanionBuilder,
    (
      RealPersonsAlbum,
      BaseReferences<_$AppDb, $RealPersonsAlbumsTable, RealPersonsAlbum>
    ),
    RealPersonsAlbum,
    PrefetchHooks Function()> {
  $$RealPersonsAlbumsTableTableManager(
      _$AppDb db, $RealPersonsAlbumsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RealPersonsAlbumsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RealPersonsAlbumsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RealPersonsAlbumsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> eventCode = const Value.absent(),
            Value<String> image = const Value.absent(),
            Value<int> score = const Value.absent(),
            Value<String> persons = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RealPersonsAlbumsCompanion(
            code: code,
            eventCode: eventCode,
            image: image,
            score: score,
            persons: persons,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String eventCode,
            required String image,
            required int score,
            required String persons,
            Value<int> rowid = const Value.absent(),
          }) =>
              RealPersonsAlbumsCompanion.insert(
            code: code,
            eventCode: eventCode,
            image: image,
            score: score,
            persons: persons,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RealPersonsAlbumsTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $RealPersonsAlbumsTable,
    RealPersonsAlbum,
    $$RealPersonsAlbumsTableFilterComposer,
    $$RealPersonsAlbumsTableOrderingComposer,
    $$RealPersonsAlbumsTableAnnotationComposer,
    $$RealPersonsAlbumsTableCreateCompanionBuilder,
    $$RealPersonsAlbumsTableUpdateCompanionBuilder,
    (
      RealPersonsAlbum,
      BaseReferences<_$AppDb, $RealPersonsAlbumsTable, RealPersonsAlbum>
    ),
    RealPersonsAlbum,
    PrefetchHooks Function()>;
typedef $$DownloadTableCreateCompanionBuilder = DownloadCompanion Function({
  required String ableCode,
  required String ableType,
  Value<bool> downloadedStatus,
  Value<int> rowid,
});
typedef $$DownloadTableUpdateCompanionBuilder = DownloadCompanion Function({
  Value<String> ableCode,
  Value<String> ableType,
  Value<bool> downloadedStatus,
  Value<int> rowid,
});

class $$DownloadTableFilterComposer extends Composer<_$AppDb, $DownloadTable> {
  $$DownloadTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get ableCode => $composableBuilder(
      column: $table.ableCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ableType => $composableBuilder(
      column: $table.ableType, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get downloadedStatus => $composableBuilder(
      column: $table.downloadedStatus,
      builder: (column) => ColumnFilters(column));
}

class $$DownloadTableOrderingComposer
    extends Composer<_$AppDb, $DownloadTable> {
  $$DownloadTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get ableCode => $composableBuilder(
      column: $table.ableCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ableType => $composableBuilder(
      column: $table.ableType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get downloadedStatus => $composableBuilder(
      column: $table.downloadedStatus,
      builder: (column) => ColumnOrderings(column));
}

class $$DownloadTableAnnotationComposer
    extends Composer<_$AppDb, $DownloadTable> {
  $$DownloadTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get ableCode =>
      $composableBuilder(column: $table.ableCode, builder: (column) => column);

  GeneratedColumn<String> get ableType =>
      $composableBuilder(column: $table.ableType, builder: (column) => column);

  GeneratedColumn<bool> get downloadedStatus => $composableBuilder(
      column: $table.downloadedStatus, builder: (column) => column);
}

class $$DownloadTableTableManager extends RootTableManager<
    _$AppDb,
    $DownloadTable,
    DownloadData,
    $$DownloadTableFilterComposer,
    $$DownloadTableOrderingComposer,
    $$DownloadTableAnnotationComposer,
    $$DownloadTableCreateCompanionBuilder,
    $$DownloadTableUpdateCompanionBuilder,
    (DownloadData, BaseReferences<_$AppDb, $DownloadTable, DownloadData>),
    DownloadData,
    PrefetchHooks Function()> {
  $$DownloadTableTableManager(_$AppDb db, $DownloadTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> ableCode = const Value.absent(),
            Value<String> ableType = const Value.absent(),
            Value<bool> downloadedStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DownloadCompanion(
            ableCode: ableCode,
            ableType: ableType,
            downloadedStatus: downloadedStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String ableCode,
            required String ableType,
            Value<bool> downloadedStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DownloadCompanion.insert(
            ableCode: ableCode,
            ableType: ableType,
            downloadedStatus: downloadedStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DownloadTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $DownloadTable,
    DownloadData,
    $$DownloadTableFilterComposer,
    $$DownloadTableOrderingComposer,
    $$DownloadTableAnnotationComposer,
    $$DownloadTableCreateCompanionBuilder,
    $$DownloadTableUpdateCompanionBuilder,
    (DownloadData, BaseReferences<_$AppDb, $DownloadTable, DownloadData>),
    DownloadData,
    PrefetchHooks Function()>;
typedef $$PhotoSelectionImageFolderTableCreateCompanionBuilder
    = PhotoSelectionImageFolderCompanion Function({
  Value<String?> eventCode,
  required int lastUpdatedAt,
  Value<int> rowid,
});
typedef $$PhotoSelectionImageFolderTableUpdateCompanionBuilder
    = PhotoSelectionImageFolderCompanion Function({
  Value<String?> eventCode,
  Value<int> lastUpdatedAt,
  Value<int> rowid,
});

class $$PhotoSelectionImageFolderTableFilterComposer
    extends Composer<_$AppDb, $PhotoSelectionImageFolderTable> {
  $$PhotoSelectionImageFolderTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => ColumnFilters(column));
}

class $$PhotoSelectionImageFolderTableOrderingComposer
    extends Composer<_$AppDb, $PhotoSelectionImageFolderTable> {
  $$PhotoSelectionImageFolderTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$PhotoSelectionImageFolderTableAnnotationComposer
    extends Composer<_$AppDb, $PhotoSelectionImageFolderTable> {
  $$PhotoSelectionImageFolderTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get eventCode =>
      $composableBuilder(column: $table.eventCode, builder: (column) => column);

  GeneratedColumn<int> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => column);
}

class $$PhotoSelectionImageFolderTableTableManager extends RootTableManager<
    _$AppDb,
    $PhotoSelectionImageFolderTable,
    PhotoSelectionImageFolderData,
    $$PhotoSelectionImageFolderTableFilterComposer,
    $$PhotoSelectionImageFolderTableOrderingComposer,
    $$PhotoSelectionImageFolderTableAnnotationComposer,
    $$PhotoSelectionImageFolderTableCreateCompanionBuilder,
    $$PhotoSelectionImageFolderTableUpdateCompanionBuilder,
    (
      PhotoSelectionImageFolderData,
      BaseReferences<_$AppDb, $PhotoSelectionImageFolderTable,
          PhotoSelectionImageFolderData>
    ),
    PhotoSelectionImageFolderData,
    PrefetchHooks Function()> {
  $$PhotoSelectionImageFolderTableTableManager(
      _$AppDb db, $PhotoSelectionImageFolderTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotoSelectionImageFolderTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotoSelectionImageFolderTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotoSelectionImageFolderTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String?> eventCode = const Value.absent(),
            Value<int> lastUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PhotoSelectionImageFolderCompanion(
            eventCode: eventCode,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String?> eventCode = const Value.absent(),
            required int lastUpdatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PhotoSelectionImageFolderCompanion.insert(
            eventCode: eventCode,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PhotoSelectionImageFolderTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDb,
        $PhotoSelectionImageFolderTable,
        PhotoSelectionImageFolderData,
        $$PhotoSelectionImageFolderTableFilterComposer,
        $$PhotoSelectionImageFolderTableOrderingComposer,
        $$PhotoSelectionImageFolderTableAnnotationComposer,
        $$PhotoSelectionImageFolderTableCreateCompanionBuilder,
        $$PhotoSelectionImageFolderTableUpdateCompanionBuilder,
        (
          PhotoSelectionImageFolderData,
          BaseReferences<_$AppDb, $PhotoSelectionImageFolderTable,
              PhotoSelectionImageFolderData>
        ),
        PhotoSelectionImageFolderData,
        PrefetchHooks Function()>;
typedef $$RealPersonsPhotoSelectionsTableCreateCompanionBuilder
    = RealPersonsPhotoSelectionsCompanion Function({
  required String code,
  required String eventCode,
  required String image,
  required int score,
  required String persons,
  Value<int> rowid,
});
typedef $$RealPersonsPhotoSelectionsTableUpdateCompanionBuilder
    = RealPersonsPhotoSelectionsCompanion Function({
  Value<String> code,
  Value<String> eventCode,
  Value<String> image,
  Value<int> score,
  Value<String> persons,
  Value<int> rowid,
});

class $$RealPersonsPhotoSelectionsTableFilterComposer
    extends Composer<_$AppDb, $RealPersonsPhotoSelectionsTable> {
  $$RealPersonsPhotoSelectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get persons => $composableBuilder(
      column: $table.persons, builder: (column) => ColumnFilters(column));
}

class $$RealPersonsPhotoSelectionsTableOrderingComposer
    extends Composer<_$AppDb, $RealPersonsPhotoSelectionsTable> {
  $$RealPersonsPhotoSelectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get persons => $composableBuilder(
      column: $table.persons, builder: (column) => ColumnOrderings(column));
}

class $$RealPersonsPhotoSelectionsTableAnnotationComposer
    extends Composer<_$AppDb, $RealPersonsPhotoSelectionsTable> {
  $$RealPersonsPhotoSelectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get eventCode =>
      $composableBuilder(column: $table.eventCode, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get persons =>
      $composableBuilder(column: $table.persons, builder: (column) => column);
}

class $$RealPersonsPhotoSelectionsTableTableManager extends RootTableManager<
    _$AppDb,
    $RealPersonsPhotoSelectionsTable,
    RealPersonsPhotoSelection,
    $$RealPersonsPhotoSelectionsTableFilterComposer,
    $$RealPersonsPhotoSelectionsTableOrderingComposer,
    $$RealPersonsPhotoSelectionsTableAnnotationComposer,
    $$RealPersonsPhotoSelectionsTableCreateCompanionBuilder,
    $$RealPersonsPhotoSelectionsTableUpdateCompanionBuilder,
    (
      RealPersonsPhotoSelection,
      BaseReferences<_$AppDb, $RealPersonsPhotoSelectionsTable,
          RealPersonsPhotoSelection>
    ),
    RealPersonsPhotoSelection,
    PrefetchHooks Function()> {
  $$RealPersonsPhotoSelectionsTableTableManager(
      _$AppDb db, $RealPersonsPhotoSelectionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RealPersonsPhotoSelectionsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$RealPersonsPhotoSelectionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RealPersonsPhotoSelectionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> eventCode = const Value.absent(),
            Value<String> image = const Value.absent(),
            Value<int> score = const Value.absent(),
            Value<String> persons = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RealPersonsPhotoSelectionsCompanion(
            code: code,
            eventCode: eventCode,
            image: image,
            score: score,
            persons: persons,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String eventCode,
            required String image,
            required int score,
            required String persons,
            Value<int> rowid = const Value.absent(),
          }) =>
              RealPersonsPhotoSelectionsCompanion.insert(
            code: code,
            eventCode: eventCode,
            image: image,
            score: score,
            persons: persons,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RealPersonsPhotoSelectionsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDb,
        $RealPersonsPhotoSelectionsTable,
        RealPersonsPhotoSelection,
        $$RealPersonsPhotoSelectionsTableFilterComposer,
        $$RealPersonsPhotoSelectionsTableOrderingComposer,
        $$RealPersonsPhotoSelectionsTableAnnotationComposer,
        $$RealPersonsPhotoSelectionsTableCreateCompanionBuilder,
        $$RealPersonsPhotoSelectionsTableUpdateCompanionBuilder,
        (
          RealPersonsPhotoSelection,
          BaseReferences<_$AppDb, $RealPersonsPhotoSelectionsTable,
              RealPersonsPhotoSelection>
        ),
        RealPersonsPhotoSelection,
        PrefetchHooks Function()>;
typedef $$PrintTableTableCreateCompanionBuilder = PrintTableCompanion Function({
  required String code,
  required String eventCode,
  required String ableType,
  required String ableCode,
  required int status,
  Value<int> rowid,
});
typedef $$PrintTableTableUpdateCompanionBuilder = PrintTableCompanion Function({
  Value<String> code,
  Value<String> eventCode,
  Value<String> ableType,
  Value<String> ableCode,
  Value<int> status,
  Value<int> rowid,
});

class $$PrintTableTableFilterComposer
    extends Composer<_$AppDb, $PrintTableTable> {
  $$PrintTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ableType => $composableBuilder(
      column: $table.ableType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ableCode => $composableBuilder(
      column: $table.ableCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$PrintTableTableOrderingComposer
    extends Composer<_$AppDb, $PrintTableTable> {
  $$PrintTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventCode => $composableBuilder(
      column: $table.eventCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ableType => $composableBuilder(
      column: $table.ableType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ableCode => $composableBuilder(
      column: $table.ableCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$PrintTableTableAnnotationComposer
    extends Composer<_$AppDb, $PrintTableTable> {
  $$PrintTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get eventCode =>
      $composableBuilder(column: $table.eventCode, builder: (column) => column);

  GeneratedColumn<String> get ableType =>
      $composableBuilder(column: $table.ableType, builder: (column) => column);

  GeneratedColumn<String> get ableCode =>
      $composableBuilder(column: $table.ableCode, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$PrintTableTableTableManager extends RootTableManager<
    _$AppDb,
    $PrintTableTable,
    PrintTableData,
    $$PrintTableTableFilterComposer,
    $$PrintTableTableOrderingComposer,
    $$PrintTableTableAnnotationComposer,
    $$PrintTableTableCreateCompanionBuilder,
    $$PrintTableTableUpdateCompanionBuilder,
    (PrintTableData, BaseReferences<_$AppDb, $PrintTableTable, PrintTableData>),
    PrintTableData,
    PrefetchHooks Function()> {
  $$PrintTableTableTableManager(_$AppDb db, $PrintTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrintTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrintTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrintTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> eventCode = const Value.absent(),
            Value<String> ableType = const Value.absent(),
            Value<String> ableCode = const Value.absent(),
            Value<int> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PrintTableCompanion(
            code: code,
            eventCode: eventCode,
            ableType: ableType,
            ableCode: ableCode,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String eventCode,
            required String ableType,
            required String ableCode,
            required int status,
            Value<int> rowid = const Value.absent(),
          }) =>
              PrintTableCompanion.insert(
            code: code,
            eventCode: eventCode,
            ableType: ableType,
            ableCode: ableCode,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PrintTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $PrintTableTable,
    PrintTableData,
    $$PrintTableTableFilterComposer,
    $$PrintTableTableOrderingComposer,
    $$PrintTableTableAnnotationComposer,
    $$PrintTableTableCreateCompanionBuilder,
    $$PrintTableTableUpdateCompanionBuilder,
    (PrintTableData, BaseReferences<_$AppDb, $PrintTableTable, PrintTableData>),
    PrintTableData,
    PrefetchHooks Function()>;
typedef $$UserPersonsTableCreateCompanionBuilder = UserPersonsCompanion
    Function({
  required String code,
  required String name,
  required String relationship,
  required String images,
  required int userOwnImage,
  Value<int> rowid,
});
typedef $$UserPersonsTableUpdateCompanionBuilder = UserPersonsCompanion
    Function({
  Value<String> code,
  Value<String> name,
  Value<String> relationship,
  Value<String> images,
  Value<int> userOwnImage,
  Value<int> rowid,
});

class $$UserPersonsTableFilterComposer
    extends Composer<_$AppDb, $UserPersonsTable> {
  $$UserPersonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relationship => $composableBuilder(
      column: $table.relationship, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get images => $composableBuilder(
      column: $table.images, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userOwnImage => $composableBuilder(
      column: $table.userOwnImage, builder: (column) => ColumnFilters(column));
}

class $$UserPersonsTableOrderingComposer
    extends Composer<_$AppDb, $UserPersonsTable> {
  $$UserPersonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relationship => $composableBuilder(
      column: $table.relationship,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get images => $composableBuilder(
      column: $table.images, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userOwnImage => $composableBuilder(
      column: $table.userOwnImage,
      builder: (column) => ColumnOrderings(column));
}

class $$UserPersonsTableAnnotationComposer
    extends Composer<_$AppDb, $UserPersonsTable> {
  $$UserPersonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get relationship => $composableBuilder(
      column: $table.relationship, builder: (column) => column);

  GeneratedColumn<String> get images =>
      $composableBuilder(column: $table.images, builder: (column) => column);

  GeneratedColumn<int> get userOwnImage => $composableBuilder(
      column: $table.userOwnImage, builder: (column) => column);
}

class $$UserPersonsTableTableManager extends RootTableManager<
    _$AppDb,
    $UserPersonsTable,
    UserPerson,
    $$UserPersonsTableFilterComposer,
    $$UserPersonsTableOrderingComposer,
    $$UserPersonsTableAnnotationComposer,
    $$UserPersonsTableCreateCompanionBuilder,
    $$UserPersonsTableUpdateCompanionBuilder,
    (UserPerson, BaseReferences<_$AppDb, $UserPersonsTable, UserPerson>),
    UserPerson,
    PrefetchHooks Function()> {
  $$UserPersonsTableTableManager(_$AppDb db, $UserPersonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPersonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPersonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPersonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> relationship = const Value.absent(),
            Value<String> images = const Value.absent(),
            Value<int> userOwnImage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserPersonsCompanion(
            code: code,
            name: name,
            relationship: relationship,
            images: images,
            userOwnImage: userOwnImage,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required String name,
            required String relationship,
            required String images,
            required int userOwnImage,
            Value<int> rowid = const Value.absent(),
          }) =>
              UserPersonsCompanion.insert(
            code: code,
            name: name,
            relationship: relationship,
            images: images,
            userOwnImage: userOwnImage,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserPersonsTableProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    $UserPersonsTable,
    UserPerson,
    $$UserPersonsTableFilterComposer,
    $$UserPersonsTableOrderingComposer,
    $$UserPersonsTableAnnotationComposer,
    $$UserPersonsTableCreateCompanionBuilder,
    $$UserPersonsTableUpdateCompanionBuilder,
    (UserPerson, BaseReferences<_$AppDb, $UserPersonsTable, UserPerson>),
    UserPerson,
    PrefetchHooks Function()>;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$TransportDataTableTableManager get transportData =>
      $$TransportDataTableTableManager(_db, _db.transportData);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$AlbumsTableTableManager get albums =>
      $$AlbumsTableTableManager(_db, _db.albums);
  $$JvtFilesTableTableManager get jvtFiles =>
      $$JvtFilesTableTableManager(_db, _db.jvtFiles);
  $$JvtFileConnectorsTableTableManager get jvtFileConnectors =>
      $$JvtFileConnectorsTableTableManager(_db, _db.jvtFileConnectors);
  $$FoldersTableTableManager get folders =>
      $$FoldersTableTableManager(_db, _db.folders);
  $$FolderStatusesTableTableManager get folderStatuses =>
      $$FolderStatusesTableTableManager(_db, _db.folderStatuses);
  $$FolderRulesTableTableManager get folderRules =>
      $$FolderRulesTableTableManager(_db, _db.folderRules);
  $$PhotoSelectionImagesTableTableManager get photoSelectionImages =>
      $$PhotoSelectionImagesTableTableManager(_db, _db.photoSelectionImages);
  $$EventInfoTableTableManager get eventInfo =>
      $$EventInfoTableTableManager(_db, _db.eventInfo);
  $$StudioPackageTableTableManager get studioPackage =>
      $$StudioPackageTableTableManager(_db, _db.studioPackage);
  $$StudioPackageValueTableTableManager get studioPackageValue =>
      $$StudioPackageValueTableTableManager(_db, _db.studioPackageValue);
  $$VideosTableTableManager get videos =>
      $$VideosTableTableManager(_db, _db.videos);
  $$CarouselPropertiesTableTableManager get carouselProperties =>
      $$CarouselPropertiesTableTableManager(_db, _db.carouselProperties);
  $$CarouselTableTableManager get carousel =>
      $$CarouselTableTableManager(_db, _db.carousel);
  $$MediaTableTableManager get media =>
      $$MediaTableTableManager(_db, _db.media);
  $$PhotoSelectionCurrentIndexTableTableManager
      get photoSelectionCurrentIndex =>
          $$PhotoSelectionCurrentIndexTableTableManager(
              _db, _db.photoSelectionCurrentIndex);
  $$PhotoSelectionsTableTableManager get photoSelections =>
      $$PhotoSelectionsTableTableManager(_db, _db.photoSelections);
  $$PersonsPhotoSelectionsTableTableManager get personsPhotoSelections =>
      $$PersonsPhotoSelectionsTableTableManager(
          _db, _db.personsPhotoSelections);
  $$PersonsAlbumsTableTableManager get personsAlbums =>
      $$PersonsAlbumsTableTableManager(_db, _db.personsAlbums);
  $$FolderNotificationTableTableManager get folderNotification =>
      $$FolderNotificationTableTableManager(_db, _db.folderNotification);
  $$WithOutPersonsAlbumsTableTableManager get withOutPersonsAlbums =>
      $$WithOutPersonsAlbumsTableTableManager(_db, _db.withOutPersonsAlbums);
  $$WithOutPersonsPhotoSelectionTableTableManager
      get withOutPersonsPhotoSelection =>
          $$WithOutPersonsPhotoSelectionTableTableManager(
              _db, _db.withOutPersonsPhotoSelection);
  $$PhotomallStudioInfoTableTableManager get photomallStudioInfo =>
      $$PhotomallStudioInfoTableTableManager(_db, _db.photomallStudioInfo);
  $$CommonTableTableTableManager get commonTable =>
      $$CommonTableTableTableManager(_db, _db.commonTable);
  $$RealPersonsAlbumsTableTableManager get realPersonsAlbums =>
      $$RealPersonsAlbumsTableTableManager(_db, _db.realPersonsAlbums);
  $$DownloadTableTableManager get download =>
      $$DownloadTableTableManager(_db, _db.download);
  $$PhotoSelectionImageFolderTableTableManager get photoSelectionImageFolder =>
      $$PhotoSelectionImageFolderTableTableManager(
          _db, _db.photoSelectionImageFolder);
  $$RealPersonsPhotoSelectionsTableTableManager
      get realPersonsPhotoSelections =>
          $$RealPersonsPhotoSelectionsTableTableManager(
              _db, _db.realPersonsPhotoSelections);
  $$PrintTableTableTableManager get printTable =>
      $$PrintTableTableTableManager(_db, _db.printTable);
  $$UserPersonsTableTableManager get userPersons =>
      $$UserPersonsTableTableManager(_db, _db.userPersons);
}
