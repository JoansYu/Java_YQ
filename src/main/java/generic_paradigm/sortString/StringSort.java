package generic_paradigm.sortString;

import java.util.Arrays;
import java.util.Scanner;

public class StringSort {

    public static void main(String args[]){
        StringSort stringSort = new StringSort();
        String[] testString = stringSort.getString();
        Arrays.sort(testString);
        System.out.printf(Arrays.toString(testString));
    }

    public String[] getString() {
        System.out.printf("Please enter N:");
        Scanner scanner = new Scanner(System.in);
        String in = scanner.nextLine();
        int N = Integer.parseInt(in);
        String[] strings = new String[N];

        for (int i = 0; i < N; i++) {
            System.out.printf("Please enter String:");
            Scanner scanner2 = new Scanner(System.in);
            String in2 = scanner2.nextLine();
            strings[i] = in2;
        }
        return strings;
    }

}


