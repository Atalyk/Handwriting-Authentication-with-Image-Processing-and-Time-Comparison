//
//  CustomObject.h
//  HandwritingSecurity
//
//  Created by Admin on 8/20/16.
//  Copyright © 2016 AAkash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomObject : NSObject

@property (strong, nonatomic) id someProperty;

- (bool) someMethod:(UIImage *)image :(UIImage *)temp;
- (void) supportVectorMachine:(NSArray *)array;

@end