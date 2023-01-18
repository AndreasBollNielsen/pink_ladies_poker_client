import 'User.dart';

class PokerTable {
  late List<User> users = [];
  late List<dynamic> bets = [];
  late List<String> collectiveCards = [];
  late List<String> cardDeck = [];
  late dynamic dealer = 0;
  late dynamic smallBlind = 0;
  late dynamic bigBlind = 0;
  late dynamic currentBet = 0;
  late dynamic totalBet = 0;
  late dynamic totalPot = 0;
  late dynamic currentUser = 0;
  late dynamic round = 0;

  PokerTable.ConvertFromJson(Map<String, dynamic> json)
      : //users = ConvertUsersToList(json),
        bets = List<double>.from(json['bets']),
        collectiveCards = List<String>.from(json['collectiveCards']),
        cardDeck = List<String>.from(json['cardDeck']),
        dealer = json['dealer'],
        smallBlind = json['smallBlind'],
        bigBlind = json['bigBlind'],
        currentBet = json['currentBet'],
        totalBet = json['totalbet'],
        totalPot = json['totalPot'],
        currentUser = json['currentUser'],
        round = json['round'];

  Map<String, dynamic> ConvertToJson() => {
        'users': users,
        'bets': bets,
        'collectiveCards': collectiveCards,
        'cardDeck': cardDeck,
        'dealer': dealer,
        'smallBlind': smallBlind,
        'bigBlind': bigBlind,
        'currentBet': currentBet,
        'totalBet': totalBet,
        'totalPot': totalPot,
        'currentUser': currentUser,
        'round': round,
      };

  ConvertUsersToList(Map<String, dynamic> json) {
    Iterable iterableList = json['users'];
    List<User> users =
        List<User>.from(iterableList.map((user) => User.ConvertFromJson(user)));
    return users;
  }
}
