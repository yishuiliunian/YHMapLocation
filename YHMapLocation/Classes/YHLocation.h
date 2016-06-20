//
//  YHLocation.h
//  YaoHe
//
//  Created by stonedong on 16/5/1.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHLocation : NSObject
@property (nonatomic, assign) double longtitude;
@property (nonatomic, assign) double latitude;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* address;
@end
