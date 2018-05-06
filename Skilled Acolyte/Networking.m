//
//  Networking.m
//  Skilled Acolyte
//
//  Created by Daniel Sykes-Turner on 5/5/18.
//  Copyright © 2018 UNIHACK Inc. All rights reserved.
//

#import "Networking.h"
#import "Skilled_Acolyte-Swift.h"

@interface Networking()
@property (nonatomic,strong) NSURLSession *sessionManager;
@end

@implementation Networking

- (void)requestMethod:(NSString *)httpMethod url:(NSString *)url body:(NSDictionary *)body completionHandler:(void(^)(NSError *error, NSDictionary *jsonData))completionHandler {

    // TODO: figure out what i'm syntaxing here
    
//    NSString *sth = Constants.HOST_URL;
    
//    NSURL *fullUrl = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@", Constants.HOST_URL, url]];
}

@end
