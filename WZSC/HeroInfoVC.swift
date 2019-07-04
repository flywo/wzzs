//
//  HeroInfoVC.swift
//  WZSC
//
//  Created by yuhua on 2019/5/28.
//  Copyright © 2019 余华. All rights reserved.
//

import UIKit
import Photos

class HeroInfoVC: UIViewController {
    
    var scroll: UIScrollView!
    var hero: Hero!
    var skinBig: UIImageView!
    var skinName: UILabel!
    var skillName: UILabel!
    var skillCool: UILabel!
    var skillDes: UITextView!
    var skillTips: UITextView!
    var items = [UIImageView]()
    var itemTips: UITextView!
    var video: UIButton!
    var segment: UISegmentedControl!
    var skinSelected = 0
    var skillSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        edgesForExtendedLayout = .init(rawValue: 0)
        title = hero.name
        
        scroll = UIScrollView()
        view.addSubview(scroll)
        scroll.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(view)
        }
        scroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*2)
        
        //皮肤大图
        skinBig = UIImageView()
        skinBig.contentMode = .scaleAspectFill
        scroll.addSubview(skinBig)
        skinBig.snp.makeConstraints {
            $0.top.left.equalTo(scroll)
            $0.height.equalTo(UIScreen.main.bounds.width/1.618)
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
        skinBig.kf.setImage(with: URL(string: hero.heroInfo?.skins?.first?.last ?? ""), placeholder: CustomCreate.createActivity())
        //皮肤列表
        let skins = UITableView()
        skins.backgroundColor = .clear
        skins.tag = 1
        skins.separatorStyle = .none
        skins.delegate = self
        skins.dataSource = self
        skins.register(UITableViewCell.self, forCellReuseIdentifier: "HeroSkinCell")
        skins.tableFooterView = UIView()
        scroll.addSubview(skins)
        skins.snp.makeConstraints {
            $0.top.left.equalTo(skinBig).offset(5)
            $0.bottom.equalTo(skinBig).offset(-5)
            $0.width.equalTo(50)
        }
        //皮肤名称
        skinName = WhiteLabel()
        skinName.font = UIFont.systemFont(ofSize: 20)
        skinName.textAlignment = .center
        skinName.text = hero.heroInfo?.skin?.first
        skinName.textColor = CustomColor.mainColor
        skinBig.addSubview(skinName)
        skinName.snp.makeConstraints {
            $0.top.left.right.equalTo(skinBig)
            $0.height.equalTo(30)
        }
        //保存皮肤
        let save = UIButton()
        save.setImage(UIImage(named: "download"), for: .normal)
        view.addSubview(save)
        save.snp.makeConstraints {
            $0.right.bottom.equalTo(skinBig).offset(-10)
            $0.width.equalTo(40)
            $0.height.equalTo(33)
        }
        save.addTarget(self, action: #selector(saveSkin), for: .touchUpInside)
        
        //技能列表
        let skills = UITableView()
        skills.tag = 2
        skills.separatorStyle = .none
        skills.delegate = self
        skills.dataSource = self
        skills.register(UITableViewCell.self, forCellReuseIdentifier: "HeroSkillCell")
        skills.tableFooterView = UIView()
        scroll.addSubview(skills)
        skills.snp.makeConstraints {
            $0.top.equalTo(skinBig.snp.bottom).offset(5)
            $0.left.equalTo(scroll).offset(5)
            $0.width.equalTo(50)
            $0.height.equalTo(250)
        }
        //技能名称
        skillName = UILabel()
        skillName.font = UIFont.systemFont(ofSize: 18)
        skillName.textColor = CustomColor.mainColor
        scroll.addSubview(skillName)
        skillName.snp.makeConstraints {
            $0.left.equalTo(skills.snp.right).offset(5)
            $0.top.equalTo(skinBig.snp.bottom).offset(5)
            $0.right.equalTo(skinBig)
            $0.height.equalTo(30)
        }
        skillName.text = hero.heroInfo?.skills?[0][0] ?? ""
        //技能消耗
        skillCool = UILabel()
        skillCool.font = UIFont.systemFont(ofSize: 16)
        skillCool.adjustsFontSizeToFitWidth = true
        skillCool.textColor = CustomColor.mainColor
        scroll.addSubview(skillCool)
        skillCool.snp.makeConstraints {
            $0.left.equalTo(skills.snp.right).offset(5)
            $0.top.equalTo(skillName.snp.bottom).offset(5)
            $0.right.equalTo(skinBig)
            $0.height.equalTo(30)
        }
        skillCool.text = hero.heroInfo?.skills?[0][2] ?? ""
        //技能描述
        skillDes = UITextView()
        skillDes.layer.cornerRadius = 2
        skillDes.backgroundColor = CustomColor.mainColor
        skillDes.textColor = CustomColor.textColorWhite
        skillDes.isEditable = false
        skillDes.isSelectable = false
        skillDes.font = UIFont.systemFont(ofSize: 14)
        skillDes.textContainerInset = .init()
        scroll.addSubview(skillDes)
        skillDes.text = hero.heroInfo?.skills?[0][3] ?? ""
        //技能提示
        skillTips = UITextView()
        skillTips.layer.cornerRadius = 2
        skillTips.isEditable = false
        skillTips.isSelectable = false
        skillTips.backgroundColor = CustomColor.mainColor
        skillTips.textColor = CustomColor.textColorWhite
        skillTips.font = UIFont.systemFont(ofSize: 12)
        skillTips.textContainerInset = .init()
        scroll.addSubview(skillTips)
        skillTips.snp.makeConstraints {
            $0.left.equalTo(skills.snp.right).offset(5)
            $0.bottom.equalTo(skills.snp.bottom)
            $0.right.equalTo(skinBig).offset(-5)
            $0.height.equalTo(50)
        }
        skillTips.text = hero.heroInfo?.skills?[0][4] ?? ""
        
        skillDes.snp.makeConstraints {
            $0.left.equalTo(skills.snp.right).offset(5)
            $0.top.equalTo(skillCool.snp.bottom).offset(5)
            $0.right.equalTo(skinBig).offset(-5)
            $0.bottom.equalTo(skillTips.snp.top).offset(-5)
        }
        
        //出装分类
        segment = UISegmentedControl(items: ["推荐出装一", "推荐出装二"])
        segment.selectedSegmentIndex = 0
        segment.tintColor = CustomColor.mainColor
        scroll.addSubview(segment)
        segment.snp.makeConstraints {
            $0.top.equalTo(skills.snp.bottom).offset(10)
            $0.height.equalTo(30)
            $0.left.equalTo(scroll).offset(10)
            $0.right.equalTo(skinBig).offset(-10)
        }
        segment.addTarget(self, action: #selector(segmentValueChenge(segment:)), for: .valueChanged)
        //出装图片
        let width = (UIScreen.main.bounds.width-70)/6
        for i in 0...5 {
            let image = UIImageView()
            image.tag = i+10
            image.contentMode = .scaleAspectFit
            let id = hero.heroInfo?.items?.first?[i] ?? ""
            image.kf.setImage(with: URL(string: "https://game.gtimg.cn/images/yxzj/img201606/itemimg/\(id).jpg"), placeholder: CustomCreate.createActivity())
            scroll.addSubview(image)
            image.snp.makeConstraints {
                $0.size.equalTo(CGSize(width: width, height: width))
                $0.top.equalTo(segment.snp.bottom).offset(5)
                $0.left.equalTo(scroll).offset(10+(10+width)*CGFloat(i))
            }
            items.append(image)
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageTap(tap:)))
            image.isUserInteractionEnabled = true
            image.addGestureRecognizer(tap)
        }
        //出装tips
        itemTips = UITextView()
        itemTips.isEditable = false
        itemTips.isSelectable = false
        itemTips.textColor = CustomColor.textColorWhite
        itemTips.backgroundColor = CustomColor.mainColor
        itemTips.layer.cornerRadius = 2
        itemTips.font = UIFont.systemFont(ofSize: 12)
        itemTips.textContainerInset = .init()
        scroll.addSubview(itemTips)
        itemTips.snp.makeConstraints {
            $0.left.equalTo(skinBig).offset(5)
            $0.right.equalTo(skinBig).offset(-5)
            $0.height.equalTo(50)
            $0.top.equalTo(segment.snp.bottom).offset(width+10)
        }
        itemTips.text = hero.heroInfo?.itemsTips?.first ?? ""
        
        //推荐铭文
        let mingLabel = UILabel()
        mingLabel.textColor = CustomColor.mainColor
        mingLabel.font = UIFont.systemFont(ofSize: 18)
        mingLabel.text = "推荐铭文"
        scroll.addSubview(mingLabel)
        mingLabel.snp.makeConstraints {
            $0.top.equalTo(itemTips.snp.bottom).offset(10)
            $0.height.equalTo(30)
            $0.left.equalTo(scroll).offset(20)
            $0.right.equalTo(skinBig)
        }
        for i in 0...2 {
            let image = UIImageView()
            image.tag = i+20
            image.contentMode = .scaleAspectFit
            let id = hero.heroInfo?.ming?[i] ?? ""
            image.kf.setImage(with: URL(string: "https://game.gtimg.cn/images/yxzj/img201606/mingwen/\(id).png"), placeholder: CustomCreate.createActivity())
            scroll.addSubview(image)
            image.snp.makeConstraints {
                $0.size.equalTo(CGSize(width: width, height: width))
                $0.top.equalTo(mingLabel.snp.bottom).offset(5)
                $0.left.equalTo(scroll).offset(10+(10+width)*CGFloat(i))
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageTap(tap:)))
            image.isUserInteractionEnabled = true
            image.addGestureRecognizer(tap)
        }
        //铭文tips
        let mingTips = UITextView()
        mingTips.isEditable = false
        mingTips.isSelectable = false
        mingTips.textColor = CustomColor.textColorWhite
        mingTips.backgroundColor = CustomColor.mainColor
        mingTips.layer.cornerRadius = 2
        mingTips.font = UIFont.systemFont(ofSize: 12)
        mingTips.textContainerInset = .init()
        scroll.addSubview(mingTips)
        mingTips.snp.makeConstraints {
            $0.left.equalTo(skinBig).offset(5)
            $0.right.equalTo(skinBig).offset(-5)
            $0.height.equalTo(40)
            $0.top.equalTo(mingLabel.snp.bottom).offset(width+10)
        }
        mingTips.text = hero.heroInfo?.mingTips ?? ""
        
        //英雄故事
        let storyLabel = UILabel()
        storyLabel.textColor = CustomColor.mainColor
        storyLabel.font = UIFont.systemFont(ofSize: 18)
        storyLabel.text = "英雄故事"
        scroll.addSubview(storyLabel)
        storyLabel.snp.makeConstraints {
            $0.top.equalTo(mingTips.snp.bottom).offset(10)
            $0.height.equalTo(30)
            $0.left.equalTo(scroll).offset(20)
            $0.right.equalTo(skinBig)
        }
        //故事
        let story = UITextView()
        story.isEditable = false
        story.isSelectable = false
        story.backgroundColor = CustomColor.mainColor
        story.layer.cornerRadius = 2
        story.font = UIFont.systemFont(ofSize: 12)
        story.textContainerInset = .init()
        scroll.addSubview(story)
        var text = hero.heroInfo?.story ?? ""
        text = text.replacingOccurrences(of: "<p>", with: "\t")
        text = text.replacingOccurrences(of: "</p>", with: "")
        text = text.replacingOccurrences(of: "<br>", with: "\n\t")
        let spacing = NSMutableParagraphStyle()
        spacing.lineSpacing = 4
        spacing.paragraphSpacing = 8
        let attr = [NSAttributedString.Key.paragraphStyle: spacing, NSAttributedString.Key.foregroundColor: CustomColor.textColorWhite]
        story.attributedText = NSAttributedString(string: text, attributes: attr)
        let max = getTextViewHeight(textView: story, width: UIScreen.main.bounds.width-10)
        var textViewHeight = 400
        if Int(max) < textViewHeight {
            textViewHeight = Int(max)
        }
        story.snp.makeConstraints {
            $0.left.equalTo(skinBig).offset(5)
            $0.right.equalTo(skinBig).offset(-5)
            $0.height.equalTo(textViewHeight)
            $0.top.equalTo(storyLabel.snp.bottom).offset(5)
        }
        
        //视频
        video = UIButton()
        let videoTitle = NSAttributedString(string: "想学点技术，点击这里查看教学视频！", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: CustomColor.mainColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.obliqueness: 0.5])
        video.setAttributedTitle(videoTitle, for: .normal)
        scroll.addSubview(video)
        video.snp.makeConstraints {
            $0.left.right.equalTo(skinBig)
            $0.top.equalTo(story.snp.bottom).offset(10)
            $0.height.equalTo(30)
        }
        video.addTarget(self, action: #selector(jumpVideoList), for: .touchUpInside)
    }
    
    @objc func saveSkin() {
        if let image = skinBig.image {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized || status == .notDetermined {
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveImage(image:error:info:)), nil)
                } else {
                    BWHUD.infoHUD(msg: "没有保存到相册的权限！")
                }
            }
        } else {
            BWHUD.infoHUD(msg: "正在下载该皮肤，请稍后再保存！")
        }
    }
    
    @objc func saveImage(image: UIImage, error: NSError?, info: AnyObject) {
        if error == nil {
            BWHUD.successHUD(msg: "已存储到相册！")
        } else {
            BWHUD.infoHUD(msg: "保存失败！")
        }
    }
    
    @objc func imageTap(tap: UITapGestureRecognizer) {
        if tap.view!.tag >= 20, let mings = CommonData.mings {
            //铭文
            let id = hero.heroInfo?.ming?[tap.view!.tag-20] ?? ""
            let ming = mings.first(where: { $0.id == id })
            guard let obj = ming else {
                return
            }
            CustomCreate.showMingTips(ming: obj)
        } else {
            //装备
            guard let items = CommonData.items else {
                return
            }
            let id = (segment.selectedSegmentIndex==0) ? (hero.heroInfo?.items?.first?[tap.view!.tag-10] ?? "") : (hero.heroInfo?.items?.last?[tap.view!.tag-10] ?? "")
            let item = items.first(where: { "\($0.id)" == id })
            guard let obj = item else {
                return
            }
            CustomCreate.showItemTips(item: obj)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if video.frame.origin.y != 0 {
            let rect = video.frame
            if rect.origin.y+rect.size.height+10 == scroll.contentSize.height {
                print("无需再次修改高度\(scroll.contentSize)")
                return
            }
            print("修改scroll的contentsize\(rect)")
            scroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: rect.origin.y+rect.size.height+10)
        }
    }
    
    @objc func jumpVideoList() {
        let videoVC = VideoList()
        videoVC.hero = hero
        navigationController?.pushViewController(videoVC, animated: true)
    }
    
    @objc func segmentValueChenge(segment: UISegmentedControl) {
        for (index, image) in items.enumerated() {
            let id = (segment.selectedSegmentIndex==0) ? (hero.heroInfo?.items?.first?[index] ?? "") : (hero.heroInfo?.items?.last?[index] ?? "")
            image.kf.setImage(with: URL(string: "https://game.gtimg.cn/images/yxzj/img201606/itemimg/\(id).jpg"), placeholder: CustomCreate.createActivity())
            itemTips.text = (segment.selectedSegmentIndex==0) ? (hero.heroInfo?.itemsTips?.first ?? "") : (hero.heroInfo?.itemsTips?.last ?? "")
        }
    }
    
    deinit {
        print("\(type(of: self))销毁了")
    }
}

