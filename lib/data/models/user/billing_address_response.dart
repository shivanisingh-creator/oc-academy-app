class BillingAddressResponse {
  final BillingAddress? response;

  BillingAddressResponse({this.response});

  factory BillingAddressResponse.fromJson(Map<String, dynamic> json) {
    return BillingAddressResponse(
      response: json['response'] != null
          ? BillingAddress.fromJson(json['response'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'response': response?.toJson()};
  }
}

class BillingAddress {
  final int? id;
  final String? userId;
  final String? name;
  final String? mobileNumber;
  final String? addressLine;
  final String? addressLine2;
  final String? zipcode;
  final String? city;
  final String? state;
  final String? country;
  final String? source;

  BillingAddress({
    this.id,
    this.userId,
    this.name,
    this.mobileNumber,
    this.addressLine,
    this.addressLine2,
    this.zipcode,
    this.city,
    this.state,
    this.country,
    this.source,
  });

  factory BillingAddress.fromJson(Map<String, dynamic> json) {
    String? extractCountry(dynamic countryData) {
      if (countryData == null) return null;
      if (countryData is Map) {
        return countryData['name']?.toString() ??
            countryData['code']?.toString();
      }
      return countryData.toString();
    }

    return BillingAddress(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      userId: json['userId']?.toString(),
      name: json['name']?.toString(),
      mobileNumber: json['mobileNumber']?.toString(),
      addressLine: json['addressLine']?.toString(),
      addressLine2: json['addressLine2']?.toString(),
      zipcode: json['zipcode']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      country: extractCountry(json['country']),
      source: json['source']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'mobileNumber': mobileNumber,
      'addressLine': addressLine,
      'addressLine2': addressLine2,
      'zipcode': zipcode,
      'city': city,
      'state': state,
      'country': country,
      'source': source,
    };
  }

  String get fullAddress {
    List<String> parts = [];
    if (addressLine != null && addressLine!.isNotEmpty) parts.add(addressLine!);
    if (addressLine2 != null && addressLine2!.isNotEmpty) {
      parts.add(addressLine2!);
    }
    if (zipcode != null && zipcode!.isNotEmpty) parts.add(zipcode!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (country != null && country!.isNotEmpty) parts.add(country!);
    return parts.join(', ');
  }
}
