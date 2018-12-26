//
//  ViewController.m
//  runLoop
//
//  Created by  RWLi on 2017/9/19.
//  Copyright © 2017年  RWLi. All rights reserved.
//

#import "ViewController.h"

typedef void(^runLoopBlock)();

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tab;

@end

@implementation ViewController

-(void)addTask:(runLoopBlock)task{
    if (_tasks.count>20) {
        [_tasks removeObjectAtIndex:0];
    }
    [_tasks addObject:task];
}

-(UITableView *)tab{
    if (!_tab) {
        _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, 414, 716) style:UITableViewStylePlain];
        _tab.delegate = self;
        _tab.dataSource = self;
        _tasks = @[].mutableCopy;
    }
    return _tab;
}


-(void)addRunloopObserver{
    CFRunLoopRef runloopRef = CFRunLoopGetCurrent();
//    CFRunLoopObserverContext contex = {
//        0,
//        (__bridge void *)self,
//        &CFRetain,
//        &CFRelease,
//        NULL
//    };
//    CFRunLoopObserverRef runloopObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &callBack, &contex);
//    CFRunLoopAddObserver(runloopRef, runloopObserver, kCFRunLoopCommonModes);
//    CFRelease(runloopObserver);
    
    
    CFRunLoopTimerContext timeContex = {
        0,
        (__bridge void *)self,
        &CFRetain,
        &CFRelease,
        NULL
    };

  CFRunLoopTimerRef timeRef =  CFRunLoopTimerCreate(NULL, 0, 0, kCFRunLoopBeforeWaiting, 1, &TimerCallBack, &timeContex);
    CFRunLoopAddTimer(runloopRef, timeRef, kCFRunLoopCommonModes);
    CFRelease(timeRef);
}



void callBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    ViewController *vc = (__bridge ViewController*)info;
    [vc.tasks enumerateObjectsUsingBlock:^(runLoopBlock obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj();
    }];
    

}

void TimerCallBack(CFRunLoopTimerRef timer, void *info){
    ViewController *vc = (__bridge ViewController*)info;
    [vc.tasks enumerateObjectsUsingBlock:^(runLoopBlock obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj();
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addRunloopObserver];
    [self.view addSubview:self.tab];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    runLoopBlock block = ^{
    
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"-----%@",[NSThread currentThread]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
                });
            });
      
    };
    [self.tasks addObject:block];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
