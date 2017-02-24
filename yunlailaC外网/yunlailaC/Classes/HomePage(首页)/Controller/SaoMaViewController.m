//
//  SaoMaViewController.m
//  yunlailaC
//
//  Created by admin on 16/8/4.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "SaoMaViewController.h"
#import <AVFoundation/AVFoundation.h>
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface SaoMaViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    AVCaptureSession * session;//输入输出的中间桥梁
}
@end

@implementation SaoMaViewController
@synthesize mydelegate;

-(void)someMethod:(NSNotification *)notification
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        NSLog(@"相机权限受限");
        [UIAlertView showAlert:@"请设置允许托运邦货主使用相机服务的权限" delegate:self cancelButton:@"取消" otherButton:@"去设置" tag:1];
        
    }
    else
    {
        //获取摄像设备
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //创建输入流
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        //创建输出流
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理 在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        output.rectOfInterest=CGRectMake(0.15,(WIDTH -280)/2/WIDTH,280/HEIGHT, 280/WIDTH);
        //初始化链接对象
        session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [session setSessionPreset:AVCaptureSessionPresetHigh];
        
        [session addInput:input];
        
        [session addOutput:output];
        
        
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
        layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        layer.frame=self.view.layer.bounds;
        [self.view.layer insertSublayer:layer atIndex:0];
        //开始捕获
        [session startRunning];
    }

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(someMethod:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];

    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self someMethod:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNav];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  @author 徐杨
 *
 *  标题栏初始化
 */
- (void)setUpNav
{
    self.title = @"扫一扫";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
    
   
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        NSLog(@"取消");
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"设置");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]];
    }
}


-(void)initView
{
    UIView *lView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT *0.15, (WIDTH -280)/2, 280)];
    lView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.view addSubview:lView];
    
    UIView *sView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT*0.15)];
    sView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];;
    [self.view addSubview:sView];
    
    UIView *rView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH - (WIDTH -280)/2, HEIGHT *0.15, (WIDTH - 280)/2, 280)];
    rView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];;
    [self.view addSubview:rView];
    
    UIView *xView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT*0.15 + 280, WIDTH, HEIGHT - HEIGHT*0.15 - 280)];
    xView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];;
    [self.view addSubview:xView];
    
    //方框
    UIImageView *kuangIm = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH - 285)/2, HEIGHT *0.15 - 2.5, 285, 285)];
    [kuangIm setImage:[UIImage imageNamed:@"saomiaokuang@2x"]];
    [self.view addSubview:kuangIm];;

    
}



-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
//        [UIAlertView showAlert:metadataObject.stringValue cancelButton:@"知道了"];
        
        if (mydelegate && [mydelegate respondsToSelector:@selector(sendCode:)])
        {
            [mydelegate sendCode:metadataObject.stringValue];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
}
/**
 *  @author 徐杨
 *
 *  返回事件
 *
 *  @param sender
 */
- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
