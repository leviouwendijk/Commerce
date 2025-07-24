import Foundation
import plate
import Structures
import Extensions
import Economics

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

public struct VATObject: Sendable, Codable {
    public let rate: Double
    public let tax: Double
    
    public init(
        rate: Double,
        gross: Double
    ) {
        self.rate = rate
        self.tax = gross.vat(rate)
    }

    public init(
        rate: Double,
        net: Double
    ) {
        self.rate = rate
        self.tax = net.vat(rate, using: .net, returning: .vat)
    }
}

public struct InvoiceLineItemUnit: Sendable, Codable {
    public let gross: Double
    public let net: Double
    public let vat: VATObject

    public init(
        gross: Double,
        net: Double,
        vat: VATObject
    ) {
        self.gross = gross
        self.net = net
        self.vat = vat
    }
    
    public init(
        net: Double,
        vatRate: Double
    ) {
        self.net = net
        self.vat = VATObject(rate: vatRate, net: net)
        self.gross = net.vat(vatRate, using: .net, returning: .receivable)
    }
    
    public init(
        gross: Double,
        vatRate: Double
    ) {
        self.gross = gross
        self.vat = VATObject(rate: vatRate, gross: gross)
        self.net = gross.vat(vatRate, using: .gross, returning: .revenue)
    }

    enum CodingKeys: String, CodingKey {
        case gross, net, vat, vatRate
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let gross = try c.decode(Double.self, forKey: .gross)

        if c.contains(.vatRate) {
            // payload: { gross, vatRate }
            let rate = try c.decode(Double.self, forKey: .vatRate)
            self = InvoiceLineItemUnit(gross: gross, vatRate: rate)

        } else if c.contains(.net) && c.contains(.vat) {
            // payload: { gross, net, vat: { rate, tax } }
            let net = try c.decode(Double.self, forKey: .net)
            let vat = try c.decode(VATObject.self, forKey: .vat)
            self = InvoiceLineItemUnit(gross: gross, net: net, vat: vat)

        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .gross,
                in: c,
                debugDescription: "InvoiceLineItemUnit needs either (gross,vatRate) or (gross,net,vat)."
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(gross, forKey: .gross)
        try c.encode(net,     forKey: .net)
        try c.encode(vat,     forKey: .vat)
    }
}

public struct InvoiceLineItemSubtotal: Sendable, Codable {
    public let gross: Double
    public let net: Double
    public let vat: Double
    
    public init(
        unit: InvoiceLineItemUnit,
        count: Double,
        direction: ValueDirection
    ) {
        let orientedGross = unit.gross.orient(to: direction)
        let orientedNet   = unit.net.orient(to: direction)
        let orientedVat   = unit.vat.tax.orient(to: direction)

        self.gross = orientedGross * count
        self.net   = orientedNet * count
        self.vat   = orientedVat * count
    }
}

public struct InvoiceLineItem: Identifiable, Sendable, Codable {
    public let id: UUID
    public let parentId: UUID?
    public let name: String
    public let direction: ValueDirection
    public let count: Double
    // public let rate: Double
    public let unit: InvoiceLineItemUnit
    public let subtotal: InvoiceLineItemSubtotal
    
    public init(
        id: UUID = UUID(),
        parentId: UUID?,
        name: String,
        direction: ValueDirection,
        count: Double,
        unit: InvoiceLineItemUnit
    ) throws {
        guard count >= 0 else {
            throw InvoiceLineItemError.negativeCountNotAllowed
        }

        guard unit.gross >= 0 else {
            throw InvoiceLineItemError.negativeRateNotAllowed
        }

        self.id = id
        self.parentId = parentId
        self.name = name
        self.direction = direction
        self.count = count
        self.unit = unit
        self.subtotal = InvoiceLineItemSubtotal(unit: unit, count: count, direction: direction)
    }
}

public struct InvoicePayment: Identifiable, Sendable, Codable {
    public let id: UUID
    public let details: String
    public let amount: Double
    
    public init(
        id: UUID = UUID(),
        details: String,
        amount: Double
    ) {
        self.id = id
        self.details = details
        self.amount = amount.orient(to: .credit)
    }
}

public struct InvoiceData: Identifiable, Sendable, Codable {
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
        content.map(\.subtotal.net).reduce(0, +)
    }

    public var vatTotal: Double {
        content.map(\.subtotal.vat).reduce(0, +)
    }

    public var reconcilableTotal: Double {
        content.map(\.subtotal.gross).reduce(0, +)
    }

    public var paymentTotal: Double {
        payments.map(\.amount).reduce(0, +)
    }

    public var finalBalance: Double {
        reconcilableTotal + paymentTotal
    }
}
