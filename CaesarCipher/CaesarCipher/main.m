//
//  main.m
//  CaesarCipher
//
//  Created by Michael Kavouras on 6/21/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaesarCipher : NSObject

- (NSString *)encode:(NSString *)string offset:(int)offset;
- (NSString *)decode:(NSString *)string offset:(int)offset;
- (BOOL)codeBreaker:(NSString *)string1 withStrings:(NSString *)string2;
@end


@implementation CaesarCipher

- (NSString *)encode:(NSString *)string offset:(int)offset {
    if (offset > 25) {
        NSAssert(offset < 26, @"offset is out of range. 1 - 25");
    }
    NSString *str = [string lowercaseString];
    unsigned long count = [string length];
    unichar result[count];
    unichar buffer[count];
    [str getCharacters:buffer range:NSMakeRange(0, count)];
    
    char allchars[] = "abcdefghijklmnopqrstuvwxyz";
    
    for (int i = 0; i < count; i++) {
        if (buffer[i] == ' ' || ispunct(buffer[i])) {
            result[i] = buffer[i];
            continue;
        }
        
        char *e = strchr(allchars, buffer[i]);
        int idx= (int)(e - allchars);
        int new_idx = (idx + offset) % strlen(allchars);
        
        result[i] = allchars[new_idx];
    }
    
    return [NSString stringWithCharacters:result length:count];
}

- (NSString *)decode:(NSString *)string offset:(int)offset {
    return [self encode:string offset: (26 - offset)];
}

- (BOOL)codeBreaker:(NSString *)string1 withStrings:(NSString *)string2 {
    
    BOOL result = NO;
    
    for (int i = 1; i <= 25; i++) {
        
        NSString * decodedString = [self decode:string1 offset:i];
        
        for (int j = 1; j <= 25; j++) {
            
            NSString * decodedString2 = [self decode:string2 offset:j];
            
            if ([decodedString isEqualToString:decodedString2]) {
                
                result = YES;
                
                NSLog(@"%@ decoded is %@ using offset %d", string1, decodedString, i);
                
                NSLog(@"%@ decoded is %@ using offset %d", string2, decodedString2, j);
                
                return result;
            }
        }
    }
    
    return result;
}

@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        CaesarCipher *cipherInstance = [[CaesarCipher alloc]init];
        
        NSString *kaisha = @"kaisha";
        NSString *jones = @"jones";
        NSString *encodedKai1 = [cipherInstance encode:kaisha offset:2];
        NSString *encodedKai2 = [cipherInstance encode:jones offset:3];
        
        BOOL isSame = [cipherInstance codeBreaker:encodedKai1 withStrings:encodedKai2];
        
        NSLog(@"Are these ciphers the same? %s", isSame ? "YES":"NO");
        
    }
}
