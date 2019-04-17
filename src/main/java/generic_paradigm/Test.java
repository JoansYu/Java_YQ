package generic_paradigm;

class GeneralType<Type extends Number> {
    Type object;
    public GeneralType(Type object){
        this.object = object;
    }
    public Type getObject(){
        return object;
    }

}

public class Test{
    public static void main(String args[]){
        GeneralType<Integer> i = new GeneralType<Integer>(2);
        System.out.printf(i.getObject().toString());
    }
}