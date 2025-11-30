package com.example.a25521523app1;

import android.os.Bundle;
import android.util.Base64;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Arrays;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

public class MainActivity extends AppCompatActivity {

    private EditText etMessage, etPassword;
    private TextView tvResult;
    private Button btnEncrypt, btnDecrypt;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Bind views
        etMessage = findViewById(R.id.etMessage);
        etPassword = findViewById(R.id.etPassword);
        tvResult   = findViewById(R.id.tvResult);
        btnEncrypt = findViewById(R.id.btnEncrypt);
        btnDecrypt = findViewById(R.id.btnDecrypt);

        // Click listeners
        btnEncrypt.setOnClickListener(v -> onEncrypt());
        btnDecrypt.setOnClickListener(v -> onDecrypt());
    }

    private void onEncrypt() {
        String msg = etMessage.getText().toString();
        String pwd = etPassword.getText().toString();

        if (msg.isEmpty() || pwd.isEmpty()) {
            Toast.makeText(this, "Message and password required", Toast.LENGTH_SHORT).show();
            return;
        }
        try {
            String cipherB64 = encrypt(msg, pwd);
            tvResult.setText(cipherB64);
        } catch (Exception e) {
            Toast.makeText(this, "Encrypt failed", Toast.LENGTH_SHORT).show();
        }
    }

    private void onDecrypt() {
        String cipherB64 = tvResult.getText().toString();
        String pwd = etPassword.getText().toString();

        if (cipherB64.isEmpty() || pwd.isEmpty()) {
            Toast.makeText(this, "Ciphertext and password required", Toast.LENGTH_SHORT).show();
            return;
        }
        try {
            String plain = decrypt(cipherB64, pwd);
            tvResult.setText(plain);
        } catch (Exception e) {
            Toast.makeText(this, "Incorrect password, try again please", Toast.LENGTH_SHORT).show();
        }
    }

    private static SecretKeySpec generateKey(String password) throws Exception {
        MessageDigest sha = MessageDigest.getInstance("SHA-256");
        byte[] key = sha.digest(password.getBytes(StandardCharsets.UTF_8));
        key = Arrays.copyOf(key, 16);
        return new SecretKeySpec(key, "AES");
    }

    private static String encrypt(String plainText, String password) throws Exception {
        SecretKeySpec keySpec = generateKey(password);
        Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, keySpec);
        byte[] out = cipher.doFinal(plainText.getBytes(StandardCharsets.UTF_8));
        return Base64.encodeToString(out, Base64.DEFAULT);
    }

    private static String decrypt(String base64CipherText, String password) throws Exception {
        SecretKeySpec keySpec = generateKey(password);
        Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
        cipher.init(Cipher.DECRYPT_MODE, keySpec);
        byte[] decoded = Base64.decode(base64CipherText, Base64.DEFAULT);
        byte[] out = cipher.doFinal(decoded);
        return new String(out, StandardCharsets.UTF_8);
    }
}