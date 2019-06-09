//
//  AccountView.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 08.06.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import SwiftUI

struct AccountView : View {
    var body: some View {
        return Text("Account View")
            .font(.title)
            .tabItemLabel(
                Text("Account")
            )
            .tag(1)
    }
}


#if DEBUG
struct AccountView_Previews : PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
#endif
