/**
* @Version: 1.0
* @Author: Remz Grges
* @Uses: 
* -----------------------------------------------------------------------------------------------
* Description: 
* Created: 27/08/2021
** -----------------------------------------------------------------------------------------------
*/
public interface IOrderSelector {
    Map<Id, Order> getOrdersByIds(Set<Id> orderIds);
}