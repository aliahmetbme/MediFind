// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhoneNumberImpl _$$PhoneNumberImplFromJson(Map<String, dynamic> json) =>
    _$PhoneNumberImpl(
      countryCode: json['countryCode'] as String,
      number: json['number'] as String,
    );

Map<String, dynamic> _$$PhoneNumberImplToJson(_$PhoneNumberImpl instance) =>
    <String, dynamic>{
      'countryCode': instance.countryCode,
      'number': instance.number,
    };

_$ContactInfoImpl _$$ContactInfoImplFromJson(Map<String, dynamic> json) =>
    _$ContactInfoImpl(
      email: json['email'] as String?,
      phone: json['phone'] == null
          ? null
          : PhoneNumber.fromJson(json['phone'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ContactInfoImplToJson(_$ContactInfoImpl instance) =>
    <String, dynamic>{'email': instance.email, 'phone': instance.phone};
