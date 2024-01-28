public class AccountTriggerHandler extends TriggerHandler {
    
    // This is better to be a custom setting if we want to change it in the future
    // but for the sake of simplicity we will leave it as a constant
    private static final String DEFAULT_FIRST_NAME = 'Candidate name';
    private static final String DEFAULT_LAST_NAME = 'Candidate lastname';
    private static final String DEFAULT_EMAIL_DOMAIN = 'candidate_name@adaptus.com';

    // modify the account name before it is inserted
    protected override void beforeInsert() {
        for (Account acc : (List<Account>)Trigger.new) {
            acc.Name = modifyAccountName(acc.Name);
        }
    }

    // create a new account when the account is created
    protected override void afterInsert() {
        processAccounts((List<Account>)Trigger.new);
    }

    // create a new account when the account is updated
    protected override void afterUpdate() {
        processAccounts((List<Account>)Trigger.new);
    }

    // create a new task when the account is deleted
    protected override void afterDelete() {
        List<Task> tasks = new List<Task>();
        for (Account acc : (List<Account>)Trigger.old) {
            tasks.add(createTaskForDeletedAccount(acc));
        }
        insert tasks;
    }

    // modify the account name before it is updated used for beforeUpdate
    private String modifyAccountName(String originalName) {
        String newName = originalName + ' - Adaptus';
        return newName.length() <= 80 ? newName : newName.substring(0, 80);
    }

    /*  the next four methods (createNewContact, processAccounts, createContactsForAccounts, insertContacts)
    *   are used for afterInsert and afterUpdate
    *   and they are separated from the main method to make the code more readable
    *   and to use clean code principles 
    */
    private Contact createNewContact(Account acc) {
        return new Contact(
            FirstName = DEFAULT_FIRST_NAME,
            LastName = DEFAULT_LAST_NAME,
            AccountId = acc.Id,
            Email = DEFAULT_EMAIL_DOMAIN
        );
    }

    private void processAccounts(List<Account> accounts) {
        List<Contact> contacts = createContactsForAccounts(accounts);
        insertContacts(contacts);
    }

    private List<Contact> createContactsForAccounts(List<Account> accounts) {
        List<Contact> contacts = new List<Contact>();
        for (Account acc : accounts) {
            contacts.add(createNewContact(acc));
        }
        return contacts;
    }

    private void insertContacts(List<Contact> contacts) {
        insert contacts; 
    }    

    // create a new task when the account is deleted
    private Task createTaskForDeletedAccount(Account acc) {
        return new Task(
            Subject = 'Deleted account ' + acc.Name,
            ActivityDate = Date.today()
        );
    }
}