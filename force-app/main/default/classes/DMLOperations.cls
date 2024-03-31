/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Sean Williams
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account acc = new Account();
        // Set some fields on the Account
        acc.Name = 'Super Store Machine';
        acc.Website = 'http://www.superstoremachine.com';
        acc.Phone = '(248) 555-1212';
        // Insert the Account into the database
        insert acc;
        // Return the Id of the newly created Account
        return acc.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account acc2 = new Account(Name = name, Industry = industry);
        // Insert the Account
        insert acc2;
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact newContact = new Contact(FirstName = 'Cal', LastName = 'Kestis', AccountId = accountID );
        // Set some fields on the Contact
        // Set the AccountId field to the given accountId

        // Insert the Contact into the database
insert newContact;
        // Return the Id of the newly created Contact
        return newContact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        // [SELECT Id FROM Contact WHERE Id = :contactId]
         Contact contact1 = [SELECT Id FROM Contact WHERE Id = :contactId];
        // Update the Contact's last name
        contact1.lastName = newLastName;
        // Update the Contact in the database
        update contact1;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        // [SELECT Id FROM Opportunity WHERE Id = :oppId]
        Opportunity getOpportunity = [SELECT Id FROM Opportunity WHERE Id = :oppId];
        // Update the Opportunity's stage
        getOpportunity.StageName = newStage;
        // Update the Opportunity in the database
        update getOpportunity;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        // [SELECT Id FROM Account WHERE Id = :accountId]
        Account thisAccount = [SELECT ID FROM Account WHERE Id = :accountId];
        // Update the Account with the given Id with the new name and industry
        thisAccount.Name = newName;
        thisAccount.Industry = newIndustry;
        update thisAccount;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Iterate over the opportunities
        for (Opportunity opportunity : opportunities) {
            opportunity.StageName = 'Qualification';
            opportunity.CloseDate = Date.today().addMonths(3);
            opportunity.Amount = 50000;
        }
        upsert opportunities;
    }

    /**
     * Question 8
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
    Account newAccounts = new Account(Name = accountName);
    insert newAccounts;
    List<Opportunity> oppList = new List<Opportunity>();
       for (String oppName : oppNames) {
        Opportunity newOpportunity = new Opportunity(Name = oppName, StageName = 'Qualification', CloseDate = Date.today().addMonths(3), Type = 'New Customer', Amount = 50000, AccountId = newAccounts.Id);
            oppList.add(newOpportunity);
        // Loop through each Opportunity name
            // Create an Opportunity with the given name
            // Add the Opportunity to the list
            
    }
    upsert oppList;
    }
    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];
        List<Account> accList = new List<Account>();
        if(accounts.isEmpty()){
            Account newAccount = new Account(Name = accountName, Description = 'New Account');
            accList.add(newAccount);
        }
        else{
            Account existingAcc = accounts.get(0);
            existingAcc.Description = 'Updated Account';
            accList.add(existingAcc);
        }
        upsert accList;
        return accList.get(0);
    }
        // if the Account does not exist, create it
		// if the Account exists, update the description
        
		// otherwise, create a new Account and set the description

		// Upsert the Account

	

    /**
     * Question 10
	 * Upserts accounts and links contacts to them based on the contact's last name and account name.
	 * Create or use existing account with contact last name. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
	 * Contacts are then linked to these accounts based on a full last name match.
     * Example Contact Last Name = Doe Link to Account Name = Doe 
     * Example Contact Last Name = Jane Link to Account Name = Jane
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
		// Loop through each Contact
        List<Contact> contactList = new List<Contact>();
        for(Contact contacts : contactsToUpsert){
            List<Account> accounts = [SELECT Id FROM Account WHERE Name = :contacts.LastName];
            if(accounts.isEmpty()){
                Account newAccount = new Account(Name = contacts.LastName);
                insert newAccount;
                contacts.AccountId=newAccount.Id;
                contactList.add(contacts);
                }
            else{
                Account existingAcc = accounts.get(0);
                contacts.AccountId=existingAcc.Id;
                contactList.add(contacts);
            }
                
            }
            upsert contactList;
    }

		// Extract the Account Name from Contact's LastName

		// Get the account based on the name or create one if it doesn't exist

		// Link the Contact to its Account using the Account Id

		// Upsert the Contacts


    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        // Loop through each Lead name
        List<Lead> leadList = new List<Lead>();
        for(String leadName : leadNames) {
            Lead newLead = new Lead(Company = 'International Business Machine', LastName = leadName);
            leadList.add(newLead);
        }
        // Insert the Leads
        insert leadList;
        // Delete the Leads
        delete [SELECT Id FROM Lead WHERE ID IN: leadList];
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
       List<Case> cases = new List<Case>();
       for(Integer i =0; i < numOfCases; i++){
        Case newCase = new Case(Status = 'New', Origin = 'Phone', AccountId = accountId);
        cases.add(newCase);
       }
        // Insert the cases
       insert cases;
        // Delete the cases
        delete [SELECT Id FROM Case WHERE ID IN: cases];
    }
}
