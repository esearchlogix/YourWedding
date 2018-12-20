//
//  Client.swift
//  Storefront
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import Buy
import Pay
import CoreData
import  MBProgressHUD

final class Client {
    
//    static let shopDomain = "graphql.myshopify.com"
//    static let apiKey     = "8e2fef6daed4b93cf4e731f580799dd1"
//    static let merchantID = "merchant.com.your.id"
    
    static let shopDomain = "yourweddinglinen.myshopify.com"
    static let apiKey     = "3edc0006abe5537441dc7821f1975964"
    static let merchantID = "merchant.com.yourwedding"
//
    static let shared = Client()
    
    private let client: Graph.Client = Graph.Client(shopDomain: Client.shopDomain, apiKey: Client.apiKey)
    
    // ----------------------------------
    //  MARK: - Init -
    //
    private init() {
        self.client.cachePolicy = .cacheFirst(expireIn: 3600)
    }
    
    // ----------------------------------
    //  MARK: - Shop -
    //
    @discardableResult
    func fetchShopName(completion: @escaping (String?) -> Void) -> Task {
        
        let query = ClientQuery.queryForShopName()
        let task  = self.client.queryGraphWith(query) { (query, error) in
            error.debugPrint()
            
            if let query = query {
                completion(query.shop.name)
            } else {
                print("Failed to fetch shop name: \(String(describing: error))")
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    // ----------------------------------
    //  MARK: - Collections -
    //
    @discardableResult
    func fetchCollections(limit: Int = 250, after cursor: String? = nil, productLimit: Int = 250, productCursor: String? = nil, completion: @escaping (PageableArray<CollectionViewModel>?) -> Void) -> Task {
        
        let query = ClientQuery.queryForCollections(limit: limit, after: cursor, productLimit: productLimit, productCursor: productCursor)
        let task  = self.client.queryGraphWith(query) { (query, error) in
            error.debugPrint()
            
            if let query = query {
                let collections = PageableArray(
                    with:     query.shop.collections.edges,
                    pageInfo: query.shop.collections.pageInfo
                )
                completion(collections)
            } else {
                print("Failed to load collections: \(String(describing: error))")
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    // ----------------------------------
    //  MARK: - Products -
    //
    @discardableResult
    func fetchProducts(in collection: CollectionViewModel, limit: Int = 250, after cursor: String? = nil, completion: @escaping (PageableArray<ProductViewModel>?) -> Void) -> Task {
        
        let query = ClientQuery.queryForProducts(in: collection, limit: limit, after: cursor)
        let task  = self.client.queryGraphWith(query) { (query, error) in
            error.debugPrint()
            
            if let query = query,
                let collection = query.node as? Storefront.Collection {
                
                let products = PageableArray(
                    with:     collection.products.edges,
                    pageInfo: collection.products.pageInfo
                )
                completion(products)
                
            } else {
                print("Failed to load products in collection (\(collection.model.node.id.rawValue)): \(String(describing: error))")
                completion(nil)
            }
        }
        
        task.resume()
        return task
    }
    
    // ----------------------------------
    //  MARK: - Discounts -
    //
    @discardableResult
    func applyDiscount(_ discountCode: String, to checkoutID: String, activeViewController :UIViewController , completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
     
        let mutation = ClientQuery.mutationForApplyingDiscount(discountCode, to: checkoutID)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
              if Utility.isInternetAvailable(){
            completion(response?.checkoutDiscountCodeApply?.checkout.viewModel)
              }else{
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: activeViewController.view, animated: true)
                }
               ModalViewController.showAlert(alertTitle: kAppName, andMessage: kMessageNoInternetError, withController:activeViewController )
            }
        }
        
        task.resume()
       
        return task
       
    }
    
    
    @discardableResult
    func createCustomer(with firstName: String, lastName : String,activeViewController :UIViewController , userMail : String , passWord: String, completion: @escaping (Storefront.CustomerCreatePayload?) -> Void) -> Task {
        let input = Storefront.CustomerCreateInput.create(
            email:            userMail,
            password:         passWord,
            firstName:        .value(firstName),
            lastName:         .value(lastName),
            acceptsMarketing: .value(true)
        )
        
        let mutation = Storefront.buildMutation { $0
            .customerCreate(input: input) { $0
                .customer { $0
                    .id()
                    .email()
                    .firstName()
                    .lastName()
                }
                .userErrors { $0
                    .field()
                    .message()
                }
            }
        }
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            print(response)
            if Utility.isInternetAvailable(){
            completion(response?.customerCreate)
        }else{
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: activeViewController.view, animated: true)
                }
            ModalViewController.showAlert(alertTitle: kAppName, andMessage: kMessageNoInternetError, withController:activeViewController )
        }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func getCustomerDetail(activeViewController :UIViewController ,  completion: @escaping (Storefront.Customer?) -> Void) -> Task {
  
       let query = Storefront.buildQuery { $0
        .customer(customerAccessToken: UserDefaults.standard.string(forKey: keyToken)!) { $0
                .id()
                .firstName()
                .lastName()
                .email()
            }
        }
        let task  = self.client.queryGraphWith(query) { (query, error) in
            error.debugPrint()
            
            if let query = query {
                let detail = query.customer
                print(detail)
                if Utility.isInternetAvailable(){
                completion(detail)
            }else{
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: activeViewController.view, animated: true)
                    }
                ModalViewController.showAlert(alertTitle: kAppName, andMessage: kMessageNoInternetError, withController:activeViewController )
            }
            } else {
                print("Failed to load collections: \(String(describing: error))")
            
            }
        }
        
        task.resume()
        return task
    }
 //   @discardableResult
//    func getShipmentAddress( ,completion: @escaping (Storefront.Customer?) -> Void) -> Task {
//
//        let query = Storefront.buildQuery { $0
//            .node(id: checkoutID) { $0
//                .onCheckout { $0
//                    .id()
//                    .availableShippingRates { $0
//                        .ready()
//                        .shippingRates { $0
//                            .handle()
//                            .price()
//                            .title()
//                        }
//                    }
//                }
//            }
//        }
//        let task  = self.client.queryGraphWith(query) { (query, error) in
//            error.debugPrint()
//
//            if let query = query {
//                let detail = query.customer
//                print(detail)
//                completion(detail)
//            } else {
//                print("Failed to load collections: \(String(describing: error))")
//
//            }
//        }
//
//        task.resume()
//        return task
//    }
    
