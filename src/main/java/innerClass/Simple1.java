package innerClass;

import java.awt.event.*;
import javax.swing.*;

public class Simple1 {
    private static JFrame frame; // 定义为静态变量以便main使用

    private static JPanel myPanel; // 该面板用来放置按钮组件

    private JButton button1; // 这里定义按钮组件

    private JButton button2; // 以便让ActionListener使用


    public Simple1() // 构造器, 建立图形界面


    {
        // 新建面板
        myPanel = new JPanel();
        // 新建按钮
        button1 = new JButton("按钮1"); // 新建按钮1
        button2 = new JButton("按钮2");

        SimpleListener ourListener = new SimpleListener();
        // 建立一个actionlistener让两个按钮共享
        button1.addActionListener(ourListener);
        button2.addActionListener(ourListener);
        myPanel.add(button1); // 添加按钮到面板
        myPanel.add(button2);
    }

    private class SimpleListener implements ActionListener {
        /**
         * 　　 * 利用该内部类来监听所有事件源产生的事件
         * 　    　 * 便于处理事件代码模块化
         */
        public void actionPerformed(ActionEvent e) {

            String buttonName = e.getActionCommand();
            if (buttonName.equals("按钮1"))
                JOptionPane.showMessageDialog(frame, "按钮1 被点击");
            else if (buttonName.equals("按钮2"))
                JOptionPane.showMessageDialog(frame, "按钮2 被点击");
            else
                JOptionPane.showMessageDialog(frame, "Unknown event");
        }
    }

    public static void main(String s[]) {
        Simple1 gui = new Simple1(); // 新建Simple1组件

        frame = new JFrame("Simple1"); // 新建JFrame
        // 处理关闭事件的通常方法
        frame.addWindowListener(new WindowAdapter() {

            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });

        frame.getContentPane().add(myPanel);
        frame.pack();   //自动适应大小
        frame.setVisible(true);
    }
}
