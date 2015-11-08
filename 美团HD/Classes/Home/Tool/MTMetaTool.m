//
//  MTMetaTool.m
//  美团HD
//
//  Created by piglikeyoung on 15/11/8.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//  

#import "MTMetaTool.h"
#import "MTCity.h"
#import "MJExtension.h"

@implementation MTMetaTool
static NSArray *_cities;

+ (NSArray *)cities {
    if (!_cities) {
        _cities = [MTCity objectArrayWithFilename:@"cities.plist"];;
    }
    return _cities;
}
@end
