//
//  ViewController.m
//  ReactiveCocoa2-MutexSample
//
//  Created by Yury Lapitsky on 17.10.15.
//  Copyright © 2015 skyylex. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveMutext.h"

@interface ViewController ()

@property (nonatomic, strong) ReactiveMutext *pullControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pullControl = [ReactiveMutext new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startPullUp:(id)sender {
    [self.pullControl tryPerformPullUp];
}

- (IBAction)startPullDown:(id)sender {
    [self.pullControl tryPerformPullDown];
}

- (IBAction)stopPullDown:(id)sender {
    [self.pullControl stopPerformPullDown];
}

- (IBAction)stopPullUp:(id)sender {
    [self.pullControl stopPerformPullUp];
}

@end
