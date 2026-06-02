// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PhoneNumber _$PhoneNumberFromJson(Map<String, dynamic> json) {
  return _PhoneNumber.fromJson(json);
}

/// @nodoc
mixin _$PhoneNumber {
  /// ITU-T country dialling code, e.g. "+1", "+44".
  String get countryCode => throw _privateConstructorUsedError;

  /// Local subscriber number, e.g. "555-0100".
  String get number => throw _privateConstructorUsedError;

  /// Serializes this PhoneNumber to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhoneNumber
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhoneNumberCopyWith<PhoneNumber> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhoneNumberCopyWith<$Res> {
  factory $PhoneNumberCopyWith(
    PhoneNumber value,
    $Res Function(PhoneNumber) then,
  ) = _$PhoneNumberCopyWithImpl<$Res, PhoneNumber>;
  @useResult
  $Res call({String countryCode, String number});
}

/// @nodoc
class _$PhoneNumberCopyWithImpl<$Res, $Val extends PhoneNumber>
    implements $PhoneNumberCopyWith<$Res> {
  _$PhoneNumberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhoneNumber
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? countryCode = null, Object? number = null}) {
    return _then(
      _value.copyWith(
            countryCode: null == countryCode
                ? _value.countryCode
                : countryCode // ignore: cast_nullable_to_non_nullable
                      as String,
            number: null == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PhoneNumberImplCopyWith<$Res>
    implements $PhoneNumberCopyWith<$Res> {
  factory _$$PhoneNumberImplCopyWith(
    _$PhoneNumberImpl value,
    $Res Function(_$PhoneNumberImpl) then,
  ) = __$$PhoneNumberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String countryCode, String number});
}

/// @nodoc
class __$$PhoneNumberImplCopyWithImpl<$Res>
    extends _$PhoneNumberCopyWithImpl<$Res, _$PhoneNumberImpl>
    implements _$$PhoneNumberImplCopyWith<$Res> {
  __$$PhoneNumberImplCopyWithImpl(
    _$PhoneNumberImpl _value,
    $Res Function(_$PhoneNumberImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PhoneNumber
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? countryCode = null, Object? number = null}) {
    return _then(
      _$PhoneNumberImpl(
        countryCode: null == countryCode
            ? _value.countryCode
            : countryCode // ignore: cast_nullable_to_non_nullable
                  as String,
        number: null == number
            ? _value.number
            : number // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PhoneNumberImpl implements _PhoneNumber {
  const _$PhoneNumberImpl({required this.countryCode, required this.number});

  factory _$PhoneNumberImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhoneNumberImplFromJson(json);

  /// ITU-T country dialling code, e.g. "+1", "+44".
  @override
  final String countryCode;

  /// Local subscriber number, e.g. "555-0100".
  @override
  final String number;

  @override
  String toString() {
    return 'PhoneNumber(countryCode: $countryCode, number: $number)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhoneNumberImpl &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.number, number) || other.number == number));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, countryCode, number);

  /// Create a copy of PhoneNumber
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhoneNumberImplCopyWith<_$PhoneNumberImpl> get copyWith =>
      __$$PhoneNumberImplCopyWithImpl<_$PhoneNumberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhoneNumberImplToJson(this);
  }
}

abstract class _PhoneNumber implements PhoneNumber {
  const factory _PhoneNumber({
    required final String countryCode,
    required final String number,
  }) = _$PhoneNumberImpl;

  factory _PhoneNumber.fromJson(Map<String, dynamic> json) =
      _$PhoneNumberImpl.fromJson;

  /// ITU-T country dialling code, e.g. "+1", "+44".
  @override
  String get countryCode;

  /// Local subscriber number, e.g. "555-0100".
  @override
  String get number;

  /// Create a copy of PhoneNumber
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhoneNumberImplCopyWith<_$PhoneNumberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ContactInfo _$ContactInfoFromJson(Map<String, dynamic> json) {
  return _ContactInfo.fromJson(json);
}

/// @nodoc
mixin _$ContactInfo {
  /// Optional e-mail address of the provider or their practice.
  String? get email => throw _privateConstructorUsedError;

  /// Optional structured phone number. Null when the API omits the field.
  PhoneNumber? get phone => throw _privateConstructorUsedError;

  /// Serializes this ContactInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactInfoCopyWith<ContactInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactInfoCopyWith<$Res> {
  factory $ContactInfoCopyWith(
    ContactInfo value,
    $Res Function(ContactInfo) then,
  ) = _$ContactInfoCopyWithImpl<$Res, ContactInfo>;
  @useResult
  $Res call({String? email, PhoneNumber? phone});

  $PhoneNumberCopyWith<$Res>? get phone;
}

/// @nodoc
class _$ContactInfoCopyWithImpl<$Res, $Val extends ContactInfo>
    implements $ContactInfoCopyWith<$Res> {
  _$ContactInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = freezed, Object? phone = freezed}) {
    return _then(
      _value.copyWith(
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as PhoneNumber?,
          )
          as $Val,
    );
  }

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PhoneNumberCopyWith<$Res>? get phone {
    if (_value.phone == null) {
      return null;
    }

    return $PhoneNumberCopyWith<$Res>(_value.phone!, (value) {
      return _then(_value.copyWith(phone: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ContactInfoImplCopyWith<$Res>
    implements $ContactInfoCopyWith<$Res> {
  factory _$$ContactInfoImplCopyWith(
    _$ContactInfoImpl value,
    $Res Function(_$ContactInfoImpl) then,
  ) = __$$ContactInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? email, PhoneNumber? phone});

  @override
  $PhoneNumberCopyWith<$Res>? get phone;
}

/// @nodoc
class __$$ContactInfoImplCopyWithImpl<$Res>
    extends _$ContactInfoCopyWithImpl<$Res, _$ContactInfoImpl>
    implements _$$ContactInfoImplCopyWith<$Res> {
  __$$ContactInfoImplCopyWithImpl(
    _$ContactInfoImpl _value,
    $Res Function(_$ContactInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = freezed, Object? phone = freezed}) {
    return _then(
      _$ContactInfoImpl(
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as PhoneNumber?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactInfoImpl implements _ContactInfo {
  const _$ContactInfoImpl({this.email, this.phone});

  factory _$ContactInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactInfoImplFromJson(json);

  /// Optional e-mail address of the provider or their practice.
  @override
  final String? email;

  /// Optional structured phone number. Null when the API omits the field.
  @override
  final PhoneNumber? phone;

  @override
  String toString() {
    return 'ContactInfo(email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactInfoImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, phone);

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactInfoImplCopyWith<_$ContactInfoImpl> get copyWith =>
      __$$ContactInfoImplCopyWithImpl<_$ContactInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactInfoImplToJson(this);
  }
}

abstract class _ContactInfo implements ContactInfo {
  const factory _ContactInfo({final String? email, final PhoneNumber? phone}) =
      _$ContactInfoImpl;

  factory _ContactInfo.fromJson(Map<String, dynamic> json) =
      _$ContactInfoImpl.fromJson;

  /// Optional e-mail address of the provider or their practice.
  @override
  String? get email;

  /// Optional structured phone number. Null when the API omits the field.
  @override
  PhoneNumber? get phone;

  /// Create a copy of ContactInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactInfoImplCopyWith<_$ContactInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
