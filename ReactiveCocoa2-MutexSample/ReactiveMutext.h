//
//  SuperClass.h
//  ReactiveCocoa-MutexSample
//
//  Created by Yury Lapitsky on 17.10.15.
//  Copyright © 2015 skyylex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

typedef NS_ENUM(NSUInteger, State) {
    Disabled = 0,
    Enabled = 1,
};

@interface ReactiveMutext : NSObject

/// Actual actions triggers
@property (nonatomic, readonly) RACSignal *pullingDownTrigger;
@property (nonatomic, readonly) RACSignal *pullingUpTrigger;

- (void)tryPerformPullDown;
- (void)tryPerformPullUp;

- (void)stopPerformPullDown;
- (void)stopPerformPullUp;

@end
