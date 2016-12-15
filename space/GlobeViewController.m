//
//  GlobeViewController.m
//  space
//
//  Created by susan lovaglio on 12/3/16.
//  Copyright © 2016 Susan Lovaglio. All rights reserved.
//

#import "GlobeViewController.h"
#import <SceneKit/SceneKit.h>
#import <ModelIO/ModelIO.h>

@interface GlobeViewController ()

@property (weak, nonatomic) IBOutlet SCNView *globeScene;

//@property(weak, nonatomic) UIButton *backButton;

@end

@implementation GlobeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self sceneSetUp];
    [self addBackButton];
    [self nodeSetUp];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
//    
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//    
//    [self.globeScene stop:nil];
//    [self.globeScene play:nil];
//}

-(void)sceneSetUp{

    self.globeScene.autoenablesDefaultLighting = YES;
    self.globeScene.allowsCameraControl = YES;
}

-(void)nodeSetUp{

    SCNNode *figureNode = self.globeScene.scene.rootNode.childNodes[0];
    figureNode.scale = SCNVector3Make(0.6, 0.6, 0.6);
  
}

-(void)addBackButton{
    
    UIFont *normalDin = [UIFont fontWithName:@"DIN" size:20];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    backButton.titleLabel.font = normalDin;
    backButton.hidden = NO;
    [self.view addSubview: backButton];
    backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [backButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [backButton.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [backButton.heightAnchor constraintEqualToConstant:50].active = YES;
    [backButton.widthAnchor constraintEqualToConstant:100].active = YES;
}

-(void)backButtonTapped{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
