/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-19-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class SOM_SelectorAccount {

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

}