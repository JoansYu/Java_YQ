package longestcommonprefix;

public class Test {
    public static void main(String []args){
        String[] strs = {"flower","flow","flight"};
        Solution solution = new Solution();
        String str = solution.longestCommonPrefix(strs);
        System.out.println(str);
    }
}
