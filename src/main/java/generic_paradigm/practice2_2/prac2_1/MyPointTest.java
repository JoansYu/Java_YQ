package generic_paradigm.practice2_2.prac2_1;

import java.util.Scanner;

public class MyPointTest {
    public static void main(String args[]){
        Scanner scanner = new Scanner(System.in);
        String str = scanner.nextLine();
        String string1[] = str.split(" ");
        double x1 = Double.parseDouble((string1[0]));
        double y1 = Double.parseDouble((string1[1]));
        String str2 = scanner.nextLine();
        String string2[] = str2.split(" ");
        double x2 = Double.parseDouble((string2[0]));
        double y2 = Double.parseDouble((string2[1]));

        MyPoint myPoint1 = new MyPoint(x1,y1);
        /*System.out.println(String.valueOf(myPoint1.getX()));*/

        System.out.println(String.valueOf(myPoint1.getD(x2,y2)));
    }
}
