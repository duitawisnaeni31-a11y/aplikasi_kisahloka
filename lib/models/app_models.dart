import 'dart:io';
import 'dart:typed_data';

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
  final File? imageFile;
  final Uint8List? imageBytes;

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
    this.imageFile,
    this.imageBytes,
  });
}

// List global agar cerita yang ditambahkan di Member langsung muncul di Guest
List<Story> globalStories = [
  Story(
    id: '1',
    title: 'Malin Kundang',
    category: 'Legenda',
    region: 'Sumatera Barat',
    summary: 'Kisah anak durhaka yang dikutuk menjadi batu oleh ibunya.',
    content: 'Pada zaman dahulu kala, di sebuah desa nelayan di Sumatera Barat, hiduplah seorang anak bernama Malin bersama ibunya yang sudah tua. Malin adalah anak yang rajin dan bercita-cita tinggi. Demi mengubah nasib keluarga, Malin memutuskan untuk merantau ke negeri seberang dengan menumpang kapal dagang yang kaya rayanya.',
    moralValue: 'Hormatilah orang tua, khususnya ibu yang telah melahirkan dan membesarkan kita.',
    iconEmoji: '⛵',
    status: 'approved',
  ),
];