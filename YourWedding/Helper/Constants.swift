//
//  Constants.swift
//  VistarApp
//
//  Created by thinksysuser on 20/01/17.
//  Copyright © 2017 thinksysuser. All rights reserved.
//


import UIKit

let kRegexEmailValidate = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
let Email_Alert_Message = "Email is not valid."
let kAppName = "Your Wedding"
let kSupportEmail = "cs@yourweddinglinen.com"
let kCollectioncellIdentifier = "cell"

let customerChangeNotification = "customerChangeNotification"

let kMessgaeCustThreBlank = "Customer threshold can't be blank."
let kMessageNoInternetError = "Internet Not Available."
let kMessageParametresError = "Parametres Error"
let kMessageNetworkError = "Network Error."
let kMessageServerError = "Internal Server Error, Please retry."
let kMessageInvalidResponseError = "Invalid Response Received from server."


var sideMenuDataSection:NSArray{
    
    let isLogIn = UserDefaults.standard.bool(forKey: keyIsLogIN)
    if isLogIn == true{
        let array = ["Home","Offers and Discounts","My Order","Contact Us","Terms And Conditions","Privacy Policy","Refund Policy","Cancellation Policy","Log Out"]
        
        return array as NSArray
    }else{
        let array = ["Home","Offers and Discounts","My Order","Contact Us","Terms And Conditions","Privacy Policy","Refund Policy","Cancellation Policy","Log In"]
        
        return array as NSArray
    }
    
}
var arrayMenuItems:NSArray{
    var array = ["Home","My Video","My Cources","Buy Package","My Package","My Downloads","Offer","Refer a friend","My Addresses","Notification","Terms of Services","Privacy Policy","Log Out"]
    
    
    
    return array as NSArray
    
}
var arrayImages:NSArray{
    var array = ["home","offerMenu","orderMenu","contactUs","termsAndCondition","privacyPolicy","refundPolicy","cancellation","logout"]
    
    
    return array as NSArray
}

var sideMenuImages:NSArray{
    var array = ["home","offerMenu","orderMenu","contactUs","termsAndCondition","privacyPolicy","refundPolicy","cancellation","logout"]
    //    if Utility.getEnvironmentType() == .Development
    //    {
    //        array = ["home","ordersMenu","quoteMenu","partSearchMenu","resourceGuideMenu","changeAmMenu","changeCustMenu","priceApprovalMenu","notificationSM","configMenu","logout"]
    //    }
    //    let initialRep = Utility.getRepCount()
    //    if initialRep == 0 {
    //        array = ["home","ordersMenu","quoteMenu","partSearchMenu","resourceGuideMenu","changeCustMenu","priceApprovalMenu","notificationSM","logout"]
    //
    //        if Utility.getEnvironmentType() == .Development
    //        {
    //            array = ["home","ordersMenu","quoteMenu","partSearchMenu","resourceGuideMenu","changeCustMenu","priceApprovalMenu","notificationSM","configMenu","logout"]
    //
    //        }
    //
    //    }
    //
    return array as NSArray
    
}







