package twosum;

import java.util.Arrays;

public class twoSumTest {
    public static void main(String args[]){
        int[] nums = {2,7,11,15};
        int target = 9;
        Solution solution = new Solution();
        int[] result = solution.twoSum(nums,target);
        System.out.println(Arrays.toString(result));
    }
}
