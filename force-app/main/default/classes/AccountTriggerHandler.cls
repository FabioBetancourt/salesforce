public class AccountTriggerHandler extends TriggerHandler {
    
    protected override void beforeInsert() {
        for (Account acc : (List<Account>)Trigger.new) {
            acc.Name = modifyAccountName(acc.Name);
        }
    }

    protected override void afterInsert() {
        List<Contact> contacts = new List<Contact>();
        for (Account acc : (List<Account>)Trigger.new) {
            contacts.add(createNewContact(acc));
        }
        insert contacts;
    }

    protected override void afterUpdate() {
        List<Contact> contacts = new List<Contact>();
        for (Account acc : (List<Account>)Trigger.new) {
            contacts.add(createNewContact(acc));
        }
        insert contacts;
    }
    

    private String modifyAccountName(String originalName) {
        String newName = originalName + ' - Adaptus';
        return newName.length() <= 80 ? newName : newName.substring(0, 80);
    }

    private Contact createNewContact(Account acc) {
        return new Contact(
            FirstName = 'Candidate name',
            LastName = 'Candidate lastname',
            AccountId = acc.Id,
            Email = 'candidate_name@adaptus.com'
        );
    }
}