class User {
  int UserID = 0;
  int TableID = 0;
  String UserName = "";
  num Saldo = 0;
  late List<String> PocketCards = [];
  String State = "";
  dynamic Bet = 0;

  User(this.UserID, this.TableID, this.UserName, this.Saldo, this.State,
      this.Bet);

  User.ConvertFromJson(Map<String, dynamic> json)
      : UserID = json['userID'],
        TableID = json['tableID'],
        UserName = json['userName'],
        Saldo = json['saldo'],
        State = json['state'],
        PocketCards = List<String>.from(json['pocketCards']),
        Bet = json['bet'];

  Map<String, dynamic> ConvertToJson() => {
        'userID': UserID,
        'tableID': TableID,
        'userName': UserName,
        'saldo': Saldo,
        'pocketCards': PocketCards,
        'state': State,
        'bet': Bet,
      };

  // @override
  // String toString() {
  //   return '{ ${this.UserID}, ${this.TableID}, ${this.UserName}, ${this.Saldo} , ${this.State}}, ${this.Bet}';
  // }
}
