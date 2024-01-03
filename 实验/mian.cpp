#include <cstdio>
#include<iostream>
#include<cmath>
using namespace std;
#include "aes.h"
int flag = 0;
int main() 
{
    AES_Key Key;
    uint8_t key[256 / 8] = { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
                            0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
                            0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
                            0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f };
    uint8_t plaintext[16] = { 0x00, 0x00, 0x11, 0x11, 0x22, 0x22, 0x33, 0x33,
                             0x44, 0x44, 0x55, 0x55, 0x66, 0x66, 0xff, 0xff };
    uint8_t ciphertext[16];
    cout <<"plaintext: ";
    for (int i = 0; i < 16; i++)
        printf("%02x ", plaintext[i]);
    cout << endl;

    flag = AES_KeyInit(key, &Key, 128);
    if (flag != 0) {
        cout<<"AES 128:"<<endl;
        AES_Encrypt(plaintext, ciphertext, Key);
        cout << "密文 ";
        for (int i = 0; i < 16; i++) 
            printf("%02x ", ciphertext[i]);
        cout << endl << "明文: ";
        AES_Decrypt(ciphertext, plaintext, Key);
        for (int i = 0; i < 16; i++) 
            printf("%02x ", plaintext[i]);
        cout<<endl;
        AES_KeyDelete(Key);
        cout << "加密解密通过";
        flag = 0;
    }
  
    /*
    AES_KeyInit(key, &Key, 256);
    cout << "AES 256:" << endl;
    cout << "ciphertext: ";
    AES_Encrypt(plaintext, ciphertext, Key);
    for (int i = 0; i < 16; i++) 
         printf("%02x ", ciphertext[i]);
    cout << endl<<"re-plaintext: ";
    AES_Decrypt(ciphertext, plaintext, Key);
    for (int i = 0; i < 16; i++) 
         printf("%02x ", plaintext[i]);
    cout << endl;
    AES_KeyDelete(Key);
       */
    return 0;
}