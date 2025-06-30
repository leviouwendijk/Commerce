import Foundation
import plate
import Structures
import Extensions

public struct CertificationData: Identifiable, Sendable {
    public let id: Int
    public let details: InvoiceDetails
    public let trainingDateRange: String
    
    public init(
        id: Int,
        details: InvoiceDetails,
        trainingDateRange: String,
    ) {
        self.id = id
        self.details = details
        self.trainingDateRange = trainingDateRange
    }
}
