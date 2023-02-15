class AvatarImage {
  final String _imagePath;

  AvatarImage(this._imagePath);

  String get imagePath => _imagePath;

  static final avatarDefault = AvatarImage("assets/images/avatars/avatar_default.png");
  static final avatar1 = AvatarImage("assets/images/avatars/avatar_1.png");
  static final avatar2 = AvatarImage("assets/images/avatars/avatar_2.png");
  static final avatar3 = AvatarImage("assets/images/avatars/avatar_3.png");
  static final avatar4 = AvatarImage("assets/images/avatars/avatar_4.png");
  static final avatar5 = AvatarImage("assets/images/avatars/avatar_5.png");
  static final avatar6 = AvatarImage("assets/images/avatars/avatar_6.png");
  static final avatar7 = AvatarImage("assets/images/avatars/avatar_7.png");
  static final avatar8 = AvatarImage("assets/images/avatars/avatar_8.png");
  static final avatar9 = AvatarImage("assets/images/avatars/avatar_9.png");
  static final avatar10 = AvatarImage("assets/images/avatars/avatar_10.png");
  static final avatar11 = AvatarImage("assets/images/avatars/avatar_11.png");
  static final avatar12 = AvatarImage("assets/images/avatars/avatar_12.png");
  static final avatar13 = AvatarImage("assets/images/avatars/avatar_13.png");
  static final avatar14 = AvatarImage("assets/images/avatars/avatar_14.png");
  static final avatar15 = AvatarImage("assets/images/avatars/avatar_15.png");
  static final avatar16 = AvatarImage("assets/images/avatars/avatar_16.png");
  static final avatar17 = AvatarImage("assets/images/avatars/avatar_17.png");
  static final avatar18 = AvatarImage("assets/images/avatars/avatar_18.png");
  static final avatar19 = AvatarImage("assets/images/avatars/avatar_19.png");
  static final avatar20 = AvatarImage("assets/images/avatars/avatar_20.png");
  static final avatar21 = AvatarImage("assets/images/avatars/avatar_21.png");
  static final avatar22 = AvatarImage("assets/images/avatars/avatar_22.png");
  static final avatar23 = AvatarImage("assets/images/avatars/avatar_23.png");
  static final avatar24 = AvatarImage("assets/images/avatars/avatar_24.png");

  static final avatarList = [
    avatar1,
    avatar2,
    avatar3,
    avatar4,
    avatar5,
    avatar6,
    avatar7,
    avatar8,
    avatar9,
    avatar10,
    avatar11,
    avatar12,
    avatar13,
    avatar14,
    avatar15,
    avatar16,
    avatar17,
    avatar18,
    avatar19,
    avatar20,
    avatar21,
    avatar22,
    avatar23,
    avatar24
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvatarImage && runtimeType == other.runtimeType && _imagePath == other._imagePath;

  @override
  int get hashCode => _imagePath.hashCode;
}