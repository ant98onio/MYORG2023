/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-20-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class SOM_Selector {

    public static Account[] selectAccountByName(String name){
        return [SELECT Id FROM Account WHERE Name = :name]; 
    }

    public static Contract[] selectContractByNumber(String num){
        return [SELECT Id FROM Contract WHERE ContractNumber = :num]; 
    }

    public static Contract[] selectContractByAccount(String accId){
        return [SELECT Id FROM Contract WHERE Account.Id = :accId]; 
    }

    public static Product2 getProductByCode(String porductCode){
        return [SELECT Id FROM Product2 WHERE ProductCode = :porductCode];
    }

    public static Order getOrderByNumber(String orderNumber){
        return [SELECT Id FROM Order WHERE OrderNumber = :orderNumber];
    }

    public static String getOrderById(String Id){
        Order o = [SELECT OrderNumber FROM Order WHERE Id = :Id];
        return o.OrderNumber;
    }

    public static String getODGByOrderId(String Id){
        OrderDeliveryGroup odg = [SELECT Id FROM OrderDeliveryGroup WHERE Order.Id = :Id];
        return odg.Id;
    }

    public static String getODMByName(String name){
        OrderDeliveryMethod odm = [SELECT Id FROM OrderDeliveryMethod WHERE Name = :name ];
        return odm.Id;
    }


}