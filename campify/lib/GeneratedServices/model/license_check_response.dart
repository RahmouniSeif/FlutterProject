//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class LicenseCheckResponse {
  /// Returns a new [LicenseCheckResponse] instance.
  LicenseCheckResponse({
    this.valid,
    this.message,
    this.licenseId,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? valid;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? message;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? licenseId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LicenseCheckResponse &&
     other.valid == valid &&
     other.message == message &&
     other.licenseId == licenseId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (valid == null ? 0 : valid!.hashCode) +
    (message == null ? 0 : message!.hashCode) +
    (licenseId == null ? 0 : licenseId!.hashCode);

  @override
  String toString() => 'LicenseCheckResponse[valid=$valid, message=$message, licenseId=$licenseId]';

  Map<String, dynamic> toJson() {
    final _json = <String, dynamic>{};
    if (valid != null) {
      _json[r'valid'] = valid;
    }
    if (message != null) {
      _json[r'message'] = message;
    }
    if (licenseId != null) {
      _json[r'licenseId'] = licenseId;
    }
    return _json;
  }

  /// Returns a new [LicenseCheckResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LicenseCheckResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "LicenseCheckResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "LicenseCheckResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return LicenseCheckResponse(
        valid: mapValueOfType<bool>(json, r'valid'),
        message: mapValueOfType<String>(json, r'message'),
        licenseId: mapValueOfType<String>(json, r'licenseId'),
      );
    }
    return null;
  }

  static List<LicenseCheckResponse>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LicenseCheckResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LicenseCheckResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LicenseCheckResponse> mapFromJson(dynamic json) {
    final map = <String, LicenseCheckResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LicenseCheckResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LicenseCheckResponse-objects as value to a dart map
  static Map<String, List<LicenseCheckResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LicenseCheckResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LicenseCheckResponse.listFromJson(entry.value, growable: growable,);
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

