// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provider_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProviderModel _$ProviderModelFromJson(Map<String, dynamic> json) {
  return _ProviderModel.fromJson(json);
}

/// @nodoc
mixin _$ProviderModel {
  // ── Identity ─────────────────────────────────────────────────────────────
  /// Unique identifier used for navigation and API lookups.
  String get id => throw _privateConstructorUsedError;

  /// Remote URL for the provider's profile photo. Null → show placeholder.
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Whether the provider holds board certification.
  /// Defaults to `false` when the API omits this field.
  bool get isBoardCertified =>
      throw _privateConstructorUsedError; // ── Name / Role ───────────────────────────────────────────────────────────
  /// Honorific prefix, e.g. "Dr.", "Prof.", "Assoc. Prof.".
  String get title => throw _privateConstructorUsedError;

  /// Full name of the provider, e.g. "Julian Thorne".
  String get name => throw _privateConstructorUsedError;

  /// Current professional role, e.g. "Senior Interventional Cardiologist".
  String get role =>
      throw _privateConstructorUsedError; // ── Location ──────────────────────────────────────────────────────────────
  /// City where the provider primarily practices.
  String get city => throw _privateConstructorUsedError;

  /// Hospital or clinic name. Null when the provider is not hospital-affiliated.
  String? get hospital => throw _privateConstructorUsedError;

  /// Countries the provider is licensed to practice in.
  /// Defaults to an empty list when the API omits this field.
  List<String> get countries =>
      throw _privateConstructorUsedError; // ── Ratings ───────────────────────────────────────────────────────────────
  /// Aggregate star rating (0.0 – 5.0). Null when no reviews exist yet.
  double? get rating => throw _privateConstructorUsedError;

  /// Total number of patient reviews. Null when no reviews exist yet.
  int? get reviewCount =>
      throw _privateConstructorUsedError; // ── Contact ───────────────────────────────────────────────────────────────
  /// Structured contact details (email, phone). Null when not disclosed.
  ContactInfo? get contactInfo =>
      throw _privateConstructorUsedError; // ── Bio ───────────────────────────────────────────────────────────────────
  /// Free-text biography / about section. Null when the API omits this field.
  String? get about =>
      throw _privateConstructorUsedError; // ── Specialties & Availability ────────────────────────────────────────────
  /// Medical specialties the provider covers.
  /// Defaults to an empty list when the API omits this field.
  @JsonKey(fromJson: _specialtiesFromJson, toJson: _specialtiesToJson)
  List<ProviderSpecialty> get specialties => throw _privateConstructorUsedError;

  /// Days of the week the provider is available, e.g. ["Monday", "Friday"].
  /// Defaults to an empty list when the API omits this field.
  List<String> get availableDays => throw _privateConstructorUsedError;

  /// Serializes this ProviderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProviderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProviderModelCopyWith<ProviderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProviderModelCopyWith<$Res> {
  factory $ProviderModelCopyWith(
    ProviderModel value,
    $Res Function(ProviderModel) then,
  ) = _$ProviderModelCopyWithImpl<$Res, ProviderModel>;
  @useResult
  $Res call({
    String id,
    String? imageUrl,
    bool isBoardCertified,
    String title,
    String name,
    String role,
    String city,
    String? hospital,
    List<String> countries,
    double? rating,
    int? reviewCount,
    ContactInfo? contactInfo,
    String? about,
    @JsonKey(fromJson: _specialtiesFromJson, toJson: _specialtiesToJson)
    List<ProviderSpecialty> specialties,
    List<String> availableDays,
  });

  $ContactInfoCopyWith<$Res>? get contactInfo;
}

