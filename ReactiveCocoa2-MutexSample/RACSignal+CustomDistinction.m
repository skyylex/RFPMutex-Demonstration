//
//  RACSignal+CustomDistinction.m
//  ReactiveCocoa2-MutexSample
//
//  Created by Yury Lapitsky on 17.10.15.
//  Copyright © 2015 skyylex. All rights reserved.
//

#import "RACSignal+CustomDistinction.h"

@implementation RACSignal (CustomDistinction)

- (RACSignal *)distinctBasedOnRule:(PassRuleBlock)passRuleBlock {
    Class class = self.class;
    
    return [[self bind:^{
        __block id lastValue = nil;
        
        return ^(id x, BOOL *stop) {
            if ((passRuleBlock(x, lastValue) == NO)) { return [class empty]; }
            
            lastValue = x;
            return [class return:x];
        };
    }] setNameWithFormat:@"[%@] -distinctBasedOnRule", self.name];
}

@end
