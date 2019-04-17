package preferences;

import org.apache.log4j.Logger;

import javax.swing.*;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.awt.*;
import java.io.*;
import java.util.prefs.Preferences;

public class PreferencesTest {
    public static void main(String[] args){
        EventQueue.invokeLater(()->{
            PreferencesFrame frame = new PreferencesFrame();
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setVisible(true);
        });
    }
}

class PreferencesFrame extends JFrame{
    Logger logger = Logger.getLogger(PreferencesFrame.class);
    private static final int DEFAULT_WIDTH = 300;
    private static final int DEFAULT_HIGHT = 200;
    private Preferences root = Preferences.userRoot();
    private Preferences node = root.node("/com/horstmann/core.java");

    public PreferencesFrame(){
        //get position, size, title from preferences
        int left = node.getInt("left",0);
        int top = node.getInt("top",0);
        int width = node.getInt("width",DEFAULT_WIDTH);
        int hight = node.getInt("hight",DEFAULT_HIGHT);
        setBounds(left,top,width,hight);

        // if no title given, ask user
        String title = node.get("title","");
        if (title.equals(""))
            title = JOptionPane.showInputDialog("Please supply a frame title:");
        if (title==null)title="";
        setTitle(title);

        //set up file chooser that shows XML files
        final JFileChooser chooser = new JFileChooser();
        chooser.setCurrentDirectory(new File("."));
        logger.info(chooser.getCurrentDirectory());
        chooser.setFileFilter(new FileNameExtensionFilter("XML files","xml"));
        logger.info(chooser.getFileFilter());

        //set up menus
        JMenuBar menuBar = new JMenuBar();
        setJMenuBar(menuBar);
        JMenu menu = new JMenu("File");
        menuBar.add(menu);

        JMenuItem exportItem = new JMenuItem("Export preferences");
        menu.add(exportItem);
        exportItem.addActionListener(event ->{
            if (chooser.showSaveDialog(PreferencesFrame.this)==JFileChooser.APPROVE_OPTION)
            {
                try{
                    savaPreferences();
                    OutputStream out = new FileOutputStream(chooser.getSelectedFile());
                    logger.info(out);
                    node.exportSubtree(out);
                    out.close();
                }catch (Exception e){
                    e.printStackTrace();
                }
            }
        });

        JMenuItem importItem = new JMenuItem("Import preferences");
        menu.add(importItem);
        importItem.addActionListener(event ->{
            if (chooser.showOpenDialog(PreferencesFrame.this)==JFileChooser.APPROVE_OPTION){
                try{
                    InputStream in = new FileInputStream(chooser.getSelectedFile());
                    Preferences.importPreferences(in);
                    in.close();
                }catch (Exception e){
                    e.printStackTrace();
                }
            }
        });

        JMenuItem exitItem = new JMenuItem("Exit");
        menu.add(exitItem);
        exitItem.addActionListener(e -> {
            savaPreferences();
            System.exit(0);
        });
    }

    public void savaPreferences(){
        node.putInt("left",getX());
        node.putInt("top",getY());
        node.putInt("width",getWidth());
        node.putInt("hight",getHeight());
        node.put("title",getTitle());
    }
}