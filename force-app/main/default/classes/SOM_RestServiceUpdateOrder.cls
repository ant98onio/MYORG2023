/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-20-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@RestResource(urlMapping='/som/order/update')
global with sharing class SOM_RestServiceUpdateOrder {
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
        
            Order o = SOM_Selector.getOrderByNumber(Request.orderNumber);
            o.Status = Request.status;
            update o;


        }catch(Exception e){

            System.debug('An unexpected error has occurred: ' + e.getMessage());
            //create PE
            response.success = false;
            response.errorMessage ='error --> '  + e.getMessage();

        }finally{
        }

        return response;
    }


    public class Request {
    
        public String orderNumber;
        public String status;
    }

    global class Response {
        public Boolean success;
        public String errorMessage;
        //public String orderNumber;
    }

}