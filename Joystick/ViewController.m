//
//  ViewController.m
//  Joystick
//
//  Created by Aaron Johnson on 2017-09-03.
//  Copyright © 2017 Aaron Johnson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

float playerPositionX;
float playerPositionY;
float playerRotation;
float bulletPositionX;
float bulletPositionY;
float bulletRotation;
float enemyPositionX;
float enemyPositionY;
int score;
int highScore;
int scoreDelay;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    tick = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    _label.numberOfLines = 0;
    _label.text = [NSString stringWithFormat:@"Score: %d/nHighscore: %d", score, highScore];
    _label2.text = [NSString stringWithFormat:@""];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    knob.center = CGPointMake(point.x, point.y);
    if(!CGRectIntersectsRect(knob.frame, pad.frame)){
        knob.center = pad.center;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    knob.center = pad.center;
}

-(void)tick{
    [self movePlayer];
    [self moveEnemy];
    [self moveBullet];
    [self score];
    [self winCheck];
}
-(void)winCheck{
    if(highScore >= 250){
        _label.text = [NSString stringWithFormat:@"Score: %d\nHighscore: %d\nYou Win!", score, highScore];
    }
}
-(void)score{
    if(score > highScore){
        highScore = score;
    }
    _label.text = [NSString stringWithFormat:@"Score: %d\nHighscore: %d", score, highScore];
    if(scoreDelay > 0){
        scoreDelay = scoreDelay - 1;
    } else {
        _label2.text = [NSString stringWithFormat:@""];
    }
}
-(void)moveEnemy{
    float rotation = [self pointPairToBearingDegrees:enemy.center secondPoint:player.center] * M_PI / 180;
    int speed = 3;
    if(score > 50){
        speed = 4;
    }
    if(score > 100){
        speed = 5;
    }
    if(score > 130){
        speed = 6;
    }
    if(score > 160){
        speed = 7;
    }
    if(score > 175){
        speed = 8;
    }
    enemyPositionX = enemyPositionX + speed*cos(rotation);
    enemyPositionY = enemyPositionY + speed*sin(rotation);
    enemy.center = CGPointMake(enemyPositionX, enemyPositionY);
    if(CGRectIntersectsRect(enemy.frame, player.frame)){
        playerPositionX = knob.center.x;
        playerPositionY = knob.center.y - 350;
        player.center = CGPointMake(playerPositionX, playerPositionY);
        _label2.text = [NSString stringWithFormat:@"%d", score];
        scoreDelay = 60;
        score = 0;
        [self placeEnemy];
    }
}
-(void)placeEnemy{
    switch (arc4random_uniform(4)) {
        case 0:
            enemyPositionX = playerPositionX + 250;
            break;
        case 1:
            enemyPositionX = playerPositionX - 250;
            break;
        case 2:
            enemyPositionY = playerPositionY + 250;
            break;
        case 3:
            enemyPositionY = playerPositionY - 250;
            break;
        default:
            break;
    }
    enemy.center = CGPointMake(enemyPositionX, enemyPositionY);
}
-(void)movePlayer{
    if (CGRectIntersectsRect(knob.frame, pad.frame) && knob.center.x != pad.center.x && knob.center.y != pad.center.y) {
        playerRotation = [self pointPairToBearingDegrees:pad.center secondPoint:knob.center] * M_PI / 180;
        player.transform = CGAffineTransformMakeRotation(playerRotation + M_PI / 2);
        playerPositionX = playerPositionX + 8*cos(playerRotation);
        playerPositionY = playerPositionY + 8*sin(playerRotation);
        player.center = CGPointMake(playerPositionX, playerPositionY);
    }
}
- (IBAction)shoot:(id)sender {
    bulletRotation = playerRotation;
    bullet.transform = CGAffineTransformMakeRotation(playerRotation + M_PI / 2);
    bulletPositionX = playerPositionX;
    bulletPositionY = playerPositionY;
    bullet.center = CGPointMake(bulletPositionX, bulletPositionY);
    }

-(void)moveBullet{
    bulletPositionX = bulletPositionX + 18*cos(bulletRotation);
    bulletPositionY = bulletPositionY + 18*sin(bulletRotation);
    bullet.center = CGPointMake(bulletPositionX, bulletPositionY);
    if(CGRectIntersectsRect(bullet.frame, enemy.frame)){
        score = score + 5;
        [self placeEnemy];
    }
}
//Copy And Pasted from https://stackoverflow.com/questions/6064630/get-angle-from-2-positions
- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}

@end
