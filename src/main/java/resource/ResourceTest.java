package resource;

import javax.swing.*;
import java.awt.*;
import java.io.InputStream;
import java.net.URL;
import java.util.Scanner;

public class ResourceTest {
    public static void main(String[] args) {
        EventQueue.invokeLater(() -> {
            JFrame frame = new ResourceTestFrame();
            frame.setTitle("ResourceTest");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setVisible(true);

        });
    }
}

    class ResourceTestFrame extends JFrame{
        private static final int DEFAULT_WIDTH = 300;
        private static final int DEFAULT_HIGHT = 300;

        public ResourceTestFrame(){
            setSize(DEFAULT_WIDTH,DEFAULT_HIGHT);
            URL aboutURL = getClass().getResource("about.gif");
            Image image = new ImageIcon(aboutURL).getImage();
            setIconImage(image);

            JTextArea textArea = new JTextArea();
            InputStream stream = getClass().getResourceAsStream("about.tex");
            try(Scanner in = new Scanner(stream,"UTF-8")){
                while (in.hasNext()){
                    textArea.append(in.nextLine()+"\n");
                }
            }
            add(textArea);
        }
    }

