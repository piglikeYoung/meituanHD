//
//  MTHttpTool.m
//  美团HD
//
//  Created by piglikeyoung on 15/11/13.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import "MTHttpTool.h"
#import "DPAPI.h"

@interface MTHttpTool()<DPRequestDelegate>

@end

@implementation MTHttpTool
static DPAPI *_api;
+ (void)initialize {
    _api = [[DPAPI alloc] init];
}

- (void)request:(NSString *)url pamras:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    DPRequest *request = [_api requestWithURL:url params:params delegate:self];
    request.success = success;
    request.failure = failure;
}

#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    if (request.success) {
        request.success(result);
    }
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    if (request.failure) {
        request.failure(error);
    }
}


@end
