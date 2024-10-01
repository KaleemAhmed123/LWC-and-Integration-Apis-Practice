@isTest
public class InsertRelatedProductTest {
    
    @testSetup
    static void setupTestData() {

		Pricebook2 standardPricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];

        Pricebook2 customPricebook = new Pricebook2(
            Name = 'For Custom Product',
            IsActive = true
        );
        insert customPricebook;

        // Create test opportunities
        List<Opportunity> oppList = new List<Opportunity>();
        for (Integer i = 1; i <= 3; i++) {
            Opportunity opp = new Opportunity(
                Name = 'Test Opportunity ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30)
            );
            oppList.add(opp);
        }
        insert oppList;
    }
    
    @isTest
    static void testInsertRelatedProduct() {

        List<Opportunity> oppList = [SELECT Id, Name FROM Opportunity];
        
        Test.startTest();
        OpportunityTriggerHandler.insertRelatedProduct(oppList); 
        Test.stopTest();
        
        List<Product2> prodList = [SELECT Id, Name FROM Product2];
        System.assertEquals(3, prodList.size(), '3 Products should have been created');
        
        List<PricebookEntry> pbeList = [SELECT Id, Product2Id, Pricebook2Id FROM PricebookEntry];
        System.assertEquals(6, pbeList.size(), '6 PricebookEntries should have been created (3 standard, 3 custom)');
        
        List<OpportunityLineItem> oliList = [SELECT Id, OpportunityId, PricebookEntryId FROM OpportunityLineItem];
        System.assertEquals(3, oliList.size(), '3 OpportunityLineItems should have been created');
        
        for (OpportunityLineItem oli : oliList) {
            System.assert(oppList.contains(new Opportunity(Id = oli.OpportunityId)), 'OpportunityLineItem should relate to the correct Opportunity');
        }
        
        List<Opportunity> updatedOppList = [SELECT Id, Pricebook2Id FROM Opportunity WHERE Pricebook2Id != null];
        System.assertEquals(3, updatedOppList.size(), '3 Opportunities should have been updated with the custom pricebook');
        
    }
}