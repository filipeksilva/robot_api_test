*** Settings ***
#Libraries
Library     RequestsLibrary
Library     JSONLibrary
Library     FakerLibrary
Library     Collections


#HTTP Objects
Resource    resources/services/order/get_order.resource
Resource    resources/services/order/post_order.resource


#Sessions
Resource    resources/session/order_session.resource

#Enviroment Variables
Variables    resources/test_data/test_data.yaml