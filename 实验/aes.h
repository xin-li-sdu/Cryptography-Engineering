#pragma once
#include <stdint.h>
typedef struct AES_Key {
    uint32_t* ek;  // AES��������Կ
    uint32_t* dk;  // AES ��������Կ
    uint32_t nr;   //��������
} AES_Key;
int AES_KeyInit(uint8_t* key, AES_Key* Key, size_t bits);
void AES_Encrypt(uint8_t* plaintext, uint8_t* ciphertext, AES_Key Key);
void AES_Decrypt(uint8_t* ciphertext, uint8_t* plaintext, AES_Key Key);
void AES_KeyDelete(AES_Key Key);