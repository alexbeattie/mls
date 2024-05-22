//
//  Constants.swift
//  NewAPI
//
//  Created by Alex Beattie on 10/1/23.
//

import Foundation
struct Constants {
    static let baseURL = "https://replication.sparkapi.com/Reso/OData/Property"
    static let AGENTKEY = ""
    static let TOKEN = "783gnjjn82x92n9lbvpr1r0c1"

    
    
    static let MLSID = "20200630203341057545000000"
    static let AKID = "20221206010747906939000000"
    static let KURT = "20200702220810507475000000"
    static let Wendy = "20200702221047598631000000"
    static let ChYba = "20190515182128662275000000"
    static let raini = "20201013021010133039000000"
    static let brandonw = "20201014010215688305000000"
    static let rickhilton = "20200702220642273565000000"
    static let drewfenton = "20200702221246066174000000"
    static let aaronkirman = "20200702220937059314000000"
   
    struct QueryKeys {
           static let filter = "_filter"
           static let select = "_select"
           static let limit = "_limit"
           static let pagination = "_pagination"
           static let page = "_page"
           static let orderby = "_orderby"
           static let expand = "_expand"
       }
    
    
    static let teamnickandkaren = "20160917171150811658000000"
    static let vanparys = "207092085"
    static let ok = "20160917164830438874000000"
    static let currentPage = 0
    static let itemsPerPage = 1
    static let compass = "20180423214801878673000000"
    static let sara = "20160917170948921021000000"
    static let laperche = "20160917170949016404000000"
    static let listAgentKey = "20160917171119703445000000"
    static let jordan = "20160917171113923841000000"
    static let laporta = "20160917171157276685000000"
    static let officeKey = "20160917164910780153000000"
    static let memberKey = "20160917171040502037000000"
    static let loriememberkey = "20160917171124687793000000"
    static let kirkman = "20200702220937059314000000"
    static let kramer = "20200702220640427118000000"
//    static let barbara = "20160726143802546977000000"
    static let fenton = "20221006165222145483000000"
    static let sandvig = "20160917171026492360000000"
    static let vp = "20220622184809040862000000"
    static let pm = "20160917171201610393000000"
    static let mlsClaw = "20200630203341057545000000"
    static let highDesert = "20200630204544040064000000"
    static let southlandRegional = "20200630203518576361000000"
    static let itech = "20200630203206752718000000"
    static let gpsmls = "20190211172710340762000000"
    static let crmls = "20200218121507636729000000"
    static let csmar = "20160622112753445171000000"
    static let joyce = "20200702220637545188000000"
    static let mauricio = "20200702220838588764000000"
    static let hyland = "20200702220637257693000000"
    static let jade = "20200827200414900446000000"
    static let lindamay = "20200702220637806449000000"
    static let money =
    "https://replication.sparkapi.com/v1/listings?_limit=1&_pagination=1&_filter=MlsId eq '20200630203341057545000000' And ListAgentId Eq '20221206010747906939000000' Or CoListAgentId Eq '20221206010747906939000000' &_order=-ListPrice&_expand=Photos,Documents,Videos,VirtualTours,OpenHouses,CustomFields"
    static let akirkman = "https://replication.sparkapi.com/v1/listings?_filter=MlsId eq '20200630203341057545000000' and ListAgentName eq 'Aaron Kirkman'"
}
//queries




//van parys
//            URLQueryItem(name: "$filter", value: "ListAgentKey eq '\(pm)' and StandardStatus eq 'Closed' and StandardStatus ne 'Expired' and StandardStatus ne 'Canceled'"),

//            URLQueryItem(name: "$filter", value: "MlsId eq '\(mlsClaw)' and StandardStatus eq 'Closed' and StandardStatus ne 'Expired' and StandardStatus ne 'Canceled'"),

//            URLQueryItem(name: "$filter", value: "MlsId eq '\(mlsServiceKey)' and StandardStatus eq 'Active' "),

//            URLQueryItem(name: "$filter", value: "MlsStatus eq 'Pending'"),
//all past 'Sold' Sherwood listings query
//            URLQueryItem(name: "$filter", value: "ListOfficeKey eq '\(officeKey)' and StandardStatus eq 'Closed' and StandardStatus ne 'Expired' and StandardStatus ne 'Canceled'"),
//            URLQueryItem(name: "$select", value: "ListPrice,MlsStatus,BuildingAreaTotal,ArchitecturalStyle,BedroomsTotal,BathroomsTotalInteger,BuyerAgentEmail,CloseDate,ClosePrice,DaysOnMarket,DocumentsCount,GarageSpaces,Inclusions,Latitude,Longitude,ListAgentKey,ListPrice,ListingContractDate,ListingId,ListingKey,LivingArea,LotSizeAcres,OffMarketDate,OnMarketDate,OriginalListPrice,PendingTimestamp,Model,AssociationAmenities,AssociationName,ListOfficePhone,AssociationFee,BathroomsTotalDecimal,BuilderName,CoListAgentEmail,ListAgentEmail,CommunityFeatures,ConstructionMaterials,Disclosures,DocumentsAvailable,DocumentsChangeTimestamp,InteriorFeatures,Levels,LotFeatures,LotSizeAcres,LotSizeArea,MajorChangeTimestamp,Model,ModificationTimestamp,OnMarketDate,OtherStructures,ParkingFeatures,PhotosCount,SecurityFeatures,SourceSystemName,UnparsedAddress,View,YearBuilt,ListAgentFirstName,ListAgentLastName,CoListAgentFirstName,CoListAgentLastName,ListAgentStateLicense,Appliances,StreetNumberNumeric,BathroomsHalf,Listing_sp_Location_sp_and_sp_Property_sp_Info_co_List_sp_PriceSqFt,Commission_sp_Info_co_Buyer_sp_Agency_sp_Comp,Showing_sp_Information_co_Showing_sp_Contact_sp_Name,Parking_sp_SpacesInformation_co_Total_sp_Garage_sp_Spaces,PublicRemarks,StreetName,StreetSuffix,StreetNumber,City,StateOrProvince,ListAgentFullName,ConstructionMaterials,Cooling,Heating,Electric,Flooring,InteriorFeatures,View,WindowFeatures,Appliances")