var tableclothArray:NSArray{
    let array = ["70” Round Satin Tablecloths","90” Round Satin Tablecloths"," 108” Round Satin Tablecloths","60 * 102 Satin Rectangular Tablecloths","60 * 126 Satin Rectangular Tablecloths","90 * 132 Satin Rectangular Tablecloths","90 * 156 Satin Rectangular Tablecloths","120 Inch Round Duchess Sequin Tablecloths","60*102 Inch Rectangular Duchess Sequin Tablecloths", "60*126 Inch Rectangular Duchess Sequin Tablecloths","90*132 Inch Rectangular Duchess Sequin Tablecloths","90*156 Inch Rectangular Duchess Sequin Tablecloths","Table Skirt Clips","70 Inch Round Polyester Tablecloths","90 Inch Round Polyester Tablecloths","108” Round Polyester Tablecloths","120” Round Polyester Tablecloths","132” Round Polyester Tablecloths","52*52 Square Polyester Tablecloths","70*70 Square Polyester Tablecloths","85*85 Square Polyester Tablecloths" ,"60*102 Rectangle Polyester Tablecloths", " 60*126 Rectangle Polyester Tablecloths"," 70*120 Rectangle Polyester Tablecloths"," 90*132 Rectangle Polyester Tablecloths"," 90*156 Rectangle Polyester Tablecloths","90*132 Rectangular Rosette Tablecloths","90*156 Rectangular Rosette Tablecloths","120 Inch Round Rosette Tablecloths","132 Inch Round Rosette Tablecloths","120 Inch Round Pintuck Tablecloths","132 Inch Round Pintuck Tablecloths","90*132 Pintuck Tablecloths","90*156 Pintuck Tablecloths","Jute Burlap Tablecloths","Rectangular Spandex Tablecloths" ,"Round Spandex Tablecloths","Spandex Cocktail Tablecloths" ,"Rectangular Spandex Tablecloths" ," Checkered/Plaid Tablecloths "," Polyester Table Skirts"]
    
    return array as NSArray
}
var tableclothImageArray:NSArray{
    let array = ["70”RoundSatinTablecloths","90”RoundSatinTablecloths","108”RoundSatinTablecloths","60*102SatinRectangularTablecloths","60*126SatinRectangularTablecloths","90*132SatinRectangularTablecloths","90*156SatinRectangularTablecloths","120InchRoundDuchessSequinTablecloths","60*102InchRectangularDuchessSequinTablecloths","60*126InchRectangularDuchessSequinTablecloths","90*132InchRectangularDuchessSequinTablecloths","90*156InchRectangularDuchessSequinTablecloths","TableSkirtClips","70InchRoundPolyesterTablecloths","90InchRoundPolyesterTablecloths","108”RoundPolyesterTablecloths","120”RoundPolyesterTablecloths","132”RoundPolyesterTablecloths","52*52SquarePolyesterTablecloths","70*70SquarePolyesterTablecloths","85*85SquarePolyesterTablecloths" ,"60*102RectanglePolyesterTablecloths", "60*126RectanglePolyesterTablecloths","70*120RectanglePolyesterTablecloths","90*132RectanglePolyesterTablecloths","90*156RectanglePolyesterTablecloths","90*132RectangularRosetteTablecloths","90*156RectangularRosetteTablecloths","120InchRoundRosetteTablecloths","132InchRoundRosetteTablecloths","120InchRoundPintuckTablecloths","132InchRoundPintuckTablecloths","90*132PintuckTablecloths","90*156PintuckTablecloths","JuteBurlapTablecloths","RectangularSpandexTablecloths" ,"RoundSpandexTablecloths","SpandexCocktailTablecloths" ,"RectangularSpandexTablecloths" ,"CheckeredPlaidTablecloths","PolyesterTableSkirts"]
    
    return array as NSArray
}
var tableclothIDArray:NSArray{
    let array = [92998991937 as UInt64,92999090241 as UInt64,92999155777 as UInt64,93001351233 as UInt64,93001384001 as UInt64,93001515073 as UInt64,93001547841 as UInt64,93002367041 as UInt64,93002399809 as UInt64,93002432577 as UInt64,93002465345 as UInt64,93002530881 as UInt64,60118073409 as UInt64,92944629825 as UInt64,92997189697 as UInt64,92997386305 as UInt64,92997550145 as UInt64,92997648449 as UInt64,92997877825 as UInt64,92997943361 as UInt64,92997976129 as UInt64,92998107201 as UInt64,92998500417 as UInt64,92998533185 as UInt64,92998664257 as UInt64,92998795329 as UInt64,93001744449 as UInt64,93001809985 as UInt64,93001908289 as UInt64,93001941057 as UInt64,93002039361 as UInt64,93002137665 as UInt64,93002170433 as UInt64,93002268737 as UInt64,60117909569 as UInt64,93002629185 as UInt64,93002694721 as UInt64,93002760257 as UInt64,93002629185 as UInt64,60118007873 as UInt64,60118040641 as UInt64]
    
    return array as NSArray
}

