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
  final String? imageUrl;
  final String? audioUrl;
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
    this.imageUrl,
    this.audioUrl,
    this.imageFile,
    this.imageBytes,
  });
}

List<Story> globalStories = [
  Story(
    id: '1',
    title: 'Sangkuriang & Tangkuban Perahu',
    category: 'Legenda',
    region: 'Jawa Barat',
    summary: 'Kisah asal usul Gunung Tangkuban Perahu dan Pemuda Sangkuriang.',
    content:
        'Pada zaman dahulu di Jawa Barat, hiduplah seorang wanita cantik bernama Dayang Sumbi dan putranya, Sangkuriang. Suatu hari saat berburu, Sangkuriang yang marah secara tidak sengaja membunuh anjing kesayangan mereka, Tumang, yang sebenarnya adalah ayahnya sendiri yang dikutuk.\n\nMengetahui hal tersebut, Dayang Sumbi sangat marah dan memukul kepala Sangkuriang hingga meninggalkan bekas luka. Sangkuriang pun pergi mengembara bertahun-tahun. Ketika dewasa, Sangkuriang kembali ke kampung halamannya dan jatuh cinta pada seorang wanita cantik tanpa menyadari bahwa wanita itu adalah ibunya sendiri.\n\nDayang Sumbi mengenali bekas luka di kepala Sangkuriang. Untuk menggagalkan pernikahan, ia memberi syarat mustahil: membuat perahu besar dan membendung sungai Citarum dalam satu malam. Dengan bantuan jin, Sangkuriang hampir berhasil. Dayang Sumbi menggelar kain sutra merah di timur agar fajar tampak menyingsing lebih cepat. Sangkuriang yang merasa gagal mengamuk dan menendang perahu buatannya hingga terbalik, membentuk Gunung Tangkuban Perahu.',
    moralValue: 'Kendalikan emosi dan amarah, serta selalu jujur dan patuh kepada orang tua.',
    imageUrl: 'https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=800',
    audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    iconEmoji: '🏔️',
    status: 'approved',
  ),
  Story(
    id: '2',
    title: 'Roro Jonggrang & Candi Prambanan',
    category: 'Legenda',
    region: 'DI Yogyakarta',
    summary: 'Kisah seribu candi dalam satu malam dan terbentuknya Candi Prambanan.',
    content:
        'Kerajaan Pengging yang dipimpin Bandung Bondowoso menaklukkan Kerajaan Prambanan. Bandung Bondowoso yang terpikat oleh kecantikan putri Prambanan, Roro Jonggrang, berniat untuk melamarnya.\n\nRoro Jonggrang tidak ingin menikahi pembunuh ayahnya, namun takut menolak secara langsung. Ia memberi syarat agar Bandung Bondowoso membuatkan 1.000 candi dalam waktu satu malam. Bandung Bondowoso menyetujuinya dan memanggil ribuan jin untuk membantunya.\n\nMelihat pembuatan candi hampir selesai sebelum fajar, Roro Jonggrang membangunkan para wanita desa untuk menumbuk padi dan membakar jerami agar suasana terang seperti pagi hari. Para jin berlarian ketakutan karena mengira matahari telah terbit. Bandung Bondowoso murka saat tahu ditipu, dan mengutuk Roro Jonggrang menjadi patung ke-1.000 untuk melengkapi Candi Prambanan.',
    moralValue: 'Jangan gunakan tipu daya untuk menyelesaikan masalah, dan penuhilah janji yang telah dibuat.',
    imageUrl: 'https://images.unsplash.com/photo-1609949279531-cf48d64bed89?w=800',
    audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    iconEmoji: '🏛️',
    status: 'approved',
  ),
  Story(
    id: '3',
    title: 'Sejarah Peristiwa Bandung Lautan Api',
    category: 'Sejarah',
    region: 'Jawa Barat',
    summary: 'Peristiwa pembumihantuan kota Bandung demi mempertahankan kemerdekaan.',
    content:
        'Peristiwa Bandung Lautan Api adalah pembumihantuan kota Bandung pada tanggal 23 Maret 1946. Sekitar 200.000 penduduk Bandung membakar rumah dan meninggalkan kota menuju pegunungan di selatan Bandung dalam waktu tujuh jam.\n\nLangkah ini diambil oleh para pejuang Indonesia agar sekutu dan NICA tidak dapat menggunakan kota Bandung sebagai pangkalan militer strategis. Mohammad Toha dan Ramdan, dua anggota milisi BBRI, mengorbankan nyawa mereka untuk meledakkan gudang amunisi sekutu di Dayeuhkolot.\n\nPeristiwa pengorbanan besar ini mengilhami lahirnya lagu perjuangan populer "Halo-Halo Bandung".',
    moralValue: 'Semangat pengorbanan dan kebersamaan demi membela kedaulatan bangsa.',
    imageUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=800',
    audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    iconEmoji: '🔥',
    status: 'approved',
  ),
  Story(
    id: '4',
    title: 'Malin Kundang',
    category: 'Legenda',
    region: 'Sumatera Barat',
    summary: 'Kisah anak durhaka yang dikutuk menjadi batu oleh ibunya.',
    content:
        'Pada zaman dahulu kala, di sebuah desa nelayan di Sumatera Barat, hiduplah seorang anak bernama Malin bersama ibunya yang sudah tua. Malin adalah anak yang rajin dan bercita-cita tinggi. Demi mengubah nasib keluarga, Malin memutuskan untuk merantau ke negeri seberang dengan menumpang kapal dagang yang kaya raya.\n\nBertahun-tahun berlalu, Malin berhasil menjadi pedagang sukses dan kaya raya serta menikahi wanita berdarah bangsawan. Ketika kapalnya bersandar di kampung halamannya, ibunya yang mendengar kabar gembira langsung berlari memeluk Malin. Namun Malin merasa malu pada istrinya dan menolak mengakui wanita tua renta itu sebagai ibunya.\n\nSakit hati karena dicampakkan dan dihina, sang ibu berdoa memohon keadilan. Seketika langit menjadi gelap, badai dahsyat menghancurkan kapal Malin, dan Malin bertekuk lutut memohon ampun sebelum seluruh tubuhnya mengeras berubah menjadi batu.',
    moralValue: 'Hormatilah orang tua, khususnya ibu yang telah melahirkan dan membesarkan kita.',
    imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
    audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    iconEmoji: '⛵',
    status: 'approved',
  ),
];