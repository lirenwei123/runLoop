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

-(void)addTimerRunloop{
    CFRunLoopRef runloopRef = CFRunLoopGetCurrent();
    CFRunLoopTimerContext timeContex = {
        0,
        (__bridge void *)self,
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    CFRunLoopTimerRef timeRef =  CFRunLoopTimerCreate(NULL, 0, 0.01, kCFRunLoopBeforeWaiting, 1, &TimerCallBack, &timeContex);
    CFRunLoopAddTimer(runloopRef, timeRef, kCFRunLoopCommonModes);
    CFRelease(timeRef);
}

void callBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    ViewController *vc = (__bridge ViewController*)info;
    if (vc.tasks.count == 0) {
        return;
    }
    runLoopBlock block = vc.tasks.firstObject;
    block();
    [vc.tasks removeObjectAtIndex:0];

}

void TimerCallBack(CFRunLoopTimerRef timer, void *info){
    ViewController *vc = (__bridge ViewController*)info;
    if (vc.tasks.count == 0) {
        return;
    }
    runLoopBlock block = vc.tasks.firstObject;
    block();
    [vc.tasks removeObjectAtIndex:0];
   
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
        [self setCell:cell indexpath:indexPath];
    }else{
        __weak typeof(self) wsf = self;
        runLoopBlock block = ^{
            
            [wsf setCell:cell indexpath:indexPath];
        };
        [self.tasks addObject:block];
    }
    
    return cell;
}

-(void)setCell:(UITableViewCell*)cell indexpath:(NSIndexPath*)indexPath{
    
    //模拟耗时
    NSLog(@"---satrtTime = %@",[NSDate date]);
    int j = 0;
    for (int i= 0; i<500; i++) {
        j= j+ i;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d",j];
    NSLog(@"---endTime = %@",[NSDate date]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
