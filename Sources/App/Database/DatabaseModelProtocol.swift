import FluentPostgresDriver
import Vapor

//extension Model {
//    var code: String { get }
//
//    // Key paths for id and code
//    static var idKey: KeyPath<Self, FieldProperty<Self, UUID?>> { get }
//    static var codeKey: KeyPath<Self, FieldProperty<Self, String>> { get }
//}


protocol DatabaseModelProtocol: Model {
    var id: UUID? { get }
    var code: String { get }

    // Key paths for id and code
    static var idKey: KeyPath<Self, FieldProperty<Self, UUID?>> { get }
    static var codeKey: KeyPath<Self, FieldProperty<Self, String>> { get }
}
