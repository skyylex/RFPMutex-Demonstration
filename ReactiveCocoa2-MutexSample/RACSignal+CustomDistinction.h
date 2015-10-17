//
//  RACSignal+CustomDistinction.h
//  ReactiveCocoa2-MutexSample
//
//  Created by Yury Lapitsky on 17.10.15.
//  Copyright © 2015 skyylex. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RACSignal (CustomDistinction)

typedef BOOL(^PassRuleBlock)(id first, id second);

- (RACSignal *)distinctBasedOnRule:(PassRuleBlock)passRuleBlock;

@end
