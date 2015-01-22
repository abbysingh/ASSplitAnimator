//
//  SplitAnimationController.m
//  SplitNavigation
//
//  Created by Abheyraj on 11/9/14.
//  Copyright (c) 2014 Abheyraj. All rights reserved.
//

#import "ASSplitAnimator.h"

@implementation ASSplitAnimator

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.4f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    fromViewController.view.userInteractionEnabled = NO;
    [transitionContext.containerView addSubview:toViewController.view];
    UIImage *imageToSplit;
    if(self.pop){
        imageToSplit = [self imageWithView:toViewController.view];
    }else{
        imageToSplit = [self imageWithView:fromViewController.view];
    }
    NSArray *splitImages = [self createHalvedImages:imageToSplit];
    UIImageView *topImage = [[UIImageView alloc] initWithImage:splitImages[0]];
    UIImageView *bottomImage = [[UIImageView alloc] initWithImage:splitImages[1]];
    [topImage setContentMode:UIViewContentModeScaleAspectFit];
    [bottomImage setContentMode:UIViewContentModeScaleAspectFit];
    [topImage layoutIfNeeded];
    [bottomImage layoutIfNeeded];
    [transitionContext.containerView addSubview:topImage];
    [transitionContext.containerView addSubview:bottomImage];
    
    if(self.pop){
        [toViewController.view setHidden:YES];
        [topImage setFrame:CGRectMake(0, -topImage.frame.size.height, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height/2)];
        [bottomImage setFrame:CGRectMake(0, bottomImage.frame.size.height*2, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height/2)];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [topImage setFrame:CGRectMake(0, 0, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height/2)];
            [bottomImage setFrame:CGRectMake(0, topImage.frame.size.height, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height/2)];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [bottomImage removeFromSuperview];
            [topImage removeFromSuperview];
            [toViewController.view setHidden:NO];
            [fromViewController.view setUserInteractionEnabled:YES];
        }];
    }
    else{
        [fromViewController.view removeFromSuperview];
        [topImage setFrame:CGRectMake(0, 0, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height/2)];
        [bottomImage setFrame:CGRectMake(0, topImage.frame.size.height, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height/2)];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [topImage setFrame:CGRectMake(0, -topImage.frame.size.height, topImage.frame.size.width, topImage.frame.size.height)];
            [bottomImage setFrame:CGRectMake(0, bottomImage.frame.size.height*2, bottomImage.frame.size.width, bottomImage.frame.size.height)];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [bottomImage removeFromSuperview];
            [topImage removeFromSuperview];
            [fromViewController.view setUserInteractionEnabled:YES];
        }];
    }
}

- (UIImage *)imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.bounds.size.width, view.bounds.size.height), view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(NSArray *)createHalvedImages:(UIImage*) image {
    CGFloat scale = [[UIScreen mainScreen] scale];
    NSMutableArray *arr = [NSMutableArray array];
    for(int i = 0; i < 2; i++){
        float y = (i * image.size.height/2.0) * scale;
        CGImageRef tmp = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, y, image.size.width*scale, (image.size.height/2)*scale));
        [arr addObject:[UIImage imageWithCGImage:tmp]];
    }
    return arr;
}


@end
