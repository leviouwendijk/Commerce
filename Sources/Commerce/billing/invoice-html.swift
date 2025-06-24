import Foundation

extension InvoiceData {
    public var invoiceDataHTML: String {
        var html = ""

        // Line items
        html += """
        <p class="emphasis-title"><i>Specificatie</i></p>
        <table class="line-items-table">
            <thead>
                <tr>
                    <th style="text-align:left;">Omschrijving</th>
                    <th style="text-align:center;">Aantal</th>
                    <th style="text-align:right;">Tarief</th>
                    <th style="text-align:right;">Subtotaal</th>
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
              <td>\(indentSymbol)\(item.name)</td>
              <td class="col-amount" style="text-align:center;">\(item.count)</td>
              <td class="col-rate"   style="text-align:right;">\(rateStr)</td>
              <td style="text-align:right;">\(subtotalStr)</td>
            </tr>
            """
        }

        // sum
        let netMag = String(format: "%.2f", abs(netTotal))
        let netStr = netTotal < 0 ? "(€\(netMag))" : "€\(netMag)"
        html += """
            <tr class="table-subtotal-row">
              <td colspan="3" class="table-subtotal-label">Totaal leverbare goederen en diensten</td>
              <td class="table-subtotal-value">\(netStr)</td>
            </tr>
        """

        html += """
            </tbody>
        </table>
        
        """

        // Payments
        if !payments.isEmpty {
            html += """
            <p class="emphasis-title" style="margin-top:24px;"><i>Betalingen</i></p>
            <table class="payments-table">
              <thead>
                <tr>
                  <th style="text-align:left;"></th>
                  <th style="text-align:right;"></th>
                </tr>
              </thead>
              <tbody>
            """
            for payment in payments {
                let amtMag = String(format: "%.2f", abs(payment.amount))
                let amtStr = payment.amount < 0 ? "(€\(amtMag))" : "€\(amtMag)"
                html += """
                  <tr>
                    <td>\(payment.details)</td>
                    <td style="text-align:right;">\(amtStr)</td>
                  </tr>
                """
            }

            // sum
            let paidMag = String(format: "%.2f", abs(paymentTotal))
            let paidStr = paymentTotal < 0 ? "(€\(paidMag))" : "€\(paidMag)"
            html += """
                  <tr class="table-subtotal-row">
                    <td class="table-subtotal-label">Totaal voldane betalingen</td>
                    <td class="table-subtotal-value">\(paidStr)</td>
                  </tr>
            """

            html += """
              </tbody>
            </table>
            
            """
        }

        // Samenvatting
        html += """
        <p class="emphasis-title" style="margin-top:24px;"><i>Samenvatting</i></p>
        <table class="final-overview-table">
          <tr>
            <td style="font-weight:500;">Som leverbare goederen en diensten</td>
            <td style="text-align:right;">\(netTotal < 0 ? "(€\(String(format: "%.2f", abs(netTotal)))" : "€\(String(format: "%.2f", netTotal))")</td>
          </tr>
        """
        if !payments.isEmpty {
            let paidMag = String(format: "%.2f", abs(paymentTotal))
            let paidStr = paymentTotal < 0 ? "(€\(paidMag))" : "€\(paidMag)"
            html += """
              <tr>
                <td style="font-weight:500;">Reeds voldane betalingen</td>
                <td style="text-align:right;">\(paidStr)</td>
              </tr>
            """
        }
        let finalMag = String(format: "%.2f", abs(finalBalance))
        let finalStr = finalBalance < 0 ? "(€\(finalMag))" : "€\(finalMag)"
        let label    = finalBalance >= 0 ? "Te betalen" : "Te ontvangen"
        html += """
          <tr>
            <td style="font-weight:700;">\(label)</td>
            <td style="text-align:right; font-weight:700;">\(finalStr)</td>
          </tr>
        </table>
        """

        return html
    }
}
