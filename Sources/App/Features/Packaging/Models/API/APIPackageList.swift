import Vapor

struct APIPackageList: Content {
    let count: Int
    let package: [APIPackage]
}
