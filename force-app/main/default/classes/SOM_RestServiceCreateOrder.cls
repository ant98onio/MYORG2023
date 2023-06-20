/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-20-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@RestResource(urlMapping='/som/order/create')
global with sharing class SOM_RestServiceCreateOrder {
    @HttpPost
    global static Response doPost(){
           
        RestRequest restRequest = RestContext.request;
        Response response = new Response();
        response.success = true;
        response.errorMessage = '';

        String OrderNumber;
        List<ProcessException> processExceptions = new List<ProcessException>();

        try{
        
            String requestBody = restRequest.requestBody.toString();
            Request request = (Request) JSON.deserialize(requestBody, Request.class);

            System.debug('### request: ' + JSON.serializePretty(request));

            Account[] accToLink = SOM_Selector.selectAccountByName(request.accountName);

            system.debug(accToLink);

            if (accToLink.size() == 0){
                response.success = false;
                response.errorMessage ='error --> non esiste nessun account per piazzare l\'ordine';
                return response;
            }
            else{
                String accToLinkId = accToLink[0].Id;

                Contract[] contrToLink = SOM_Selector.selectContractByAccount(accToLinkId);
    
                Order o = new Order(
    
                    EffectiveDate = request.EffectiveDate,
                    Status = request.status);
    
                if (contrToLink.size() == 0){
                    Contract c = new Contract(
                        Status = Request.contractStatus,
                        ContractTerm = Request.contractTerm,
                        StartDate = request.contractStardDate
                    );
                    insert c;

                    o.ContractId = c.Id;
                }
                else{
                    o.ContractId = contrToLink[0].Id;
                }
                //selectContractByNumber(request.contractNumber);
    
                o.AccountId = accToLink[0].Id;
                o.Pricebook2Id = '01s7R000002wXkdQAE';
                insert o;

                List<OrderItem> toadd = new List<OrderItem>();

                OrderDeliveryGroup odg = new OrderDeliveryGroup();
                String odmId = SOM_Selector.getODMByName(Request.deliveryMethodName);
                odg.OrderDeliveryMethodId = odmId;
                odg.orderId = o.Id;
                odg.DeliverToName = Request.accountName;
                insert odg; 
                //odg.orderId = o.Id;
                String odgId = SOM_Selector.getODGByOrderId(o.Id);

                for(Product p : Request.products){
                    Product2 p2 = SOM_Selector.getProductByCode(p.productCode);
                    System.debug('Product2 --> '  + p2);
                    OrderItem item = new OrderItem();
                    item.Product2Id = p2.Id;
                    item.UnitPrice = 4.0;
                    item.quantity = p.quantity;
                    item.PricebookEntryId = '01u7R00001IKXG9QAP';
                    item.orderId = o.Id;
                    item.orderDeliveryGroupId = odgId;
                    item.TotalLineAmount = 100.0; //da cambiare
                    toadd.add(item);
                }
                //System.debug('toadd --> ' + toadd);
                insert toadd;

                update o;
                OrderNumber = SOM_Selector.getOrderById(o.Id);
                  
            }


        }catch(Exception e){

            System.debug('An unexpected error has occurred: ' + e.getMessage());
            //create PE
            response.success = false;
            response.errorMessage ='error --> '  + e.getMessage();

        }finally{
        }

        response.orderNumber = OrderNumber; 
        return response;
    }


    public class Request {
    
        public String name;
        public String accountName;
        public String contractNumber;
        public String status;
        public Date effectiveDate;
        public Boolean check;
        public String contractStatus;
        public Integer contractTerm;
        public Date contractStardDate;
        public String deliveryMethodName;
        public List<Product> products;

    }

    global class Response {
        public Boolean success;
        public String errorMessage;
        public String orderNumber;
    }

    global class Product{
        public String productCode;
        public Decimal quantity;
    }
}