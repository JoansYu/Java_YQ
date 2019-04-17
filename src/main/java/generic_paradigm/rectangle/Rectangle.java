package generic_paradigm.rectangle;

import java.util.Scanner;

public class Rectangle {


    public static void main(String args[]){
        Rectangle rectangle = new Rectangle();
        Scanner scanner = new Scanner(System.in);
        int height = Integer.parseInt(scanner.nextLine());
        int width = Integer.parseInt(scanner.nextLine());
        System.out.printf(String.valueOf(rectangle.getArea(height,width))+"\n");
        System.out.printf(String.valueOf(rectangle.getPerimeter(height,width))+"\n");
    }

    public int getArea(int height,int width){
        int area = height*width;
        return area;
    }

    public int getPerimeter(int height,int width){
        int perimeter = 2*(height+width);
        return perimeter;
    }
}
