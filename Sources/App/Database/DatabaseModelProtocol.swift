import FluentPostgresDriver
import Vapor

protocol DatabaseModelProtocol: Codable, Model where IDValue == UUID {
    var code: String { get }

    static var idKey: KeyPath<Self, IDProperty<Self, UUID>> { get }
    static var codeKey: KeyPath<Self, Field<String>> { get }
}