/// @nodoc
class _$ProviderModelCopyWithImpl<$Res, $Val extends ProviderModel>
    implements $ProviderModelCopyWith<$Res> {
  _$ProviderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProviderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = freezed,
    Object? isBoardCertified = null,
    Object? title = null,
    Object? name = null,
    Object? role = null,
    Object? city = null,
    Object? hospital = freezed,
    Object? countries = null,
    Object? rating = freezed,
    Object? reviewCount = freezed,
    Object? contactInfo = freezed,
    Object? about = freezed,
    Object? specialties = null,
    Object? availableDays = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            isBoardCertified: null == isBoardCertified
                ? _value.isBoardCertified
                : isBoardCertified // ignore: cast_nullable_to_non_nullable
                      as bool,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            hospital: freezed == hospital
                ? _value.hospital
                : hospital // ignore: cast_nullable_to_non_nullable
                      as String?,
            countries: null == countries
                ? _value.countries
                : countries // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
            reviewCount: freezed == reviewCount
                ? _value.reviewCount
                : reviewCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            contactInfo: freezed == contactInfo
                ? _value.contactInfo
                : contactInfo // ignore: cast_nullable_to_non_nullable
                      as ContactInfo?,
            about: freezed == about
                ? _value.about
                : about // ignore: cast_nullable_to_non_nullable
                      as String?,
            specialties: null == specialties
                ? _value.specialties
                : specialties // ignore: cast_nullable_to_non_nullable
                      as List<ProviderSpecialty>,
            availableDays: null == availableDays
                ? _value.availableDays
                : availableDays // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }

  /// Create a copy of ProviderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactInfoCopyWith<$Res>? get contactInfo {
    if (_value.contactInfo == null) {
      return null;
    }

    return $ContactInfoCopyWith<$Res>(_value.contactInfo!, (value) {
      return _then(_value.copyWith(contactInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProviderModelImplCopyWith<$Res>
    implements $ProviderModelCopyWith<$Res> {
  factory _$$ProviderModelImplCopyWith(
    _$ProviderModelImpl value,
    $Res Function(_$ProviderModelImpl) then,
  ) = __$$ProviderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? imageUrl,
    bool isBoardCertified,
    String title,
    String name,
    String role,
    String city,
    String? hospital,
    List<String> countries,
    double? rating,
    int? reviewCount,
    ContactInfo? contactInfo,
    String? about,
    @JsonKey(fromJson: _specialtiesFromJson, toJson: _specialtiesToJson)
    List<ProviderSpecialty> specialties,
    List<String> availableDays,
  });

  @override
  $ContactInfoCopyWith<$Res>? get contactInfo;
}

/// @nodoc
class __$$ProviderModelImplCopyWithImpl<$Res>
    extends _$ProviderModelCopyWithImpl<$Res, _$ProviderModelImpl>
    implements _$$ProviderModelImplCopyWith<$Res> {
  __$$ProviderModelImplCopyWithImpl(
    _$ProviderModelImpl _value,
    $Res Function(_$ProviderModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProviderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = freezed,
    Object? isBoardCertified = null,
    Object? title = null,
    Object? name = null,
    Object? role = null,
    Object? city = null,
    Object? hospital = freezed,
    Object? countries = null,
    Object? rating = freezed,
    Object? reviewCount = freezed,
    Object? contactInfo = freezed,
    Object? about = freezed,
    Object? specialties = null,
    Object? availableDays = null,
  }) {
    return _then(
      _$ProviderModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        isBoardCertified: null == isBoardCertified
            ? _value.isBoardCertified
            : isBoardCertified // ignore: cast_nullable_to_non_nullable
                  as bool,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        hospital: freezed == hospital
            ? _value.hospital
            : hospital // ignore: cast_nullable_to_non_nullable
                  as String?,
        countries: null == countries
            ? _value._countries
            : countries // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
        reviewCount: freezed == reviewCount
            ? _value.reviewCount
            : reviewCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        contactInfo: freezed == contactInfo
            ? _value.contactInfo
            : contactInfo // ignore: cast_nullable_to_non_nullable
                  as ContactInfo?,
        about: freezed == about
            ? _value.about
            : about // ignore: cast_nullable_to_non_nullable
                  as String?,
        specialties: null == specialties
            ? _value._specialties
            : specialties // ignore: cast_nullable_to_non_nullable
                  as List<ProviderSpecialty>,
        availableDays: null == availableDays
            ? _value._availableDays
            : availableDays // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProviderModelImpl implements _ProviderModel {
  const _$ProviderModelImpl({
    required this.id,
    this.imageUrl,
    this.isBoardCertified = false,
    required this.title,
    required this.name,
    required this.role,
    required this.city,
    this.hospital,
    final List<String> countries = const <String>[],
    this.rating,
    this.reviewCount,
    this.contactInfo,
    this.about,
    @JsonKey(fromJson: _specialtiesFromJson, toJson: _specialtiesToJson)
    final List<ProviderSpecialty> specialties = const <ProviderSpecialty>[],
    final List<String> availableDays = const <String>[],
  }) : _countries = countries,
       _specialties = specialties,
       _availableDays = availableDays;

  factory _$ProviderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProviderModelImplFromJson(json);

  // ── Identity ─────────────────────────────────────────────────────────────
  /// Unique identifier used for navigation and API lookups.
  @override
  final String id;

  /// Remote URL for the provider's profile photo. Null → show placeholder.
  @override
  final String? imageUrl;

  /// Whether the provider holds board certification.
  /// Defaults to `false` when the API omits this field.
  @override
  @JsonKey()
  final bool isBoardCertified;
  // ── Name / Role ───────────────────────────────────────────────────────────
  /// Honorific prefix, e.g. "Dr.", "Prof.", "Assoc. Prof.".
  @override
  final String title;

  /// Full name of the provider, e.g. "Julian Thorne".
  @override
  final String name;

  /// Current professional role, e.g. "Senior Interventional Cardiologist".
  @override
  final String role;
  // ── Location ──────────────────────────────────────────────────────────────
  /// City where the provider primarily practices.
  @override
  final String city;

  /// Hospital or clinic name. Null when the provider is not hospital-affiliated.
  @override
  final String? hospital;

  /// Countries the provider is licensed to practice in.
  /// Defaults to an empty list when the API omits this field.
  final List<String> _countries;

  /// Countries the provider is licensed to practice in.
  /// Defaults to an empty list when the API omits this field.
  @override
  @JsonKey()
  List<String> get countries {
    if (_countries is EqualUnmodifiableListView) return _countries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_countries);
  }

  // ── Ratings ───────────────────────────────────────────────────────────────
  /// Aggregate star rating (0.0 – 5.0). Null when no reviews exist yet.
  @override
  final double? rating;

  /// Total number of patient reviews. Null when no reviews exist yet.
  @override
  final int? reviewCount;
  // ── Contact ───────────────────────────────────────────────────────────────
  /// Structured contact details (email, phone). Null when not disclosed.
  @override
  final ContactInfo? contactInfo;
  // ── Bio ───────────────────────────────────────────────────────────────────
  /// Free-text biography / about section. Null when the API omits this field.
  @override
  final String? about;
  // ── Specialties & Availability ────────────────────────────────────────────
  /// Medical specialties the provider covers.
  /// Defaults to an empty list when the API omits this field.
  final List<ProviderSpecialty> _specialties;
  // ── Specialties & Availability ────────────────────────────────────────────
  /// Medical specialties the provider covers.
  /// Defaults to an empty list when the API omits this field.
  @override
  @JsonKey(fromJson: _specialtiesFromJson, toJson: _specialtiesToJson)
  List<ProviderSpecialty> get specialties {
    if (_specialties is EqualUnmodifiableListView) return _specialties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specialties);
  }

  /// Days of the week the provider is available, e.g. ["Monday", "Friday"].
  /// Defaults to an empty list when the API omits this field.
  final List<String> _availableDays;

  /// Days of the week the provider is available, e.g. ["Monday", "Friday"].
  /// Defaults to an empty list when the API omits this field.
  @override
  @JsonKey()
  List<String> get availableDays {
    if (_availableDays is EqualUnmodifiableListView) return _availableDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableDays);
  }

  @override
  String toString() {
    return 'ProviderModel(id: $id, imageUrl: $imageUrl, isBoardCertified: $isBoardCertified, title: $title, name: $name, role: $role, city: $city, hospital: $hospital, countries: $countries, rating: $rating, reviewCount: $reviewCount, contactInfo: $contactInfo, about: $about, specialties: $specialties, availableDays: $availableDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProviderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isBoardCertified, isBoardCertified) ||
                other.isBoardCertified == isBoardCertified) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.hospital, hospital) ||
                other.hospital == hospital) &&
            const DeepCollectionEquality().equals(
              other._countries,
              _countries,
            ) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.contactInfo, contactInfo) ||
                other.contactInfo == contactInfo) &&
            (identical(other.about, about) || other.about == about) &&
            const DeepCollectionEquality().equals(
              other._specialties,
              _specialties,
            ) &&
            const DeepCollectionEquality().equals(
              other._availableDays,
              _availableDays,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    imageUrl,
    isBoardCertified,
    title,
    name,
    role,
    city,
    hospital,
    const DeepCollectionEquality().hash(_countries),
    rating,
    reviewCount,
    contactInfo,
    about,
    const DeepCollectionEquality().hash(_specialties),
    const DeepCollectionEquality().hash(_availableDays),
  );

  /// Create a copy of ProviderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProviderModelImplCopyWith<_$ProviderModelImpl> get copyWith =>
      __$$ProviderModelImplCopyWithImpl<_$ProviderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProviderModelImplToJson(this);
  }
}

