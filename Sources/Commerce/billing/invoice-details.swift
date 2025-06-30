import Foundation
import plate

public enum InvoiceAddressType: Sendable {
    case billing
    case shipping
}

public struct InvoiceAddressDetail: Sendable {
    public let type: InvoiceAddressType
    public let street: String // Some Street
    public let number: String // 51
    public let area: String // 1058PJ
    public let place: String // Amsterdam
    
    public init(
        type: InvoiceAddressType,
        street: String,
        number: String,
        area: String,
        place: String
    ) {
        self.type = type
        self.street = street
        self.number = number
        self.area = area
        self.place = place
    }
}

public struct InvoiceClientContactDetails: Sendable {
    public let email: String
    public let phone: String
    
    public init(
        email: String,
        phone: String
    ) {
        self.email = email
        self.phone = phone
    }
}

public struct InvoiceClientDetail: Sendable {
    public let name: String
    public let infix: String?
    public let middle: String?
    public let surname: String?
    public let contact: InvoiceClientContactDetails 
    
    public init(
        name: String,
        infix: String?,
        middle: String?,
        surname: String?,
        contact: InvoiceClientContactDetails
    ) {
        self.name = name
        self.infix = infix
        self.middle = middle
        self.surname = surname
        self.contact = contact
    }

    public var fullName: String {
        var parts: [String] = [name]
        if let infix = infix { parts.append(infix) }
        if let middle = middle { parts.append(middle) }
        if let surname = surname { parts.append(surname) }
        return parts.joined(separator: " ")
    }
}

public struct InvoiceDogDetail: Sendable {
    public let name: String
    public let chip: String?
    public let breed: String?
    public let passport: String?
    public let birthdate: String?
    
    public init(
        name: String,
        chip: String?,
        breed: String?,
        passport: String?,
        birthdate: String?
    ) {
        self.name = name
        self.chip = chip
        self.breed = breed
        self.passport = passport
        self.birthdate = birthdate
    }
}

public struct InvoiceDetails: Sendable {
    public let client: InvoiceClientDetail
    public let dog: InvoiceDogDetail
    public let address: [InvoiceAddressDetail]
    
    public init(
        client: InvoiceClientDetail,
        dog: InvoiceDogDetail,
        address: [InvoiceAddressDetail]
    ) {
        self.client = client
        self.dog = dog
        self.address = address
    }
}
