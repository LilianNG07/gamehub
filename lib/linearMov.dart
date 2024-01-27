
abstract class linearMov {
  static bool hasVerticalWay(int x,int y,int xTarget,int yTarget) {
    if (y == yTarget && x != xTarget) {
      return true;
    }
    return false;
  }

  static bool hasHorizontalWay(int x,int y,int xTarget,int yTarget) {
    if (y != yTarget && x == xTarget) {
      return true;
    }
    return false;
  }

  static bool hasDiagonalWay(int x,int y,int xTarget,int yTarget) {
    if ((y - yTarget).abs() == (x - xTarget).abs()) {
      return true;
    }
    return false;
  }
}