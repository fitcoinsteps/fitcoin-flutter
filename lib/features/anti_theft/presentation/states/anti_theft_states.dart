sealed class AntiTheftState {}

class AntiTheftInitial extends AntiTheftState {}

class AntiTheftArmed extends AntiTheftState {}

class AntiTheftDisarmed extends AntiTheftState {}

class AntiTheftTriggered extends AntiTheftState {
  final String message;
  AntiTheftTriggered(this.message);
}