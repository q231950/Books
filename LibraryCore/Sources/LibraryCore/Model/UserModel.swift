//
//  UserModel.swift
//  
//
//  Created by Kim Dung-Pham on 23.01.21.
//

import Foundation

public struct UserModel: Codable {
        struct Body: Codable {
            let getBorrowerSummaryResponse: GetBorrowerSummaryResponse

            struct GetBorrowerSummaryResponse: Codable {
                let getBorrowerSummaryResult: GetBorrowerSummaryResult
                
                struct GetBorrowerSummaryResult: Codable {
//                    let userId: String
                }
            }
    }
    let body: Body
}
