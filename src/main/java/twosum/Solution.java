package twosum;

public class Solution {
    int result[] =new int[2];
    public int[] twoSum(int[] nums, int target){
        for (int i = 0;i < nums.length;i++ ){
            for (int j = i+1;j < nums.length;j++ ){
                if(target == (nums[i] + nums[j])){
                    result[0] = i;
                    result[1] = j;
                    //System.out.println("i = "+ i + "j = "+ j);
                    break;

                }

            }
        }
        return result;
    }
}
