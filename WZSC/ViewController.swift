//
//  ViewController.swift
//  WZSC
//
//  Created by yuhua on 2019/5/27.
//  Copyright © 2019 余华. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    var storeHeros = [Hero]()
    var heros = [Hero]()
    var collection: UICollectionView!
    var show: UIButton!
    var choice: UIScrollView!
    var choiceButtons = [UIButton]()
    var currentChoice = 0
    var reloadButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        edgesForExtendedLayout = .init(rawValue: 0)
        
        show = UIButton()
        show.backgroundColor = CustomColor.mainColor
        show.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        show.setTitle("点击这里进行筛选", for: .normal)
        show.setTitle("点击这里收回", for: .selected)
        show.setTitleColor(CustomColor.textColorWhite, for: .normal)
        show.setTitleColor(CustomColor.textColorWhite, for: .selected)
        view.addSubview(show)
        show.snp.makeConstraints {
            $0.top.left.right.equalTo(view)
            $0.height.equalTo(30)
        }
        show.addTarget(self, action: #selector(show(btn:)), for: .touchUpInside)
        
        choice = UIScrollView()
        choice.alpha = 0
        view.addSubview(choice)
        choice.snp.makeConstraints {
            $0.left.right.equalTo(view)
            $0.top.equalTo(show.snp.bottom)
            $0.height.equalTo(60)
        }
        choice.contentSize = CGSize(width: max(UIScreen.main.bounds.width, 55*7), height: 60)
        view.layoutIfNeeded()
        let t1 = UILabel()
        t1.textColor = CustomColor.mainColor
        t1.font = UIFont.systemFont(ofSize: 12)
        t1.text = "综合"
        t1.textAlignment = .center
        choice.addSubview(t1)
        t1.snp.makeConstraints {
            $0.left.top.equalToSuperview()
            $0.height.equalTo(choice.frame.height/2)
            $0.width.equalTo(50)
        }
        let b0 = addChoiceBtn(title: "全部")
        choice.addSubview(b0)
        b0.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalTo(t1.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height/2-10))
        }
        let b1 = addChoiceBtn(title: "周免")
        choice.addSubview(b1)
        b1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalTo(b0.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height/2-10))
        }
        let b2 = addChoiceBtn(title: "新手")
        choice.addSubview(b2)
        b2.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalTo(b1.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height/2-10))
        }
        let t2 = UILabel()
        t2.textColor = CustomColor.mainColor
        t2.font = UIFont.systemFont(ofSize: 12)
        t2.text = "定位"
        t2.textAlignment = .center
        choice.addSubview(t2)
        t2.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalToSuperview().offset(30)
            $0.height.equalTo(choice.frame.height/2)
            $0.width.equalTo(50)
        }
        let b3 = addChoiceBtn(title: "坦克")
        choice.addSubview(b3)
        b3.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.left.equalTo(t2.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height/2-10))
        }
        let b4 = addChoiceBtn(title: "战士")
        choice.addSubview(b4)
        b4.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.left.equalTo(b3.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height/2-10))
        }
        let b5 = addChoiceBtn(title: "刺客")
        choice.addSubview(b5)
        b5.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.left.equalTo(b4.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height/2-10))
        }
        let b6 = addChoiceBtn(title: "法师")
        choice.addSubview(b6)
        b6.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.left.equalTo(b5.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height/2-10))
        }
        let b7 = addChoiceBtn(title: "射手")
        choice.addSubview(b7)
        b7.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.left.equalTo(b6.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height/2-10))
        }
        let b8 = addChoiceBtn(title: "辅助")
        choice.addSubview(b8)
        b8.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.left.equalTo(b7.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height/2-10))
        }
        
        let width = (UIScreen.main.bounds.width-60)/4
        let flow = UICollectionViewFlowLayout()
        flow.itemSize = CGSize(width: width, height: width+20)
        collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        collection.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        collection.register(HeroCell.self, forCellWithReuseIdentifier: "HeroCell")
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalTo(view).offset(5)
            $0.top.equalTo(show.snp.bottom).offset(5)
            $0.right.bottom.equalTo(view).offset(-5)
        }
        
        reloadButton.setTitle("点击这里重新获取", for: .normal)
        reloadButton.setTitleColor(CustomColor.mainColor, for: .normal)
        reloadButton.layer.borderColor = CustomColor.mainColor.cgColor
        reloadButton.layer.borderWidth = 1
        reloadButton.layer.cornerRadius = 2
        view.addSubview(reloadButton)
        reloadButton.snp.makeConstraints {
            $0.center.equalTo(view)
            $0.size.equalTo(CGSize(width: 200, height: 40))
        }
        reloadButton.addTarget(self, action: #selector(updateData), for: .touchUpInside)
        
        clearUpChoice()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    @objc func updateData() {
        if heros.isEmpty {
            let request = Net.GetHero(fail: {
                DispatchQueue.main.async {
                    BWHUD.infoHUD(msg: "无法获取！")
                }
            }) { value in
                self.storeHeros = value
                self.heros = value
                DispatchQueue.main.async {
                    if self.heros.isEmpty {
                        self.reloadButton.isHidden = false
                    } else {
                        self.reloadButton.isHidden = true
                    }
                    self.collection.reloadData()
                    BWHUD.dismissHUD()
                }
            }
            if let req = request {
                BWHUD.showHUD(msg: "获取英雄列表...") {
                    print("获取超时，取消请求")
                    req.cancel()
                }
            }
        }
        if CommonData.mings == nil {
            _ = Net.GetMing()
        }
        if CommonData.items == nil {
            _ = Net.GetEquip()
        }
        if CommonData.summons == nil {
            _ = Net.GetSummon()
        }
        do {
            let total = try Video.db?.scalar(Video.video.count) ?? 0
            print("数据库已存在视频数据：\(total)")
            if total == 0 {
                _ = Net.GetVideo()
            }
        } catch {
            print("数据库查询视频出现错误")
        }
        
    }
    func clearUpChoice() {
        var btn = choiceButtons.first(where: {$0.isSelected})
        btn?.isSelected = false
        btn?.backgroundColor = CustomColor.backgroundColor
        btn = choiceButtons[currentChoice]
        btn?.isSelected = true
        btn?.backgroundColor = CustomColor.mainColor
        switch currentChoice {
        case 1:
            //周免
            heros = storeHeros.filter { $0.payType==10 }
        case 2:
            //新手
            heros = storeHeros.filter { $0.payType==11 }
        case 3:
            //坦克
            heros = storeHeros.filter { $0.heroType==3 }
        case 4:
            //战士
            heros = storeHeros.filter { $0.heroType==1 }
        case 5:
            //刺客
            heros = storeHeros.filter { $0.heroType==4 }
        case 6:
            //法师
            heros = storeHeros.filter { $0.heroType==2 }
        case 7:
            //射手
            heros = storeHeros.filter { $0.heroType==5 }
        case 8:
            //辅助
            heros = storeHeros.filter { $0.heroType==6 }
        default:
            heros = storeHeros
        }
        collection.reloadData()
    }
    func addChoiceBtn(title: String) -> UIButton {
        let b = UIButton()
        b.setTitle(title, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        b.setTitleColor(CustomColor.mainColor, for: .normal)
        b.setTitleColor(CustomColor.textColorWhite, for: .selected)
        b.backgroundColor = CustomColor.backgroundColor
        b.layer.cornerRadius = 2
        b.layer.borderColor = CustomColor.mainColor.cgColor
        b.layer.borderWidth = 1
        choiceButtons.append(b)
        b.addTarget(self, action: #selector(choiceBtnSelected(btn:)), for: .touchUpInside)
        return b
    }
    @objc func choiceBtnSelected(btn: UIButton) {
        if btn.isSelected {
            return
        }
        currentChoice = choiceButtons.firstIndex(of: btn)!
        clearUpChoice()
    }
    @objc func show(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            UIView.animate(withDuration: 0.5) {
                self.collection.snp.updateConstraints {
                    $0.top.equalTo(self.show.snp.bottom).offset(self.choice.frame.height+5)
                }
                self.view.layoutIfNeeded()
                self.choice.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.collection.snp.updateConstraints {
                    $0.top.equalTo(self.show.snp.bottom).offset(5)
                }
                self.view.layoutIfNeeded()
                self.choice.alpha = 0
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heros.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroCell", for: indexPath) as! HeroCell
        let hero = heros[indexPath.row]
        cell.heroImage.image = nil
        cell.heroImage.kf.setImage(with: URL(string: hero.imageUrl), placeholder: CustomCreate.createActivity())
        cell.heroName.text = hero.name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        var hero = heros[indexPath.row]
        if hero.heroInfo != nil {
            self.jumpHeroInfo(hero: hero)
        } else {
            let request = Net.GetHeroInfo(hero: hero, fail: {
                DispatchQueue.main.async {
                    BWHUD.infoHUD(msg: "无法获取！")
                }
            }) { heroInfo in
                hero.heroInfo = heroInfo
                DispatchQueue.main.async {
                    self.jumpHeroInfo(hero: hero)
                    BWHUD.dismissHUD()
                }
            }
            BWHUD.showHUD(msg: "获取英雄信息...") {
                print("获取超时，取消请求")
                request?.cancel()
            }
        }
    }
    func jumpHeroInfo(hero: Hero) {
        let vc = HeroInfoVC()
        vc.hidesBottomBarWhenPushed = true
        vc.hero = hero
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

