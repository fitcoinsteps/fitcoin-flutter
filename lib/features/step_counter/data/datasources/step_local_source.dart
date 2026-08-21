import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitcoin/features/step_counter/data/models/step_data_model.dart';

class StepLocalSource {
  static const _stepsKey = 'today_steps';
  static const _goalKey = 'daily_goal';
  static const _dateKey = 'step_date';

  Future<StepDataModel?> getTodaySteps() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDate = prefs.getString(_dateKey);
    final today = DateTime.now().toIso8601String().substring(0, 10);

    if (storedDate != today) {
      return null; // new day, start fresh
    }

    final steps = prefs.getInt(_stepsKey) ?? 0;
    final goal = prefs.getInt(_goalKey) ?? 10000;
    return StepDataModel(
      steps: steps,
      goal: goal,
      date: DateTime.now(),
    );
  }

  Future<void> saveTodaySteps(int steps, {int goal = 10000}) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    await prefs.setString(_dateKey, today);
    await prefs.setInt(_stepsKey, steps);
    await prefs.setInt(_goalKey, goal);
  }

  /// Clear ALL locally stored step data (use on logout/account deletion)
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();

    // Remove known keys
    await prefs.remove(_stepsKey);
    await prefs.remove(_goalKey);
    await prefs.remove(_dateKey);

    // 🔥 Extra safety: remove any other key that contains 'step' (case-insensitive)
    final allKeys = prefs.getKeys();
    for (final key in allKeys) {
      if (key.toLowerCase().contains('step')) {
        await prefs.remove(key);
      }
    }
  }
}