//
//  MMBStatusCell.m
//  My-Microblog
//
//  Created by 赵志丹 on 15/12/1.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "MMBStatusCell.h"
#import "MMBStatusFrame.h"
#import "MMBUser.h"
#import "MMBStatus.h"
#import "UIImageView+WebCache.h"
#import "MMBPhoto.h"
#import "MMBStatusToolbar.h"
#import "MMBStatusPhotoView.h"
#import "MMBStatusPhotosView.h"
#import "MMBIconView.h"
#import "NSAttributedString+Emoji.h"


@interface MMBStatusCell ()
/** 原创微博 */
/** 原创微博整体 */
@property (nonatomic,weak) UIView *originnalView;
/** 头像 */
@property (nonatomic,weak) MMBIconView *iconView;
/** 会员图标 */
@property (nonatomic,weak) UIImageView *vipView;
/** 配图 */
@property (nonatomic,weak) MMBStatusPhotosView *photoView;
/** 昵称 */
@property (nonatomic,weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic,weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic,weak) UILabel *sourceLabel;
/** 正文 */
@property (nonatomic,weak) UILabel *contentLabel;


/** 转发微博 */
/** 转发微博整体 */
@property (nonatomic, weak) UIView *retweetView;
/** 转发微博正文和昵称 */
@property (nonatomic,weak) UILabel *retweetContentLabel;
/** 转发配图 */
@property (nonatomic,weak) MMBStatusPhotosView *retweetPhotoView;

/** 工具条 */
@property (nonatomic, weak) MMBStatusToolbar *toolbar;
@end

@implementation MMBStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellId = @"statusCell";
    MMBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //self.backgroundColor = MMBColor(221, 221, 221);
        //原创微博
        [self setupOriginal];
       
        //转发微博
        [self setupRetweet];
        
        //初始化工具条
        [self setupToolbar];
    }
    return self;
}

/**
 * 初始化工具条
 */
- (void)setupToolbar{
    MMBStatusToolbar *toolbar = [MMBStatusToolbar toolbar];
    [self.contentView addSubview:toolbar];
    self.toolbar = toolbar;
}

/**
 *  转发微博
 */
- (void)setupRetweet{
    //转发微博整体
    UIView *retweetView = [[UIView alloc] init];
    retweetView.backgroundColor = MMBColor(247, 247, 247);
    [self.contentView addSubview:retweetView];
    self.retweetView = retweetView;
    
    /** 转发微博正文 + 昵称 */
    UILabel *retweetContentLabel = [[UILabel alloc] init];
    retweetContentLabel.font = MMBStatusCellContentFont;
    retweetContentLabel.numberOfLines = 0;
    [retweetView addSubview:retweetContentLabel];
    self.retweetContentLabel = retweetContentLabel;
    
    /** 转发微博配图 */
    MMBStatusPhotosView *retweetPhotoView = [[MMBStatusPhotosView alloc] init];
    [retweetView addSubview:retweetPhotoView];
    self.retweetPhotoView = retweetPhotoView;
    
}

/** 原创微博整体 */
- (void)setupOriginal{
    /** 原创微博整体 */
    UIView *originnalView = [[UIView alloc] init];
    originnalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originnalView];
    self.originnalView = originnalView;
    
    /** 头像 */
    MMBIconView *iconView = [[MMBIconView alloc] init];
    [originnalView addSubview:iconView];
    self.iconView = iconView;
    
    /** 会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    vipView.contentMode = UIViewContentModeCenter;
    [originnalView addSubview:vipView];
    self.vipView = vipView;
    
    /** 配图 */
    MMBStatusPhotosView *photoView = [[MMBStatusPhotosView alloc] init];
    [originnalView addSubview:photoView];
    self.photoView = photoView;
    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = MMBStatusCellNameFont;
    [originnalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = MMBStatusCellTimeFont;
    [originnalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = MMBStatusCellSourceFont;
    [originnalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /** 正文 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = MMBStatusCellContentFont;
    contentLabel.numberOfLines = 0;
    [originnalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
}

- (void)setStatusFrame:(MMBStatusFrame *)statusFrame{
    _statusFrame = statusFrame;
    
    MMBStatus *status = statusFrame.status;
    MMBUser *user = status.user;
    
    /** 原创微博整体 */
    self.originnalView.frame = statusFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame = statusFrame.iconViewF;
    self.iconView.user = user;
    //[self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    
    /** 会员图标 */
    if (user.isVip) {
        self.imageView.hidden = NO;
        self.vipView.frame = statusFrame.vipViewF;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%zd",user.mbrank];
        self.vipView.image = [UIImage imageNamed:vipName];
        self.nameLabel.textColor = [UIColor orangeColor];
    }else{
        self.nameLabel.textColor = [UIColor blackColor];
        self.vipView.hidden = YES;
    }
    
    /** 配图 */
    if (status.pic_urls.count) {
        self.photoView.frame = statusFrame.photoViewF;
        //MMBPhoto *photo = [status.pic_urls firstObject];
        self.photoView.photos = status.pic_urls;
        //[self.photoView sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
        self.photoView.hidden = NO;
    }else{
        self.photoView.hidden = YES;
    }
    
    
    
    /** 昵称 */
    self.nameLabel.text = user.name;
    self.nameLabel.frame = statusFrame.nameLabelF;
    
    /** 时间 */
    self.timeLabel.text = status.created_at;
    self.timeLabel.frame = statusFrame.timeLabelF;
    
    /** 来源 */
    self.sourceLabel.text = status.source;
    self.sourceLabel.frame = statusFrame.sourceLabelF;
    
    /** 正文 */
    self.contentLabel.text = status.text;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:status.text];
    //完成图文混排
    self.contentLabel.attributedText = [NSAttributedString emojiStringWithString:attr];
    
    self.contentLabel.frame = statusFrame.contentLabelF;
    
    
    /** 被转发的微博 */
    if (status.retweeted_status){
        MMBStatus *retweeted_status = status.retweeted_status;
        MMBUser *retweeted_status_user = retweeted_status.user;
        self.retweetView.hidden = NO;
        /** 被转发微博整体 */
        self.retweetView.frame = statusFrame.retweetViewF;
        NSString *str = [NSString stringWithFormat:@"@%@ : %@", retweeted_status_user.name,retweeted_status.text];
        NSMutableAttributedString *retweetAttr = [[NSMutableAttributedString alloc] initWithString:str];

        //完成图文混排
        self.retweetContentLabel.attributedText = [NSAttributedString emojiStringWithString:retweetAttr];
        

        self.retweetContentLabel.frame = statusFrame.retweetContentLabelF;
        
        if (retweeted_status.pic_urls.count) {
            //MMBPhoto *photo= [retweeted_status.pic_urls firstObject];
            //[self.retweetPhotoView sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
            self.retweetPhotoView.photos = retweeted_status.pic_urls;
            self.retweetPhotoView.hidden = NO;
            self.retweetPhotoView.frame = statusFrame.retweetPhotoViewF;
        }else{
            self.retweetPhotoView.hidden = YES;
        }
    }else{
        self.retweetView.hidden = YES;
    }
    
    /** 工具条 */
    self.toolbar.frame = statusFrame.toolbarF;
    self.toolbar.status = status;
}





@end
