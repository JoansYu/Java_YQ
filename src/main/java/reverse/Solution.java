package reverse;

class Solution {
    boolean flag = false;
    public int reverse(int x) {
        if (x<0){
            x = -x;
            flag = true;
        }
        StringBuffer sb = new StringBuffer(String.valueOf(x)).reverse();
        try {
            int result = Integer.parseInt(String.valueOf(sb));

        if (flag){
            result = -result;
        }
        return result;
    }catch (NumberFormatException e){
            return 0;
        }
    }
}

