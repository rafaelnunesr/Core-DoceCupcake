extension Array {
    func asyncCompactMap<T>(_ transform: (Element) async throws -> T?) async rethrows -> [T] {
        var results = [T]()
        results.reserveCapacity(self.count)
        
        for element in self {
            if let transformed = try await transform(element) {
                results.append(transformed)
            }
        }
        
        return results
    }
    
    func asyncMap<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
        var results = [T]()
        results.reserveCapacity(self.count)
        
        for element in self {
            try await results.append(transform(element))
        }
        
        return results
    }
}
