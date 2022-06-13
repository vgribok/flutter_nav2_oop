/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Activity type in your schema. */
@immutable
class Activity extends Model {
  static const classType = const _ActivityModelType();
  final String id;
  final String? _personId;
  final TemporalDate? _date;
  final int? _orderOrTime;
  final ActivityType? _type;
  final int? _userLogEntryNumber;
  final String? _notes;
  final String? _guidePersonId;
  final String? _providerId;
  final double? _locationLatitude;
  final double? _locationLongitude;
  final String? _trip;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get personId {
    return _personId;
  }
  
  TemporalDate get date {
    try {
      return _date!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get orderOrTime {
    try {
      return _orderOrTime!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  ActivityType get type {
    try {
      return _type!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int? get userLogEntryNumber {
    return _userLogEntryNumber;
  }
  
  String? get notes {
    return _notes;
  }
  
  String? get guidePersonId {
    return _guidePersonId;
  }
  
  String? get providerId {
    return _providerId;
  }
  
  double? get locationLatitude {
    return _locationLatitude;
  }
  
  double? get locationLongitude {
    return _locationLongitude;
  }
  
  String? get trip {
    return _trip;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Activity._internal({required this.id, personId, required date, required orderOrTime, required type, userLogEntryNumber, notes, guidePersonId, providerId, locationLatitude, locationLongitude, trip, createdAt, updatedAt}): _personId = personId, _date = date, _orderOrTime = orderOrTime, _type = type, _userLogEntryNumber = userLogEntryNumber, _notes = notes, _guidePersonId = guidePersonId, _providerId = providerId, _locationLatitude = locationLatitude, _locationLongitude = locationLongitude, _trip = trip, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Activity({String? id, String? personId, required TemporalDate date, required int orderOrTime, required ActivityType type, int? userLogEntryNumber, String? notes, String? guidePersonId, String? providerId, double? locationLatitude, double? locationLongitude, String? trip}) {
    return Activity._internal(
      id: id == null ? UUID.getUUID() : id,
      personId: personId,
      date: date,
      orderOrTime: orderOrTime,
      type: type,
      userLogEntryNumber: userLogEntryNumber,
      notes: notes,
      guidePersonId: guidePersonId,
      providerId: providerId,
      locationLatitude: locationLatitude,
      locationLongitude: locationLongitude,
      trip: trip);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Activity &&
      id == other.id &&
      _personId == other._personId &&
      _date == other._date &&
      _orderOrTime == other._orderOrTime &&
      _type == other._type &&
      _userLogEntryNumber == other._userLogEntryNumber &&
      _notes == other._notes &&
      _guidePersonId == other._guidePersonId &&
      _providerId == other._providerId &&
      _locationLatitude == other._locationLatitude &&
      _locationLongitude == other._locationLongitude &&
      _trip == other._trip;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Activity {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("personId=" + "$_personId" + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("orderOrTime=" + (_orderOrTime != null ? _orderOrTime!.toString() : "null") + ", ");
    buffer.write("type=" + (_type != null ? enumToString(_type)! : "null") + ", ");
    buffer.write("userLogEntryNumber=" + (_userLogEntryNumber != null ? _userLogEntryNumber!.toString() : "null") + ", ");
    buffer.write("notes=" + "$_notes" + ", ");
    buffer.write("guidePersonId=" + "$_guidePersonId" + ", ");
    buffer.write("providerId=" + "$_providerId" + ", ");
    buffer.write("locationLatitude=" + (_locationLatitude != null ? _locationLatitude!.toString() : "null") + ", ");
    buffer.write("locationLongitude=" + (_locationLongitude != null ? _locationLongitude!.toString() : "null") + ", ");
    buffer.write("trip=" + "$_trip" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Activity copyWith({String? id, String? personId, TemporalDate? date, int? orderOrTime, ActivityType? type, int? userLogEntryNumber, String? notes, String? guidePersonId, String? providerId, double? locationLatitude, double? locationLongitude, String? trip}) {
    return Activity._internal(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      date: date ?? this.date,
      orderOrTime: orderOrTime ?? this.orderOrTime,
      type: type ?? this.type,
      userLogEntryNumber: userLogEntryNumber ?? this.userLogEntryNumber,
      notes: notes ?? this.notes,
      guidePersonId: guidePersonId ?? this.guidePersonId,
      providerId: providerId ?? this.providerId,
      locationLatitude: locationLatitude ?? this.locationLatitude,
      locationLongitude: locationLongitude ?? this.locationLongitude,
      trip: trip ?? this.trip);
  }
  
  Activity.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _personId = json['personId'],
      _date = json['date'] != null ? TemporalDate.fromString(json['date']) : null,
      _orderOrTime = (json['orderOrTime'] as num?)?.toInt(),
      _type = enumFromString<ActivityType>(json['type'], ActivityType.values),
      _userLogEntryNumber = (json['userLogEntryNumber'] as num?)?.toInt(),
      _notes = json['notes'],
      _guidePersonId = json['guidePersonId'],
      _providerId = json['providerId'],
      _locationLatitude = (json['locationLatitude'] as num?)?.toDouble(),
      _locationLongitude = (json['locationLongitude'] as num?)?.toDouble(),
      _trip = json['trip'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'personId': _personId, 'date': _date?.format(), 'orderOrTime': _orderOrTime, 'type': enumToString(_type), 'userLogEntryNumber': _userLogEntryNumber, 'notes': _notes, 'guidePersonId': _guidePersonId, 'providerId': _providerId, 'locationLatitude': _locationLatitude, 'locationLongitude': _locationLongitude, 'trip': _trip, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "activity.id");
  static final QueryField PERSONID = QueryField(fieldName: "personId");
  static final QueryField DATE = QueryField(fieldName: "date");
  static final QueryField ORDERORTIME = QueryField(fieldName: "orderOrTime");
  static final QueryField TYPE = QueryField(fieldName: "type");
  static final QueryField USERLOGENTRYNUMBER = QueryField(fieldName: "userLogEntryNumber");
  static final QueryField NOTES = QueryField(fieldName: "notes");
  static final QueryField GUIDEPERSONID = QueryField(fieldName: "guidePersonId");
  static final QueryField PROVIDERID = QueryField(fieldName: "providerId");
  static final QueryField LOCATIONLATITUDE = QueryField(fieldName: "locationLatitude");
  static final QueryField LOCATIONLONGITUDE = QueryField(fieldName: "locationLongitude");
  static final QueryField TRIP = QueryField(fieldName: "trip");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Activity";
    modelSchemaDefinition.pluralName = "Activities";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.OWNER,
        ownerField: "personId",
        identityClaim: "cognito:username",
        provider: AuthRuleProvider.USERPOOLS,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ]),
      AuthRule(
        authStrategy: AuthStrategy.GROUPS,
        groupClaim: "cognito:groups",
        groups: [ "GsAdmins", "GsModerators" ],
        provider: AuthRuleProvider.USERPOOLS,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Activity.PERSONID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Activity.DATE,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Activity.ORDERORTIME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Activity.TYPE,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Activity.USERLOGENTRYNUMBER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Activity.NOTES,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Activity.GUIDEPERSONID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Activity.PROVIDERID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Activity.LOCATIONLATITUDE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Activity.LOCATIONLONGITUDE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Activity.TRIP,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _ActivityModelType extends ModelType<Activity> {
  const _ActivityModelType();
  
  @override
  Activity fromJson(Map<String, dynamic> jsonData) {
    return Activity.fromJson(jsonData);
  }
}