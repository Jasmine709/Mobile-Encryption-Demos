//
//  ViewController.swift
//  25521523Q2_iOS
//
//  Created by APPLE on 2025/10/15.
//

import UIKit
import Security

class ViewController: UIViewController {
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var keyTextView: UITextView!
    @IBOutlet weak var encryptedTextView: UITextView!
    @IBOutlet weak var decryptedTextView: UITextView!
   
    private var keyName = "25521523"
    
    private var privateKey: SecKey?
       private var cipherTextData: Data?

       override func viewDidLoad() {
           super.viewDidLoad()
           keyTextView.text = ""
           encryptedTextView.text = ""
           decryptedTextView.text = ""
       }

       private func prepareKey() -> Bool {
           if privateKey != nil { return true }
           if let k = KeychainHelper.getKey(name: keyName) { privateKey = k; return true }
           do { privateKey = try KeychainHelper.generateAndSaveKey(name: keyName); return true }
           catch { print("Create key failed: \(error)"); return false }
       }

       private func publicKeyBase64() -> String? {
           guard let priv = privateKey, let pub = SecKeyCopyPublicKey(priv) else { return nil }
           var err: Unmanaged<CFError>?
           if let data = SecKeyCopyExternalRepresentation(pub, &err) as Data? {
               return data.base64EncodedString()
           }
           return nil
       }

       private func encrypt(_ text: String) {
           guard prepareKey() else { return }
           guard let pub = SecKeyCopyPublicKey(privateKey!) else { return }

           let alg: SecKeyAlgorithm = .eciesEncryptionCofactorVariableIVX963SHA256AESGCM
           guard SecKeyIsAlgorithmSupported(pub, .encrypt, alg) else { return }

           var err: Unmanaged<CFError>?
           let clear = Data(text.utf8)
           guard let cipher = SecKeyCreateEncryptedData(pub, alg, clear as CFData, &err) as Data? else { return }
           self.cipherTextData = cipher

           // 分开展示（严格符合“one Text View for key, one for encrypted message”）
           keyTextView.text = publicKeyBase64() ?? "N/A"
           encryptedTextView.text = cipher.base64EncodedString()
       }

       private func decryptCurrentCipher() {
           guard prepareKey() else { return }
           guard let cipher = cipherTextData else { decryptedTextView.text = "No ciphertext"; return }

           let alg: SecKeyAlgorithm = .eciesEncryptionCofactorVariableIVX963SHA256AESGCM
           guard SecKeyIsAlgorithmSupported(privateKey!, .decrypt, alg) else { return }

           var err: Unmanaged<CFError>?
           guard let clear = SecKeyCreateDecryptedData(privateKey!, alg, cipher as CFData, &err) as Data? else { return }
           decryptedTextView.text = String(decoding: clear, as: UTF8.self)
       }
    
    
    @IBAction func encryptButtonTapped(_ sender: Any) {
        guard let text = inputTextField.text, !text.isEmpty else { return }
                encrypt(text)
    }
    @IBAction func decryptButtonTapped(_ sender: Any) {
        decryptCurrentCipher()
    }


}

