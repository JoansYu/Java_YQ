package generic_paradigm.practice2_2.prac2_1;



public class MyPoint {
    private double x;
    private double y;
    public MyPoint(){
    this(0,0);
    }

    public MyPoint(double x,double y){
        this.x = x;
        this.y = y;
    }

    public double getX(){
        return x;
    }
    public double getY(){
        return y;
    }
    public void setX(double x){
        this.x = x;
    }
    public void setY(double y){
        this.y = y;
    }

    public double getD(double x,double y){
        double d = Math.pow((Math.pow((this.x - x),2) + Math.pow((this.y - y),2)),0.5);
        return d;
    }


}