var runnersArray:NSArray{
    let array = ["Fall & Winter Collection Overlay", "72*72 satin/pintuck/rosette/duchess sequin", "72*72 Organza with Flower print Overlay" ," 72*72 Organza with Roses Overlay "," 60*60 Satin Overlays", "85*85 Pintuck/Rosette Overlays", "90*90 Satin Overlays","Checkered/plaid table Runner ", "Organza with Flower Print Table Runner" , "Organza with Roses table Runner","Organza Table Runner", "Satin Table Runner","Organza With Metallic Design Table Runner","Lace table Runner", "Rosette Satin Table Runner" , "Pintuck Satin Table Runner"," Burlap Table Runner","Duchess Sequin Table Runner" , "Fall & Winter Collection Table Runner"]
    
    return array as NSArray
}
var runnersImageArray:NSArray{
    let array = ["Fall&WinterCollectionOverlay", "72*72satinpintuckrosetteduchessSequin", "72*72OrganzaWithFlowerPrintOverlay" ,"72*72OrganzaWithRosesOverlay","60*60SatinOverlays", "85*85PintuckRosetteOverlays", "90*90SatinOverlays","CheckeredplaidTableRunner", "OrganzaWithFlowerPrintTableRunner" , "OrganzaWithRosesTableRunner","OrganzaTableRunner", "SatinTableRunner","OrganzaWithMetallicDesignTableRunner","LaceTableRunner", "RosetteSatinTableRunner", "PintuckSatinTableRunner","BurlapTableRunner","DuchessSequinTableRunner" , "Fall&WinterCollectionTableRunner"]
    
    return array as NSArray
}

var runnersIDArray:NSArray{
    let array = [93007216705 as UInt64,93007249473 as UInt64,93007708225 as UInt64,93007773761 as UInt64,93007806529 as UInt64,93007872065 as UInt64,93007937601 as UInt64,93007970369 as UInt64,93008003137 as UInt64,93008035905 as UInt64,93008068673 as UInt64,93008101441 as UInt64,93008134209 as UInt64,93008232513 as UInt64,93008330817 as UInt64,93008363585 as UInt64,93008461889 as UInt64,93008527425 as UInt64,93008560193 as UInt64]
    
    return array as NSArray
}

var chairSashArray:NSArray{
    let array = ["Sequin Chair Sash" , "Spandex chair Sash "," Satin Chair Sash" ," Animal Print Satin Chair Sash"," Organza Sash" , "Glitter Organza Sash", "lace Chair Sashes", "Pintuck satin Chair Sashes" , " Burlap Chair Sashes"]
    
    return array as NSArray
}
var chairSashImageArray:NSArray{
    let array = ["sequinChairSash" , "spandexChairSash ","satinChairSash" ,"animalPrintSatinChairSash","Organza Sash" , "glitterOrganzaSash", "laceChairSashes", "pintuckSatinChairSashes" , "burlapChairSashes"]
    
    return array as NSArray
}

var chairSashIDArray:NSArray{
    let array = [80844357697 as UInt64,60119154753 as UInt64,60119187521 as UInt64,60119220289 as UInt64,60119253057 as UInt64,60119285825 as UInt64,60119318593 as UInt64,60119384129 as UInt64,60119416897 as UInt64]

    
    return array as NSArray
}

