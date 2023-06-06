extension NearestIndex on Iterable<int> {
  int? nearestIndex({
    required int target,
    int threshold = 0,
  }) {
    var left = 0;
    var right = length - 1;
    var nearestValue = last;

    while (left <= right) {
      final mid = left + ((right - left) ~/ 2);
      final elementAtMid = elementAt(mid);

      if ((elementAtMid - target).abs() < threshold) return elementAtMid;

      if ((elementAtMid - target).abs() < (nearestValue - target).abs()) {
        nearestValue = elementAtMid;
      }

      elementAtMid < target ? left = mid + 1 : right = mid - 1;
    }
    return null;
  }
}
