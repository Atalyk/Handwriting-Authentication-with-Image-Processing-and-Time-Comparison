//
//  CustomObject.m
//  HandwritingSecurity
//
//  Created by Admin on 8/20/16.
//  Copyright © 2016 AAkash. All rights reserved.
//

#import "CustomObject.h"
#import <opencv2/opencv.hpp>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>

using namespace cv;
using namespace cv::ml;
using namespace std;

@implementation CustomObject

- (void) supportVectorMachine:(NSArray *)array {
    
    int labels[3] = {1, 1, -1};
    cv::Mat labelsMat(3, 1, CV_32S, labels);

    float trainingData[3][3] = { { 375, 645, 145 }, { 247, 704, 174}, { 510, 1044, 158} };
    
    //float trainingData[10][1] = { 100, 150, 600, 600, 100, 455, 345, 501, 401, 150};
    
    cv::Mat trainDataMat(3, 3, CV_32FC1, trainingData);
    
    //opencv 3.0
    Ptr<ml::SVM> svm = ml::SVM::create();
    // edit: the params struct got removed,
    // we use setter/getter now:
    svm->setType(ml::SVM::C_SVC);
    svm->setKernel(ml::SVM::LINEAR);
    svm->setTermCriteria(TermCriteria(TermCriteria::MAX_ITER, 100, 1e-6));
    svm->setGamma(3.0);
    
    Ptr<TrainData> td = TrainData::create(trainDataMat, ROW_SAMPLE, labelsMat);
    svm->train(td);
    
    float testData[3] = {[array[0] floatValue], [array[1] floatValue], [array[2] floatValue]};
    
    //float testData[3] = {70, 500, 100};
    
    cv::Mat testDataMat(1, 3, CV_32FC1, testData);
    
    //Predict the class labele for test data sample
    float predictLable = svm->predict(testDataMat);
    
    NSLog(@"%f", predictLable);
}

- (bool) someMethod:(UIImage *)image :(UIImage *)temp {
    
    RNG rng(12345);
    
    cv::Mat src_base, hsv_base;
    cv::Mat src_test1, hsv_test1;
    
    src_base = [self cvMatWithImage:image];
    src_test1 = [self cvMatWithImage:temp];
    
    int thresh=150;
    double ans=0, result=0;
    
    Mat imageresult1, imageresult2;
    
    cv::cvtColor(src_base, hsv_base, cv::COLOR_BGR2HSV);
    cv::cvtColor(src_test1, hsv_test1, cv::COLOR_BGR2HSV);
    
    std::vector<std::vector<cv::Point>>contours1, contours2;
    std::vector<Vec4i>hierarchy1, hierarchy2;
    
    Canny(hsv_base, imageresult1, thresh, thresh*2);
    Canny(hsv_test1, imageresult2, thresh, thresh*2);
    
    findContours(imageresult1,contours1,hierarchy1,CV_RETR_EXTERNAL,CV_CHAIN_APPROX_SIMPLE,cvPoint(0,0));
    for(int i=0;i<contours1.size();i++)
    {
        //cout<<contours1[i]<<endl;
        Scalar color=Scalar(rng.uniform(0, 255), rng.uniform(0,255), rng.uniform(0,255));
        drawContours(imageresult1,contours1,i,color,1,8,hierarchy1,0,cv::Point());
    }
    
    findContours(imageresult2,contours2,hierarchy2,CV_RETR_EXTERNAL,CV_CHAIN_APPROX_SIMPLE,cvPoint(0,0));
    for(int i=0;i<contours2.size();i++)
    {
        Scalar color=Scalar(rng.uniform(0, 255), rng.uniform(0,255), rng.uniform(0,255));
        drawContours(imageresult2,contours2,i,color,1,8,hierarchy2,0,cv::Point());
    }
    
    
    ans = matchShapes(contours1[0],contours2[0],CV_CONTOURS_MATCH_I3,0);
    
    std::cout<<"The answer is "<<ans<<endl;
    
    if (ans<=20) {
        return true;
    }
    
    return false;
}

/*
 - (bool) someMethod:(UIImage *)image :(UIImage *)temp {
 
 cv::Mat src_base, hsv_base;
 cv::Mat src_test1, hsv_test1;
 
 src_base = [self cvMatWithImage:image];
 src_test1 = [self cvMatWithImage:temp];
 
 cv::cvtColor(src_base, hsv_base, cv::COLOR_BGR2HSV);
 cv::cvtColor(src_test1, hsv_test1, cv::COLOR_BGR2HSV);
 
 int h_bins = 50; int s_bins = 60;
 int histSize[] = { h_bins, s_bins };
 
 float h_ranges[] = { 0, 180 };
 float s_ranges[] = { 0, 256 };
 
 const float* ranges[] = { h_ranges, s_ranges };
 
 // Use the o-th and 1-st channels
 int channels[] = { 0, 1 };
 
 
 /// Histograms
 cv::MatND hist_base;
 cv::MatND hist_half_down;
 cv::MatND hist_test1;
 cv::MatND hist_test2;
 
 calcHist( &hsv_base, 1, channels, cv::Mat(), hist_base, 2, histSize, ranges, true, false );
 normalize( hist_base, hist_base, 0, 1, cv::NORM_MINMAX, -1, cv::Mat() );
 
 calcHist( &hsv_test1, 1, channels, cv::Mat(), hist_test1, 2, histSize, ranges, true, false );
 normalize( hist_test1, hist_test1, 0, 1, cv::NORM_MINMAX, -1, cv::Mat() );
 
 double base_test1 = compareHist( hist_base, hist_test1, 0);
 
 NSLog(@"%f", base_test1);
 
 if (base_test1>0.9) {
 return true;
 }
 
 return false;
 }

*/

- (cv::Mat)cvMatWithImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

@end
