//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdmLicense {
  /// Returns a new [AdmLicense] instance.
  AdmLicense({
    this.id,
    this.activatedDate,
    this.expireDate,
    this.userId,
    this.userNumber,
    this.activeUserNumber,
    this.description,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? id;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? activatedDate;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? expireDate;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? userId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? userNumber;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? activeUserNumber;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdmLicense &&
     other.id == id &&
     other.activatedDate == activatedDate &&
     other.expireDate == expireDate &&
     other.userId == userId &&
     other.userNumber == userNumber &&
     other.activeUserNumber == activeUserNumber &&
     other.description == description;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (activatedDate == null ? 0 : activatedDate!.hashCode) +
    (expireDate == null ? 0 : expireDate!.hashCode) +
    (userId == null ? 0 : userId!.hashCode) +
    (userNumber == null ? 0 : userNumber!.hashCode) +
    (activeUserNumber == null ? 0 : activeUserNumber!.hashCode) +
    (description == null ? 0 : description!.hashCode);

  @override
  String toString() => 'AdmLicense[id=$id, activatedDate=$activatedDate, expireDate=$expireDate, userId=$userId, userNumber=$userNumber, activeUserNumber=$activeUserNumber, description=$description]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
    if (id != null) {
      _json[r'id'] = id;
    }
    if (activatedDate != null) {
      _json[r'activatedDate'] = _dateFormatter.format(activatedDate!.toUtc());
    }
    if (expireDate != null) {
      _json[r'expireDate'] = _dateFormatter.format(expireDate!.toUtc());
    }
    if (userId != null) {
      _json[r'userId'] = userId;
    }
    if (userNumber != null) {
      _json[r'userNumber'] = userNumber;
    }
    if (activeUserNumber != null) {
      _json[r'activeUserNumber'] = activeUserNumber;
    }
    if (description != null) {
      _json[r'description'] = description;
    }
    return _json;
  }

  /// Returns a new [AdmLicense] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdmLicense? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdmLicense[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdmLicense[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdmLicense(
        id: mapValueOfType<String>(json, r'id'),
        activatedDate: mapDateTime(json, r'activatedDate', ''),
        expireDate: mapDateTime(json, r'expireDate', ''),
        userId: mapValueOfType<String>(json, r'userId'),
        userNumber: mapValueOfType<int>(json, r'userNumber'),
        activeUserNumber: mapValueOfType<int>(json, r'activeUserNumber'),
        description: mapValueOfType<String>(json, r'description'),
      );
    }
    return null;
  }

  static List<AdmLicense>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdmLicense>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdmLicense.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdmLicense> mapFromJson(dynamic json) {
    final map = <String, AdmLicense>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdmLicense.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdmLicense-objects as value to a dart map
  static Map<String, List<AdmLicense>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdmLicense>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdmLicense.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

