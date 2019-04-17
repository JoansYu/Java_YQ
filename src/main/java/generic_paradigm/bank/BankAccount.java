package generic_paradigm.bank;

import synch.Bank;

import java.text.DecimalFormat;
import java.util.jar.JarEntry;

public class BankAccount {
    private static int LAST_ACCOUNT_NUMBER = 0;
    private String ownerName;
    private int accountNumber;
    private float balance;

    public BankAccount() {
        this("", 0);
    }
    public BankAccount(String initName){
        this(initName,0);
    }

    public BankAccount(String initName, float initBal) {
        ownerName = initName;
        accountNumber = ++LAST_ACCOUNT_NUMBER;
        balance = initBal;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public int getAccountNumber() {
        return accountNumber;
    }

    public float getBalance() {
        return balance;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

   /* public void setAccountNumber(int accountNumber) {
        this.accountNumber = accountNumber;
    }*/

/*    public void setBalance(float balance) {
        this.balance = balance;
    }*/

    public static BankAccount example1(){
        BankAccount ba = new BankAccount();
        ba.setOwnerName("LiHong");
        ba.deposit(1000);
        return ba;
    }

    public static BankAccount example2(){
        BankAccount ba = new BankAccount();
        ba.setOwnerName("Zhaowei");
        ba.deposit(1000);
        ba.deposit(2000);
        return ba;
    }

    public static BankAccount emptyAccountExample(){
        BankAccount ba = new BankAccount();
        ba.setOwnerName("HeLi");
        return ba;
    }

    public String toString() {
        return ("Account#" + new java.text.DecimalFormat("000000").format(accountNumber) +
                " with balance" + new java.text.DecimalFormat("$0.00").format(balance));

    }

    //存款
    public float deposit(float anAmount) {
        balance += anAmount;
        return balance;
    }

    //取款
    public float withdraw(float anAmount) {
        if (anAmount <= balance)
            balance -= anAmount;
        return balance;
    }

}
