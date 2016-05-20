//
//  ViewController.m
//  01-KVO练习
//
//  Created by qingyun on 16/4/27.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import "QYmode.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tempLab;
@property (weak, nonatomic) IBOutlet UIView *tempView;
@property (strong,nonatomic) QYmode *mode;
@property (strong,nonatomic)NSArray *colorArr;


@property (nonatomic) float maxY;
@end

@implementation ViewController

-(NSArray *)colorArr{
    if (_colorArr) {
        return _colorArr;
    }
    _colorArr=@[[UIColor purpleColor],[UIColor greenColor],[UIColor yellowColor],[UIColor blueColor]];
    
    return _colorArr;

}


-(void)AlaterWithMessage:(NSString *)Message{

    UIAlertController *alterController=[UIAlertController alertControllerWithTitle:@"提示" message:Message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
    [alterController addAction:okAction];
    
    [self presentViewController:alterController animated:YES completion:nil];

}


-(void)swipeGestureUpOrDown:(UISwipeGestureRecognizer*)gesture{
   //判断手势方向，做相应处理
    if (gesture.direction==UISwipeGestureRecognizerDirectionDown) {
        //向下滑动的逻辑
        if(_mode.height==100){
          //警告
            [self AlaterWithMessage:@"血量过低，请加血"];
        
        }else{
          //Height-100  Kvo
            _mode.height-=100;
        }
    }else{
        //向上滑动的逻辑
        if(_mode.height==400){
          //提示 血量已满，不用重复加
            [self AlaterWithMessage:@"血量已满不用续加"];
        }else{
         //height+100；
            _mode.height+=100;
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取_tempView的最大Y
    _maxY= CGRectGetMaxY(_tempView.frame);
    
    //给tempview添加手势
    UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureUpOrDown:)];
    swipeGesture.direction=UISwipeGestureRecognizerDirectionUp;
    [_tempView addGestureRecognizer:swipeGesture];
    
    UISwipeGestureRecognizer  *swipGestureDown=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureUpOrDown:)];
    swipGestureDown.direction=UISwipeGestureRecognizerDirectionDown;
    [_tempView addGestureRecognizer:swipGestureDown];
    
    //给mode初始化，赋值
    _mode=[[QYmode alloc] init];
    
    //kvo监听height属性，Height属性就是_tempView的frame的高度
    [_mode addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionNew context:(__bridge void *)_tempView];
    //_tempView 背景色赋值
    _tempView.backgroundColor =self.colorArr[0];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
  //判断，监听新值，更新UI
    if ([keyPath isEqualToString:@"height"]) {
        //float 值height
        float height=[change[@"new"] floatValue];
        //获取uiview
        
     [UIView animateWithDuration:.3 animations:^{
        UIView *view=(__bridge UIView *)context;
        CGRect rect=view.frame;
        rect.size.height=height;
        rect.origin.y=_maxY-height;
        view.frame=rect;
        NSInteger index=(400-height)/100;
        view.backgroundColor=self.colorArr[index];
     }];

        
        
        
        _tempLab.text=[NSString stringWithFormat:@"血量：%.0f",height];
        
    }
    
    
    
}

-(void)dealloc{
    [_mode removeObserver:self forKeyPath:@"height"];

}


- (void)didReceiveMemoryWarning {
    
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
