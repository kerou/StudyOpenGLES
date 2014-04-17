//
//  GLMainViewController.m
//  Tutorial01
//
//  Created by gw_ysy on 14-4-11.
//  Copyright (c) 2014年 GL. All rights reserved.
//

#import "GLMainViewController.h"
#import "GLOpenGLView.h"

@interface GLMainViewController ()

@property (nonatomic, strong) GLOpenGLView *openGLView;

@end

@implementation GLMainViewController
@synthesize openGLView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 图像view
    openGLView = [[GLOpenGLView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    [self.view addSubview:openGLView];
    [self setValueForGLView];
    [openGLView updateTransfrom];
    [openGLView render];
    
    // 底部view
    CGFloat viewHeg = self.view.bounds.size.height-400;
    UIView *otherView = [[UIView alloc] initWithFrame:CGRectMake(0,400,320,viewHeg)];
    otherView.backgroundColor = [UIColor brownColor];
    
    NSArray *nameArray = @[@"x:",@"y:",@"z:",@"rotate x:",@"scale z:"];
    for (int i = 0; i < 5; i ++) {
        // 属性
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, viewHeg/5.0 * i, 70, viewHeg/5.0)];
        nameLabel.text = nameArray[i];
        nameLabel.textAlignment = NSTextAlignmentRight;
        [otherView addSubview:nameLabel];
        // slider
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(75, viewHeg/5.0 * i, 150, 30)];
        slider.tag = i;
            if (i == 0 || i == 1)
            {
                [slider setMaximumValue:3.0f];
                [slider setMinimumValue:-3.0f];
                [slider setValue:0];
            }else if (i == 2)
            {
                [slider setMaximumValue:3.0f];
                [slider setMinimumValue:-3.0f];
                [slider setValue:1];
            }
            else if (i == 3)
            {
                [slider setMaximumValue:0.5f];
                [slider setMinimumValue:2.0f];
                [slider setValue:1];
            }
            else if (i == 4)
            {
                [slider setMaximumValue:-180.0f];
                [slider setMinimumValue:180.0f];
                [slider setValue:-5.5];
            }
        [slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
        [otherView addSubview:slider];
    }
    [self.view addSubview:otherView];
  
}
- (void)setValueForGLView
{
    openGLView.posX = 0.0;
    openGLView.posY = 0.0;
    openGLView.posZ = -5.5;
    openGLView.scaleZ = 1.0;
    openGLView.rotateX = 0.0;
}
- (void)sliderChange:(UISlider *)sender
{
    NSLog(@"%d,%f",sender.tag,sender.value);
    switch (sender.tag) {
        case 0:
        {
            openGLView.posX = sender.value;
            [openGLView updateTransfrom];
            [openGLView render];
            break;
        }
        case 1:
        {
            openGLView.posY = sender.value;
            [openGLView updateTransfrom];
            [openGLView render];
            break;
        }
        case 2:
        {
            openGLView.posZ = sender.value;
            [openGLView updateTransfrom];
            [openGLView render];
            break;
        }
        case 3:
        {
            openGLView.rotateX = sender.value;
            [openGLView updateTransfrom];
            [openGLView render];
            break;
        }
        case 4:
        {
            openGLView.scaleZ = sender.value;
            [openGLView updateTransfrom];
            [openGLView render];
            break;
        }
        default:
            break;
    }

}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
