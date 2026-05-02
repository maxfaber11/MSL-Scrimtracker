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
  Agent.Astra: 'https://liquipedia.net/commons/images/thumb/8/8f/Astra_VALORANT_Icon.png/20px-Astra_VALORANT_Icon.png',
  Agent.Breach: 'https://liquipedia.net/commons/images/thumb/2/2f/Breach_0.50_VALORANT_Icon.png/20px-Breach_0.50_VALORANT_Icon.png',
  Agent.Brimstone: 'https://liquipedia.net/commons/images/thumb/1/1d/Brimstone_0.50_VALORANT_Icon.png/20px-Brimstone_0.50_VALORANT_Icon.png',
  Agent.Chamber: 'https://liquipedia.net/commons/images/thumb/5/5f/Chamber_6.10_VALORANT_Icon.png/20px-Chamber_6.10_VALORANT_Icon.png',
  Agent.Clove: 'https://liquipedia.net/commons/images/thumb/b/b3/Clove_VALORANT_Icon.png/20px-Clove_VALORANT_Icon.png',
  Agent.Cypher: 'https://liquipedia.net/commons/images/thumb/c/c1/Cypher_0.50_VALORANT_Icon.png/20px-Cypher_0.50_VALORANT_Icon.png',
  Agent.Deadlock: 'https://liquipedia.net/commons/images/thumb/e/ec/Deadlock_VALORANT_Icon.png/20px-Deadlock_VALORANT_Icon.png',
  Agent.Fade: 'https://liquipedia.net/commons/images/thumb/c/c2/Fade_6.10_VALORANT_Icon.png/20px-Fade_6.10_VALORANT_Icon.png',
  Agent.Gekko: 'https://liquipedia.net/commons/images/thumb/7/77/Gekko_6.08_VALORANT_Icon.png/20px-Gekko_6.08_VALORANT_Icon.png',
  Agent.Harbor: 'https://liquipedia.net/commons/images/thumb/6/65/Harbor_6.10_VALORANT_Icon.png/20px-Harbor_6.10_VALORANT_Icon.png',
  Agent.Iso: 'https://liquipedia.net/commons/images/thumb/c/c9/Iso_VALORANT_Icon.png/20px-Iso_VALORANT_Icon.png',
  Agent.Jett: 'https://liquipedia.net/commons/images/thumb/f/ff/Jett_0.50_VALORANT_Icon.png/20px-Jett_0.50_VALORANT_Icon.png',
  Agent.KAY_O: 'https://liquipedia.net/commons/images/thumb/7/76/KAY-O_VALORANT_Icon.png/20px-KAY-O_VALORANT_Icon.png',
  Agent.Killjoy: 'https://liquipedia.net/commons/images/thumb/6/61/Killjoy_VALORANT_Icon.png/20px-Killjoy_VALORANT_Icon.png',
  Agent.Miks: 'https://liquipedia.net/commons/images/thumb/d/d8/Miks_VALORANT_Icon.png/20px-Miks_VALORANT_Icon.png',
  Agent.Neon: 'https://liquipedia.net/commons/images/thumb/d/da/Neon_VALORANT_Icon.png/20px-Neon_VALORANT_Icon.png',
  Agent.Omen: 'https://liquipedia.net/commons/images/thumb/1/1e/Omen_0.50_VALORANT_Icon.png/20px-Omen_0.50_VALORANT_Icon.png',
  Agent.Phoenix: 'https://liquipedia.net/commons/images/thumb/1/16/Phoenix_0.50_VALORANT_Icon.png/20px-Phoenix_0.50_VALORANT_Icon.png',
  Agent.Raze: 'https://liquipedia.net/commons/images/thumb/a/a4/Raze_0.50_VALORANT_Icon.png/20px-Raze_0.50_VALORANT_Icon.png',
  Agent.Reyna: 'https://liquipedia.net/commons/images/thumb/b/b4/Reyna_VALORANT_Icon.png/20px-Reyna_VALORANT_Icon.png',
  Agent.Sage: 'https://liquipedia.net/commons/images/thumb/9/97/Sage_0.50_VALORANT_Icon.png/20px-Sage_0.50_VALORANT_Icon.png',
  Agent.Skye: 'https://liquipedia.net/commons/images/thumb/d/d6/Skye_VALORANT_Icon.png/20px-Skye_VALORANT_Icon.png',
  Agent.Sova: 'https://liquipedia.net/commons/images/thumb/4/4b/Sova_0.50_VALORANT_Icon.png/20px-Sova_0.50_VALORANT_Icon.png',
  Agent.Tejo: 'https://liquipedia.net/commons/images/thumb/1/1d/Tejo_VALORANT_Icon.png/20px-Tejo_VALORANT_Icon.png',
  Agent.Veto: 'https://liquipedia.net/commons/images/thumb/5/5a/Veto_VALORANT_Icon.png/20px-Veto_VALORANT_Icon.png',
  Agent.Viper: 'https://liquipedia.net/commons/images/thumb/1/1d/Viper_0.50_VALORANT_Icon.png/20px-Viper_0.50_VALORANT_Icon.png',
  Agent.Vyse: 'https://liquipedia.net/commons/images/thumb/6/61/Vyse_VALORANT_Icon.png/20px-Vyse_VALORANT_Icon.png',
  Agent.Waylay: 'https://liquipedia.net/commons/images/thumb/1/10/Waylay_VALORANT_Icon.png/20px-Waylay_VALORANT_Icon.png',
  Agent.Yoru: 'https://liquipedia.net/commons/images/thumb/9/92/Yoru_VALORANT_Icon.png/20px-Yoru_VALORANT_Icon.png',
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
