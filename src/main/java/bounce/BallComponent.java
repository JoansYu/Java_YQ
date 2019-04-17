package bounce;

import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;
import java.util.List;

public class BallComponent extends JPanel {
    /**
     * the component that draw the balls
     */
    private static final int DEFAULT_WIDTH = 450;
    private static final int DEFAULT_HIGHT = 350;

    private List<Ball> balls = new ArrayList<>();

    /**
     * Add a ball to the component
     * @param b the ball to add
     */
    public void add(Ball b){
        balls.add(b);
    }

    public void paintComponent(Graphics g){
        super.paintComponent(g);//erase background
        Graphics2D g2 = (Graphics2D) g;
        for (Ball b:balls){
            g2.fill(b.getShape());
        }
    }

    public Dimension getPreferredSize(){
        return new Dimension(DEFAULT_WIDTH,DEFAULT_HIGHT);
    }
}
