import 'package:collection/collection.dart';

extension NearestIndex on Iterable<int> {
  int? nearestIndex({
    required int target,
    int threshold = 0,
  }) {
    var diff = (elementAt(0) - target).abs();

    return firstWhereOrNull(
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
