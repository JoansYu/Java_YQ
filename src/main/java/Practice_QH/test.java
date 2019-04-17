package Practice_QH;

import java.util.Scanner;

public class test {
}


class Person{

    Scanner in = new Scanner(System.in);
    public  Person(Scanner in){
        this.in = in;
    }
    public String getPerson(Scanner in){
        return in.toString();
    }
}

class Teacher extends Person{


    public Teacher(Scanner in) {
        super(in);

    }

}


class Students extends Person{

    public Students(Scanner in) {
        super(in);
    }
}