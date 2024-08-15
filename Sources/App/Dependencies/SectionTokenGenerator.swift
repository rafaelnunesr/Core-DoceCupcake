import Foundation

protocol SectionTokenGeneratorProtocol {
    func getToken() -> String
}

final class SectionTokenGenerator: SectionTokenGeneratorProtocol {
    func getToken() -> String {
        let randomData = Data(0...255).map { _ in UInt8.random(in: 0...255) }
        return randomData.map { String(format: "%02hhx", $0) }.joined()
    }
}
