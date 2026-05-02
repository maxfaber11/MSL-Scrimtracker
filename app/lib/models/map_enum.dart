enum GameMap {
  Ascent,
  Haven,
  Icebox,
  Breeze,
  Fracture,
  Lotus,
  Sunset,
  Pearl,
  Bind,
  Corrode,
  Split,
}

const Map<GameMap, String> mapImageUrls = {
  GameMap.Ascent: 'https://static.wikia.nocookie.net/valorant/images/e/e7/Loading_Screen_Ascent.png/revision/latest/scale-to-width-down/1000?cb=20200607180020',
  GameMap.Haven: 'https://static.wikia.nocookie.net/valorant/images/7/70/Loading_Screen_Haven.png/revision/latest/scale-to-width-down/1000?cb=20200620202335',
  GameMap.Icebox: 'https://static.wikia.nocookie.net/valorant/images/1/13/Loading_Screen_Icebox.png/revision/latest/scale-to-width-down/1000?cb=20250730171440',
  GameMap.Breeze: 'https://static.wikia.nocookie.net/valorant/images/1/10/Loading_Screen_Breeze.png/revision/latest/scale-to-width-down/1000?cb=20260106175937',
  GameMap.Fracture: 'https://static.wikia.nocookie.net/valorant/images/f/fc/Loading_Screen_Fracture.png/revision/latest/scale-to-width-down/1000?cb=20210908143656',
  GameMap.Lotus: 'https://static.wikia.nocookie.net/valorant/images/d/d0/Loading_Screen_Lotus.png/revision/latest/scale-to-width-down/1000?cb=20230106163526',
  GameMap.Sunset: 'https://static.wikia.nocookie.net/valorant/images/5/5c/Loading_Screen_Sunset.png/revision/latest/scale-to-width-down/1000?cb=20230829125442',
  GameMap.Pearl: 'https://static.wikia.nocookie.net/valorant/images/a/af/Loading_Screen_Pearl.png/revision/latest/scale-to-width-down/1000?cb=20220622132842',
  GameMap.Bind: 'https://static.wikia.nocookie.net/valorant/images/2/23/Loading_Screen_Bind.png/revision/latest/scale-to-width-down/1000?cb=20200620202316',
  GameMap.Corrode: 'https://static.wikia.nocookie.net/valorant/images/6/6f/Loading_Screen_Corrode.png/revision/latest/scale-to-width-down/1000?cb=20250624201813',
  GameMap.Split: 'https://static.wikia.nocookie.net/valorant/images/d/d6/Loading_Screen_Split.png/revision/latest/scale-to-width-down/1000?cb=20230411161807',
};

extension GameMapExtension on GameMap {
  String get name => toString().split('.').last;

  String? get imageUrl {
    final url = mapImageUrls[this]?.trim();
    return url == null || url.isEmpty ? null : url;
  }
}