var tulleFabricArray:NSArray{
    let array = ["Tulle Roll 6 Inch * 25 Yards" ," Tulle Roll 6 Inch * 100 Yards" , "Tulle Bolt 54 Inch * 40 yards" ,"Tulle Fabric 108 Inch * 50 yards" , "Tulle Roll 12 Inch 25 yards" , "Tulle Roll 18 Inch * 25 yards","Premium Quality Nylon Tulle Fabric 54 In * 40 Yds"," Premium Quality Nylon Tulle Roll 6 In * 100 Yds" , "6 Inch * 10 yards Animal Printed Tulle Spool","9 Inch Nylon Circle Tulle","12 Inch Nylon Circle Tulle","54 Inch * 10 Yards Animal Printed tulle Bolt","Polka Heart 6 Inch Tulle Roll","Bow Design Tulle 6Inch * 10 yard","Swiss Color dot Tulle 6 Inch * 10 Yards","Snowflake Design Tulle 6 inch * 10 yards","Multi Stripe Tulle 6 Inch * 25 yards" , "Glitter Multi Stripe Tulle 6 Inch * 25 yards",    "Glitter Tulle Bolt 54 inch","Glitter tulle roll 6 Inch * 25 Yards","Glitter Tulle Roll 6 Inch * 10 yards" , "Swiss Dot Tulle 6 inch * 10 Yards", "Polka Dot Tulle 6 Inch * 10 Yards"]
    
    return array as NSArray
}
var tulleFabricImageArray:NSArray{
    let array = ["TulleRoll6Inch25Yards" ,"TulleRoll6Inch100Yards" , "TulleBolt54Inch40yards" ,"TulleFabric108Inch50yards" , "TulleRoll12Inch25yards" , "TulleRoll18Inch25yards","PremiumQualityNylonTulleFabric54In40Yds","PremiumQualityNylonTulleRoll6In100Yds" , "6Inch10yardsAnimalPrintedTulleSpool","9InchNylonCircleTulle","12InchNylonCircleTulle","54Inch10YardsAnimalPrintedTulleBolt","PolkaHeart6InchTulleRoll","BowDesignTulle6Inch10yard","SwissColordotTulle6Inch10Yards","SnowflakeDesignTulle6inch10yards","MultiStripeTulle6Inch25yards" , "GlitterMultiStripeTulle6Inch25yards",    "GlitterTulleBolt54inch","GlitterTulleRoll6Inch25Yards","GlitterTulleRoll6Inch10yards" , "SwissColordotTulle6Inch10Yards", "PolkaDotTulle6Inch10Yards"]
    
    return array as NSArray
}

var  tulleFabricIDArray:NSArray{
    let array = [92997615681 as UInt64,92997779521 as UInt64,92997845057 as UInt64,92997910593 as UInt64,92998041665 as UInt64,92998074433 as UInt64,60119973953 as UInt64,60120039489 as UInt64,60120105025 as UInt64,92998369345 as UInt64,92998434881 as UInt64,92998598721 as UInt64,60120203329 as UInt64,60120268865 as UInt64,60120301633 as UInt64,60120334401 as UInt64,60120367169 as UInt64,60120399937 as UInt64,60120432705 as UInt64,60120465473 as UInt64,60120498241 as UInt64,60120531009 as UInt64,60120596545 as UInt64]
    
    return array as NSArray
}
var weddingNapkinsArray:NSArray{
    let array = ["19*19 Checkered/ Plaid napkins" ," napkin Rings" , " 17*17 Polyester Napkins" ," 20*20 polyester Napkins" ,  "20*20 satin napkins"]
    
    return array as NSArray
}
var weddingNapkinsImageArray:NSArray{
    let array = ["19*19CheckeredPlaidNapkins" ,"napkinRings" , "17*17PolyesterNapkins" ,"20*20PolyesterNapkins" ,  "20*20SatinNapkins"]
    
    return array as NSArray
}

