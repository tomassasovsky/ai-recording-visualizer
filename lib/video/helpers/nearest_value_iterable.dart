import 'package:collection/collection.dart';

extension NearestIndex on Iterable<int> {
  // TODO(tomastisocco): optimize nearestIndex
  int? nearestIndex({
    required int target,
    int threshold = 0,
  }) {
    // include only targets within the threshold
    final targets = where((element) => (element - target).abs() <= threshold);

    var diff = (elementAt(0) - target).abs();

    return targets.firstWhereOrNull(
      (element) {
        final currentDiff = (element - target).abs();
        if (currentDiff < diff && currentDiff <= threshold) {
          diff = currentDiff;
        }

        return currentDiff <= threshold;
      },
    );
  }
}
