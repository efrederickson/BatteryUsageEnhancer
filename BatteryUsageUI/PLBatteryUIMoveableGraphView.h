/*
 *     Generated by class-dump 3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2012 by Steve Nygard.
 */

#import "UIView.h"

@class NSDate, NSMutableArray, NSMutableDictionary, UIColor;

@interface PLBatteryUIMoveableGraphView : UIView
{
    float maxPower;
    float minPower;
    int _errValue;
    double horizontal_label_offset;
    double vertical_label_offset;
    double rectWidth;
    double rectHeight;
    double xInterval;
    double yInterval;
    NSMutableDictionary *defaultTextAttributes;
    NSMutableArray *_dateChangeArray;
    int _graphType;
    double _displayRange;
    NSMutableArray *_inputData;
    UIColor *_labelColor;
    UIColor *_graphBackgroundColor;
    UIColor *_lineColor;
    UIColor *_gridColor;
    NSDate *_startDate;
    NSDate *_endDate;
    struct CGSize _displaySize;
}

+ (int)graphHeight;
- (void).cxx_destruct;
- (id)DateChangeArray;
@property(nonatomic) double displayRange; // @synthesize displayRange=_displayRange;
@property(nonatomic) struct CGSize displaySize; // @synthesize displaySize=_displaySize;
- (void)drawDayLines:(struct CGContext *)arg1 andRect:(struct CGRect)arg2;
- (void)drawErrorText:(struct CGContext *)arg1 andRect:(struct CGRect)arg2;
- (void)drawFill:(struct CGContext *)arg1 andRect:(struct CGRect)arg2;
- (void)drawGrid:(struct CGContext *)arg1 andRect:(struct CGRect)arg2;
- (void)drawLine:(struct CGContext *)arg1 andRect:(struct CGRect)arg2;
- (void)drawRect:(struct CGRect)arg1;
@property(readonly, nonatomic) NSDate *endDate; // @synthesize endDate=_endDate;
@property(copy, nonatomic) UIColor *graphBackgroundColor; // @synthesize graphBackgroundColor=_graphBackgroundColor;
@property(nonatomic) int graphType; // @synthesize graphType=_graphType;
@property(copy, nonatomic) UIColor *gridColor; // @synthesize gridColor=_gridColor;
- (id)init;
- (void)initGraphAttributes;
- (id)initWithFrame:(struct CGRect)arg1;
@property(copy, nonatomic) NSMutableArray *inputData; // @synthesize inputData=_inputData;
@property(copy, nonatomic) UIColor *labelColor; // @synthesize labelColor=_labelColor;
@property(copy, nonatomic) UIColor *lineColor; // @synthesize lineColor=_lineColor;
- (void)setDefaultRange;
- (void)setFrame:(struct CGRect)arg1;
- (double)setGridRange:(double)arg1;
- (void)setRangesFromArray:(id)arg1;
@property(readonly, nonatomic) NSDate *startDate; // @synthesize startDate=_startDate;

@end

