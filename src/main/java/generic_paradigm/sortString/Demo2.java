package generic_paradigm.sortString;

import java.util.*;

public class Demo2 {
    public static void main(String args[]){
        Scanner scanner = new Scanner(System.in);
       // while (scanner.hasNext()) {
            long n = Integer.parseInt(scanner.nextLine());
            List<String> list = new ArrayList<String>();
            for (int i = 0; i < n; i++) {
                String b = scanner.next();
                list.add(b);
            }
            Collections.sort(list);
            for (String st : list) {
                System.out.printf(st+"\n");
            }
       // }
    }
}
