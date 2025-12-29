abstract class ProgressState{}

class ProgressInitial extends ProgressState{
  final int amount;

  ProgressInitial({required this.amount});

  ProgressInitial copyWith({int? amount}){
    print(amount);
    return ProgressInitial(amount: amount??this.amount);
  }
}
