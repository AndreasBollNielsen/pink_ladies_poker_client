import 'User.dart';

class PokerTable {
  late List<User> users = [];
  // final List<double> bets;
  final List<String> collectiveCards;
  final List<String> cardDeck;
  final num dealer;
  final num smallBlind;
  final num bigBlind;
  final num currentBet;
  final num totalBet;
  final num totalPot;
  final num currentUser;
  final num round;

  PokerTable.ConvertFromJson(Map<String, dynamic> json)
      : //users = ConvertUsersToList(json),
        // bets = json['bets'],
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
        // 'bets': bets,
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
