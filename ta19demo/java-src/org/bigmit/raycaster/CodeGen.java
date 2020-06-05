package org.bigmit.raycaster;

import java.io.PrintStream;

public class CodeGen {

    static final double TRS_UNIT_ANGLE_DEG = 360.0 / 256.0;
    static final double TRS_HALF_UNIT_ANG_DEG = TRS_UNIT_ANGLE_DEG / 2.0;

    public static double deltaDistX(double radians) {
        return 1.0 / Math.cos(radians);
    }


    public static double deltaDistY(double radians) {
        return 1.0 / Math.sin(radians);
    }


    public static double distance(double x, double y) {
        return Math.sqrt(x * x + y * y);
    }

    public static double trsTableLookup(int trsAngle0to64) {
        double radians = Math.toRadians(trsAngle0to64 * TRS_UNIT_ANGLE_DEG);
        // I think this is wrong: return distance(deltaDistY(radians), 1);
        return deltaDistY(radians);
    }

    public static int trsTableLookupInt(int trsAngle0to64) {
        double distance = trsTableLookup(trsAngle0to64);
        return (int) Math.round(distance * 256.0);
    }

    public static double trsTableSkewLookup(int trsAngle0to64) {
        double radians = Math.toRadians(trsAngle0to64 * TRS_UNIT_ANGLE_DEG + TRS_HALF_UNIT_ANG_DEG);
        return distance(deltaDistY(radians), 1);
    }

    public static int trsTableSkewLookupInt(int trsAngle0to64) {
        double distance = trsTableSkewLookup(trsAngle0to64);
        return (int) Math.round(distance * 256.0);
    }


    public static double trsDeltaDistX(int trsAngle) {
        if (trsAngle < 0 || trsAngle >= 256)
            throw new IllegalStateException("trsAngle must be (0,256] and is " + trsAngle);
        if (trsAngle == 0 || trsAngle == 128) return Double.POSITIVE_INFINITY;
        if (trsAngle == 64 || trsAngle == 192) return 1;
        if (trsAngle > 128 && trsAngle < 192) {
            trsAngle = trsAngle - 128;
        } else if (trsAngle > 64 && trsAngle < 128 || trsAngle > 192 && trsAngle < 256) {
            if (trsAngle > 192) trsAngle = trsAngle - 128;
            trsAngle = 64 - (64 - trsAngle);
        }
        return trsTableLookup(trsAngle);
    }

    public static int intDeltaDistX(int trsAngle, int[] table) {
        if (trsAngle < 0 || trsAngle >= 256)
            throw new IllegalStateException("trsAngle must be (0,256] and is " + trsAngle);
        if (trsAngle >= 128) {
            trsAngle -= 128;
        }
        return table[trsAngle];
    }

    public static int intDeltaDistY(int trsAngle, int[] table) {
        return intDeltaDistX((trsAngle + 64) % 256, table);
    }

    public static double trsDeltaDistY(int trsAngle) {
        if (trsAngle < 0 || trsAngle >= 256)
            throw new IllegalStateException("trsAngle must be (0,256] and is " + trsAngle);
        if (trsAngle == 0 || trsAngle == 128) return 1;
        if (trsAngle == 64 || trsAngle == 192) return Double.POSITIVE_INFINITY;
        if (trsAngle > 0 && trsAngle < 64 || trsAngle > 128 && trsAngle < 192) {
            if (trsAngle > 128) trsAngle = trsAngle - 128;
            trsAngle = 64 - trsAngle;
        } else if (trsAngle > 64 && trsAngle < 128) {
            trsAngle = trsAngle - 64;
        } else if (trsAngle > 192 && trsAngle < 256) {
            trsAngle = trsAngle - 128;
        }
        return trsTableLookup(trsAngle);
    }

    public static void outputRotationTable(PrintStream o) {
        System.out.println("TRS_UNIT_ANGLE_DEG " + TRS_UNIT_ANGLE_DEG);
        for (int trsAngle = 0; trsAngle < 256; trsAngle++) {
            System.out.println("trsAngle " + trsAngle + " deltaDistX -> " + trsDeltaDistX(trsAngle) + " deltaDistY -> " + trsDeltaDistY(trsAngle));
        }

        for (int trsAngle = 0; trsAngle < 256; trsAngle++) {
            System.out.println("trsAngle " + trsAngle + " deltaDistX -> " + intDeltaDistX(trsAngle, delta_dist_x) + "," + intDeltaDistX(trsAngle, delta_skew_x) + " deltaDistY -> " + intDeltaDistY(trsAngle, delta_dist_x) + "," + intDeltaDistY(trsAngle, delta_skew_x));
        }
    }


    public static void outputTable(PrintStream o, String name, int[] table) {
        for (int angle = 0; angle <= 128; angle++) {
            o.println(name + String.format("%03d", angle) + "\t\tdefw\t" + table[angle]);
        }
    }

    static int[] delta_dist_x;

    public static void pop_delta_dist_x() {
        delta_dist_x = new int[129];
        delta_dist_x[0] = 65535;
        for (int angle = 1; angle < 64; angle++) {
            delta_dist_x[angle] = trsTableLookupInt(angle);
        }
        delta_dist_x[64] = 0;
        for (int angle = 65; angle < 128; angle++) {
            delta_dist_x[angle] = trsTableLookupInt(angle);
        }
        delta_dist_x[128] = 65535;
    }

    static int[] delta_skew_x;

    public static void pop_delta_skew_x() {
        delta_skew_x = new int[129];
        for (int angle = 0; angle <= 128; angle++) {
            delta_skew_x[angle] = trsTableSkewLookupInt(angle);
        }
    }

    static class Point {
        Point(int x, int y) {
            this.x = x;
            this.y = y;
        }

        /**
         * Half-height
         */
        int x;
        /**
         * Distance in map units.
         */
        int y;
    }

    public static void dist_lookup_table(Point p1, Point p2, PrintStream o) {
        // Slope for y = mx + b
        double m = ((double) (p2.y - p1.y) / (double) (p2.x - p1.x));
        double b = p1.y - m * p1.x;
        for (int hh = 1; hh < 18; hh++) {
            double distMapUnits = m * hh + b;
            o.print("hh_" + String.format("%02d", hh) + "\t\t defw\t" + Math.round(distMapUnits * 256));
            o.println("\t; map distance " + distMapUnits);
        }
    }


    public static void main(String[] args) {
        pop_delta_dist_x();
        pop_delta_skew_x();

        System.out.println("trsTableLookup(64) = " + trsTableLookup(64));

        outputRotationTable(System.out);
        System.out.println();
        outputTable(System.out, "delta_dist_x_", delta_dist_x);
        System.out.println();
        outputTable(System.out, "delta_skew_x_", delta_skew_x);
        System.out.println();
        dist_lookup_table(new Point(1, 17), new Point(17, 1), System.out);
    }
}

