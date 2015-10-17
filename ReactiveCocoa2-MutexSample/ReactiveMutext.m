//
//  SuperClass.m
//  ReactiveCocoa-MutexSample
//
//  Created by Yury Lapitsky on 17.10.15.
//  Copyright © 2015 skyylex. All rights reserved.
//

#import "ReactiveMutext.h"
#import "RACSignal+CustomDistinction.h"

@interface ReactiveMutext ()

@property (nonatomic, strong) NSNumber *pullDown;
@property (nonatomic, strong) NSNumber *pullUp;

@property (nonatomic, strong) NSNumber *tryPullDown;
@property (nonatomic, strong) NSNumber *tryPullUp;

@property (nonatomic, readwrite) RACSubject *pullingDownTrigger;
@property (nonatomic, readwrite) RACSubject *pullingUpTrigger;

@end

@implementation ReactiveMutext

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pullingDownTrigger = [RACSubject subject];
        self.pullingUpTrigger = [RACSubject subject];
        
        [self.pullExecuting subscribeNext:^(NSNumber *executing) {
            NSLog(@"Q:Is anything executing? A:, %@", (executing.boolValue)?@"YES":@"NO");
        }];
        
        
        [[[self.somebodyTriesToPullDownTrigger combineLatestWith:[self pullExecuting]] distinctBasedOnRule:^BOOL(RACTuple *firstTuple, RACTuple *secondTuple) {
            NSString *firstIdentity = firstTuple.first;
            NSString *secondIdentity = secondTuple.first;
            return [firstIdentity isEqualToString:secondIdentity] == NO;
        }] subscribeNext:^(RACTuple *tuple) {
            NSNumber *isExecuting = tuple.second;
            if (isExecuting.boolValue == NO) {
                NSLog(@"pull down started");
                [((RACSubject *)self.pullingDownTrigger) sendNext:@(Enabled)];
            }
        }];
        
        [[[self.somebodyTriesToPullUpTrigger combineLatestWith:[self pullExecuting]] distinctBasedOnRule:^BOOL(RACTuple *firstTuple, RACTuple *secondTuple) {
            NSString *firstIdentity = firstTuple.first;
            NSString *secondIdentity = secondTuple.first;
            return [firstIdentity isEqualToString:secondIdentity] == NO;
        }] subscribeNext:^(RACTuple *tuple) {
            NSNumber *isExecuting = tuple.second;
            if (isExecuting.boolValue == NO) {
                NSLog(@"pull up started");
                [((RACSubject *)self.pullingUpTrigger) sendNext:@(Enabled)];
            }
        }];
        
        /// Load initial state
        [((RACSubject *)self.pullingUpTrigger) sendNext:@(Disabled)];
        [((RACSubject *)self.pullingDownTrigger) sendNext:@(Disabled)];
    }
    return self;
}

- (RACSignal *)stateChanged {
    RACSignal *pullingUpTrigger = [self.pullingUpTrigger filter:^BOOL(id value) { return value != nil; }];
    RACSignal *pullingDownTrigger = [self.pullingDownTrigger filter:^BOOL(id value) { return value != nil; }];
    RACSignal *stateChanged = [pullingDownTrigger combineLatestWith:pullingUpTrigger];
    return stateChanged.deliverOnMainThread;
}

- (RACSignal *)pullExecuting {
    RACSignal *pullExecuting = [self.stateChanged map:^id(RACTuple *tuple) {
        BOOL firstEnabled = ((NSNumber *)tuple.first).boolValue == YES;
        BOOL secondEnabled = ((NSNumber *)tuple.second).boolValue == YES;
        
        return @(firstEnabled || secondEnabled);
    }];
    
    return pullExecuting.deliverOnMainThread;
}

- (RACSignal *)somebodyTriesToPullDownTrigger {
    return [[RACObserve(self, tryPullDown).deliverOnMainThread filter:^BOOL(id value) {
        return value != nil;
    }] map:^id(id value) {
        return [NSUUID UUID].UUIDString;
    }];
}
         
- (RACSignal *)somebodyTriesToPullUpTrigger {
    return [[RACObserve(self, tryPullUp).deliverOnMainThread filter:^BOOL(id value) {
        return value != nil;
    }] map:^id(id value) {
        return [NSUUID UUID].UUIDString;
    }];
}

- (void)tryPerformPullDown {
    NSLog(@"try pull down");
    self.tryPullDown = @(1);
}

- (void)tryPerformPullUp {
    NSLog(@"try pull up");
    self.tryPullUp = @(1);
}

- (void)stopPerformPullDown {
    NSLog(@"pull down stopped");
    [((RACSubject *)self.pullingDownTrigger) sendNext:@(Disabled)];
}

- (void)stopPerformPullUp {
    NSLog(@"pull up stopped");
    [((RACSubject *)self.pullingUpTrigger) sendNext:@(Disabled)];
}

@end
