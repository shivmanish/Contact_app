part of contact_app;

class KVPair {
  final String key;
  final String? value;

  KVPair({required this.key, required this.value});

  Map<String, dynamic> toMap() {
    return {key: value};
  }

  static KVPair fromMap(dynamic kv) {
    return KVPair(key: kv.entries.first.key, value: kv.entries.first.value);
  }
}

class ContactStoreModel {
  int identifier;
  final String givenName;
  final String middleName;
  final String familyName;
  final KVPair phoneNumbers;
  bool isFavorite;
  KVPair? emails;

  ContactStoreModel({
    required this.identifier,
    required this.givenName,
    required this.middleName,
    required this.familyName,
    required this.phoneNumbers,
    this.isFavorite = false,
    this.emails,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'givenName': givenName,
      'middleName': middleName,
      'familyName': familyName,
      'phoneNumbers': phoneNumbers.key,
      'isFavorite': isFavorite ? 1 : 0,
      'emails': emails?.key,
    };
    if (identifier >= 0) {
      map['identifier'] = identifier;
    }
    return map;
  }

  static ContactStoreModel fromMap(dynamic parsed) {
    return ContactStoreModel(
      identifier: parsed['identifier'],
      givenName: parsed['givenName'],
      middleName: parsed['middleName'] ?? "",
      familyName: parsed['familyName'] ?? "",
      phoneNumbers: KVPair(key: parsed['phoneNumbers'], value: 'Mobile'),
      isFavorite: parsed['isFavorite'] == 1 ? true : false,
      emails:
          parsed.containsKey('emails') && parsed['emails'] != null
              ? KVPair(key: parsed['emails'], value: 'Personal')
              : null,
    );
  }

  ContactStoreModel copyWith({
    int? identifier,
    String? givenName,
    String? middleName,
    String? familyName,
    KVPair? phoneNumbers,
    KVPair? emails,
    bool? isFavorite,
  }) {
    return ContactStoreModel(
      identifier: identifier ?? this.identifier,
      givenName: givenName ?? this.givenName,
      middleName: middleName ?? this.middleName,
      familyName: familyName ?? this.familyName,
      phoneNumbers: phoneNumbers ?? this.phoneNumbers,
      emails: emails ?? this.emails,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ContactStoreModel) return false;
    return identifier == other.identifier;
  }

  @override
  int get hashCode => identifier.hashCode;

  @override
  String toString() => jsonEncode(toMap());
}

extension ContactExtension on ContactStoreModel {
  void updateIdentifier(int id) {
    identifier = id;
  }

  void updateFavourite(bool value) {
    isFavorite = value;
  }

  bool hasEmailId() {
    // TODO:  can add here email validator
    return (emails != null && emails!.key.isNotEmpty);
  }

  String getInitials() {
    var initials = [];
    if (givenName.isNotEmpty) {
      initials.add(String.fromCharCode(givenName.runes.first));
    }
    if (familyName.isNotEmpty) {
      initials.add(String.fromCharCode(familyName.runes.first));
    }
    return initials.join('');
  }

  String firstCharacter() {
    final displayName = getDisplayableName();
    return String.fromCharCode(displayName.runes.first);
  }

  /// Returns displayable name for a contact.
  String getDisplayableName() {
    var displayName = [];
    if (givenName.isNotEmpty) {
      displayName.add(givenName);
    }
    if (middleName.isNotEmpty) {
      displayName.add(middleName);
    }
    if (familyName.isNotEmpty) {
      displayName.add(familyName);
    }
    String d = displayName.join(' ');
    d = d.isEmpty ? getDisplayNameFromPhoneOrEmail() : d;

    if (d.runes.isNotEmpty && d.runes.first == 173) {
      d = String.fromCharCode(161) + d.substring(1);
    }
    return d;
  }

  String getDisplayNameFromPhoneOrEmail() {
    return phoneNumbers.key;
  }

  Widget avatarFromInitials({
    double radius = 20,
    Color? backgroundColor,
    TextStyle? textStyle,
    double initialsFontSize = 40,
    bool isBlocked = false,
  }) {
    return Builder(
      builder: (context) {
        return CircleAvatar(
          backgroundColor:
              backgroundColor ??
              Theme.of(context).primaryColor.withValues(alpha: 0.1),
          radius: radius,
          child: Stack(
            children: [
              Center(
                child: Text(
                  getInitials(),
                  style:
                      textStyle ??
                      TextStyle(
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.1),
                        fontSize: initialsFontSize,
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Returns a circular avatar for the contact.
  Widget circleAvatar({
    double radius = 20,
    double backgroundColorOpacity = 0.3,
    double textColorOpacity = 0.2,
    Color? backgroundColor,
    TextStyle? textStyle,
    bool isBlocked = false,
    double initialsFontSize = 40,
    double statusCircleRadius = 10,
  }) {
    Widget child = avatarFromInitials(
      radius: radius,
      backgroundColor: backgroundColor,
      textStyle: textStyle,
      initialsFontSize: initialsFontSize,
    );

    return child;
  }
}
