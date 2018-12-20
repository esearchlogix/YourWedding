//
//  ServerConstants.swift
//  VistarApp
//
//  Created by thinksysuser on 19/01/17.
//  Copyright © 2017 thinksysuser. All rights reserved.
//

import Foundation

var baseUrl:String {
    

    return String(format:"https://5db043a132bc463ff146cd4dafe4c686:4d46228d1e98c7bd1df570363a0427f5@yourweddinglinen.myshopify.com/admin/")
    


}
//var loginUrl:String{
//return String(format: baseUrl+"proxy/auth/logon.do")
//}
//var testUrl:String{
//    return String(format:baseUrl+"proxy/test/hello.do")
//}
//var loginOff:String{
//    return String(format: baseUrl+"proxy/auth/logoff.do")
//}
var fetchOrderUrl:String{
    return String(format: baseUrl+"customers/5381823821/orders.json")
}
var fetchCountryDetail:String{
    return String(format: baseUrl+"countries.json")
}
var fetchCustomerDetail:String{
    return String(format: baseUrl+"customers/")
}
var fetchProductImages:String{
    return String(format: baseUrl+"customers/")
}
var fetchShopDetail:String{
    return String(format: baseUrl+"shop.json")
}
var featuredProductUrl:String{
    return String(format: baseUrl+"products.json?collection_id=60122857537")
}
var addressUrl :String{
    return String(format: "/addresses.json")
}
var ProductsCountUrl:String{
    return String(format: baseUrl+"products/count.json?collection_id=")
}
var refundOrderUrl:String{
    return String(format: baseUrl+"orders/")  
}
var ProductsUrl:String{
    return String(format: baseUrl+"products.json?collection_id=")
}
var ProductsSearchUrl:String{
    return String(format: baseUrl+"products.json?title=")
}
var allproductUrl:String{
    return String(format: baseUrl+"products.json?limit=250&page=")
}
var allproductCountUrl:String{
    return String(format: baseUrl+"products/count.json")
}
var loginUrl:String{
    return String(format: baseUrl+"auth/logon.do")
}
var testUrl:String{
    return String(format:baseUrl+"test/hello.do")
}
var loginOff:String{
    return String(format: baseUrl+"auth/logoff.do")
}
var customerListURL:String{
    return String(format: baseUrl + "customers.do")
}
var orderSearchURL:String{
    return String(format: baseUrl + "order/search.do")
}
var orderDetailURL:String{
    return String(format: baseUrl + "order/detail.do")
}
var manufacturesListURL:String{
    return String(format: baseUrl + "manufacturers.do")
}

var partSearchURL:String{
    return String(format: baseUrl + "part/search.do")
}
var partDetailURL:String{
    return String(format: baseUrl + "part/detail.do")
}
var personSearchURL:String{
    return String(format:baseUrl + "person/search.do")
}
var personDetailURL:String{
    return String(format:baseUrl + "person/detail.do")
}
var locationSearchURL:String{
    return String(format:baseUrl + "location/search.do")
}
var locationDetailURL:String{
    return String(format:baseUrl + "location/detail.do")
}
var repsListURL:String{
    return String(format:baseUrl + "reps.do")
}
var priceApprovalSummarURL:String{
    return String(format:baseUrl + "approval/summary.do")
}
var priceApprovalDetailURL:String{
    return String(format:baseUrl + "approval/detail.do")
}
var priceApprovalUpdateURL:String{
    return String(format:baseUrl + "approval/update.do")
}
var quoteSearchUrl:String{
    return String(format:baseUrl + "quote/search.do")
}
var quoteDetailUrl:String{
    return String(format:baseUrl + "quote/detail.do")
}

var getNotification:String{
    return String(format:baseUrl + "notification/list.do")
}

var notificationReadStatus:String{
    return String(format:baseUrl + "notification/read.do")
}

var notificationUnreadCount:String{
    return String(format:baseUrl + "notification/info.do")
}

var configCustomerURL:String{
    return String(format:baseUrl + "config/customer.do")


}
var appliedHeaders:[String:String]{
    
  return  ["Content-Type":"application/json"]
    
}
