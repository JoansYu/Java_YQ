package TestLambda;

import lambda.FunctionInterface;
import org.junit.Test;

public class FunctionInterfaceTest {

    @Test
    public void testLambda(){
        func(new FunctionInterface(){
            @Override
            public void test(){
                System.out.println("Hello World!");
            }
        });
        func(() ->System.out.println("Hello World!"));
    }


    private void func(FunctionInterface functionInterface){
        functionInterface.test();
    }
}
