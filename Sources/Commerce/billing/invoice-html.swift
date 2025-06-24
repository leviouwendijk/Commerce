import Foundation

extension InvoiceData {
    public var invoiceDataHTML: String {
        var html = ""
        
        // Line items
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
            let indent = item.parentId != nil ? "&nbsp;&nbsp;&nbsp;&nbsp;" : ""
            html += """
                    <tr>
                        <td style="padding:4px;">\(indent)\(item.name)</td>
                        <td style="text-align:center; padding:4px;">\(item.count)</td>
                        <td style="text-align:right; padding:4px;">€\(String(format: "%.2f", abs(item.rate)))</td>
                        <td style="text-align:right; padding:4px;">€\(String(format: "%.2f", abs(item.subtotal)))</td>
                    </tr>
            """
        }
        html += """
            </tbody>
        </table>
        
        """

        // Payments
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
                html += """
                        <tr>
                            <td style="padding:4px;">Betaling \(index + 1)</td>
                            <td style="text-align:right; padding:4px;">€\(String(format: "%.2f", abs(payment.amount)))</td>
                        </tr>
                """
            }
            html += """
                </tbody>
            </table>
            
            """
        }

        // Summary
        html += """
        <p class="emphasis-title" style="margin-top:24px;"><i>Samenvatting</i></p>
        <table style="width:100%; font-size:12px; border-collapse: collapse;">
            <tr>
                <td style="font-weight:500; padding:4px;">Subtotaal</td>
                <td style="text-align:right; padding:4px;">€\(String(format: "%.2f", abs(netTotal)))</td>
            </tr>
        """
        if !payments.isEmpty {
            html += """
            <tr>
                <td style="font-weight:500; padding:4px;">Reeds betaald</td>
                <td style="text-align:right; padding:4px;">–€\(String(format: "%.2f", abs(paymentTotal)))</td>
            </tr>
            """
        }
        let label = finalBalance >= 0 ? "Te betalen" : "Te ontvangen"
        html += """
            <tr>
                <td style="font-weight:700; padding:4px;">\(label)</td>
                <td style="text-align:right; font-weight:700; padding:4px;">€\(String(format: "%.2f", abs(finalBalance)))</td>
            </tr>
        </table>
        """

        return html
    }
}
