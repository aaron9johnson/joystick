//
//  ViewController.h
//  Joystick
//
//  Created by Aaron Johnson on 2017-09-03.
//  Copyright © 2017 Aaron Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    NSTimer *tick;
    UITouch *touch;
    
    IBOutlet UIImageView *knob;
    IBOutlet UIImageView *player;
    IBOutlet UIImageView *pad;
    IBOutlet UIImageView *bullet;
    IBOutlet UIImageView *enemy;
    
    
}
@property (weak, nonatomic) IBOutlet UIButton *shoot;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *label2;


@end

