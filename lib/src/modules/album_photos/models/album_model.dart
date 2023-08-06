// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AlbumModel {
  final String imagePath;
  final String fullPath;
  final String? comentario;
  final String date;
  final String hour;
  final String isFavorite;
  final String? usuarioId;
  final String avatarUrl;

  AlbumModel({
    required this.imagePath,
    required this.fullPath,
    required this.comentario,
    required this.date,
    required this.hour,
    required this.isFavorite,
    required this.usuarioId,
    required this.avatarUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imagePath': imagePath,
      'fullPath': fullPath,
      'comentario': comentario,
      'date': date,
      'hour': hour,
      'isFavorite': isFavorite,
      'usuarioId': usuarioId,
      'avatarUrl': avatarUrl,
    };
  }

  factory AlbumModel.fromMap(Map<String, dynamic> map) {
    return AlbumModel(
      imagePath: map['imagePath'] as String,
      fullPath: map['fullPath'] as String,
      comentario: map['comentario'],
      date: map['date'] as String,
      hour: map['hour'] as String,
      isFavorite: map['isFavorite'] as String,
      usuarioId: map['usuarioId'],
      avatarUrl: map['avatarUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AlbumModel.fromJson(String source) => AlbumModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
