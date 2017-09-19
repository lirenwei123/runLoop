//
//  ViewController.m
//  runLoop
//
//  Created by  RWLi on 2017/9/19.
//  Copyright © 2017年  RWLi. All rights reserved.
//

#import "ViewController.h"

typedef void(^runLoopBlock)();

@interface ViewController ()


@end

@implementation ViewController

-(void)addTask:(runLoopBlock)task{
    if (_tasks.count>20) {
        [_tasks removeObjectAtIndex:0];
    }
    [_tasks addObject:task];
}


-(void)addRunloopObserver{
    CFRunLoopRef runloopRef = CFRunLoopGetCurrent();
    CFRunLoopObserverContext contex = {
        0,
        (__bridge void *)self,
        &CFRetain,
        &CFRelease,
        NULL
    };
    CFRunLoopObserverRef runloopObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &callBack, &contex);
    CFRunLoopAddObserver(runloopRef, runloopObserver, kCFRunLoopCommonModes);
    CFRelease(runloopObserver);
}

void callBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    UIViewController *vc  =(__bridge UIViewController *)info;
}
    

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
