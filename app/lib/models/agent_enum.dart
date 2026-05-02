enum Agent {
  Astra,
  Breach,
  Brimstone,
  Chamber,
  Clove,
  Cypher,
  Deadlock,
  Fade,
  Gekko,
  Harbor,
  Iso,
  Jett,
  KAY_O,
  Killjoy,
  Miks,
  Neon,
  Omen,
  Phoenix,
  Raze,
  Reyna,
  Sage,
  Skye,
  Sova,
  Tejo,
  Veto,
  Viper,
  Vyse,
  Waylay,
  Yoru,
}

const Map<Agent, String> agentImageUrls = {
  Agent.Astra: 'https://static.wikia.nocookie.net/valorant/images/0/08/Astra_icon.png/revision/latest/smart/width/250/height/250?cb=20230523180525',
  Agent.Breach: 'https://static.wikia.nocookie.net/valorant/images/5/53/Breach_icon.png/revision/latest/scale-to-width-down/75?cb=20230523180542',
  Agent.Brimstone: 'https://static.wikia.nocookie.net/valorant/images/4/4d/Brimstone_icon.png/revision/latest/scale-to-width-down/75?cb=20230523180558',
  Agent.Chamber: 'https://static.wikia.nocookie.net/valorant/images/0/09/Chamber_icon.png/revision/latest/scale-to-width-down/75?cb=20230523180616',
  Agent.Clove: 'https://static.wikia.nocookie.net/valorant/images/3/30/Clove_icon.png/revision/latest/scale-to-width-down/75?cb=20240326163719',
  Agent.Cypher: 'https://static.wikia.nocookie.net/valorant/images/8/88/Cypher_icon.png/revision/latest/scale-to-width-down/75?cb=20230523180623',
  Agent.Deadlock: 'https://static.wikia.nocookie.net/valorant/images/e/eb/Deadlock_icon.png/revision/latest/scale-to-width-down/75?cb=20230627132804',
  Agent.Fade: 'https://static.wikia.nocookie.net/valorant/images/a/a6/Fade_icon.png/revision/latest/scale-to-width-down/75?cb=20230523161332',
  Agent.Gekko: 'https://static.wikia.nocookie.net/valorant/images/6/66/Gekko_icon.png/revision/latest/scale-to-width-down/75?cb=20230523180641',
  Agent.Harbor: 'https://static.wikia.nocookie.net/valorant/images/f/f3/Harbor_icon.png/revision/latest/scale-to-width-down/75?cb=20230523161242',
  Agent.Iso: 'https://static.wikia.nocookie.net/valorant/images/b/b7/Iso_icon.png/revision/latest/scale-to-width-down/75?cb=20231031131018',
  Agent.Jett: 'https://static.wikia.nocookie.net/valorant/images/3/35/Jett_icon.png/revision/latest/scale-to-width-down/75?cb=20230909031447',
  Agent.KAY_O: 'https://static.wikia.nocookie.net/valorant/images/f/f0/KAYO_icon.png/revision/latest/scale-to-width-down/75?cb=20230523180711',
  Agent.Killjoy: 'https://static.wikia.nocookie.net/valorant/images/1/15/Killjoy_icon.png/revision/latest/scale-to-width-down/75?cb=20230523180727',
  Agent.Miks: 'https://static.wikia.nocookie.net/valorant/images/5/56/Miks_icon.png/revision/latest/scale-to-width-down/75?cb=20260317165334',
  Agent.Neon: 'https://static.wikia.nocookie.net/valorant/images/d/d0/Neon_icon.png/revision/latest/scale-to-width-down/75?cb=20230523180744',
  Agent.Omen: 'https://static.wikia.nocookie.net/valorant/images/b/b0/Omen_icon.png/revision/latest/scale-to-width-down/75?cb=20230523180801',
  Agent.Phoenix: 'https://static.wikia.nocookie.net/valorant/images/1/14/Phoenix_icon.png/revision/latest/scale-to-width-down/75?cb=20230606161016',
  Agent.Raze: 'https://static.wikia.nocookie.net/valorant/images/9/9c/Raze_icon.png/revision/latest/scale-to-width-down/75?cb=20230523180834',
  Agent.Reyna: 'https://static.wikia.nocookie.net/valorant/images/b/b0/Reyna_icon.png/revision/latest/scale-to-width-down/75?cb=20230606161102',
  Agent.Sage: 'https://static.wikia.nocookie.net/valorant/images/7/74/Sage_icon.png/revision/latest/scale-to-width-down/75?cb=20260317170200',
  Agent.Skye: 'https://static.wikia.nocookie.net/valorant/images/3/33/Skye_icon.png/revision/latest/scale-to-width-down/75?cb=20230606161546',
  Agent.Sova: 'https://static.wikia.nocookie.net/valorant/images/4/49/Sova_icon.png/revision/latest/scale-to-width-down/75?cb=20230523180933',
  Agent.Tejo: 'https://static.wikia.nocookie.net/valorant/images/9/90/Tejo_icon.png/revision/latest/scale-to-width-down/75?cb=20250107192428',
  Agent.Veto: 'https://static.wikia.nocookie.net/valorant/images/4/4e/Veto_icon.png/revision/latest/scale-to-width-down/75?cb=20251007182648',
  Agent.Viper: 'https://static.wikia.nocookie.net/valorant/images/5/5f/Viper_icon.png/revision/latest/scale-to-width-down/75?cb=20230523180950',
  Agent.Vyse: 'https://static.wikia.nocookie.net/valorant/images/2/21/Vyse_icon.png/revision/latest/scale-to-width-down/75?cb=20240827165928',
  Agent.Waylay: 'https://static.wikia.nocookie.net/valorant/images/3/3d/Waylay_icon.png/revision/latest/scale-to-width-down/75?cb=20250304181241',
  Agent.Yoru: 'https://static.wikia.nocookie.net/valorant/images/d/d4/Yoru_icon.png/revision/latest/scale-to-width-down/75?cb=20250318173810',
};

extension AgentExtension on Agent {
  String get displayName {
    switch (this) {
      case Agent.KAY_O:
        return 'KAY/O';
      default:
        return toString().split('.').last;
    }
  }

  String? get imageUrl {
    final url = agentImageUrls[this]?.trim();
    return url == null || url.isEmpty ? null : url;
  }
}