    //  MARK: - update shipping address
   // @discardableResult
//    func updateShippingAddress( id : GraphQL.ID? ,completion: @escaping (Storefront.Customer?) -> Void) -> Task {
//        let shippingAddress: Storefront.MailingAddressInput
//        let mutation = Storefront.buildMutation { $0
//            .checkoutShippingAddressUpdate(shippingAddress: shippingAddress, checkoutId: id!){
//                .checkout { $0
//                    .id()
//                    }
//                    .userErrors { $0
//                        .field()
//                        .message()
//                }
//            }
//        }
//        let task     = self.client.mutateGraphWith(mutation) { response, error in
//            error.debugPrint()
//            completion((response?.customerAccessTokenCreate)!)
//        }
//
//        task.resume()
//        return task
//    }
    //  MARK: - Forget Password
    
    @discardableResult
    func forgetPassWord(with userName: String ,activeViewController :UIViewController , completion: @escaping (Storefront.CustomerRecoverPayload) -> Void) -> Task {
      
        
        let mutation = Storefront.buildMutation { $0
            .customerRecover(email:userName ) { $0
                .userErrors { $0
                    .field()
                    .message()
                }
            }
        }
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
           if Utility.isInternetAvailable(){
            completion((response?.customerRecover)!)
        }else{
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: activeViewController.view, animated: true)
            }
            ModalViewController.showAlert(alertTitle: kAppName, andMessage: kMessageNoInternetError, withController:activeViewController )
        }
        }
        
        task.resume()
        return task
    }
 
   //  MARK: - logIN -
    @discardableResult
    func createLogin(with userName: String ,activeViewController :UIViewController , passWord: String, completion: @escaping (Storefront.CustomerAccessTokenCreatePayload) -> Void) -> Task {
        let input = Storefront.CustomerAccessTokenCreateInput.create(
            email:    userName,
            password: passWord
        )
        
        let mutation = Storefront.buildMutation { $0
            .customerAccessTokenCreate(input: input) { $0
                .customerAccessToken { $0
                    .accessToken()
                    .expiresAt()
                }
                .userErrors { $0
                    .field()
                    .message()
                }
            }
        }
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            if Utility.isInternetAvailable(){
            completion((response?.customerAccessTokenCreate)!)
        }else{
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: activeViewController.view, animated: true)
                }
            ModalViewController.showAlert(alertTitle: kAppName, andMessage: kMessageNoInternetError, withController:activeViewController )
        }
        }
        
        task.resume()
        return task
    }
    
    //  MARK: - checkOut -
    @discardableResult
    func createCheckOutCart(with cartArry: [Any] ,activeViewController :UIViewController , completion: @escaping (Storefront.CheckoutCreatePayload) -> Void) -> Task {
        let lineItems = cartArry.map { item in
            Storefront.CheckoutLineItemInput.create(quantity: Int32(((item as? NSManagedObject)!.value(forKey: "quantity")) as? Int ?? 0), variantId: GraphQL.ID(rawValue: ((item as? NSManagedObject)!.value(forKey: "id") as? String)! ))
        }
        let checkoutInput = Storefront.CheckoutCreateInput.create(
            lineItems: .value(lineItems),
             allowPartialAddresses: .value(true)
        )
        
        
        let mutation = Storefront.buildMutation { $0
            .checkoutCreate(input: checkoutInput) { $0
                .checkout { $0
                    .fragmentForCheckout()
                } .userErrors { $0
                    .field()
                    .message()
                }
            }
        }
        
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            if Utility.isInternetAvailable(){
            completion((response?.checkoutCreate)!)
        }else{
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: activeViewController.view, animated: true)
                }
            ModalViewController.showAlert(alertTitle: kAppName, andMessage: kMessageNoInternetError, withController:activeViewController )
        }
        }
        
        task.resume()
        return task
    }
    
    // ----------------------------------
    //  MARK: - Checkout -
    //
    @discardableResult
    func createCheckout(with Quantity : Int, ID : String ,activeViewController :UIViewController , completion: @escaping (Storefront.CheckoutCreatePayload) -> Void) -> Task {
   
        let checkoutInput = Storefront.CheckoutCreateInput.create(
            lineItems: .value([
                Storefront.CheckoutLineItemInput.create(quantity: Int32( Quantity ??  0), variantId: GraphQL.ID(rawValue: ID )),
                ]),
            
            allowPartialAddresses: .value(true)
        )
        
        
        let mutation = Storefront.buildMutation { $0
            .checkoutCreate(input: checkoutInput) { $0
                .checkout { $0
                    .fragmentForCheckout()
                } .userErrors { $0
                    .field()
                    .message()
                }
            }
        }
        
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            if Utility.isInternetAvailable(){
            completion((response?.checkoutCreate)!)
        }else{
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: activeViewController.view, animated: true)
                }
            ModalViewController.showAlert(alertTitle: kAppName, andMessage: kMessageNoInternetError, withController:activeViewController )
        }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func updateCheckout(_ id: String, updatingPartialShippingAddress address: PayPostalAddress,activeViewController :UIViewController , completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForUpdateCheckout(id, updatingPartialShippingAddress: address)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            
            if let checkout = response?.checkoutShippingAddressUpdate?.checkout,
                let _ = checkout.shippingAddress {
                if Utility.isInternetAvailable(){
                completion(checkout.viewModel)
            }else{
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: activeViewController.view, animated: true)
                    }
                ModalViewController.showAlert(alertTitle: kAppName, andMessage: kMessageNoInternetError, withController:activeViewController )
            }
            } else {
                if Utility.isInternetAvailable(){
                completion(nil)
            }else{
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: activeViewController.view, animated: true)
                    }
                ModalViewController.showAlert(alertTitle: kAppName, andMessage: kMessageNoInternetError, withController:activeViewController )
            }
            }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func updateCheckout(_ id: String, updatingCompleteShippingAddress address: NSDictionary, activeViewController :UIViewController, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForUpdateCheckout(id, updatingCompleteShippingAddress: address)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            if Utility.isInternetAvailable(){
            if let checkout = response?.checkoutShippingAddressUpdate?.checkout,
                let _ = checkout.shippingAddress {
                completion(checkout.viewModel)
            } else {
                completion(nil)
            }
        }else{
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: activeViewController.view, animated: true)
                }
            ModalViewController.showAlert(alertTitle: kAppName, andMessage: kMessageNoInternetError, withController:activeViewController )
        }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func updateCheckout(_ id: String, updatingShippingRate shippingRate: String,activeViewController :UIViewController, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForUpdateCheckout(id, updatingShippingRate: shippingRate)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
         if Utility.isInternetAvailable(){
            if let checkout = response?.checkoutShippingLineUpdate?.checkout,
                let _ = checkout.shippingLine {
                completion(checkout.viewModel)
            } else {
                completion(nil)
            }
        }else{
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: activeViewController.view, animated: true)
            }
            ModalViewController.showAlert(alertTitle: kAppName, andMessage: kMessageNoInternetError, withController:activeViewController )
        }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func updateCheckout1(_ id: String, updatingShippingRate shippingRate: PayShippingRate,activeViewController :UIViewController, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForUpdateCheckout1(id, updatingShippingRate: shippingRate)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            if Utility.isInternetAvailable(){

            if let checkout = response?.checkoutShippingLineUpdate?.checkout,
                let _ = checkout.shippingLine {
                completion(checkout.viewModel)
            } else {
                completion(nil)
            }
        }else{
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: activeViewController.view, animated: true)
                }
            ModalViewController.showAlert(alertTitle: kAppName, andMessage: kMessageNoInternetError, withController:activeViewController )
        }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func updateCheckout(_ id: String, updatingEmail email: String,activeViewController :UIViewController, completion: @escaping (CheckoutViewModel?) -> Void) -> Task {
        let mutation = ClientQuery.mutationForUpdateCheckout(id, updatingEmail: email)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
            if Utility.isInternetAvailable(){

            if let checkout = response?.checkoutEmailUpdate?.checkout,
                let _ = checkout.email {
                completion(checkout.viewModel)
            } else {
                completion(nil)
            }
        }else{
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: activeViewController.view, animated: true)
                }
            ModalViewController.showAlert(alertTitle: kAppName, andMessage: kMessageNoInternetError, withController:activeViewController )
        }
        }
        
        task.resume()
        return task
    }
    
    @discardableResult
    func fetchShippingRatesForCheckout(_ id: String,activeViewController :UIViewController, completion: @escaping ((checkout: CheckoutViewModel, rates: [ShippingRateViewModel])?) -> Void) -> Task {
        
        let retry = Graph.RetryHandler<Storefront.QueryRoot>(endurance: .finite(30)) { response, error -> Bool in
            error.debugPrint()
            
            if let response = response {
                return (response.node as! Storefront.Checkout).availableShippingRates?.ready ?? false == false
            } else {
                return false
            }
        }
        
        let query = ClientQuery.queryShippingRatesForCheckout(id)
        let task  = self.client.queryGraphWith(query, retryHandler: retry) { response, error in
            error.debugPrint()
           if Utility.isInternetAvailable(){
            if let response = response,
                let checkout = response.node as? Storefront.Checkout {
                completion((checkout.viewModel, checkout.availableShippingRates!.shippingRates!.viewModels))
            } else {
                completion(nil)
            }
        }else{
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: activeViewController.view, animated: true)
            }
            ModalViewController.showAlert(alertTitle: kAppName, andMessage: kMessageNoInternetError, withController:activeViewController )
        }
        }
        
        task.resume()
        return task
    }
    
    func completeCheckout(_ checkout: PayCheckout, billingAddress: PayAddress,activeViewController :UIViewController, applePayToken token: String, idempotencyToken: String, completion: @escaping (PaymentViewModel?) -> Void) {
        
        let mutation = ClientQuery.mutationForCompleteCheckoutUsingApplePay(checkout, billingAddress: billingAddress, token: token, idempotencyToken: idempotencyToken)
        let task     = self.client.mutateGraphWith(mutation) { response, error in
            error.debugPrint()
             if Utility.isInternetAvailable(){
            if let payment = response?.checkoutCompleteWithTokenizedPayment?.payment {
                
                print("Payment created, fetching status...")
                self.fetchCompletedPayment(payment.id.rawValue) { paymentViewModel in
                    completion(paymentViewModel)
                }
                
            } else {
                completion(nil)
            }
        }else{
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: activeViewController.view, animated: true)
                }
            ModalViewController.showAlert(alertTitle: kAppName, andMessage: kMessageNoInternetError, withController:activeViewController )
        }
        }
        
        task.resume()
    }
    
    func fetchCompletedPayment(_ id: String, completion: @escaping (PaymentViewModel?) -> Void) {
        
        let retry = Graph.RetryHandler<Storefront.QueryRoot>(endurance: .finite(30)) { response, error -> Bool in
            error.debugPrint()
            
            if let payment = response?.node as? Storefront.Payment {
                print("Payment not ready yet, retrying...")
                return !payment.ready
            } else {
                return false
            }
        }
        
        let query = ClientQuery.queryForPayment(id)
        let task  = self.client.queryGraphWith(query, retryHandler: retry) { query, error in
            
            if let payment = query?.node as? Storefront.Payment {
                completion(payment.viewModel)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
}
//  MARK: - Extenstion String to change base 64 -
extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

// ----------------------------------
//  MARK: - GraphError -
//
extension Optional where Wrapped == Graph.QueryError {
    
    func debugPrint() {
        switch self {
        case .some(let value):
            print("Graph.QueryError: \(value)")
        case .none:
            break
        }
    }
}
