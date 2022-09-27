//
//  User.swift
//  SecureImageViewer
//
//  Created by Артур Фомин on 27.09.2022.
//

import Foundation

class User: Codable {
    let name: String
    let password: String
    
    init(name: String, password: String) {
        self.name = name
        self.password = password
    }
    
    enum CodingKeys: String, CodingKey {
            case name, password
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.name = try container.decode(String.self, forKey: .name)
            self.password = try container.decode(String.self, forKey: .password)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.name, forKey: .name)
            try container.encode(self.password, forKey: .password)
        }
}
