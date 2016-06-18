//
//  YHLocationCellElement.h
//  YaoHe
//
//  Created by stonedong on 16/5/1.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <ElementKit/ElementKit.h>
#import "YHLocation.h"
@interface YHLocationCellElement : EKAdjustCellElement
@property (nonatomic, strong, readonly) YHLocation* location;
- (instancetype) initWithLocation:(YHLocation*)location;
@end
