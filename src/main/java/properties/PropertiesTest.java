package properties;

import org.apache.log4j.Logger;

import javax.swing.*;
import java.awt.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.*;
import java.util.Properties;

public class PropertiesTest {

    public static void main(String[] args) {

        EventQueue.invokeLater(() -> {
            PropertiesFrame frame = new PropertiesFrame();
            frame.setVisible(true);
        });
    }

}

class PropertiesFrame extends JFrame {
    private static final int DEFAULT_WIDTH = 300;
    private static final int DEFAULT_HIGHT = 300;

    private File propertiesFile;
    private Properties settings;
    private static Logger logger = Logger.getLogger(PropertiesFrame.class);


    public PropertiesFrame() {

        String userDir = System.getProperty("user.home");
        logger.info(userDir);

        File propertiesDir = new File(userDir, ".corejava");
        if (!propertiesDir.exists()) propertiesDir.mkdir();
        propertiesFile = new File(propertiesDir, "program.properties");
        logger.info(propertiesFile);

        Properties defaultSettings = new Properties();
        defaultSettings.setProperty("top", "0");
        defaultSettings.setProperty("left", "0");
        defaultSettings.setProperty("width", "" + DEFAULT_WIDTH);
        defaultSettings.setProperty("height", "" + DEFAULT_HIGHT);
        defaultSettings.setProperty("title", "");

        settings = new Properties(defaultSettings);

        if (propertiesFile.exists()) {
            try (InputStream in = new FileInputStream(propertiesFile)) {
                settings.load(in);
            } catch (IOException e) {
                e.printStackTrace();
            }
            int left = Integer.parseInt(settings.getProperty("left"));
            int top = Integer.parseInt(settings.getProperty("top"));
            int width = Integer.parseInt(settings.getProperty("width"));
            int heigt = Integer.parseInt(settings.getProperty("height"));
            setBounds(left, top, width, heigt);


            //if no title ,ask user
            String title = settings.getProperty("title");
            if (title.equals(""))
                title = JOptionPane.showInputDialog("Please supply a frame title:");
            if (title == null) title = "";
            setTitle(title);

            addWindowListener(new WindowAdapter() {
                public void windowClosing(WindowEvent event) {
                    settings.setProperty("left", "" + getX());
                    settings.setProperty("top", "" + getY());
                    settings.setProperty("width", "" + getWidth());
                    settings.setProperty("height", "" + getHeight());
                    settings.setProperty("title", "" + getTitle());

                    try (OutputStream out = new FileOutputStream(propertiesFile)) {
                        settings.store(out, "Program Properties");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    System.exit(0);
                }
            });
        }
    }
}
