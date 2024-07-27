//
//  UserProvider.swift
//  ConstableOnPatrol
//
//  Created by Mac on 18/07/24.
//

import UIKit

struct UserProvider: Codable {
       let token: String
       let _id: String
       let userName: String?
       let phoneNumber: String?
//       let dateOfBirth: String?
//       let gender: String?
//       let address: String
//       let userRole: String?
//       let isLoggedIn: Bool?
//       let active: Bool?
//       let __v: Int?
    
    init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          token = try container.decode(String.self, forKey: .token)
          _id = try container.decode(String.self, forKey: ._id)
          userName = try container.decodeIfPresent(String.self, forKey: .userName)
//          address = try container.decode(String.self, forKey: .address)
          phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
//        dateOfBirth = try container.decodeIfPresent(String.self, forKey: .dateOfBirth)
//        gender = try container.decode(String.self, forKey: .gender)
//        userRole = try container.decodeIfPresent(String.self, forKey: .userRole)
//        isLoggedIn = try container.decodeIfPresent(Bool.self, forKey: .isLoggedIn)
//        active = try container.decodeIfPresent(Bool.self, forKey: .active)
//        __v = try container.decodeIfPresent(Int.self, forKey: .__v)
      }
    private enum CodingKeys: String, CodingKey {
            case token
            case _id
            case userName
            case phoneNumber
//            case dateOfBirth
//            case gender
//            case address
//            case userRole
//            case isLoggedIn
//        case active
//        case __v
        }
}

