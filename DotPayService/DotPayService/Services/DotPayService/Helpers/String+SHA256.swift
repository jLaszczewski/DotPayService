//
//  SHA256Helper.swift
//  WebViewDotPayment
//
//  Created by Jakub Łaszczewski on 25/04/2019.
//  Copyright © 2019 let'S. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    func sha256() -> String? {
        
        guard let str = self.cString(using: String.Encoding.utf8) else { return nil }
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_SHA256_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)

        CC_SHA256(str, strLen, result)

        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }

        result.deallocate()

        return String(format: hash as String)
    }
}
