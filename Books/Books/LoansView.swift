//
//  LoansView.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 08.06.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import SwiftUI

struct LoansView : View {
    var body: some View {
        return List {
            LoanCell()
            LoanCell()
            }
            .tag(0)
            .tabItemLabel(
                Text("Loans")
        )
    }
}


#if DEBUG
struct LoansView_Previews : PreviewProvider {
    static var previews: some View {
        LoansView()
    }
}
#endif

struct LoanCell : View {
    var body: some View {
        return VStack {
            Text("Loan 1")
                .font(.headline)
            Text("abc")
                .font(.subheadline)
            
        }
    }
}
