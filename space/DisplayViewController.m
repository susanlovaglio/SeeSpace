//
//  DisplayViewController.m
//  Inspired By
//
//  Created by Susan on 4/1/16.
//  Copyright © 2016 Susan Lovaglio. All rights reserved.
//

#import "DisplayViewController.h"
#import "NasaApiClient.h"
#import "AstronomyPOD.h"
#import "HomeViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"


@interface DisplayViewController() <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *imageTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet UIButton *saveImageButton;
@property (strong, nonatomic) NSString *moreInfo;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end

@implementation DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backButton.hidden = YES;
    self.imageTitle.hidden = YES;
    self.saveImageButton.hidden = YES;
    
    self.spinner.hidden = NO;
    
    NasaApiClient *apiClient = [[NasaApiClient alloc]init];
    
    [apiClient imagesFromApiWithCompletionBlock:^(NSDictionary *imageDictionaries) {
        
    AstronomyPOD *currentImage = [AstronomyPOD imagesFromDictionary:imageDictionaries];
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: currentImage.imageURL];
        
        UIImage *imageFromData = [UIImage imageWithData:imageData];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.spinner.hidden = YES;
            self.backButton.hidden = NO;
            self.imageTitle.hidden = NO;
            self.saveImageButton.hidden = NO;
            self.backgroundImage.image = imageFromData;
            self.imageTitle.text = currentImage.imageTitle;
            self.moreInfo = currentImage.imageExplanation;
        }];
    }];
    
    
//    CGRect contentRect = CGRectZero;
//    for (UIView *view in self.scrollView.subviews) {
//        contentRect = CGRectUnion(contentRect, view.frame);
//    }
//    self.scrollView.contentSize = contentRect.size;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenTapped:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedUp:)];
    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeGestureRecognizer];
    
    self.scrollView.minimumZoomScale =.55;
    self.scrollView.maximumZoomScale =  self.view.bounds.size.height/100;
    self.scrollView.contentSize = self.backgroundImage.frame.size;
    self.scrollView.delegate = self;
    
    
    //initialize the motion manager
    self.motionManager = [[CMMotionManager alloc]init];
    
    DisplayViewController * __weak weakSelf = self;
//    if (self.motionManager.accelerometerAvailable) {
//        self.motionManager.accelerometerUpdateInterval = 0.01f;
//        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
//                                      withHandler:^(CMAccelerometerData *data, NSError *error) {
//                                          double rotation = atan2(data.acceleration.x, data.acceleration.y) - M_PI;
//                                          weakSelf.backgroundImage.transform = CGAffineTransformMakeRotation(rotation);
//                                      }];
//    }
//    
//    if (self.motionManager.accelerometerAvailable) {
//        self.motionManager.deviceMotionUpdateInterval = .01f;
//        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *data, NSError *error) {
//            
//            if(data.acceleration.x >0.1){
//                NSString *accelerationDirection=@"right";
//                [self adjustLocation:accelerationDirection];
//            } else if(data.acceleration.x <-0.1){
//                NSString *accelerationDirection=@"left";
//                [self adjustLocation:accelerationDirection];
//            }
//            
////            double rotation = atan2(motion.gravity.x, motion.gravity.y) - M_PI;
//            
////            weakSelf.backgroundImage.transform = CGAffineTransformMakeRotation(rotation);
//        }];
//    }
//}

}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.backgroundImage;
}

-(void)swipedUp: (UISwipeGestureRecognizer*)swipe{
    NSLog(@"swiped");
//    self.containersVisibleHeight.constant = 500;
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)screenTapped:(UITapGestureRecognizer *)sender {
    NSLog(@"tapped");
    [UIView transitionWithView:self.backButton duration:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    [UIView transitionWithView:self.imageTitle duration:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    [UIView transitionWithView:self.saveImageButton duration:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    
        if (self.backButton.hidden == NO) {
            self.backButton.hidden = YES;
            self.imageTitle.hidden = YES;
            self.saveImageButton.hidden = YES;
        }else{
            self.backButton.hidden = NO;
            self.imageTitle.hidden = NO;
            self.saveImageButton.hidden = NO;
        }
}
- (IBAction)saveImageButtonTapped:(id)sender {
    NSLog(@"save image been tapped");
    UIImageWriteToSavedPhotosAlbum(self.backgroundImage.image, nil, nil, nil);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Saved!";

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    });
    
    [UIView transitionWithView:hud duration:.8 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        hud.hidden = YES;
    }];
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