var  weddingNapkinsIDArray:NSArray{
    let array = [60119547969 as UInt64,60119580737 as UInt64,60121972801 as UInt64,60119679041 as UInt64,60119711809 as UInt64]
    
    return array as NSArray
}
var weddingSuppliesArray:NSArray{
    let array = ["Charger plates", "Sequin Backdrop" ," Lace Fabric", "Organza fabric"," satin Fabrics Solid Print" ," Satin Fabric Zebra Prints" ," Faux Burlap Roll 6 Inch * 10 yards" ,"Burlap Roll 6 inch * 5 yards" , "glitter Sisal Mesh 6 Inch 10 yards" ," Glitter Net 6 Inch * 10 yards"]
    
    return array as NSArray
}
var weddingSuppliesImageArray:NSArray{
    let array = ["ChargerPlates", "SequinBackdrop" ,"LaceFabric", "OrganzaFabric","SatinFabricsSolidPrint" ,"SatinFabricZebraPrints" ,"FauxBurlapRoll6Inch10yards" ,"BurlapRoll6Inch5yards" , "glitterSisalMesh6Inch10yards" ,"GlitterNet6Inch10yards"]
    
    return array as NSArray
}
var  weddingSuppliesIDArray:NSArray{
    let array = [60119810113 as UInt64,60534915137 as UInt64,92999024705 as UInt64,93001842753 as UInt64,93008166977 as UInt64,93008265281 as UInt64,93089824833 as UInt64,93008429121 as UInt64,93008592961 as UInt64,93008625729 as UInt64]
    
    return array as NSArray
}

var sortingArray:NSArray{
    let array = ["Sort By","Alphabetically,A-Z","Alphabetically,Z-A","Price,low to high","Price,high to low"]
    
    return array as NSArray
}

var tableclothSections = [
    Section(category: "New & Hot", subCategory: ["New & Hot"], colorFilter: ["Ivory","Lavender","Pink","Polyester","Purple","Red","White"], sizeFilter: ["13 Inch x 90 Inch","14 Inch x 90 Inch","14 Inch x 108 Inch"], shapeFilter: ["Rectangular"], subCategoryImage: ["New&Hot"], id: [80974970945 as UInt64], expended: false),
    Section(category: "TableCloth", subCategory:  tableclothArray as! [String],colorFilter: ["Apple Green", "Aqua Blue" ,"Baby Maize", "Black","Burgundy","Charcoal","Chocolate Brown", "Coral", "Daffodil","Fuchsia", "Gold","Ivory","Lavender","Light Blue","Light Pink", "Navy", "Navy Blue", "Orange","Pink","Plum","Polyester" ,"Purple","Red", "Royal Blue","Silver","Turquoise","White"], sizeFilter: ["108 Inch", "108 Inch Round","120 Inch Round","132 Inch Round","52 Inch x 52 Inch","58 Inch x 126 Inch","60 Inch x 102 Inch" , "60 Inch x 60 Inch","70 Inch Round", "70 Inch x 120 Inch","70 Inch x 70 Inch", "72 Inch x 72 Inch", "85 Inch x 85 Inch","90 Inch Round", "90 Inch x 132 Inch","90 Inch x 156 Inch"], shapeFilter: ["Rectangular","Round" , "Square"],subCategoryImage : tableclothImageArray as! [String], id:tableclothIDArray as! [UInt64], expended: false),
    Section(category: "Runners & Overlays", subCategory: runnersArray as! [String],colorFilter: ["Baby Maize", "Black","Burgundy","Gold","Ivory","Lavender","Light Blue", "Navy Blue","Pink","Polyester" ,"Purple","Red", "Royal Blue","Silver","Turquoise","White"], sizeFilter: ["12 Inch x 108 inches", "14 Inch x 108 Inch" , "14 Inch x 108 inches","72 Inch x 72 Inch" ], shapeFilter: ["Rectangular","Square"],subCategoryImage : runnersImageArray as! [String],id: runnersIDArray as! [UInt64], expended: false),
    Section(category: "Chair Cover", subCategory: ["Economy Chair Covers" , "Madrid Spandex Chair Cover" , "Duchess Sequin Chair Cap", "Rosette Chair Cap"],colorFilter: [ "Black","Burgundy","Chocolate Brown","Fuchsia", "Gold","Ivory","Light Pink", "Navy Blue","Plum","Polyester" ,"Purple","Red", "Royal Blue","Silver","Turquoise","White"], sizeFilter: [""], shapeFilter: [""],subCategoryImage : ["economyChairCovers" , "madridSpandexChairCover" , "duchessSequinChairCap", "RosetteChairCap"],id:  [60118335553 as UInt64,60118368321 as UInt64,60118401089 as UInt64,60118990913 as UInt64], expended: false),
    Section(category: "Chair Sash", subCategory: chairSashArray as! [String],colorFilter: ["Apple Green", "Aqua Blue" ,"Baby Maize", "Black","Burgundy","Chocolate Brown", "Coral", "Daffodil","Fuchsia", "Gold","Ivory","Lavender","Light Blue","Light Pink", "Navy", "Navy Blue", "Orange","Pink","Plum","Polyester" ,"Purple","Red", "Royal Blue","Silver","Turquoise","White"], sizeFilter: ["16 Inch x 14 Inch" , "6 Inch x 106 Inch", "6 Inch x 108 inches", "7 Inch x 106 inches" , "7 Inch x 108 inches", "8 Inch x 108 Inch"], shapeFilter: ["Rectangular"],subCategoryImage : chairSashImageArray as! [String],id: chairSashIDArray as! [UInt64], expended: false),
    Section(category: "Tulle fabric", subCategory: tulleFabricArray as! [String],colorFilter: ["Black","Burgundy","Fuchsia", "Gold","Ivory","Silver","White"], sizeFilter: ["6 Inch x 10 Inch" , "6 Inch X 10 Yards"], shapeFilter: ["Rectangular"],subCategoryImage : tulleFabricImageArray as! [String],id: tulleFabricIDArray as! [UInt64], expended: false),
    Section(category: "Wedding Napkins", subCategory: weddingNapkinsArray as! [String],colorFilter: ["Apple Green","Aqua Blue" , "Black","Burgundy","Charcoal","Chocolate Brown", "Coral","Fuchsia", "Gold","Ivory","Lavender","Light Blue","Navy","Navy Blue", "Orange","Pink","Plum","Polyester", "Purple","Red", "Royal Blue","Silver","Turquoise","White"], sizeFilter: ["17 Inch X 17 Inch" , "20 Inch X 20 Inch" ], shapeFilter: ["Square"],subCategoryImage : weddingNapkinsImageArray as! [String],id: weddingNapkinsIDArray as! [UInt64], expended: false),
    Section(category: "Wedding Supplies", subCategory: weddingSuppliesArray as! [String],colorFilter: ["Apple Green","Black","Fuchsia", "Gold","Orange","Pink","Red","Silver","Turquoise"], sizeFilter: ["13 Inch x 90 Inch","14 Inch x 90 Inch","14 Inch x 108 Inch"], shapeFilter: ["Round" , "Square"],subCategoryImage : weddingSuppliesImageArray as! [String],id: weddingSuppliesIDArray as! [UInt64], expended: false),
      Section(category: "Clearance", subCategory: ["Clearance"],colorFilter: [""], sizeFilter: [""], shapeFilter: [""],subCategoryImage : ["Clearance"], id: [60120629313 as UInt64], expended: false)
]




