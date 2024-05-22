//
//  SparkModel.swift
//  SparkApi
//
//  Created by Alex Beattie on 5/20/24.
//

import Foundation
struct ActiveListings: Codable {
    struct ListingData: Codable {
        var D: ResultsData
    }
    
    struct ResultsData: Codable {
        var Results: [ListingResult]
    }
    
    struct ListingResult: Codable, Identifiable, Hashable {
        
        
        var Id: String
        var ResourceUri: String
        var StandardFields: StandardFields
        var CustomFields: [CustomFields]
        var LastCachedTimestamp: String?
        var id: String { Id }
        static func == (lhs: ListingResult, rhs: ListingResult) -> Bool {
            return lhs.Id == rhs.Id
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(Id)
        }
        
    }

    struct Pagination: Codable {
        var totalRows: Int
        var pageSize: Int
        var currentPage: Int
        var totalPages: Int
        
        init(totalRows: Int? = nil, pageSize: Int? = nil, currentPage:Int? = nil, totalPages:Int? = nil) {
            self.totalRows = totalRows ?? 0
            self.pageSize = pageSize ?? 0
            self.currentPage = currentPage ?? 0
            self.totalPages = totalPages ?? 0
        }
                                                                                                        enum CodingKeys: String, CodingKey {
            case totalRows = "totalRows"
            case pageSize = "pageSize"
            case currentPage = "currentPage"
            case totalPages = "totalPages"
        }
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            totalRows = try container.decode(Int.self, forKey: .totalRows)
            pageSize = try container.decode(Int.self, forKey: .pageSize)
            currentPage = try container.decode(Int.self, forKey: .currentPage)
            totalPages = try container.decode(Int.self, forKey: .totalPages)
        }
        
    }
    
    //    static let instance = Listing()
    
    
    //listing struct
    enum StringOrDouble: Codable {
           case string(String)
           case double(Double)
           
           var doubleValue: Double? {
               switch self {
               case .string(let str):
                   return Double(str)
               case .double(let dbl):
                   return dbl
               }
           }
           
           var value: String {
               switch self {
               case .string(let str):
                   return str
               case .double(let dbl):
                   return String(dbl)
               }
           }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let doubleValue = try? container.decode(Double.self) {
                self = .double(doubleValue)
            } else if let stringValue = try? container.decode(String.self) {
                self = .string(stringValue)
            } else {
                throw DecodingError.typeMismatch(StringOrDouble.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected Double or String"))
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .string(let str):
                try container.encode(str)
            case .double(let dbl):
                try container.encode(dbl)
            }
        }
    }

    
    
    struct StandardFields: Codable {
        
        var BedsTotal: String
        var BathsFull: String
        var BuildingAreaTotal: Float?
        var Latitude: StringOrDouble?
        var Longitude: StringOrDouble?

        var ListingId: String?
        var ListAgentName: String?
        var ListAgentStateLicense: String?
        var ListAgentEmail: String?
        var CoListAgentName: String?
        var MlsStatus: String?
        var ListOfficePhone: String?
        var ListOfficeFax: String?
        
        var UnparsedFirstLineAddress: String?
        var City: String?
        var PostalCode: String?
        var StateOrProvince: String?
        
        var UnparsedAddress: String?
        
        var CurrentPricePublic: Int?
        var ListPrice: Int?
        var PublicRemarks: String?
        
        var ListAgentURL: String?
        var ListOfficeName: String?
        
        var VirtualTours: [VirtualToursObjs]?
        struct VirtualToursObjs: Codable {
            var Uri: String?
        }
        
        var Videos: [VideosObjs]?
        struct VideosObjs: Codable {
            var ObjectHtml: String?
        }
        
        var Photos: [PhotoDictionary]?
        struct PhotoDictionary:Codable {
            var Id: String
            var Name: String
            var Uri640: String?
            var Uri800: String?
            var Uri1600: String?
            
        }
        
        enum CodingKeys: String, CodingKey {
            case BathsFull = "BathsFull", BedsTotal = "BedsTotal", Latitude = "Latitude", Longitude = "Longitude", ListingId = "ListingId", BuildingAreaTotal = "BuildingAreaTotal", ListAgentName = "ListAgentName", CoListAgentName = "CoListAgentName", MlsStatus = "MlsStatus", ListOfficePhone = "ListOfficePhone", UnparsedFirstLineAddress = "UnparsedFirstLineAddress", City = "City", PostalCode = "PostalCode", StateOrProvince = "StateOrProvince", UnparsedAddress = "UnparsedAddress", CurrentPricePublic = "CurrentPricePublic", ListPrice = "ListPrice", PublicRemarks = "PublicRemarks", Photos = "Photos", Videos = "Videos", VirtualTours = "VirtualTours"
            
        }
        
        init(BathsFull: String? = nil, Latitude: StringOrDouble? = nil, Longitude: StringOrDouble? = nil, BedsTotal: String? = nil, ListingId: String? = nil, BuildingAreaTotal:Float? = nil,ListAgentName: String? = nil, CoListAgentName: String? = nil, MlsStatus: String? = nil, ListOfficePhone: String? = nil, UnparsedFirstLineAddress: String? = nil, City: String? = nil, PostalCode: String?, StateOrProvince: String? = nil, UnparsedAddress: String? = nil, CurrentPricePublic: Int? = nil, ListPrice: Int? = nil, PublicRemarks: String? = nil, Photos:[PhotoDictionary]? = nil, Videos:[VideosObjs]? = nil, VirtualTours:[VirtualToursObjs]? = nil) {
            self.BathsFull = BathsFull ?? ""
            self.BedsTotal = BedsTotal ?? ""
            self.ListingId = ListingId ?? ""
            self.BuildingAreaTotal = BuildingAreaTotal ?? nil
            self.Latitude = Latitude ?? nil
            self.Longitude = Longitude ?? nil
            self.ListAgentName = ListAgentName ?? ""
            self.CoListAgentName = CoListAgentName ?? ""
            self.MlsStatus = MlsStatus ?? ""
            self.ListOfficePhone = ListOfficePhone ?? ""
            self.UnparsedFirstLineAddress = UnparsedFirstLineAddress ?? ""
            self.City = City ?? ""
            self.PostalCode = PostalCode ?? ""
            self.StateOrProvince = StateOrProvince ?? ""
            self.UnparsedAddress = UnparsedAddress ?? ""
            self.CurrentPricePublic = CurrentPricePublic ?? 0
            self.ListPrice = ListPrice ?? 0
            self.PublicRemarks = PublicRemarks ?? ""
            self.Photos = Photos ?? []
            self.Videos = Videos ?? []
            self.VirtualTours = VirtualTours ?? []
            
            
        }
        
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            Latitude = try container.decodeIfPresent(StringOrDouble.self, forKey: .Latitude)
            Longitude = try container.decodeIfPresent(StringOrDouble.self, forKey: .Longitude)
            ListingId = try container.decodeIfPresent(String.self, forKey: .ListingId)
            ListAgentName = try container.decode(String.self, forKey: .ListAgentName)
            MlsStatus = try container.decode(String.self, forKey: .MlsStatus)
            ListOfficePhone = try container.decodeIfPresent(String.self, forKey: .ListOfficePhone)
            UnparsedFirstLineAddress = try container.decodeIfPresent(String.self, forKey: .UnparsedFirstLineAddress)
            City = try container.decodeIfPresent(String.self, forKey: .City)
            PostalCode = try container.decodeIfPresent(String.self, forKey: .PostalCode)
            StateOrProvince = try container.decodeIfPresent(String.self, forKey: .StateOrProvince)
            UnparsedAddress = try container.decodeIfPresent(String.self, forKey: .UnparsedAddress)
            CurrentPricePublic = try container.decodeIfPresent(Int.self, forKey: .CurrentPricePublic)
            ListPrice = try container.decodeIfPresent(Int.self, forKey: .ListPrice)
            PublicRemarks = try container.decodeIfPresent(String.self, forKey: .PublicRemarks)
            Photos = try container.decodeIfPresent([PhotoDictionary].self, forKey: .Photos)
            Videos = try container.decodeIfPresent([VideosObjs].self, forKey: .Videos)
            VirtualTours = try container.decodeIfPresent([VirtualToursObjs].self, forKey: .VirtualTours)
            
            if let value = try? container.decode(Int.self, forKey: .BathsFull) {
                BathsFull = String(value)
            } else {
                BathsFull = try container.decodeIfPresent(String.self, forKey: .BathsFull) ?? ""
            }
            
            if let value = try? container.decode(Int.self, forKey: .BedsTotal) {
                BedsTotal = String(value)
            } else {
                BedsTotal = try container.decodeIfPresent(String.self, forKey: .BedsTotal) ?? ""
            }
            
            if let value = try? container.decode(String.self, forKey: .BuildingAreaTotal) {
                BuildingAreaTotal = Float(value)
            } else {
                BuildingAreaTotal = try? container.decode(Float.self, forKey: .BuildingAreaTotal)
            }
            
            if let value = try? container.decodeIfPresent(String.self, forKey: .CoListAgentName) {
                CoListAgentName = String(value)
            } else {
                CoListAgentName = nil
            }
            
        }
    }
    struct CustomFields: Codable {
        var main: [Main]?
        enum CodingKeys: String, CodingKey {
               case main = "Main"
           }
    }
    struct Main: Codable {
        let listingLocationAndPropertyInfo: [ListingLocationAndPropertyInfo]?
        let commissionInfo: [CommissionInfo]?
        let generalPropertyInformation: [GeneralPropertyInformation]?
        let miscLegal: [MiscLegal]?
        let propertyInfo: [PropertyInfo]?
        let statusChangeInfo: [StatusChangeInfo]?
        let currentlyNotUsed: [CurrentlyNotUsed]?
        let specialListingConditions: [SpecialListingCondition]?
        let cooling: [CoolingElement]?
        let view: [ViewElement]?
        let heating: [HeatingElement]?
        let laundry: [Laundry]?
        let roomType: [RoomType]?
        let fireplaceFeatures: [FireplaceFeature]?
        let flooring: [FlooringElement]?
        let poolFeatures: [PoolFeature]?
        let spaFeatures: [SPAFeature]?
        let commonWalls: [CommonWall]?
        let architecturalStyle: [ArchitecturalStyle]?
        let parkingSpacesInformation: [ParkingSpacesInformation]?
        let parking: [Parking]?
        let preferredOrderOfContact: [PreferredOrderOfContact]?
        let interiorFeatures: [InteriorFeature]?
        let utilities: [Utilit]?
        let appliances: [Appliance]?
        let associationInformation: [AssociationInformation]?
        let patioAndPorchFeatures: [PatioAndPorchFeature]?
        let hoa1Frequency, hoa2Frequency: [Frequency]?
        let securityFeatures: [SecurityFeature]?
        let associationAmenities: [AssociationAmenity]?
        let entryLocation: [EntryLocation]?
        let levels: [Level]?
        let eatingArea: [EatingArea]?
        let propertyCondition: [PropertyCondition]?
        let directionFaces: [DirectionFace]?
        let showingInformation: [ShowingInformation]?
        let disclosures: [Disclosure]?
        let dpr: [Dpr]?
        let otherStructures: [OtherStructure]?
        let bathroomFeatures: [BathroomFeature]?
        let kitchenFeatures: [KitchenFeature]?
        let lotFeatures: [LotFeature]?
        let waterSource: [BuyerFinancing]?
        let windowFeatures: [WindowFeature]?

        enum CodingKeys: String, CodingKey {
            case listingLocationAndPropertyInfo = "Listing, Location and Property Info"
            case commissionInfo = "Commission Info"
            case generalPropertyInformation = "General Property Information"
            case miscLegal = "Misc & Legal"
            case propertyInfo = "Property Info"
            case statusChangeInfo = "Status Change Info"
            case currentlyNotUsed = "Currently Not Used"
            case specialListingConditions = "Special Listing Conditions"
            case cooling = "Cooling"
            case view = "View"
            case heating = "Heating"
            case laundry = "Laundry"
            case roomType = "Room Type"
            case fireplaceFeatures = "Fireplace Features"
            case flooring = "Flooring"
            case poolFeatures = "Pool Features"
            case spaFeatures = "Spa Features"
            case commonWalls = "Common Walls"
            case architecturalStyle = "Architectural Style"
            case parkingSpacesInformation = "Parking Spaces/Information"
            case parking = "Parking"
            case preferredOrderOfContact = "Preferred Order of Contact"
            case interiorFeatures = "Interior Features"
            case utilities = "Utilities"
            case appliances = "Appliances"
            case associationInformation = "Association Information"
            case patioAndPorchFeatures = "Patio and Porch Features"
            case hoa1Frequency = "HOA 1 Frequency"
            case hoa2Frequency = "HOA 2 Frequency"
            case securityFeatures = "Security Features"
            case associationAmenities = "Association Amenities"
            case entryLocation = "Entry Location"
            case levels = "Levels"
            case eatingArea = "Eating Area"
            case propertyCondition = "Property Condition"
            case directionFaces = "Direction Faces"
            case showingInformation = "Showing Information"
            case disclosures = "Disclosures"
            case dpr = "DPR"
            case otherStructures = "Other Structures"
            case bathroomFeatures = "Bathroom Features"
            case kitchenFeatures = "Kitchen Features"
            case lotFeatures = "Lot Features"
            case waterSource = "Water Source"
            case windowFeatures = "Window Features"
        }
    }
    struct Appliance: Codable {
        let appliances: String?
        let dishwasher, freezer, refrigerator, disposal: Bool?
        let barbecue, ventedExhaustFan, microwave, trashCompactor: Bool?
        let doubleOven, warmingDrawer, builtIn: Bool?

        enum CodingKeys: String, CodingKey {
            case appliances = "Appliances"
            case dishwasher = "Dishwasher"
            case freezer = "Freezer"
            case refrigerator = "Refrigerator"
            case disposal = "Disposal"
            case barbecue = "Barbecue"
            case ventedExhaustFan = "Vented Exhaust Fan"
            case microwave = "Microwave"
            case trashCompactor = "Trash Compactor"
            case doubleOven = "Double Oven"
            case warmingDrawer = "Warming Drawer"
            case builtIn = "Built-In"
        }
    }
    // MARK: - Appliance
