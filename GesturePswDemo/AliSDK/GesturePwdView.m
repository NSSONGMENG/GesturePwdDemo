//
//  GesturePwdView.m
//  AliPayDemo
//
//  Created by pg on 15/7/9.
//  Copyright (c) 2015年 pg. All rights reserved.
//

#import "GesturePwdView.h"
#import "GesturePwdItem.h"
#import "GesturePwdHeader.h"
#import "GesturePWdData.h"
#import "GesturePwdSubItem.h"
#import "Masonry.h"

#define KscreenHeight [UIScreen mainScreen].bounds.size.height
#define KscreenWidth [UIScreen mainScreen].bounds.size.width

#define ITEMTAG 122

@interface GesturePwdView()
@property(nonatomic , strong)NSMutableArray *btnArray;
@property(nonatomic , assign)CGPoint movePoint;
@property(nonatomic , strong)GesturePwdSubItem *subItemsss;
@property(nonatomic , strong)UILabel *tfLabel;
@property(nonatomic , assign)CGPoint lastPoint;
//验证次数
@property (nonatomic, assign) int confirmCount;

@end

@implementation GesturePwdView


- (instancetype)initWithModel:(GesturePWDModel)model{
    if (self = [super init]) {
        _gestureModel = model;
        [self initViews];
        _confirmCount = 5;
    }
    return self;
}

#pragma mark - init
- (void)initViews
{
    self.backgroundColor = [UIColor clearColor];
    
    /*******  上面的9个小点 ******/
    self.subItemsss.backgroundColor = [UIColor clearColor];
    
    
    /***** 提示文字 ******/
    self.tfLabel.backgroundColor = [UIColor clearColor];
    
    
    /****** 9个大点的布局 *****/
    [self createPoint_nine];


    /******* 小按钮上三角的point ******/
    _lastPoint = CGPointMake(0, 0);
}


#pragma mark - Touch Event
/**
 *  begin
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (_confirmCount > 0){
        CGPoint point = [self touchLocation:touches];
        
        [self isContainItem:point];
    }
    else{
        [self shake:_tfLabel];
    }
}


/**
 *  touch Move
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if (_confirmCount <= 0) return;
    
    CGPoint point = [self touchLocation:touches];
    
    [self isContainItem:point];
    
    [self touchMove_triangleAction];
    
    [self setNeedsDisplay];
}


/**
 *  touch End
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (_confirmCount <= 0) return;
    
    [self touchEndAction];
    
    [self setNeedsDisplay];
}


#pragma mark - UILabel  property
- (void)shake:(UIView *)myView
{
    int offset = 8 ;
    
    CALayer *lbl = [myView layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-offset, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+offset, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.06];
    [animation setRepeatCount:2];
    [lbl addAnimation:animation forKey:nil];
    
}

- (void)setGestureModel:(GesturePWDModel)gestureModel
{
    _gestureModel = gestureModel;
    self.tfLabel.textColor = [UIColor whiteColor];

    switch (gestureModel) {
            
        case GesturePWDModelResetPwdModel:
            //修改密码
            self.tfLabel.text = GesturePwdInputOldPwdStr; //请输入原始密码
            break;
            
        case GesturePWDModelSetPwdModel:
            //重置密码
            self.tfLabel.text = GesturePwdSettingStr;        //请滑动设置密码
            break;
            
        case GesturePWDModelConfirmPwdModel:
            //验证密码
            self.tfLabel.text = GesturePwdConfirmPwdStr; //验证密码
            break;
            
        case GesturePWDModelDeletePwdModel:
            //删除密码
            [GesturePWdData forgotPsw];
            break;
            
        default:
            break;
    }
}





#pragma mark - total method

/**
 *  下面的9个划线的点   init
 */
- (void)createPoint_nine
{
    
    for (int i=0; i<9; i++)
    {
        int row    = i / 3;
        int column = i % 3;
        
        CGFloat spaceFloat = 40.f;             //每个item的间距是等宽的
        CGFloat topOffset = 60.f;
        if (_gestureModel == GesturePWDModelConfirmPwdModel) {
            topOffset = 36.f;
        }
        CGFloat pointX     = spaceFloat*(column+1)+ITEMWH*column;   //起点X
        CGFloat pointY     = topOffset + ITEMWH*row + spaceFloat*row;     //起点Y
        
        /**
         *  对每一个item的frame的布局
         */
        GesturePwdItem *item = [[GesturePwdItem alloc] initWithFrame:CGRectMake( pointX  , pointY , ITEMWH, ITEMWH)];
        item.userInteractionEnabled = YES;
        item.backgroundColor = [UIColor clearColor];
        item.isSelect = NO;
        item.tag = ITEMTAG + i ;
        [self addSubview:item];
        
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tfLabel.mas_bottom).offset(pointY);
            make.left.equalTo(self).offset(pointX);
            make.width.height.mas_equalTo(ITEMWH);
        }];
        
    }
}

/**
 *  touch  begin move
 */

- (CGPoint)touchLocation:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _movePoint = point;
    
    return point;
}