var arrayCategoryName:NSArray{
    let array = ["DOG","CAT","FISH","BIRD"]
    
    return array as NSArray
}
var arrayCategoryImages:NSArray{
    let array = ["rectTblClothImage","roundtblClothImage","chairSashesImage","JuteImage"]
    
    return array as NSArray
}

var arraySlideOfferImages:NSArray{
    let array = ["SlideImage1","SlideImage2","SlideImage3"]
    
    return array as NSArray
}

let tableViewCellIdentifier = "tablecellidentifier"
let screenWidth = UIScreen.main.bounds.size.width
let screenheight = UIScreen.main.bounds.size.height
var labelHeading:UILabel?

import Foundation

// MARK:- Social Promotion web URL
var keyfacbookURL:String {
    return String(format:"https://www.facebook.com/PetStylo-935822639892767/")
}
var keyGooglURL:String {
    return String(format:"https://plus.google.com/110519442366304126211")
}
var keyInstagramURL:String {
    return String(format:"https://www.instagram.com/ribbons.cheap/")
}
var keyPinterestURL:String {
    return String(format:"https://in.pinterest.com/ribbonscheap/")
}
var keyTwitterkURL:String {
    return String(format:"https://twitter.com/Shopify?ref_src=twsrc%5Etfw%7Ctwcamp%5Eembeddedtimeline%7Ctwterm%5Eprofile%3AShopify&ref_url=https%3A%2F%2Fwww.petstylo.com%2F")
}
var keyDiscountOfferUrl : String{
    return "https://yourweddinglinen.myshopify.com/pages/promotions"
}
var keyContactUsURL:String{
    return String(format: "https://yourweddinglinen.myshopify.com/pages/contact-us")
}

