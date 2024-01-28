public class AccountTriggerHandler extends TriggerHandler {
    
    // This method is public because it is called by the AccountTrigger
    protected override void beforeInsert() {
        for (Account acc : (List<Account>)Trigger.new) {
            acc.Name = modifyAccountName(acc.Name);
        }
    }
    
    // This method is private because it is only used by the beforeInsert method
    private String modifyAccountName(String originalName) {
        String newName = originalName + ' - Adaptus';
        return newName.length() <= 80 ? newName : newName.substring(0, 80);
    }
}