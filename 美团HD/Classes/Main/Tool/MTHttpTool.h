//
//  MTHttpTool.h
//  美团HD
//
//  Created by piglikeyoung on 15/11/13.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTHttpTool : NSObject
- (void)request:(NSString *)url pamras:(NSMutableDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end
