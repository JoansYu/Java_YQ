package generic_paradigm.bank;

public class AccountTester {
    public static void main(String args[]){
        BankAccount bobsAccount,marysAccount,biffsAccount;
        bobsAccount = BankAccount.example1();
        marysAccount = BankAccount.example1();
        biffsAccount = BankAccount.example2();
        marysAccount.setOwnerName("Mary");
        marysAccount.deposit(250);
        System.out.println(bobsAccount);
        System.out.println(marysAccount);
        System.out.println(biffsAccount);
    }
}
