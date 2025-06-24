import Foundation
import Structures

public struct InvoiceLineItem: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let direction: ValueDirection
    public let count: Double
    public let rate: Double
    public let subtotal: Double
    
    public init(
        id: UUID,
        name: String,
        direction: ValueDirection,
        count: Double,
        rate: Double
    ) {
        self.id = UUID()
        self.name = name
        self.direction = direction
        self.count = count
        self.rate = rate
        self.subtotal = (count * rate)
    }
}


public struct InvoiceData: Identifiable, Sendable {
    public let id: Int
    public let content: [InvoiceLineItem]
}