//    struct Appliance: Codable {
//        let appliances: String?
//        let dishwasher, freezer, refrigerator, disposal: Bool?
//        let barbecue, ventedExhaustFan, microwave, trashCompactor: Bool?
//        let doubleOven, warmingDrawer, builtIn: Bool?
//
//        enum CodingKeys: String, CodingKey {
//            case appliances = "Appliances"
//            case dishwasher = "Dishwasher"
//            case freezer = "Freezer"
//            case refrigerator = "Refrigerator"
//            case disposal = "Disposal"
//            case barbecue = "Barbecue"
//            case ventedExhaustFan = "Vented Exhaust Fan"
//            case microwave = "Microwave"
//            case trashCompactor = "Trash Compactor"
//            case doubleOven = "Double Oven"
//            case warmingDrawer = "Warming Drawer"
//            case builtIn = "Built-In"
//        }
//    }

    // MARK: - ArchitecturalStyle
    struct ArchitecturalStyle: Codable {
        let spanish, seeRemarks, mediterranean, midCenturyModern: Bool?
        let modern, contemporary: Bool?

        enum CodingKeys: String, CodingKey {
            case spanish = "Spanish"
            case seeRemarks = "See Remarks"
            case mediterranean = "Mediterranean"
            case midCenturyModern = "Mid Century Modern"
            case modern = "Modern"
            case contemporary = "Contemporary"
        }
    }

    // MARK: - AssociationAmenity
    struct AssociationAmenity: Codable {
        let pool: Bool?

        enum CodingKeys: String, CodingKey {
            case pool = "Pool"
        }
    }

    // MARK: - AssociationInformation
    struct AssociationInformation: Codable {
        let otherPhoneDescription, otherPhoneNumber: String?

        enum CodingKeys: String, CodingKey {
            case otherPhoneDescription = "Other Phone Description"
            case otherPhoneNumber = "Other Phone Number"
        }
    }

    // MARK: - BathroomFeature
    struct BathroomFeature: Codable {
        let showerInTub, vanityArea, hollywoodBathroomJackJill: Bool?

        enum CodingKeys: String, CodingKey {
            case showerInTub = "Shower in Tub"
            case vanityArea = "Vanity Area"
            case hollywoodBathroomJackJill = "Hollywood Bathroom (Jack & Jill)"
        }
    }

    // MARK: - CommissionInfo
    struct CommissionInfo: Codable {
        let buyerAgencyComp: Double?
        let buyerAgencyCompType: String?

        enum CodingKeys: String, CodingKey {
            case buyerAgencyComp = "Buyer Agency Comp"
            case buyerAgencyCompType = "Buyer Agency Comp Type"
        }
    }

    // MARK: - CommonWall
    struct CommonWall: Codable {
        let noCommonWalls: Bool?

        enum CodingKeys: String, CodingKey {
            case noCommonWalls = "No Common Walls"
        }
    }

    // MARK: - CoolingElement
    struct CoolingElement: Codable {
        let cooling: String?
        let centralAir, dual: Bool?

        enum CodingKeys: String, CodingKey {
            case cooling = "Cooling"
            case centralAir = "Central Air"
            case dual = "Dual"
        }
    }

    // MARK: - CurrentlyNotUsed
    struct CurrentlyNotUsed: Codable {
        let buyerAgencyCompensation: String?
        let lpSP: Double?
        let buyerAgentStateLicense, endingDate: String?
        let bathsFullAnd34, totalMonthlyAssociationFees: Int?

        enum CodingKeys: String, CodingKey {
            case buyerAgencyCompensation = "Buyer Agency Compensation"
            case lpSP = "LP/SP"
            case buyerAgentStateLicense = "Buyer Agent State License"
            case endingDate = "Ending Date"
            case bathsFullAnd34 = "Baths Full and 3/4"
            case totalMonthlyAssociationFees = "Total Monthly Association Fees"
        }
    }

    // MARK: - DirectionFace
    struct DirectionFace: Codable {
        let east: Bool?

        enum CodingKeys: String, CodingKey {
            case east = "East"
        }
    }

    // MARK: - Disclosure
    struct Disclosure: Codable {
        let ccAndRS: Bool?

        enum CodingKeys: String, CodingKey {
            case ccAndRS = "CC And R's"
        }
    }

    // MARK: - Dpr
    struct Dpr: Codable {
        let dprEligible: String?

        enum CodingKeys: String, CodingKey {
            case dprEligible = "DPR Eligible"
        }
    }

    // MARK: - EatingArea
    struct EatingArea: Codable {
        let familyKitchen, inKitchen, seeRemarks: Bool?

        enum CodingKeys: String, CodingKey {
            case familyKitchen = "Family Kitchen"
            case inKitchen = "In Kitchen"
            case seeRemarks = "See Remarks"
        }
    }

    // MARK: - EntryLocation
    struct EntryLocation: Codable {
        let entryLocation: String?

        enum CodingKeys: String, CodingKey {
            case entryLocation = "Entry Location"
        }
    }

    // MARK: - FireplaceFeature
    struct FireplaceFeature: Codable {
        let den, livingRoom, masterBedroom, decorative: Bool?
        let firePit, none, library, familyRoom: Bool?
        let greatRoom, woodBurning, gas, patio: Bool?
        let guestHouse, masterRetreat, diningRoom: Bool?

        enum CodingKeys: String, CodingKey {
            case den = "Den"
            case livingRoom = "Living Room"
            case masterBedroom = "Master Bedroom"
            case decorative = "Decorative"
            case firePit = "Fire Pit"
            case none = "None"
            case library = "Library"
            case familyRoom = "Family Room"
            case greatRoom = "Great Room"
            case woodBurning = "Wood Burning"
            case gas = "Gas"
            case patio = "Patio"
            case guestHouse = "Guest House"
            case masterRetreat = "Master Retreat"
            case diningRoom = "Dining Room"
        }
    }

    // MARK: - FlooringElement
    struct FlooringElement: Codable {
        let wood, stone, tile, carpet: Bool?

        enum CodingKeys: String, CodingKey {
            case wood = "Wood"
            case stone = "Stone"
            case tile = "Tile"
            case carpet = "Carpet"
        }
    }

    // MARK: - GeneralPropertyInformation
    struct GeneralPropertyInformation: Codable {
        let seniorCommunity, leaseConsidered: String?
        let entryLevel: Int?
        let livingAreaSource, landLeasePurchase, yearBuiltSource: String?

        enum CodingKeys: String, CodingKey {
            case seniorCommunity = "Senior Community"
            case leaseConsidered = "Lease Considered"
            case entryLevel = "Entry Level"
            case livingAreaSource = "Living Area Source"
            case landLeasePurchase = "Land Lease Purchase?"
            case yearBuiltSource = "Year Built Source"
        }
    }

    // MARK: - HeatingElement
    struct HeatingElement: Codable {
        let heating: String?
        let central, wallFurnace, fireplaceS, forcedAir: Bool?
        let radiant: Bool?

        enum CodingKeys: String, CodingKey {
            case heating = "Heating"
            case central = "Central"
            case wallFurnace = "Wall Furnace"
            case fireplaceS = "Fireplace(s)"
            case forcedAir = "Forced Air"
            case radiant = "Radiant"
        }
    }

    // MARK: - Frequency
    struct Frequency: Codable {
        let monthly: Bool?

        enum CodingKeys: String, CodingKey {
            case monthly = "Monthly"
        }
    }

    // MARK: - InteriorFeature
    struct InteriorFeature: Codable {
        let elevator, bar, furnished, highCeilings: Bool?
        let homeAutomationSystem, livingRoomBalcony, openFloorplan, recessedLighting: Bool?
        let storage, trackLighting, twoStoryCeilings: Bool?

        enum CodingKeys: String, CodingKey {
            case elevator = "Elevator"
            case bar = "Bar"
            case furnished = "Furnished"
            case highCeilings = "High Ceilings"
            case homeAutomationSystem = "Home Automation System"
            case livingRoomBalcony = "Living Room Balcony"
            case openFloorplan = "Open Floorplan"
            case recessedLighting = "Recessed Lighting"
            case storage = "Storage"
            case trackLighting = "Track Lighting"
            case twoStoryCeilings = "Two Story Ceilings"
        }
    }

    // MARK: - KitchenFeature
    struct KitchenFeature: Codable {
        let kitchenIsland, kitchenOpenToFamilyRoom, stoneCounters, walkInPantry: Bool?

        enum CodingKeys: String, CodingKey {
            case kitchenIsland = "Kitchen Island"
            case kitchenOpenToFamilyRoom = "Kitchen Open to Family Room"
            case stoneCounters = "Stone Counters"
            case walkInPantry = "Walk-In Pantry"
        }
    }

    // MARK: - Laundry
    struct Laundry: Codable {
        let laundry: String?
        let individualRoom, dryerIncluded, upperLevel, washerIncluded: Bool?
        let seeRemarks, community, inside: Bool?

        enum CodingKeys: String, CodingKey {
            case laundry = "Laundry"
            case individualRoom = "Individual Room"
            case dryerIncluded = "Dryer Included"
            case upperLevel = "Upper Level"
            case washerIncluded = "Washer Included"
            case seeRemarks = "See Remarks"
            case community = "Community"
            case inside = "Inside"
        }
    }

    // MARK: - Level
    struct Level: Codable {
        let multiSplit: Bool?

        enum CodingKeys: String, CodingKey {
            case multiSplit = "Multi/Split"
        }
    }

    // MARK: - ListingLocationAndPropertyInfo
    struct ListingLocationAndPropertyInfo: Codable {
        let listingKeyNumeric: Int?
        let entryDate, onMarketDate: String?
        let listPriceSqFt, schoolDistrict: Double?
        let postalCode4: Int?
        let listPriceAcre: Double?

        enum CodingKeys: String, CodingKey {
            case listingKeyNumeric = "ListingKeyNumeric"
            case entryDate = "Entry Date"
            case onMarketDate = "On Market Date"
            case listPriceSqFt = "List Price/SqFt"
            case schoolDistrict = "School District"
            case postalCode4 = "Postal Code + 4"
            case listPriceAcre = "List Price/Acre"
        }
    }

    // MARK: - LotFeature
    struct LotFeature: Codable {
        let sprinklers: String?

        enum CodingKeys: String, CodingKey {
            case sprinklers = "Sprinklers"
        }
    }

    // MARK: - MiscLegal
    struct MiscLegal: Codable {
        let lotSizeDimensions: String?

        enum CodingKeys: String, CodingKey {
            case lotSizeDimensions = "Lot Size Dimensions"
        }
    }

    // MARK: - OtherStructure
    struct OtherStructure: Codable {
        let guestHouse, barnS: Bool?

        enum CodingKeys: String, CodingKey {
            case guestHouse = "Guest House"
            case barnS = "Barn(s)"
        }
    }

    // MARK: - Parking
    struct Parking: Codable {
        let parking: String?
        let circularDriveway, driveway, garage, builtInStorage: Bool?
        let communityStructure, garageThreeDoor, concrete, controlledEntrance: Bool?
        let covered, directGarageAccess, garageTwoDoor, gated: Bool?
        let parkingPrivate, street, none, subterranean: Bool?
        let guest, sideBySide, porteCochere, attachedCarport: Bool?
        let detachedCarport: Bool?

        enum CodingKeys: String, CodingKey {
            case parking = "Parking"
            case circularDriveway = "Circular Driveway"
            case driveway = "Driveway"
            case garage = "Garage"
            case builtInStorage = "Built-In Storage"
            case communityStructure = "Community Structure"
            case garageThreeDoor = "Garage - Three Door"
            case concrete = "Concrete"
            case controlledEntrance = "Controlled Entrance"
            case covered = "Covered"
            case directGarageAccess = "Direct Garage Access"
            case garageTwoDoor = "Garage - Two Door"
            case gated = "Gated"
            case parkingPrivate = "Private"
            case street = "Street"
            case none = "None"
            case subterranean = "Subterranean"
            case guest = "Guest"
            case sideBySide = "Side by Side"
            case porteCochere = "Porte-Cochere"
            case attachedCarport = "Attached Carport"
            case detachedCarport = "Detached Carport"
        }
    }

    // MARK: - ParkingSpacesInformation
    struct ParkingSpacesInformation: Codable {
        let totalParkingSpaces, totalGarageSpaces, totalUncoveredAssignedSpaces, totalCarportSpaces: Int?

        enum CodingKeys: String, CodingKey {
            case totalParkingSpaces = "Total Parking Spaces"
            case totalGarageSpaces = "Total Garage Spaces"
            case totalUncoveredAssignedSpaces = "Total Uncovered/Assigned Spaces"
            case totalCarportSpaces = "Total Carport Spaces"
        }
    }

    // MARK: - PatioAndPorchFeature
    struct PatioAndPorchFeature: Codable {
        let patio: String?
        let patioOpen: Bool?

        enum CodingKeys: String, CodingKey {
            case patio = "Patio"
            case patioOpen = "Patio Open"
        }
    }

    // MARK: - PoolFeature
    struct PoolFeature: Codable {
        let inGround, permits, poolFeaturePrivate, community: Bool?
        let fenced, poolCover, seeRemarks, none: Bool?
        let heated, indoor, infinity, saltWater: Bool?

        enum CodingKeys: String, CodingKey {
            case inGround = "In Ground"
            case permits = "Permits"
            case poolFeaturePrivate = "Private"
            case community = "Community"
            case fenced = "Fenced"
            case poolCover = "Pool Cover"
            case seeRemarks = "See Remarks"
            case none = "None"
            case heated = "Heated"
            case indoor = "Indoor"
            case infinity = "Infinity"
            case saltWater = "Salt Water"
        }
    }

    // MARK: - PreferredOrderOfContact
    struct PreferredOrderOfContact: Codable {
        let preferredOrderOfContact1, preferredOrderOfContact3, preferredOrderOfContact4, preferredOrderOfContact6: String?
        let preferredOrderOfContact5: String?

        enum CodingKeys: String, CodingKey {
            case preferredOrderOfContact1 = "Preferred Order of Contact 1"
            case preferredOrderOfContact3 = "Preferred Order of Contact 3"
            case preferredOrderOfContact4 = "Preferred Order of Contact 4"
            case preferredOrderOfContact6 = "Preferred Order of Contact 6"
            case preferredOrderOfContact5 = "Preferred Order of Contact 5"
        }
    }

    // MARK: - PropertyCondition
    struct PropertyCondition: Codable {
        let updatedRemodeled: Bool?

        enum CodingKeys: String, CodingKey {
            case updatedRemodeled = "Updated/Remodeled"
        }
    }

    // MARK: - PropertyInfo
    struct PropertyInfo: Codable {
        let pool, spa, fireplace, view: String?

        enum CodingKeys: String, CodingKey {
            case pool = "Pool"
            case spa = "Spa"
            case fireplace = "Fireplace"
            case view = "View"
        }
    }

    // MARK: - RoomType
    struct RoomType: Codable {
        let bonusRoom, familyRoom, formalEntry, greatRoom: Bool?
        let guestMaidSQuarters, library, masterBathroom, sauna: Bool?
        let den, livingRoom, masterBedroom, walkInCloset: Bool?
        let seeRemarks, homeTheatre, wineCellar, office: Bool?
        let utilityRoom, walkInPantry, mediaRoom, recreation: Bool?
        let dressingArea, basement, projection, artStudio: Bool?
        let centerHall, danceStudio, entry, loft: Bool?
        let retreat: Bool?

        enum CodingKeys: String, CodingKey {
            case bonusRoom = "Bonus Room"
            case familyRoom = "Family Room"
            case formalEntry = "Formal Entry"
            case greatRoom = "Great Room"
            case guestMaidSQuarters = "Guest/Maid's Quarters"
            case library = "Library"
            case masterBathroom = "Master Bathroom"
            case sauna = "Sauna"
            case den = "Den"
            case livingRoom = "Living Room"
            case masterBedroom = "Master Bedroom"
            case walkInCloset = "Walk-In Closet"
            case seeRemarks = "See Remarks"
            case homeTheatre = "Home Theatre"
            case wineCellar = "Wine Cellar"
            case office = "Office"
            case utilityRoom = "Utility Room"
            case walkInPantry = "Walk-In Pantry"
            case mediaRoom = "Media Room"
            case recreation = "Recreation"
            case dressingArea = "Dressing Area"
            case basement = "Basement"
            case projection = "Projection"
            case artStudio = "Art Studio"
            case centerHall = "Center Hall"
            case danceStudio = "Dance Studio"
            case entry = "Entry"
            case loft = "Loft"
            case retreat = "Retreat"
        }
    }

    // MARK: - SecurityFeature
    struct SecurityFeature: Codable {
        let cardCodeAccess, gatedCommunity, smokeDetectorS, automaticGate: Bool?
        let carbonMonoxideDetectorS, fireAndSmokeDetectionSystem, fireSprinklerSystem: Bool?

        enum CodingKeys: String, CodingKey {
            case cardCodeAccess = "Card/Code Access"
            case gatedCommunity = "Gated Community"
            case smokeDetectorS = "Smoke Detector(s)"
            case automaticGate = "Automatic Gate"
            case carbonMonoxideDetectorS = "Carbon Monoxide Detector(s)"
            case fireAndSmokeDetectionSystem = "Fire and Smoke Detection System"
            case fireSprinklerSystem = "Fire Sprinkler System"
        }
    }

    // MARK: - ShowingInformation
    struct ShowingInformation: Codable {
        let showingContactPhone: String?

        enum CodingKeys: String, CodingKey {
            case showingContactPhone = "Showing Contact Phone"
        }
    }

    // MARK: - SPAFeature
    struct SPAFeature: Codable {
        let inGround, none, bath, heated: Bool?
        let spaFeaturePrivate: Bool?

        enum CodingKeys: String, CodingKey {
            case inGround = "In Ground"
            case none = "None"
            case bath = "Bath"
            case heated = "Heated"
            case spaFeaturePrivate = "Private"
        }
    }

    // MARK: - SpecialListingCondition
    struct SpecialListingCondition: Codable {
        let standard: Bool?

        enum CodingKeys: String, CodingKey {
            case standard = "Standard"
        }
    }

    // MARK: - StatusChangeInfo
    struct StatusChangeInfo: Codable {
        let autoSold: String?
        let soldPriceSqFt, soldPriceAcre: Double?

        enum CodingKeys: String, CodingKey {
            case autoSold = "Auto Sold"
            case soldPriceSqFt = "Sold Price/SqFt"
            case soldPriceAcre = "Sold Price/Acre"
        }
    }

    // MARK: - Utilit
    struct Utilit: Codable {
        let cableAvailable: Bool?

        enum CodingKeys: String, CodingKey {
            case cableAvailable = "Cable Available"
        }
    }

    // MARK: - ViewElement
    struct ViewElement: Codable {
        let cityLights, golfCourse, treesWoods, none: Bool?
        let courtyard, coastline, mountainS, ocean: Bool?
        let orchard, panoramic, water, pool: Bool?
        let canyon, creekStream, hills, valley: Bool?
        let parkGreenbelt, bay, catalina: Bool?

        enum CodingKeys: String, CodingKey {
            case cityLights = "City Lights"
            case golfCourse = "Golf Course"
            case treesWoods = "Trees/Woods"
            case none = "None"
            case courtyard = "Courtyard"
            case coastline = "Coastline"
            case mountainS = "Mountain(s)"
            case ocean = "Ocean"
            case orchard = "Orchard"
            case panoramic = "Panoramic"
            case water = "Water"
            case pool = "Pool"
            case canyon = "Canyon"
            case creekStream = "Creek/Stream"
            case hills = "Hills"
            case valley = "Valley"
            case parkGreenbelt = "Park/Greenbelt"
            case bay = "Bay"
            case catalina = "Catalina"
        }
    }

    // MARK: - BuyerFinancing
    struct BuyerFinancing: Codable {
        let buyerFinancingPrivate: Bool?

        enum CodingKeys: String, CodingKey {
            case buyerFinancingPrivate = "Private"
        }
    }

    // MARK: - WindowFeature
    struct WindowFeature: Codable {
        let customCovering: Bool?

        enum CodingKeys: String, CodingKey {
            case customCovering = "Custom Covering"
        }
    }

    // MARK: - DisplayCompliance
    struct DisplayCompliance: Codable {
        let view: String?

        enum CodingKeys: String, CodingKey {
            case view = "View"
        }
    }
}
