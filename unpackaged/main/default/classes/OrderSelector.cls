/**
* @Version: 1.0
* @Author: Remz Grges
* -----------------------------------------------------------------------------------------------
* Description: Selector class where all query operations for orders should be stored in methods.
* Created: 27/08/2021
** -----------------------------------------------------------------------------------------------
*/
public with sharing class OrderSelector implements IOrderSelector{
    /**
     * @param orderIds: Id of the orders to query
     *
     * @return queried orders mapped by there ID
     */
    public Map<Id, Order> getOrdersByIds(Set<Id> orderIds) {
        Map<Id, Order> mapOrderById = new Map<Id, Order>([SELECT Id,
                OrderNumber,
                EffectiveDate,
                EndDate,
                Status,
                Type_de_location__c,
                PF_Location_Number_of_Days__c
        FROM Order WHERE Id IN: orderIds]);
        return mapOrderById;
    }
}