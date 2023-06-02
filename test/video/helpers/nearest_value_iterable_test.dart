import 'package:ai_recording_visualizer/video/helpers/nearest_value_iterable.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Tries to find nearest index value', () {
    final list = [0, 1, 2, 4, 5, 6, 7];
    final nearestIndex = list.nearestIndex(target: 3, threshold: 1);
    expect(nearestIndex, 2);
  });
}
