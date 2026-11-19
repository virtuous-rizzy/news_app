/// Kata tema yang selalu digabung ke pencarian bebas.
const String kKataTema = 'game';

/// Topik game: label chip -> kata kunci GNews (/search, mendukung AND/OR/NOT).
const Map<String, String> kTopikGame = {
  'Semua': 'game OR gaming OR "video game"',
  'Esports': 'esports OR "e-sports"',
  'Mobile': '"game mobile" OR "Mobile Legends" OR "Free Fire" OR PUBG',
  'PC': '"game PC" OR Steam',
  'Konsol': 'PlayStation OR Xbox OR Nintendo',
  'Rilis Baru': '"game baru" OR "rilis game" OR "game terbaru"',
  'Industri': '"industri game" OR "developer game" OR "studio game"',
};
