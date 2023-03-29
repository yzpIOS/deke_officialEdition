//
//  NSString+Utility.m
//  TianLi_Proprietor
//
//  Created by Allen on 5/20/16.
//  Copyright © 2016 TianLi. All rights reserved.
//

#import "NSString+Utility.h"
#import <netinet/in.h>
#import <arpa/inet.h>

@implementation NSString (Utility)

//校验String是否为空
- (BOOL)validateStringEqualToValid
{
    NSString *validateStr = self;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    validateStr = [validateStr stringByTrimmingCharactersInSet:whitespace];
    
    if (!validateStr || [validateStr isEqualToString:@""])
    {
        return NO;
    }
    
    return YES;
}

//NSString 是否包含某个string
- (BOOL)stringContainsString:(NSString*)other
{
    if (IS_iOS8)
    {
        return [self containsString:other];
    }
    else
    {
        NSRange range = [self rangeOfString:other];
        return range.length != 0;
    }
}




//转换为JSON
+ (NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

+ (NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+ (NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

+ (NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [NSString jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NSString jsonStringWithArray:object];
    }
    else
    {
        value = [NSString jsonStringWithString:[NSString stringWithFormat:@"%@", object]];
    }
    return value;
}

//域名解析是否有限制
+ (BOOL)resolveHost:(NSString *)hostname {
    
    Boolean result = NO;
    
    CFHostRef hostRef;
    
    CFArrayRef addresses;
    
    NSString *ipAddress = nil;
    
    hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)hostname);
    
    if(hostRef) {
        
        result = CFHostStartInfoResolution(hostRef,kCFHostAddresses,NULL);// pass an error instead of NULL here to find out why it failed
        
        if (result) {
            
            addresses =CFHostGetAddressing(hostRef, &result);
            
        }
        
    }
    
    if (result) {
        
        CFIndex index = 0;
        
        CFDataRef ref = (CFDataRef)CFArrayGetValueAtIndex(addresses, index);
        
        int port = 0;
        
        struct sockaddr *addressGeneric;
        
        NSData *myData = (__bridge NSData *)ref;
        
        addressGeneric = (struct sockaddr *)[myData bytes];
        
        switch(addressGeneric->sa_family) {
                
            case AF_INET: {
                
                struct sockaddr_in *ip4;
                
                char dest[INET_ADDRSTRLEN];
                
                ip4 = (struct sockaddr_in*)[myData bytes];
                
                port = ntohs(ip4->sin_port);
                
                ipAddress = [NSString stringWithFormat:@"%s",inet_ntop(AF_INET, &ip4->sin_addr, dest,sizeof dest)];
                
            }
                
                break;
                
            case AF_INET6: {
                
                struct sockaddr_in6*ip6;
                
                char dest[INET6_ADDRSTRLEN];
                
                ip6 = (struct sockaddr_in6 *)[myData bytes];
                
                port = ntohs(ip6->sin6_port);
                
                ipAddress = [NSString stringWithFormat:@"%s",inet_ntop(AF_INET6, &ip6->sin6_addr, dest,sizeof dest)];
                
            }
                
                break;
                
            default:
                
                ipAddress = nil;
                
                break;
                
        }
        
    }
    
    if (ipAddress) {
        
        return YES;
        
    } else {
        
        return NO;
        
    }
    
}

@end
