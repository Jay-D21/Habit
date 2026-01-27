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

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the Feedback type in your schema. */
class Feedback extends amplify_core.Model {
  static const classType = const _FeedbackModelType();
  final String id;
  final String? _message;
  final FeedbackType? _type;
  final String? _userEmail;
  final String? _userName;
  final String? _appVersion;
  final String? _platform;
  final String? _status;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  FeedbackModelIdentifier get modelIdentifier {
      return FeedbackModelIdentifier(
        id: id
      );
  }
  
  String get message {
    try {
      return _message!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  FeedbackType get type {
    try {
      return _type!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get userEmail {
    return _userEmail;
  }
  
  String? get userName {
    return _userName;
  }
  
  String? get appVersion {
    return _appVersion;
  }
  
  String? get platform {
    return _platform;
  }
  
  String? get status {
    return _status;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Feedback._internal({required this.id, required message, required type, userEmail, userName, appVersion, platform, status, createdAt, updatedAt}): _message = message, _type = type, _userEmail = userEmail, _userName = userName, _appVersion = appVersion, _platform = platform, _status = status, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Feedback({String? id, required String message, required FeedbackType type, String? userEmail, String? userName, String? appVersion, String? platform, String? status}) {
    return Feedback._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      message: message,
      type: type,
      userEmail: userEmail,
      userName: userName,
      appVersion: appVersion,
      platform: platform,
      status: status);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Feedback &&
      id == other.id &&
      _message == other._message &&
      _type == other._type &&
      _userEmail == other._userEmail &&
      _userName == other._userName &&
      _appVersion == other._appVersion &&
      _platform == other._platform &&
      _status == other._status;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Feedback {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("message=" + "$_message" + ", ");
    buffer.write("type=" + (_type != null ? amplify_core.enumToString(_type)! : "null") + ", ");
    buffer.write("userEmail=" + "$_userEmail" + ", ");
    buffer.write("userName=" + "$_userName" + ", ");
    buffer.write("appVersion=" + "$_appVersion" + ", ");
    buffer.write("platform=" + "$_platform" + ", ");
    buffer.write("status=" + "$_status" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Feedback copyWith({String? message, FeedbackType? type, String? userEmail, String? userName, String? appVersion, String? platform, String? status}) {
    return Feedback._internal(
      id: id,
      message: message ?? this.message,
      type: type ?? this.type,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      appVersion: appVersion ?? this.appVersion,
      platform: platform ?? this.platform,
      status: status ?? this.status);
  }
  
  Feedback copyWithModelFieldValues({
    ModelFieldValue<String>? message,
    ModelFieldValue<FeedbackType>? type,
    ModelFieldValue<String?>? userEmail,
    ModelFieldValue<String?>? userName,
    ModelFieldValue<String?>? appVersion,
    ModelFieldValue<String?>? platform,
    ModelFieldValue<String?>? status
  }) {
    return Feedback._internal(
      id: id,
      message: message == null ? this.message : message.value,
      type: type == null ? this.type : type.value,
      userEmail: userEmail == null ? this.userEmail : userEmail.value,
      userName: userName == null ? this.userName : userName.value,
      appVersion: appVersion == null ? this.appVersion : appVersion.value,
      platform: platform == null ? this.platform : platform.value,
      status: status == null ? this.status : status.value
    );
  }
  
  Feedback.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _message = json['message'],
      _type = amplify_core.enumFromString<FeedbackType>(json['type'], FeedbackType.values),
      _userEmail = json['userEmail'],
      _userName = json['userName'],
      _appVersion = json['appVersion'],
      _platform = json['platform'],
      _status = json['status'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'message': _message, 'type': amplify_core.enumToString(_type), 'userEmail': _userEmail, 'userName': _userName, 'appVersion': _appVersion, 'platform': _platform, 'status': _status, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'message': _message,
    'type': _type,
    'userEmail': _userEmail,
    'userName': _userName,
    'appVersion': _appVersion,
    'platform': _platform,
    'status': _status,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<FeedbackModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<FeedbackModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final MESSAGE = amplify_core.QueryField(fieldName: "message");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final USEREMAIL = amplify_core.QueryField(fieldName: "userEmail");
  static final USERNAME = amplify_core.QueryField(fieldName: "userName");
  static final APPVERSION = amplify_core.QueryField(fieldName: "appVersion");
  static final PLATFORM = amplify_core.QueryField(fieldName: "platform");
  static final STATUS = amplify_core.QueryField(fieldName: "status");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Feedback";
    modelSchemaDefinition.pluralName = "Feedbacks";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Feedback.MESSAGE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Feedback.TYPE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Feedback.USEREMAIL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Feedback.USERNAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Feedback.APPVERSION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Feedback.PLATFORM,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Feedback.STATUS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _FeedbackModelType extends amplify_core.ModelType<Feedback> {
  const _FeedbackModelType();
  
  @override
  Feedback fromJson(Map<String, dynamic> jsonData) {
    return Feedback.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Feedback';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Feedback] in your schema.
 */
class FeedbackModelIdentifier implements amplify_core.ModelIdentifier<Feedback> {
  final String id;

  /** Create an instance of FeedbackModelIdentifier using [id] the primary key. */
  const FeedbackModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'FeedbackModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is FeedbackModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}