package unsynch;

import java.util.Arrays;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * A bank with a number of bank accounts
 */
public class Bank {
    private Lock bankLock = new ReentrantLock();
    private final double[] accounts ;

    /**
     * Constructs the bank
     * @param n
     * @param initialBalance
     */
    public Bank(int n, double initialBalance){

        accounts = new double[n];
        Arrays.fill(accounts,initialBalance);
    }

    /**
     * Transfers money from one account to another
     * @param from
     * @param to
     * @param amount
     */
    public void transfer(int from,int to ,double amount){
        bankLock.lock();
        try {
            if (accounts[from] < amount) return;
            System.out.print(Thread.currentThread());
            accounts[from] -= amount;
            System.out.printf(" %10.2f from %d to %d", amount, from, to);
            accounts[to] += amount;
            System.out.printf(" Total Balance : %10.2f%n", getTotalBalance());
        }finally {
            bankLock.unlock();
        }
    }

    /**
     * Gets the sum of all account balances
     * @return the total balance
     */
    public double getTotalBalance(){
        double sum = 0;
        for (double a :accounts)
            sum +=a;
        return sum;
    }

    /**
     * Gets the number of accounts in the bank
     * @return
     */
    public int size(){
        return accounts.length;
    }

}