var keyRefundPolicyURL:String{
    return String(format: "https://yourweddinglinen.myshopify.com/pages/return")
}
var keyTermsURL:String{
    return String(format: "https://yourweddinglinen.myshopify.com/pages/terms")
}
var keyPrivacyPolicyURL:String{
    return String(format: "https://yourweddinglinen.myshopify.com/pages/privacy-policy")
}
var keyCancelPolicyURL:String{
    return String(format: "https://yourweddinglinen.myshopify.com/pages/cancellation-policy")
}

var keyFresh:String {
    return String(format:"isFresh")
}
var keySessionID:String {
    return String(format:"sessionID")
}
var keyDeviceToken:String {
    return String(format:"deviceToken")
}
var isNotificationReceived:String {
    return String(format:"isNotificationReceived")
}
var keyRepCount:String {
    return String(format: "repCount")
}

//var keyInitialRep:String {
//    return String(format:"initialRep")
//}
var keyCurrentRep:String {
    return String(format:"currentReps")
}
var keyAMname:String {
    return String(format:"amName")
}
var keyEnvironmentType:String {
    return String(format:"environmentType")
}
var keyCustomerDetailDic:String{
    
    return String(format:"selectedCustomerDetailsDic")
}
var keyUserName:String{
    
    return String(format:"userName")
}
var keyUserDisplayName:String{
    
    return String(format:"userDisplayName")
}
var keyUserTitle:String{
    
    return String(format:"userTitle")
}
var keyToken:String{
    
    return String(format:"activeToken")
}
var keyCustomerFirstName:String{
    
    return String(format:"customerFirstName")
}
var keyCustomerLastName:String{
    
    return String(format:"customerLirstName")
}
var keyCustomerID:String{
    
    return String(format:"customerID")
}

var keyValidDateToken:String{
    
    return String(format:"expiryDateToken")
}
var keyIsLogIN:String{
    
    return String(format:"isLogIN")
}

var keyCustomerAccount:String{
    
    return String(format:"customerAccount")
}
var keyCustomerCity:String{
    
    return String(format:"customerCity")
}
var keyCustomerName:String{
    
    return String(format:"customerName")
}
var keyCustomerPlant:String{
    
    return String(format:"customerPlant")
}
var keyCustomerState:String{
    
    return String(format:"customerState")
}


var keyArrayPlots:String{
    
    return String(format:"arrayPlots")
}
var appFont:String{
    
    return String(format:"HelveticaNeue")
}

var appFontBold:String{
    
    return String(format:"HelveticaNeue-Bold")
}

var notificationTypePriceApproval:String{
    
    return String(format:"priceApproval")
}

var notificationTypeQuoteAdded:String{
    
    return String(format:"quoteAdded")
}

var badgeCountUpdateNotification:String{
    
    return String(format:"badgeCountUpdateNotification")
}


var screenRatioWidth:Double
{
    return Double(screenWidth)/375.0
}
enum NotificationType {
    case PriceApproval
    case QuoteAdded
    case NotDefined
}

enum ScrollViewLazy{
    case UP
    case Down
    case None
}

enum DetailType{
    case PriceApprovalOther
    case QuoteDetailOther
    case OrderDetailOther
    case PriceApprovalProduct
    case QuoteDetailProduct
    case OrderDetailProduct
    case PartDetail
    case PartDetailOther
    case PartDetailArray
    
    case PartDetailOtherArray
    
    
}

enum EnvironmentType:String{
    case Production = "Production"
    case Development = "Development"
    
}