abstract class _ProviderModel implements ProviderModel {
  const factory _ProviderModel({
    required final String id,
    final String? imageUrl,
    final bool isBoardCertified,
    required final String title,
    required final String name,
    required final String role,
    required final String city,
    final String? hospital,
    final List<String> countries,
    final double? rating,
    final int? reviewCount,
    final ContactInfo? contactInfo,
    final String? about,
    @JsonKey(fromJson: _specialtiesFromJson, toJson: _specialtiesToJson)
    final List<ProviderSpecialty> specialties,
    final List<String> availableDays,
  }) = _$ProviderModelImpl;

  factory _ProviderModel.fromJson(Map<String, dynamic> json) =
      _$ProviderModelImpl.fromJson;

  // ── Identity ─────────────────────────────────────────────────────────────
  /// Unique identifier used for navigation and API lookups.
  @override
  String get id;

  /// Remote URL for the provider's profile photo. Null → show placeholder.
  @override
  String? get imageUrl;

  /// Whether the provider holds board certification.
  /// Defaults to `false` when the API omits this field.
  @override
  bool get isBoardCertified; // ── Name / Role ───────────────────────────────────────────────────────────
  /// Honorific prefix, e.g. "Dr.", "Prof.", "Assoc. Prof.".
  @override
  String get title;

