//
//  KeychainHelper.swift
//  25521523Q2_iOS
//
//  Created by APPLE on 2025/10/15.
//

import Foundation
import Security

final class KeychainHelper {
    private init() {}

    static func generateAndSaveKey(name: String) throws -> SecKey {
        removeKey(name: name)
        let tag = name.data(using: .utf8)!
        let attrs: [String: Any] = [
            kSecAttrKeyType as String       : kSecAttrKeyTypeEC,
            kSecAttrKeySizeInBits as String : 256,
            kSecAttrTokenID as String       : kSecAttrTokenIDSecureEnclave,
            kSecPrivateKeyAttrs as String   : [
                kSecAttrIsPermanent as String    : true,
                kSecAttrApplicationTag as String : tag
            ]
        ]
        var err: Unmanaged<CFError>?
        guard let priv = SecKeyCreateRandomKey(attrs as CFDictionary, &err) else {
            throw err!.takeRetainedValue() as Error
        }
        return priv
    }

    static func getKey(name: String) -> SecKey? {
        let tag = name.data(using: .utf8)!
        let q: [String: Any] = [
            kSecClass as String              : kSecClassKey,
            kSecAttrApplicationTag as String : tag,
            kSecAttrKeyType as String        : kSecAttrKeyTypeEC,
            kSecReturnRef as String          : true
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(q as CFDictionary, &item)
        guard status == errSecSuccess else { return nil }
        return (item as! SecKey)
    }

    static func removeKey(name: String) {
        let tag = name.data(using: .utf8)!
        let q: [String: Any] = [
            kSecClass as String              : kSecClassKey,
            kSecAttrApplicationTag as String : tag
        ]
        SecItemDelete(q as CFDictionary)
    }
}
