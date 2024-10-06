struct AllergicInfo: Codable {
    var hasEggs = false
    var hasMilk = false
    var hasWheat = false
    var hasSoy = false
    var hasNuts = false
    
    enum CodingKeys: String, CodingKey {
        case hasEggs = "has_eggs"
        case hasMilk = "has_milk"
        case hasWheat = "has_wheat"
        case hasSoy = "has_soy"
        case hasNuts = "has_nuts"
    }
}
