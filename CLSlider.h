/**
 * CLSlider.h
 * CosteliqueKit Library
 *
 * Copyright (c) 2018 Georgiy Chremnikh.
 * All rights reserved.
 */

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@class UIImage, UIColor;

NS_CLASS_AVAILABLE_IOS(2_0) __TVOS_PROHIBITED @interface CLSlider : UIControl <NSCoding>

@property (nonatomic) IBInspectable float value; // Default 0.0. This value will be pinned to min/max.
@property (nonatomic) IBInspectable float minimumValue; // Default 0.0. The current value may change if outside new min value.
@property (nonatomic) IBInspectable float maximumValue; // Default 1.0. The current value may change if outside new max value.

@property (nonatomic, getter=isContinues) IBInspectable BOOL continues; // If set, value change events are generated any time the value changes due to dragging. Default is YES.

- (void)setValue:(float)value animated:(BOOL)animated; // Move slider at fixed velocity (i.e. duration depends on distance). Does not send action.

@property (nullable, nonatomic, strong) IBInspectable UIColor *leftTrackTintColor UI_APPEARANCE_SELECTOR;
@property (nullable, nonatomic, strong) IBInspectable UIColor *rightTrackTintColor UI_APPEARANCE_SELECTOR;;
@property (nullable, nonatomic, strong) IBInspectable UIColor *thumbTintColor UI_APPEARANCE_SELECTOR;

@property (nonatomic) IBInspectable float trackHeight; // Default 2.0. This value determines the height of the track.
@property (nonatomic) IBInspectable float thumbRadius; // Default 28.0. This value determines the radius of the thumb.

@property (nonatomic, getter=isHorizontal) IBInspectable BOOL horizontal; // If set, the slider will be positioned horizontally. Default is YES.

@property (nonatomic, getter=hasShadow) IBInspectable BOOL shadow; // If set, the thumb will have a shadow. Default is YES.

// The methods below set images for certain slider states. Note that this class supports only the UIControlStateNormal and UIControlStateHighlighted control states.
- (void)setThumbImage:(nullable UIImage *)image forState:(UIControlState)state;
- (void)setLeftImage:(nullable UIImage *)image forState:(UIControlState)state;
- (void)setRightImage:(nullable UIImage *)image forState:(UIControlState)state;

@property (nullable, nonatomic, readonly) UIImage *currentLeftImage;
@property (nullable, nonatomic, readonly) UIImage *currentRightImage;
@property (nullable, nonatomic, readonly) UIImage *currentThumbImage;

@end

NS_ASSUME_NONNULL_END
