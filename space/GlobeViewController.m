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

@property(weak, nonatomic) UIButton *backButton;

@end

@implementation GlobeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self sceneSetUp];
//    [self addBackButton];
    [self nodeSetUp];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(UIStatusBarStyle)preferredStatusBarStyle{
    
  //  return UIStatusBarStyleLightContent;
//}

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
//    SCNNode *figureNode = self.globeScene.scene.rootNode;
//    SCNMaterial *texture = [SCNMaterial material];
//    texture.diffuse.contents = [UIImage imageNamed: @"ColorMap.jpg"];
//    figureNode.geometry.firstMaterial = texture;
    
}

//-(void)addBackButton{
//    
//    UIFont *normalDin = [UIFont fontWithName:@"DIN" size:20];
//    
//    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
//    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
//    self.backButton.titleLabel.font = normalDin;
//    self.backButton.hidden = YES;
//    [self.globeScene addSubview:self.backButton];
//    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.backButton.leadingAnchor constraintEqualToAnchor:self.globeScene.leadingAnchor].active = YES;
//    [self.backButton.topAnchor constraintEqualToAnchor:self.globeScene.topAnchor].active = YES;
//    [self.backButton.heightAnchor constraintEqualToConstant:50].active = YES;
//    [self.backButton.widthAnchor constraintEqualToConstant:100].active = YES;
//}
//
//-(void)backButtonTapped{
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
