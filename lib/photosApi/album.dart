import "package:json_annotation/json_annotation.dart";

part 'album.g.dart';

@JsonSerializable()
class Album {
  String id;
  String title;
  String productUrl;
  bool isWriteable;
  ShareInfo shareInfo;
  String mediaItemsCount;
  String coverPhotoBaseUrl;
  String coverPhotoMediaItemId;

  Album(this.id, this.title, this.productUrl, this.isWriteable,
      this.mediaItemsCount, this.coverPhotoBaseUrl, this.coverPhotoMediaItemId);

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumToJson(this);
}

@JsonSerializable()
class ShareInfo {
  SharedAlbumOptions sharedAlbumOptions;
  String shareableUrl;
  String shareToken;
  bool isJoined;
  bool isOwned;

  ShareInfo(this.sharedAlbumOptions, this.shareableUrl, this.shareToken,
      this.isJoined, this.isOwned);

  factory ShareInfo.fromJson(Map<String, dynamic> json) =>
      _$ShareInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ShareInfoToJson(this);
}

@JsonSerializable()
class SharedAlbumOptions {
  bool isCollaborative;
  bool isCommentable;

  SharedAlbumOptions(this.isCollaborative, this.isCommentable);

  factory SharedAlbumOptions.fromJson(Map<String, dynamic> json) =>
      _$SharedAlbumOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$SharedAlbumOptionsToJson(this);
}
