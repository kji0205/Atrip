//
//  Extension.swift
//  Atrip
//
//  Created by jimmy on 2020/04/08.
//  Copyright © 2020 jimmy. All rights reserved.
//

import Foundation

extension Dictionary {
    var queryString: String {
        var output = ""
        for (key, value) in self {
            output = output + "\(key)=\(value)&"
        }
        
        output = String(output.dropLast())
        return output
    }
}