  /// Full name of the provider, e.g. "Julian Thorne".
  @override
  String get name;

  /// Current professional role, e.g. "Senior Interventional Cardiologist".
  @override
  String get role; // ── Location ──────────────────────────────────────────────────────────────
  /// City where the provider primarily practices.
  @override
  String get city;

  /// Hospital or clinic name. Null when the provider is not hospital-affiliated.
  @override
  String? get hospital;

  /// Countries the provider is licensed to practice in.
  /// Defaults to an empty list when the API omits this field.
  @override
  List<String> get countries; // ── Ratings ───────────────────────────────────────────────────────────────
  /// Aggregate star rating (0.0 – 5.0). Null when no reviews exist yet.
  @override
  double? get rating;

  /// Total number of patient reviews. Null when no reviews exist yet.
  @override
  int? get reviewCount; // ── Contact ───────────────────────────────────────────────────────────────
  /// Structured contact details (email, phone). Null when not disclosed.
  @override
  ContactInfo? get contactInfo; // ── Bio ───────────────────────────────────────────────────────────────────
  /// Free-text biography / about section. Null when the API omits this field.
  @override
  String? get about; // ── Specialties & Availability ────────────────────────────────────────────
  /// Medical specialties the provider covers.
  /// Defaults to an empty list when the API omits this field.
  @override
  @JsonKey(fromJson: _specialtiesFromJson, toJson: _specialtiesToJson)
  List<ProviderSpecialty> get specialties;

  /// Days of the week the provider is available, e.g. ["Monday", "Friday"].
  /// Defaults to an empty list when the API omits this field.
  @override
  List<String> get availableDays;

  /// Create a copy of ProviderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProviderModelImplCopyWith<_$ProviderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
