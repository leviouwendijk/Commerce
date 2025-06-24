import Foundation
import plate
import Structures
import Extensions

public enum InvoiceLineItemError: Error, Sendable {
    case negativeRateNotAllowed
    case negativeCountNotAllowed
    // case invalidVATPercentage
}

// public struct InvoiceLineItemVAT: Sendable {
//     public let percentage: Double
//     public let amount: Double

//     public init(percentage: Double, on gross: Double) throws {
//         guard percentage >= 0 && percentage <= 100 else {
//             throw InvoiceLineItemError.invalidVATPercentage
//         }

//         self.percentage = percentage
//         self.amount = gross - (gross / (1 + (percentage / 100)))
//     }
// }

public struct InvoiceLineItem: Identifiable, Sendable {
    public let id: UUID
    public let parentId: UUID?
    public let name: String
    public let direction: ValueDirection
    public let count: Double
    public let rate: Double
    public let subtotal: Double
    
    public init(
        id: UUID = UUID(),
        parentId: UUID?,
        name: String,
        direction: ValueDirection,
        count: Double,
        rate: Double
    ) throws {
        guard count >= 0 else {
            throw InvoiceLineItemError.negativeCountNotAllowed
        }

        guard rate >= 0 else {
            throw InvoiceLineItemError.negativeRateNotAllowed
        }

        self.id = id
        self.parentId = parentId
        self.name = name
        self.direction = direction
        self.count = count
        self.rate = ( rate.orient(to: direction) )
        self.subtotal = (count * self.rate)
    }
}

public struct InvoicePayment: Identifiable, Sendable {
    public let id: UUID
    public let amount: Double
    
    public init(
        id: UUID = UUID(),
        amount: Double
    ) {
        self.id = id
        self.amount = amount.orient(to: .credit)
    }
}

public struct InvoiceData: Identifiable, Sendable {
    public let id: Int
    public let details: InvoiceDetails
    public let content: [InvoiceLineItem]
    public let payments: [InvoicePayment]
    
    public init(
        id: Int,
        details: InvoiceDetails,
        content: [InvoiceLineItem],
        payments: [InvoicePayment]
    ) {
        self.id = id
        self.details = details
        self.content = content
        self.payments = payments
    }

    public var netTotal: Double {
        content.map(\.subtotal).reduce(0, +)
    }

    public var paymentTotal: Double {
        payments.map(\.amount).reduce(0, +)
    }

    public var finalBalance: Double {
        netTotal - paymentTotal
    }
}
