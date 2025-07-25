// import Foundation
// import plate

// extension InvoiceData {
//     public func replacements() -> [StringTemplateReplacement] {
//         let billing = details.address.first(where: { $0.type == .billing })

//         let dateString = DateFormatter.localizedString(
//             from: Date(),
//             dateStyle: .medium,
//             timeStyle: .none
//         )

//         return [
//             StringTemplateReplacement(
//                 placeholders: ["client_fullname"],
//                 replacement: details.client.fullName,
//                 initializer: .auto
//             ),
//             StringTemplateReplacement(
//                 placeholders: ["client_names_inline"],
//                 replacement: details.client.fullName.strippingBreaks(),
//                 initializer: .auto
//             ),
//             StringTemplateReplacement(
//                 placeholders: ["client_email"],
//                 replacement: details.client.contact.email,
//                 initializer: .auto
//             ),
//             StringTemplateReplacement(
//                 placeholders: ["client_phone"],
//                 replacement: details.client.contact.phone,
//                 initializer: .auto
//             ),
//             StringTemplateReplacement(
//                 placeholders: ["dog_name"],
//                 replacement: details.dog.name,
//                 initializer: .auto
//             ),
//             StringTemplateReplacement(
//                 placeholders: ["dog_breed"],
//                 replacement: details.dog.breed ?? "-",
//                 initializer: .auto
//             ),
//             StringTemplateReplacement(
//                 placeholders: ["dog_chip"],
//                 replacement: details.dog.chip ?? "-",
//                 initializer: .auto
//             ),
//             StringTemplateReplacement(
//                 placeholders: ["dog_passport"],
//                 replacement: details.dog.passport ?? "-",
//                 initializer: .auto
//             ),
//             StringTemplateReplacement(
//                 placeholders: ["dog_birthdate"],
//                 replacement: details.dog.birthdate ?? "-",
//                 initializer: .auto
//             ),
//             StringTemplateReplacement(
//                 placeholders: ["billing_street"],
//                 replacement: billing?.street ?? "",
//                 initializer: .auto
//             ),
//             StringTemplateReplacement(
//                 placeholders: ["billing_number"],
//                 replacement: billing?.number ?? "",
//                 initializer: .auto
//             ),
//             StringTemplateReplacement(
//                 placeholders: ["billing_area"],
//                 replacement: billing?.area ?? "",
//                 initializer: .auto
//             ),
//             StringTemplateReplacement(
//                 placeholders: ["billing_place"],
//                 replacement: billing?.place ?? "",
//                 initializer: .auto
//             ),
//             StringTemplateReplacement(
//                 placeholders: ["date"],
//                 replacement: dateString,
//                 initializer: .auto
//             ),
//             StringTemplateReplacement(
//                 placeholders: ["document_label"],
//                 replacement: self.finalBalance.payableOrReceivable().documentLabel(),
//                 initializer: .auto
//             ),
//             StringTemplateReplacement(
//                 placeholders: ["invoice_data"],
//                 replacement: invoiceDataHTML,
//                 initializer: .auto
//             )
//         ]
//     }
// }
