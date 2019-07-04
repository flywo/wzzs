//
//  VideoCell.swift
//  WZSC
//
//  Created by yuhua on 2019/5/31.
//  Copyright © 2019 余华. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {
    
    var videoImage: UIImageView!
    var videoTitle: UILabel!
    var videoDesc: UILabel!
    var videoDetail: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        videoImage = UIImageView()
        videoImage.contentMode = .scaleAspectFill
        videoImage.layer.masksToBounds = true
        contentView.addSubview(videoImage)
        
        videoTitle = UILabel()
        videoTitle.textColor = CustomColor.mainColor
        videoTitle.font = UIFont.systemFont(ofSize: 18)
        videoTitle.numberOfLines = 2
        videoTitle.textAlignment = .left
        videoTitle.adjustsFontSizeToFitWidth = true
        contentView.addSubview(videoTitle)
        
        videoDesc = UILabel()
        videoDesc.textColor = CustomColor.mainColor
        videoDesc.font = UIFont.systemFont(ofSize: 12)
        videoDesc.textAlignment = .left
        videoDesc.adjustsFontSizeToFitWidth = true
        videoDesc.numberOfLines = 3
        contentView.addSubview(videoDesc)
        
        videoDetail = UILabel()
        videoDetail.textColor = .gray
        videoDetail.font = UIFont.systemFont(ofSize: 10)
        videoDetail.textAlignment = .left
        videoDetail.adjustsFontSizeToFitWidth = true
        contentView.addSubview(videoDetail)
        
        videoImage.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
            $0.width.equalTo(100/0.618)
        }
        
        videoTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.left.equalTo(videoImage.snp.right).offset(5)
            $0.height.equalTo(40)
        }
        
        videoDesc.snp.makeConstraints {
            $0.top.equalTo(videoTitle.snp.bottom)
            $0.right.equalToSuperview().offset(-5)
            $0.left.equalTo(videoTitle)
            $0.height.equalTo(40)
        }
        
        videoDetail.snp.makeConstraints {
            $0.right.bottom.equalToSuperview().offset(-5)
            $0.left.equalTo(videoTitle)
            $0.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
