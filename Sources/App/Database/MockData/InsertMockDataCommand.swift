//import Vapor
//import Fluent
//
//struct InsertMockDataCommand: Command {
//    fileprivate let security = Security()
//    
//    var help: String {
//        "Inserts mock data into the database"
//    }
//
//    func run(using context: CommandContext, signature: Signature) throws {
//        let app = context.application
//        let db = app.db
//
//        try insertMockUsers(db)
//        try insertMockAdmins(db)
//        try insertMockProductTags(db)
//        try insertMockVouchers(db)
//        try insertMockProducts(db)
//        try insertMockPackages(db)
//        
//        
//        context.console.print("Mock data inserted successfully!")
//    }
//
//    struct Signature: CommandSignature { }
//}
//
//// MARK: - CREATE USERS
//extension InsertMockDataCommand {
//    private func insertMockUsers(_ db: Database) throws {
//        let password = try security.hashStringValue("12345678A")
//        
//        let john = User(id: UUID(),
//                        createdAt: Date(),
//                        userName: "John Smith",
//                        email: "john@email.com",
//                        password: password,
//                        imageUrl: nil)
//        
//        let mary = User(id: UUID(),
//                        createdAt: Date(),
//                        userName: "Mary Scott",
//                        email: "mary@email.com",
//                        password: password,
//                        imageUrl: nil)
//        
//        _ = john.create(on: db)
//        _ = mary.create(on: db)
//    }
//    
//    private func insertMockAdmins(_ db: Database) throws {
//        let password = try security.hashStringValue("12345678A")
//        let john = Admin(id: UUID(),
//                        createdAt: Date(),
//                        userName: "John Smith",
//                        email: "john+admin@email.com",
//                        password: password)
//        
//        let mary = Admin(id: UUID(),
//                        createdAt: Date(),
//                        userName: "Mary Scott",
//                        email: "mary+admin@email.com",
//                        password: password)
//        
//        _ = john.create(on: db)
//        _ = mary.create(on: db)
//    }
//}
//
//// MARK: - CREATE ADDRESS
//extension InsertMockDataCommand {
//    private func insertMockAddresses(_ db: Database, userId: UUID) throws {
//        let firstAddress = Address(id: UUID(),
//                                   createdAt: Date(),
//                                   userId: userId,
//                                   streetName: "Main Street",
//                                   number: "1234",
//                                   zipCode: "90210",
//                                   complementary: "",
//                                   state: "CA",
//                                   city: "Anytown",
//                                   country: "USA")
//        
//        let secondAddress = Address(id: UUID(),
//                                    createdAt: Date(),
//                                    userId: userId,
//                                    streetName: "Second Street",
//                                    number: "9874",
//                                    zipCode: "5612230",
//                                    complementary: "",
//                                    state: "CA",
//                                    city: "Anytown",
//                                    country: "USA")
//        
//        _ = firstAddress.create(on: db)
//        _ = secondAddress.create(on: db)
//    }
//}
//    
//// MARK: - CREATE PRODUCT TAGS
//extension InsertMockDataCommand {
//    private func insertMockProductTags(_ db: Database) throws {
//        let tagA = ProductTag(id: UUID(), code: "C-01", description: "Vegan")
//        let tagB = ProductTag(id: UUID(), code: "C-02", description: "Vegetarian")
//        let tagC = ProductTag(id: UUID(), code: "C-03", description: "Nuts")
//        let tagD = ProductTag(id: UUID(), code: "C-04", description: "Milk")
//        let tagE = ProductTag(id: UUID(), code: "C-05", description: "Sugar")
//        
//        _ = tagA.create(on: db)
//        _ = tagB.create(on: db)
//        _ = tagC.create(on: db)
//        _ = tagD.create(on: db)
//        _ = tagE.create(on: db)
//    }
//}
//
//// MARK: - CREATE VOUCHERS
//extension InsertMockDataCommand {
//    private func insertMockVouchers(_ db: Database) throws {
//        let currentDate = Date()
//        let futureDate = Calendar.current.date(byAdding: .day, value: 10, to: currentDate)
//        let voucherA = Voucher(id: UUID(), 
//                               createdAt: Date(),
//                               expiryDate: futureDate ?? Date(), 
//                               code: "10_OFF",
//                               percentageDiscount: 10,
//                               monetaryDiscount: nil,
//                               availabilityCount: 1000)
//        
//        let voucherB = Voucher(id: UUID(),
//                               createdAt: Date(),
//                               expiryDate: futureDate ?? Date(),
//                               code: "50_OFF",
//                               percentageDiscount: nil,
//                               monetaryDiscount: 50,
//                               availabilityCount: 1000)
//        
//        let voucherC = Voucher(id: UUID(),
//                               createdAt: Date(),
//                               expiryDate: futureDate ?? Date(),
//                               code: "30_OFF",
//                               percentageDiscount: 30,
//                               monetaryDiscount: nil,
//                               availabilityCount: nil)
//        
//        _ = voucherA.create(on: db)
//        _ = voucherB.create(on: db)
//        _ = voucherC.create(on: db)
//    }
//}
//
//// MARK: - CREATE PRODUCTS
//extension InsertMockDataCommand {
//    private func insertMockProducts(_ db: Database) throws {
//        let nutritionalA = NutritionalInformation(id: UUID(), code: "01", name: "Saturated Fat", quantityDescription: "0.5g", dailyRepresentation: "1%")
//        let nutritionalB = NutritionalInformation(id: UUID(), code: "02", name: "Trans Fat", quantityDescription: "0g", dailyRepresentation: "0%")
//        let nutritionalC = NutritionalInformation(id: UUID(), code: "03", name: "Vitamin D", quantityDescription: "10mg", dailyRepresentation: "0.5%")
//        let nutritionalD = NutritionalInformation(id: UUID(), code: "04", name: "Total Sugars", quantityDescription: "40g", dailyRepresentation: "10%")
//        
//        _ = nutritionalA.create(on: db)
//        _ = nutritionalB.create(on: db)
//        _ = nutritionalC.create(on: db)
//        _ = nutritionalD.create(on: db)
//        
//        let allergicInfo = AllergicInfo(hasEggs: true, hasMilk: true)
//        
//        let productA = Product(id: UUID(),
//                               createdAt: Date(),
//                               code: "789456123",
//                               name: "Cupcake dark chocolate",
//                               description: "A delicious cupcake with dark chocolate",
//                               imageUrl: "https://github.com/rafaelnunesr/Image/blob/main/cupkcake.png?raw=true",
//                               currentPrice: 9.99,
//                               originalPrice: 14.99,
//                               voucherCode: "10_OFF",
//                               stockCount: 50,
//                               launchDate: Date(),
//                               tags: ["C-01", "C-04"],
//                               allergicInfo: allergicInfo,
//                               nutritionalIds: [nutritionalA.id!, nutritionalB.id!, nutritionalC.id!],
//                               isNew: true)
//        
//        let productB = Product(id: UUID(),
//                               createdAt: Date(),
//                               code: "789123456",
//                               name: "Cupcake light chocolate",
//                               description: "A delicious cupcake with light chocolate",
//                               imageUrl: "https://github.com/rafaelnunesr/Image/blob/main/cupcake2.png?raw=true",
//                               currentPrice: 13.49,
//                               originalPrice: 15.29,
//                               voucherCode: "50_OFF",
//                               stockCount: 18,
//                               launchDate: Date(),
//                               tags: ["C-02", "C-03"],
//                               allergicInfo: allergicInfo,
//                               nutritionalIds: [nutritionalA.id!, nutritionalB.id!, nutritionalD.id!],
//                               isNew: false)
//        
//        let productC = Product(id: UUID(),
//                               createdAt: Date(),
//                               code: "789654321",
//                               name: "Cupcake with strawberries",
//                               description: "A delicious cupcake with strawberries",
//                               imageUrl: "https://github.com/rafaelnunesr/Image/blob/main/cupkcake.png?raw=true",
//                               currentPrice: 9.99,
//                               originalPrice: 14.99,
//                               voucherCode: "10_OFF",
//                               stockCount: 50,
//                               launchDate: Date(),
//                               tags: ["C-01", "C-04"],
//                               allergicInfo: allergicInfo,
//                               nutritionalIds: [nutritionalA.id!, nutritionalB.id!, nutritionalC.id!, nutritionalD.id!],
//                               isNew: true)
//        
//        let productD = Product(id: UUID(),
//                               createdAt: Date(),
//                               code: "789415263",
//                               name: "Cupcake with orange",
//                               description: "A delicious cupcake with orange",
//                               imageUrl: "https://github.com/rafaelnunesr/Image/blob/main/cupcake2.png?raw=true",
//                               currentPrice: 4.99,
//                               originalPrice: 9.99,
//                               voucherCode: "50_OFF",
//                               stockCount: 77,
//                               launchDate: Date(),
//                               tags: ["C-03", "C-04", "C-05"],
//                               allergicInfo: allergicInfo,
//                               nutritionalIds: [nutritionalB.id!, nutritionalC.id!, nutritionalD.id!],
//                               isNew: false)
//        
//        let productE = Product(id: UUID(),
//                               createdAt: Date(),
//                               code: "789362514",
//                               name: "Cupcake raspberries",
//                               description: "A delicious cupcake with raspberries",
//                               imageUrl: "https://github.com/rafaelnunesr/Image/blob/main/cupkcake.png?raw=true",
//                               currentPrice: 7.99,
//                               originalPrice: 9.99,
//                               voucherCode: "30_OFF",
//                               stockCount: 54,
//                               launchDate: Date(),
//                               tags: ["C-01", "C-05"],
//                               allergicInfo: allergicInfo,
//                               nutritionalIds: [nutritionalA.id!, nutritionalC.id!, nutritionalD.id!],
//                               isNew: false)
//        
//        _ = productA.create(on: db)
//        _ = productB.create(on: db)
//        _ = productC.create(on: db)
//        _ = productD.create(on: db)
//        _ = productE.create(on: db)
//        
//    }
//}
//
//// MARK: - CREATE PACKAGES
//extension InsertMockDataCommand {
//    private func insertMockPackages(_ db: Database) throws {
//        let packageA = Package(id: UUID(),
//                               createdAt: Date(),
//                               code: "PK-A",
//                               name: "Package A",
//                               description: "A package",
//                               width: 20,
//                               height: 20,
//                               depth: 20,
//                               price: 3.99,
//                               stockCount: 30)
//        
//        let packageB = Package(id: UUID(),
//                               createdAt: Date(),
//                               code: "PK-B",
//                               name: "Package B",
//                               description: "A package",
//                               width: 20,
//                               height: 20,
//                               depth: 20,
//                               price: 3.99,
//                               stockCount: 30)
//        
//        let packageC = Package(id: UUID(),
//                               createdAt: Date(),
//                               code: "PK-C",
//                               name: "Package C",
//                               description: "A package",
//                               width: 20,
//                               height: 20,
//                               depth: 20,
//                               price: 3.99,
//                               stockCount: 30)
//        
//        _ = packageA.create(on: db)
//        _ = packageB.create(on: db)
//        _ = packageC.create(on: db)
//    }
//}
