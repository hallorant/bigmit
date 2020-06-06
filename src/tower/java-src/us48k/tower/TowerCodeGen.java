package us48k.tower;

import java.io.PrintStream;
import java.util.function.IntUnaryOperator;

/**
 * This class generates tables for the Tower TRS-80 game.
 * In particular it helps with raycasting calculations, but any
 * tedious code generated here and copied into the z80 assembly.
 *
 * @author Tim Halloran
 */
public class TowerCodeGen {
  static final double TRS_UNIT_ANGLE_DEG = 360.0 / 128.0;

  /**
   * This defines conversions:
   * 8 world units = 1 map unit
   * 8 sub-world units = 1 world unit
   * By only using one conversion we avoid duplicate tables.
   */
  static final int UNITS_PER_MORE_COURSE_UNIT = 8;

  /*
   * Code to output raycasting step distances as lookup tables.
   * We cannot do these calculations in TRS-80 assembly quickly.
   */

  static double hypotenuseLength(int trsAngle) {
    double radians = Math.toRadians(trsAngle * TRS_UNIT_ANGLE_DEG);
    return 1.0 / Math.sin(radians);
  }

  static int getHypotenuseInFinerUnits(int trsAngle) {
    if (trsAngle == 0 || trsAngle == 64) return 255;
    double length = hypotenuseLength(trsAngle);  // Step of one in course unit.
    return (int) Math.round(length * UNITS_PER_MORE_COURSE_UNIT);
  }

  static double otherTriangleSideLength(int trsAngle0to32) {
    double c = hypotenuseLength(trsAngle0to32);
    return Math.sqrt(c * c - 1);
  }

  static int getOtherSideLengthInFinerUnits(int trsAngle) {
    if (trsAngle == 0 || trsAngle == 64) return 255;
    double length = otherTriangleSideLength(trsAngle);
    return (int) Math.round(length * UNITS_PER_MORE_COURSE_UNIT);
  }

  static void outputDistanceLookupTable(PrintStream o, String name, String indent, IntUnaryOperator distanceFn) {
    for (int trsAngle = 0; trsAngle <= 64; trsAngle++) {
      o.println((trsAngle == 0 ? name : indent) + "\tdefb\t" + distanceFn.applyAsInt(trsAngle) +
        "\t; at angle " + String.format("%02d", trsAngle));
    }
  }

  /**
   * Used to describe desired wall half height for a world distance.
   */
  static class HeightExample {
    HeightExample(int halfHeight, int distInWorldUnits) {
      this.halfHeight = halfHeight;
      this.distInWorldUnits = distInWorldUnits;
    }

    /**
     * Half-height [0,11]
     */
    int halfHeight;
    /**
     * Distance in world units.
     */
    int distInWorldUnits;
  }

  static int fishEyeCorrection(int distInWorldUnits, int trsAngle) {
    double distance = distInWorldUnits;
    double radians = Math.toRadians(trsAngle * TRS_UNIT_ANGLE_DEG);
    double correctedDistance = distance * Math.cos(radians);
    return (int) correctedDistance;
  }

  static void outputHalfHeightDistanceLookupTable(HeightExample p1, HeightExample p2, PrintStream o) {
    for (int trsAngle = 0; trsAngle < 11; trsAngle++) {
      // Do fish eye correction now, we need table distance values to be for uncorrected distances.
      HeightExample pc1 = new HeightExample(p1.halfHeight, fishEyeCorrection(p1.distInWorldUnits, trsAngle));
      HeightExample pc2 = new HeightExample(p2.halfHeight, fishEyeCorrection(p2.distInWorldUnits, trsAngle));
      // Slope for y = mx + b
      double m = ((double) (pc2.distInWorldUnits - pc1.distInWorldUnits) / (double) (pc2.halfHeight - pc1.halfHeight));
      double b = pc1.distInWorldUnits - m * pc1.halfHeight;
      for (int halfHeight = pc1.halfHeight; halfHeight <= pc2.halfHeight; halfHeight++) {
        double distMapUnits = m * halfHeight + b;
        int intDistMapUnits = (int) Math.round(distMapUnits);
        if (halfHeight == pc1.halfHeight) {
          o.print("\n; Half-height lookup table for");
          o.println((trsAngle == 0 ? " the " : " angle " + trsAngle + " off ") + "center of view.");
          o.println("; Maps the smallest distance which should use a particular wall half-height.");
          o.println("; All values are (uncorrected for fisheye) distances in world units.");
        }
        o.print((halfHeight == pc1.halfHeight ? "hh_for_angle_" + String.format("%02d", trsAngle) : "\t"));
        o.print("\t\tdefb\t" + intDistMapUnits);
        o.println("\t; for a wall half height of " + halfHeight);
      }
      if (trsAngle == 0) {
        o.println("hh_table_size\t\tequ\t$-hh_for_angle_" + String.format("%02d", trsAngle));
      }
    }
  }

  static void outputHalfHeightWalls(boolean solidWalls, String id, PrintStream o) {
    for (int halfHeight = 0; halfHeight <= 11; halfHeight++) {
      o.print(id + String.format("%02d", halfHeight) + "\tdefs\t");
      boolean first = true;
      for (int i = 1; i <= 21; i++) {
        if (first) {
          first = false;
        } else {
          o.print(",");
        }
        int dist = i - 11;
        if (solidWalls) {
          o.print(Math.abs(dist) <= halfHeight ? "$ff" : "$00");
        } else {
          o.print(Math.abs(dist) == halfHeight ? "$ff" : "$00");
        }
      }
      o.println();
    }
  }

  public static void main(String[] args) {
    System.out.println();
    System.out.println("; For one unit step in the x direction this lookup table maps a");
    System.out.println("; given angle to the distance (hypotenuse) in the next finer unit.");
    System.out.println("; Can be used for:");
    System.out.println(";  - Map unit steps resulting in distances in world units.");
    System.out.println(";  - World unit steps resulting in distances in sub-world units.");
    System.out.println("; Usage notes: Only contains angles [0,64]. Despite containing values the");
    System.out.println(";              vertical/horizontal angles should be treated as a special");
    System.out.println(";              case, i.e., 255 != infinity.");
    outputDistanceLookupTable(System.out, "x_step_distance", "\t", TowerCodeGen::getHypotenuseInFinerUnits);
    System.out.println();
    System.out.println("; For one unit step in the x direction this lookup table maps a");
    System.out.println("; given angle to the y-distance (length) in the next finer unit.");
    System.out.println("; Can be used for:");
    System.out.println(";  - Map unit steps resulting in lengths in world units.");
    System.out.println(";  - World unit steps resulting in lengths in sub-world units.");
    System.out.println("; Usage notes: Only contains angles [0,64]. Despite containing values the");
    System.out.println(";              vertical/horizontal angles should be treated as a special");
    System.out.println(";              case, i.e., 255 != infinity.");
    outputDistanceLookupTable(System.out, "x_step_y_length", "\t", TowerCodeGen::getOtherSideLengthInFinerUnits);

    System.out.println();
    outputHalfHeightDistanceLookupTable(new HeightExample(0, 31 * UNITS_PER_MORE_COURSE_UNIT), new HeightExample(10, 4), System.out);
    System.out.println();
    outputHalfHeightWalls(false, "wall_dots_hh_", System.out);
    System.out.println();
    outputHalfHeightWalls(true, "wall_line_hh_", System.out);
  }
}