- (void)isContainItem:(CGPoint)point
{
    for (GesturePwdItem *item  in self.subviews)
    {
        if (![item isKindOfClass:[GesturePwdSubItem class]] && [item isKindOfClass:[GesturePwdItem class]])
        {
            BOOL isContain = CGRectContainsPoint(item.frame, point);
            if (isContain && item.isSelect==NO)
            {
                [self.btnArray addObject:item];
                item.isSelect = YES;
                item.model = selectStyle;
            }
        }
    }
}

- (void)touchMove_triangleAction
{
    NSString *resultStr = [self getResultPwd];
    if (resultStr&&resultStr.length>0   )
    {
        NSArray *resultArr = [resultStr componentsSeparatedByString:@"A"];
        if ([resultArr isKindOfClass:[NSArray class]]  &&  resultArr.count>2 )
        {
            NSString *lastTag    = resultArr[resultArr.count-1];
            NSString *lastTwoTag = resultArr[resultArr.count-2];

            CGPoint lastP ;
            CGPoint lastTwoP;
            GesturePwdItem *lastItem;
            
            for (GesturePwdItem *item  in self.btnArray)
            {
                if (item.tag-ITEMTAG == lastTag.intValue)
                {
                    lastP = item.center;
                }
                if (item.tag-ITEMTAG == lastTwoTag.intValue)
                {
                    lastTwoP = item.center;
                    lastItem = item;
                }
                
                CGFloat x1 = lastTwoP.x;
                CGFloat y1 = lastTwoP.y;
                CGFloat x2 = lastP.x;
                CGFloat y2 = lastP.y;

                [lastItem judegeDirectionActionx1:x1 y1:y1 x2:x2 y2:y2 isHidden:NO];
            }
        }
    }
}

/**
 *  touch end
 */
- (void)touchEndAction
{
    for (GesturePwdItem *itemssss in self.btnArray)
    {
        [itemssss judegeDirectionActionx1:0 y1:0 x2:0 y2:0 isHidden:NO];
    }
    
    if ([self.btnArray count] == 0) return;
    
    // if (判断格式少于4个点) [处理密码数据]
    if ([self judgeFormat]) [self setPswMethod:[self getResultPwd]] ;

    
    // 数组清空
    [self.btnArray removeAllObjects];
    
    
    // 选中样式
    for (GesturePwdItem *item  in self.subviews)
    {
        if (![item isKindOfClass:[GesturePwdSubItem class]] && [item isKindOfClass:[GesturePwdItem class]])
        {
            item.isSelect = NO;
            item.model = normalStyle;
            [item judegeDirectionActionx1:0 y1:0 x2:0 y2:0 isHidden:YES];
        }
        
    }
    
}



/**
 *  少于4个点
 */
- (BOOL)judgeFormat
{
    if (self.btnArray.count<=3) {
        //不合法
        self.tfLabel.textColor = GESTUREPSW_WRONGCOLOR;
        if (_gestureModel == GesturePWDModelSetPwdModel) {
            self.tfLabel.text = GesturePwdSettingStr;
        }
        else{
            self.tfLabel.text = GesturePwdConfirmPwdStr;
        }
        [self shake:self.tfLabel];
        _confirmCount --;
        return NO;
    }
    
    return YES;
}

/**
 *  对密码str进行处理
 */
- (NSString *)getResultPwd
{
    NSMutableString *resultStr = [NSMutableString string];
    
    for (GesturePwdItem *item  in self.btnArray)
    {
        if (![item isKindOfClass:[GesturePwdSubItem class]] && [item isKindOfClass:[GesturePwdItem class]])
        {
            [resultStr appendString:@"A"];
            [resultStr appendString:[NSString stringWithFormat:@"%ld", (long)item.tag-ITEMTAG]];
        }
    }
    
    return (NSString *)resultStr;
}

#pragma mark - 处理修改，设置，登录的业务逻辑
- (void)setPswMethod:(NSString *)resultStr
{
    //没有任何记录，第一次登录
    BOOL isSaveBool = [GesturePWdData isFirstInput:resultStr];
    
    //默认为蓝色
    UIColor *color = GESTUREPSW_ALERT_TEXTCOLOR;
    
    if (isSaveBool) {
        
        //第一次输入之后，显示的文字
        self.tfLabel.text = GesturePwdResetStr;
        self.tfLabel.textColor = [UIColor whiteColor];
        
    } else {
        //密码已经存在
        //1 , 修改
        //2 , 验证
        //3 , 登录
        
        //设置密码
        color = [self setPwdJudgeAction:color str:resultStr];
        
        //修改密码
        color = [self alertPwdJudgeAction:color str:resultStr];
        
        //验证密码
        color = [self validatePwdJudgeAction:color str:resultStr];
        
    }
    
    /**************  小键盘颜色 ***************/
    [self.subItemsss resultArr:(NSArray *)[resultStr componentsSeparatedByString:@"A"] fillColor:color];
    
}


/**
 *  设置密码
 */
