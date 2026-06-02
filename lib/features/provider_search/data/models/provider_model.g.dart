// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProviderModelImpl _$$ProviderModelImplFromJson(Map<String, dynamic> json) =>
    _$ProviderModelImpl(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String?,
      isBoardCertified: json['isBoardCertified'] as bool? ?? false,
      title: json['title'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      city: json['city'] as String,
      hospital: json['hospital'] as String?,
      countries:
          (json['countries'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: (json['reviewCount'] as num?)?.toInt(),
      contactInfo: json['contactInfo'] == null
          ? null
          : ContactInfo.fromJson(json['contactInfo'] as Map<String, dynamic>),
      about: json['about'] as String?,
      specialties: json['specialties'] == null
          ? const <ProviderSpecialty>[]
          : _specialtiesFromJson(json['specialties'] as List),
      availableDays:
          (json['availableDays'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$$ProviderModelImplToJson(_$ProviderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'isBoardCertified': instance.isBoardCertified,
      'title': instance.title,
      'name': instance.name,
      'role': instance.role,
      'city': instance.city,
      'hospital': instance.hospital,
      'countries': instance.countries,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'contactInfo': instance.contactInfo,
      'about': instance.about,
      'specialties': _specialtiesToJson(instance.specialties),
      'availableDays': instance.availableDays,
    };
