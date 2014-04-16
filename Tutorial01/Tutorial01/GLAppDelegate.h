//
//  GLAppDelegate.h
//  Tutorial01
//
//  Created by gw_ysy on 14-4-11.
//  Copyright (c) 2014年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLOpenGLView.h"

@class GLMainViewController;
@interface GLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) GLOpenGLView *glview;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GLMainViewController *mainView;


@end
