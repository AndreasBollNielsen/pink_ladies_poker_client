class User {
  int UserID;
  int TableID;
  String UserName;
  double Saldo;
  late List<String> PocketCards;
  String State;
  double Bet;

  // User(this.UserID, this.TableID, this.UserName, this.Saldo, this.PocketCards,this.State, this.Bet);

  User.ConvertFromJson(Map<String, dynamic> json)
      : UserID = json['userID'] as int,
        TableID = json['tableID'] as int,
        UserName = json['userName'] as String,
        Saldo = json['saldo'] as double,
        State = json['state'] as String,
        Bet = json['bet'] as double;

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
