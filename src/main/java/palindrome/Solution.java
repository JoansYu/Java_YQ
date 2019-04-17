package palindrome;

import java.util.ArrayList;

public class Solution {
    public boolean isPalindrome(int x) {
        boolean result = false;
//        ArrayList List = new ArrayList();
        String s = String.valueOf(x);
        char[] chars = s.toCharArray();
//        int length = List.size();
        for (int i = 0,j = chars.length-1;i<j;i++,j--){
//            System.out.println("i="+chars[i]);
//            System.out.println("j="+chars[j]);
            if (chars[i]!=chars[j])
                return false;
        }
        return true;


    }
}
