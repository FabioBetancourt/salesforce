public class AccountTriggerHandler extends TriggerHandler {
    
    // This is better to be a custom setting if we want to change it in the future
    // but for the sake of simplicity we will leave it as a constant
    private static final String DEFAULT_FIRST_NAME = 'Candidate name';
    private static final String DEFAULT_LAST_NAME = 'Candidate lastname';
    private static final String DEFAULT_EMAIL_DOMAIN = 'candidate_name@adaptus.com';

    protected override void beforeInsert() {
        for (Account acc : (List<Account>)Trigger.new) {
            acc.Name = modifyAccountName(acc.Name);
        }
    }

    protected override void afterInsert() {
        processAccounts((List<Account>)Trigger.new);
    }

    protected override void afterUpdate() {
        processAccounts((List<Account>)Trigger.new);
    }

    protected override void afterDelete() {
        List<Task> tasks = new List<Task>();
        for (Account acc : (List<Account>)Trigger.old) {
            tasks.add(createTaskForDeletedAccount(acc));
        }
        insert tasks;
    }
    
    private String modifyAccountName(String originalName) {
        String newName = originalName + ' - Adaptus';
        return newName.length() <= 80 ? newName : newName.substring(0, 80);
    }

    private Contact createNewContact(Account acc) {
        return new Contact(
            FirstName = DEFAULT_FIRST_NAME,
            LastName = DEFAULT_LAST_NAME,
            AccountId = acc.Id,
            Email = DEFAULT_EMAIL_DOMAIN
        );
    }

    private void processAccounts(List<Account> accounts) {
        List<Contact> contacts = new List<Contact>();
        for (Account acc : accounts) {
            contacts.add(createNewContact(acc));
        }
        insert contacts;
    }

    private Task createTaskForDeletedAccount(Account acc) {
        return new Task(
            Subject = 'Deleted account ' + acc.Name,
            ActivityDate = Date.today()
        );
    }
}