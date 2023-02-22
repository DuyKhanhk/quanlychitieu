class Expense {
  final String uID, money, note, timeChosse, timeInput, type;

  Expense(this.money, this.note, this.timeChosse, this.timeInput, this.type, this.uID);
}

class User {
  final AccountBanks kdy;
  final int image, totalMoney;
  final String phone, userID, userName;

  User(this.kdy, this.image, this.totalMoney, this.phone, this.userID,
      this.userName);
}

class AccountBanks {
  final String name;
  final int moneyCurrent;
  AccountBanks(this.name, this.moneyCurrent);
}
