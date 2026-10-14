class Story {
  final String id;
  final String title;
  final String region;
  final String category;
  final String summary;
  final String content;
  final String moralValue;
  final String iconEmoji;
  final String? imageUrl;
  String status; // 'terbit', 'pending', 'ditolak'
  bool isFavorite;
  final String author;

  Story({
    required this.id,
    required this.title,
    required this.region,
    required this.category,
    required this.summary,
    required this.content,
    required this.moralValue,
    required this.iconEmoji,
    this.imageUrl,
    this.status = 'terbit',
    this.isFavorite = false,
    required this.author,
  });
}

List<Story> globalStories = [
  Story(
    id: '1',
    title: 'Malin Kundang',
    region: 'Sumatera Barat',
    category: 'Legenda',
    summary: 'Kisah anak durhaka yang mengingkari ibunya hingga dikutuk menjadi batu.',
    content: 'Pada zaman dahulu kala, di sebuah desa nelayan di Sumatera Barat, hiduplah seorang anak bernama Malin bersama ibunya yang sudah tua. Malin adalah anak yang rajin dan bercita-cita tinggi. Demi mengubah nasib keluarga, Malin memutuskan untuk merantau ke negeri seberang dengan menumpang kapal pedagang kaya.\n\nBertahun-tahun berlalu, Malin berhasil menjadi saudagar yang sangat kaya raya dan memiliki istri seorang putri bangsawan. Suatu hari, kapal megah Malin berlabuh di kampung halamannya. Sang ibu yang mendengar kabar tersebut segera berlari ke pelabuhan untuk menyambut putra tercintanya.\n\nNamun, ketika sang ibu mendekat dan memanggil namanya, Malin merasa malu akan penampilan ibunya yang lusuh di hadapan istrinya. Malin secara kejam mendorong dan mengusir wanita tua itu sambil berteriak bahwa dia tidak pernah memiliki ibu sepertinya.\n\nDengan hati yang hancur dan air mata yang mengalir deras, sang ibu berlutut memohon keadilan. Seketika langit menjadi gelap, petir menyambar, dan badai dahsyat menghantam kapal Malin. Di tengah gemuruh badai, tubuh Malin perlahan-lahan mengeras dan berubah menjadi batu sebagai hukuman atas kedurhakaannya.',
    moralValue: 'Hormatilah orang tua, setinggi apa pun kesuksesanmu.',
    iconEmoji: '⛵',
    author: 'Admin',
    status: 'terbit',
  ),
  Story(
    id: '2',
    title: 'Roro Jonggrang',
    region: 'Jawa Tengah',
    category: 'Mitos',
    summary: 'Kisah seribu candi yang dibangun dalam semalam demi sebuah janji cinta.',
    content: 'Dahulu di Pulau Jawa berdiri Kerajaan Pengging dan Prambanan. Pangeran Bandung Bondowoso dari Pengging yang sakti berhasil mengalahkan Kerajaan Prambanan. Di sana ia terpikat oleh kecantikan Roro Jonggrang, putri Kerajaan Prambanan.\n\nRoro Jonggrang tidak ingin menikahi pembunuh ayahnya, namun tak berani menolak secara langsung. Ia memberi syarat agar Bandung Bondowoso membangun 1.000 candi dalam waktu semalam sebelum fajar menyingsing.\n\nDengan kesaktiannya, Bandung Bondowoso mengerahkan ribuan jin untuk membangun candi. Melihat pekerjaan yang hampir selesai saat tengah malam, Roro Jonggrang panik. Ia menyuruh para gadis desa menumbuk lesung dan membakar jerami agar suasana terlihat terang bagai fajar.\n\nAyam jantan pun berkokok menandakan pagi telah tiba. Para jin yang takut sinar matahari segera berlari meninggalkan pekerjaan yang baru mencapai 999 candi. Bandung Bondowoso yang mengetahui kecurangan Roro Jonggrang sangat murka dan mengutuk Roro Jonggrang menjadi arca ke-1000 untuk melengkapi Candi Prambanan.',
    moralValue: 'Jangan melakukan kecurangan untuk mencapai keinginanmu.',
    iconEmoji: '🏰',
    author: 'Admin',
    status: 'terbit',
  ),
  Story(
    id: '3',
    title: 'Danau Toba',
    region: 'Sumatera Utara',
    category: 'Legenda',
    summary: 'Ikan ajaib yang menjelma menjadi wanita dan asal usul danau raksasa.',
    content: 'Di sebuah wilayah Sumatera Utara, hidup seorang pemuda bernama Toba. Suatu hari saat memancing, Toba menangkap seekor ikan mas yang sangat besar dan berkilau. Betapa terkejutnya Toba ketika ikan tersebut berubah menjadi seorang wanita cantik.\n\nWanita itu bersedia menikah dengan Toba dengan syarat: Toba tidak boleh membocorkan rahasia asal-usulnya bahwa ia adalah seekor ikan. Toba menyanggupi janji tersebut. Mereka pun menikah dan dikaruniai seorang anak laki-laki bernama Samosir.\n\nSamosir tumbuh menjadi anak yang sangat aktif namun sering membuat ayahnya hilang kesabaran. Suatu ketika, Samosir diminta mengantar makanan untuk ayahnya di ladang. Di tengah jalan, Samosir menyantap sebagian besar makanan tersebut karena lapar.\n\nToba yang sangat lapar dan marah meluapkan emosinya lalu berteriak: "Anak tidak tahu diri, dasar anak ikan!"\n\nSeketika itu janji suci terlanggar. Langit berguncang, hujan lebat mengguyur tanpa henti, dan mata air menyembur deras dari tanah hingga menenggelamkan seluruh desa. Genangan air raksasa itu kini dikenal sebagai Danau Toba, dan pulau di tengahnya dinamai Pulau Samosir.',
    moralValue: 'Pegang teguh janji yang telah diucapkan dalam situasi apa pun.',
    iconEmoji: '🏞️',
    author: 'Admin',
    status: 'terbit',
  ),
];