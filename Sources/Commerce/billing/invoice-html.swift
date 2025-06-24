import Foundation

extension InvoiceData {
    public var invoiceDataHTML: String {
        var html = ""
        
        html += """
        <p class="emphasis-title"><i>Specificatie</i></p>
        <table style="width:100%; font-size:12px; border-collapse: collapse;">
            <thead>
                <tr>
                    <th style="text-align:left; padding:4px;">Omschrijving</th>
                    <th style="text-align:center; padding:4px;">Aantal</th>
                    <th style="text-align:right; padding:4px;">Tarief</th>
                    <th style="text-align:right; padding:4px;">Totaal</th>
                </tr>
            </thead>
            <tbody>
        """
        for item in content {
            let indentSymbol = item.parentId != nil ? "└─ " : ""
            let rateMag     = String(format: "%.2f", abs(item.rate))
            let rateStr     = item.rate < 0 ? "(€\(rateMag))" : "€\(rateMag)"
            let subtotalMag = String(format: "%.2f", abs(item.subtotal))
            let subtotalStr = item.subtotal < 0 ? "(€\(subtotalMag))" : "€\(subtotalMag)"
            
            html += """
            <tr>
              <td style="padding:4px;">\(indentSymbol)\(item.name)</td>
              <td style="text-align:center; padding:4px;">\(item.count)</td>
              <td style="text-align:right; padding:4px;">\(rateStr)</td>
              <td style="text-align:right; padding:4px;">\(subtotalStr)</td>
            </tr>
            """
        }
        html += """
            </tbody>
        </table>
        
        """

        if !payments.isEmpty {
            html += """
            <p class="emphasis-title" style="margin-top:24px;"><i>Betalingen</i></p>
            <table style="width:100%; font-size:12px; border-collapse: collapse;">
                <thead>
                    <tr>
                        <th style="text-align:left; padding:4px;">Omschrijving</th>
                        <th style="text-align:right; padding:4px;">Bedrag</th>
                    </tr>
                </thead>
                <tbody>
            """
            for (index, payment) in payments.enumerated() {
                let payMag = String(format: "%.2f", abs(payment.amount))
                let payStr = payment.amount < 0 ? "(€\(payMag))" : "€\(payMag)"
                html += """
                        <tr>
                            <td style="padding:4px;">Betaling \(index + 1)</td>
                            <td style="text-align:right; padding:4px;">\(payStr)</td>
                        </tr>
                """
            }
            html += """
                </tbody>
            </table>
            
            """
        }

        html += """
        <p class="emphasis-title" style="margin-top:24px;"><i>Samenvatting</i></p>
        <table style="width:100%; font-size:12px; border-collapse: collapse;">
            <tr>
                <td style="font-weight:500; padding:4px;">Subtotaal</td>
        """
        let netMag = String(format: "%.2f", abs(netTotal))
        let netStr = netTotal < 0 ? "(€\(netMag))" : "€\(netMag)"
        html += """
                <td style="text-align:right; padding:4px;">\(netStr)</td>
            </tr>
        """
        if !payments.isEmpty {
            let paidMag = String(format: "%.2f", abs(paymentTotal))
            let paidStr = paymentTotal < 0 ? "(€\(paidMag))" : "€\(paidMag)"
            html += """
            <tr>
                <td style="font-weight:500; padding:4px;">Reeds voldane betalingen</td>
                <td style="text-align:right; padding:4px;">\(paidStr)</td>
            </tr>
            """
        }
        let finalMag = String(format: "%.2f", abs(finalBalance))
        let finalStr = finalBalance < 0 ? "(€\(finalMag))" : "€\(finalMag)"
        let label = finalBalance >= 0 ? "Te betalen" : "Te ontvangen"
        html += """
            <tr>
                <td style="font-weight:700; padding:4px;">\(label)</td>
                <td style="text-align:right; font-weight:700; padding:4px;">\(finalStr)</td>
            </tr>
        </table>
        """

        return html
    }
}