extension HeroInfoVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return hero.heroInfo?.skins?.count ?? 0
        } else if tableView.tag == 2 {
            return hero.heroInfo?.skills?.count ?? 0
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if tableView.tag == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "HeroSkinCell", for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            for sub in cell.contentView.subviews {
                sub.removeFromSuperview()
            }
            if skinSelected == indexPath.row {
                let back = UIView()
                back.backgroundColor = CustomColor.mainColor
                cell.contentView.addSubview(back)
                back.snp.makeConstraints {
                    $0.left.top.bottom.right.equalTo(cell.contentView)
                }
            }
            let image = UIImageView()
            cell.contentView.addSubview(image)
            image.snp.makeConstraints {
                $0.left.top.equalTo(cell.contentView).offset(2)
                $0.right.bottom.equalTo(cell.contentView).offset(-2)
            }
            let skin = hero.heroInfo?.skins?[indexPath.row].first ?? ""
            image.kf.setImage(with: URL(string: skin), placeholder: CustomCreate.createActivity())
        } else if tableView.tag == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "HeroSkillCell", for: indexPath)
            cell.selectionStyle = .none
            for sub in cell.contentView.subviews {
                sub.removeFromSuperview()
            }
            if skillSelected == indexPath.row {
                let back = UIView()
                back.layer.cornerRadius = 25
                back.backgroundColor = CustomColor.mainColor
                cell.contentView.addSubview(back)
                back.snp.makeConstraints {
                    $0.left.top.bottom.right.equalTo(cell.contentView)
                }
            }
            let image = UIImageView()
            cell.contentView.addSubview(image)
            image.snp.makeConstraints {
                $0.left.top.equalTo(cell.contentView).offset(2)
                $0.right.bottom.equalTo(cell.contentView).offset(-2)
            }
            let skin = hero.heroInfo?.skills?[indexPath.row][1] ?? ""
            image.kf.setImage(with: URL(string: skin), placeholder: CustomCreate.createActivity())
        } else {
            cell = UITableViewCell()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 1 || tableView.tag == 2 {
            return 50
        }
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            if skinSelected == indexPath.row {
                return
            }
            skinSelected = indexPath.row
            let url = hero.heroInfo?.skins?[indexPath.row].last ?? ""
            skinBig.image = nil
            skinBig.kf.setImage(with: URL(string: url), placeholder: CustomCreate.createActivity())
            skinName.text = hero.heroInfo?.skin?[indexPath.row]
        } else if tableView.tag == 2 {
            if skillSelected == indexPath.row {
                return
            }
            skillSelected = indexPath.row
            skillName.text = hero.heroInfo?.skills?[indexPath.row][0] ?? ""
            skillCool.text = hero.heroInfo?.skills?[indexPath.row][2] ?? ""
            skillDes.text = hero.heroInfo?.skills?[indexPath.row][3] ?? ""
            skillTips.text = hero.heroInfo?.skills?[indexPath.row][4] ?? ""
        }
        tableView.reloadData()
    }
}