- (UIColor *)setPwdJudgeAction:(UIColor *)color str:(NSString *)resultStr
{
    /**
     *  设置密码
     */
    if (self.gestureModel == GesturePWDModelSetPwdModel) {
        
        // isRight == YES 2次的密码相同
        BOOL isRight = [GesturePWdData isSecondInputRight:resultStr];
        if (isRight) {
            // 验证成功
            
            self.tfLabel.text = GesturePwdSetSuccessStr;
            self.tfLabel.textColor =  [UIColor whiteColor];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self blockAction:resultStr];
            });
            
        } else {
            
            // 失败
            self.tfLabel.text = GesturePWdConfirmSettingFailureStr;
            self.tfLabel.textColor = GESTUREPSW_WRONGCOLOR;
            [self shake:self.tfLabel];
            color = GESTUREPSW_WRONGCOLOR;
            
        }
    }
    return color;
}
/**
 *  修改密码
 */
- (UIColor *)alertPwdJudgeAction:(UIColor *)color str:(NSString *)resultStr
{
    /**
     *  修改
     */
    if (self.gestureModel == GesturePWDModelResetPwdModel)
    {
        BOOL isValidate = [GesturePWdData isSecondInputRight:resultStr];
        if (isValidate) {
            
            //如果验证成功
            [GesturePWdData forgotPsw];
            self.tfLabel.text = GesturePwdInputNewPwdStr;
            self.tfLabel.textColor = [UIColor whiteColor];
            _gestureModel = GesturePWDModelSetPwdModel;
            
        } else {
            //验证失败
            self.tfLabel.text = GesturePwdConfirmFailureStr;
            self.tfLabel.textColor = GESTUREPSW_WRONGCOLOR;
            [self shake:self.tfLabel];
            color = GESTUREPSW_WRONGCOLOR;
        }
    }
    return color;
}

/**
 *  验证，登录
 */
- (UIColor *)validatePwdJudgeAction:(UIColor *)color str:(NSString *)resultStr
{
    
    
    if (self.gestureModel == GesturePWDModelConfirmPwdModel) {
        BOOL isValidate = [GesturePWdData isSecondInputRight:resultStr];
        if (isValidate) {
            //如果验证成功
            self.tfLabel.text = GesturePwdConfirmSuccessStr;
            self.tfLabel.textColor = [UIColor whiteColor];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self blockAction:resultStr];
            });
            
        } else {
            //失败
            if (_confirmCount > 0)  _confirmCount -- ;
            NSString    * alertStr = [NSString stringWithFormat:@"密码错误，还可以输入%d次",_confirmCount];
            if (_confirmCount == 0) {
                alertStr = GesturePwdConfirmFailureTooMany;
            }
            self.tfLabel.text = alertStr;
            self.tfLabel.textColor = GESTUREPSW_WRONGCOLOR;
            [self shake:self.tfLabel];
            color = GESTUREPSW_WRONGCOLOR;

        }
    }
    
    return color;
}

/**
 *   成功的block回调
 */
- (void)blockAction:(NSString *)resultStr
{
    if (self.block)
    {
        _gestureModel = NoneModel;
        self.block([resultStr stringByReplacingOccurrencesOfString:@"A" withString:@"__"]);
    }
}



#pragma mark - getter

- (NSMutableArray *)btnArray
{
    if (_btnArray==nil) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (UILabel *)tfLabel
{
    if (_tfLabel==nil) {
        _tfLabel = [UILabel new];
        _tfLabel.textAlignment = NSTextAlignmentCenter;
        _tfLabel.textColor = [UIColor yellowColor];
        _tfLabel.font= [UIFont fontWithName:@"PingFangHK-Semibold" size:15];
        _tfLabel.text = GesturePwdSettingStr;
        [self addSubview:_tfLabel];
        
        [_tfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (_gestureModel == GesturePWDModelConfirmPwdModel) {
                make.top.equalTo(self);
            }
            else{
                make.top.equalTo(self.subItemsss.mas_bottom).offset(41);
            }
            make.centerX.equalTo(self);
        }];
    }
    return _tfLabel;
}


- (GesturePwdSubItem *)subItemsss
{
    if (_subItemsss==nil) {
        _subItemsss = [GesturePwdSubItem new];
        [_subItemsss setNeedsDisplay];
        [self addSubview:_subItemsss];
        
        [_subItemsss mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(SUBITEM_TOP);
            make.centerX.equalTo(self);
            make.width.height.mas_equalTo(SUBITEMTOTALWH);
        }];
        
        _subItemsss.hidden = _gestureModel == GesturePWDModelConfirmPwdModel;
    }
    return _subItemsss;
}


#pragma mark - drawRect
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];

    for (int i=0; i<self.btnArray.count; i++)
    {
        GesturePwdItem *item = (GesturePwdItem *)self.btnArray[i];
        if (i==0)
        {
            [path moveToPoint:item.center];
        }
        else
        {
            [path addLineToPoint:item.center];
        }
    }
    
    if (_movePoint.x!=0 && _movePoint.y!=0 && NSStringFromCGPoint(_movePoint))
    {
        [path addLineToPoint:_movePoint];
    }
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineWidth:ITEMRADIUS_LINEWIDTH];
    [GESTUREPSW_ALERT_TEXTCOLOR setStroke];
    [path stroke];
}


@end
