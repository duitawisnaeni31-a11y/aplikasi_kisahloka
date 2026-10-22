import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class Story {
  final String id;
  final String title;
  final String category;
  final String region;
  final String summary;
  final String content;
  final String moralValue;
  final String iconEmoji;
  final String status;
  final String? imageUrl;
  final String? audioUrl;
  final File? imageFile;
  final Uint8List? imageBytes;
  bool isFavorite;

  Story({
    required this.id,
    required this.title,
    required this.category,
    required this.region,
    required this.summary,
    required this.content,
    required this.moralValue,
    this.iconEmoji = '📖',
    this.status = 'approved',
    this.imageUrl,
    this.audioUrl,
    this.imageFile,
    this.imageBytes,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'region': region,
      'summary': summary,
      'content': content,
      'moralValue': moralValue,
      'iconEmoji': iconEmoji,
      'status': status,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'isFavorite': isFavorite,
      'imageBase64': imageBytes != null ? base64Encode(imageBytes!) : null,
    };
  }

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? '',
      category: json['category'] ?? 'Legenda',
      region: json['region'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      moralValue: json['moralValue'] ?? '',
      iconEmoji: json['iconEmoji'] ?? '📖',
      status: json['status'] ?? 'approved',
      imageUrl: json['imageUrl'],
      audioUrl: json['audioUrl'],
      isFavorite: json['isFavorite'] ?? false,
      imageBytes: json['imageBase64'] != null ? base64Decode(json['imageBase64']) : null,
    );
  }
}

List<Story> globalStories = [];

List<Story> initialDefaultStories = [
  Story(
    id: '1',
    title: 'Sangkuriang & Tangkuban Perahu',
    category: 'Legenda',
    region: 'Jawa Barat',
    summary: 'Kisah asal usul Gunung Tangkuban Perahu dan Pemuda Sangkuriang.',
    content:
        'Pada zaman dahulu di Jawa Barat, hiduplah seorang wanita cantik bernama Dayang Sumbi dan putranya, Sangkuriang. Suatu hari saat berburu, Sangkuriang secara tidak sengaja membunuh anjing kesayangan mereka, Tumang, yang sebenarnya adalah ayahnya sendiri.\n\nMengetahui hal tersebut, Dayang Sumbi sangat marah dan memukul kepala Sangkuriang. Sangkuriang pun pergi mengembara bertahun-tahun. Ketika dewasa, Sangkuriang kembali dan jatuh cinta pada Dayang Sumbi tanpa menyadari wanita itu ibunya.\n\nDayang Sumbi memberi syarat membuat perahu besar dalam satu malam. Sebelum fajar, Dayang Sumbi menggelar kain sutra merah agar fajar tampak menyingsing. Sangkuriang yang merasa gagal mengamuk dan menendang perahu buatannya hingga terbalik, membendung Gunung Tangkuban Perahu.',
    moralValue: 'Kendalikan emosi dan selalu jujur serta patuh kepada orang tua.',
    imageUrl: 'https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=800',
    iconEmoji: '🏔️',
    isFavorite: true,
  ),
  Story(
    id: '2',
    title: 'Roro Jonggrang & Candi Prambanan',
    category: 'Legenda',
    region: 'DI Yogyakarta',
    summary: 'Kisah seribu candi dalam satu malam dan terbentuknya Candi Prambanan.',
    content:
        'Bandung Bondowoso menaklukkan Kerajaan Prambanan dan berniat melamar putri Roro Jonggrang. Roro Jonggrang memberi syarat membuatkan 1.000 candi dalam satu malam.\n\nMelihat candi hampir selesai, Roro Jonggrang membangunkan wanita desa untuk menumbuk padi dan membakar jerami agar suasana terang. Para jin berlarian karena mengira hari telah pagi. Bandung Bondowoso murka dan mengutuk Roro Jonggrang menjadi patung ke-1.000.',
    moralValue: 'Jangan gunakan tipu daya untuk menyelesaikan masalah.',
    imageUrl: 'https://images.unsplash.com/photo-1609949279531-cf48d64bed89?w=800',
    iconEmoji: '🏛️',
    isFavorite: true,
  ),
  Story(
    id: '3',
    title: 'Sejarah Peristiwa Bandung Lautan Api',
    category: 'Sejarah',
    region: 'Jawa Barat',
    summary: 'Peristiwa pembumihantuan kota Bandung demi mempertahankan kemerdekaan.',
    content:
        'Peristiwa Bandung Lautan Api adalah pembumihantuan kota Bandung pada tanggal 23 Maret 1946. Sekitar 200.000 penduduk Bandung membakar rumah dan meninggalkan kota menuju pegunungan di selatan Bandung dalam waktu tujuh jam.\n\nLangkah ini diambil oleh para pejuang Indonesia agar sekutu dan NICA tidak dapat menggunakan kota Bandung sebagai pangkalan militer strategis.',
    moralValue: 'Semangat pengorbanan demi membela kedaulatan bangsa.',
    imageUrl: 'https://images.unsplash.com/photo-1508873696983-2df515122519?w=800',
    iconEmoji: '🔥',
    isFavorite: false,
  ),
  Story(
    id: '4',
    title: 'Legenda Malin Kundang',
    category: 'Legenda',
    region: 'Sumatera Barat',
    summary: 'Kisah anak durhaka yang dikutuk menjadi batu oleh ibunya.',
    content:
        'Pada zaman dahulu kala di Sumatera Barat, hiduplah anak bernama Malin bersama ibunya. Malin merantau dan berhasil menjadi pedagang kaya raya.\n\nKetika kapalnya bersandar di kampung halaman, ibunya berlari memeluk Malin. Namun Malin malu dan menolak mengakui wanita tua renta itu sebagai ibunya.\n\nSakit hati, sang ibu berdoa memohon keadilan. Badai dahsyat menghancurkan kapal Malin, dan Malin bertekuk lutut memohon ampun sebelum seluruh tubuhnya mengeras berubah menjadi batu.',
    moralValue: 'Hormatilah orang tua, khususnya ibu yang telah melahirkan dan membesarkan kita.',
    imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
    iconEmoji: '⛵',
    isFavorite: true,
  ),
];

Future<void> saveStoriesToStorage() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> rawData = globalStories.map((s) => jsonEncode(s.toJson())).toList();
  await prefs.setStringList('kisahloka_stories_key', rawData);
}

Future<void> loadStoriesFromStorage() async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? rawData = prefs.getStringList('kisahloka_stories_key');

  if (rawData != null && rawData.isNotEmpty) {
    globalStories = rawData.map((s) => Story.fromJson(jsonDecode(s))).toList();
  } else {
    globalStories = List.from(initialDefaultStories);
    await saveStoriesToStorage();
  }
}