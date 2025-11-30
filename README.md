# Mobile Encryption Demos

Project Duration: Sep 2025 – Oct 2025

A cross-platform mobile encryption showcase featuring two standalone apps:

1. **Android AES Encryption Demo** – password-based symmetric encryption  
2. **iOS Secure Enclave Public-Key Encryption Demo** – asymmetric encryption with hardware-backed key protection

This repository demonstrates practical message security workflows, modern cryptography usage on mobile devices, and user-friendly interfaces for performing secure encryption and decryption operations.


## 1. Android App — AES Message Encryption

### Overview
A lightweight Android application that encrypts and decrypts messages using **AES symmetric encryption** derived from a user-provided password.  
The app provides an intuitive UI to demonstrate how raw text is transformed into cipher text, and how a correct/incorrect password affects the decryption result.

### Key Features
- Input fields for:
  - Message text
  - Password
- One display area showing encryption or decryption result
- “Encrypt” and “Decrypt” buttons (large size for clarity)
- AES encryption using a password-based key
- Incorrect password detection with a toast alert
- Fully offline; no data leaves the device

### Technical Notes
- AES/CBC or AES/GCM (depending on your implementation)
- Key derived from password using PBKDF2-style key derivation
- Secure random IV generation
- Graceful error handling for invalid credentials

<img height="500" alt="image" src="https://github.com/user-attachments/assets/73879f7a-d039-4997-a629-c000207b534a" />


## 2. iOS App — Public-Key Encryption with Secure Enclave

### Overview
An iOS application that performs **public-key encryption** using an asymmetric key pair generated and stored inside **Apple Keychain + Secure Enclave**.  
This demonstrates hardware-backed key protection and modern cryptographic practices in iOS.

### Key Features
- Text input field for plaintext messages
- “Encrypt” button to encrypt with the public key
- Display area showing:
  - Encrypted message
  - Public key (Base64 or printable format)
- “Decrypt” button using the Secure Enclave private key
- Final output showing the decrypted message

### Security Properties
- Private key remains inside Secure Enclave (cannot be exported)
- Public key stored in Keychain for retrieval
- End-to-end encryption workflow fully local to device
- Hardware-protected private key operations

### Technical Notes
- SecKey API for key generation and encryption/decryption
- Secure Enclave attributes for private key storage
- Error-resistant decryption flow
- UIKit-based clean interface layout
<img height="500" alt="image" src="https://github.com/user-attachments/assets/4edf0ab7-d4d3-42d7-94c3-6d5e0f11f755" />


## 3. Technologies Used

### Android
- Java / Kotlin  
- AES symmetric encryption  
- Key derivation (password → AES key)  
- Android UI components (EditText, TextView, Buttons)  
- Toast notifications for user feedback  

### iOS
- Swift  
- Secure Enclave  
- Keychain Services  
- Asymmetric cryptography (public/private key pair)  
- UIKit (TextField, TextView, Buttons)  




