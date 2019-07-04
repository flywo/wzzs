//
//  MingVC.swift
//  WZSC
//
//  Created by yuhua on 2019/5/27.
//  Copyright © 2019 余华. All rights reserved.
//

import UIKit

class MingVC: UIViewController {

    var storeMings = [Ming]()
    var mings = [Ming]()
    var collection: UICollectionView!
    var show: UIButton!
    var choice: UIScrollView!
    var choiceButtons = [UIButton]()
    var currentUpChoice = 0
    var currentDownChoice = 0
    
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
        t1.text = "颜色"
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
        let b1 = addChoiceBtn(title: "红色")
        choice.addSubview(b1)
        b1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalTo(b0.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height/2-10))
        }
        let b2 = addChoiceBtn(title: "蓝色")
        choice.addSubview(b2)
        b2.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalTo(b1.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height/2-10))
        }
        let b9 = addChoiceBtn(title: "绿色")
        choice.addSubview(b9)
        b9.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalTo(b2.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height/2-10))
        }
        let t2 = UILabel()
        t2.textColor = CustomColor.mainColor
        t2.font = UIFont.systemFont(ofSize: 12)
        t2.text = "等级"
        t2.textAlignment = .center
        choice.addSubview(t2)
        t2.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalToSuperview().offset(30)
            $0.height.equalTo(choice.frame.height/2)
            $0.width.equalTo(50)
        }
        let b3 = addChoiceBtn(title: "全部")
        choice.addSubview(b3)
        b3.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.left.equalTo(t2.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height/2-10))
        }
        let b4 = addChoiceBtn(title: "五级")
        choice.addSubview(b4)
        b4.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.left.equalTo(b3.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height/2-10))
        }
        let b5 = addChoiceBtn(title: "四级")
        choice.addSubview(b5)
        b5.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.left.equalTo(b4.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height/2-10))
        }
        let b6 = addChoiceBtn(title: "三级")
        choice.addSubview(b6)
        b6.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.left.equalTo(b5.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height/2-10))
        }
        let b7 = addChoiceBtn(title: "二级")
        choice.addSubview(b7)
        b7.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.left.equalTo(b6.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height/2-10))
        }
        let b8 = addChoiceBtn(title: "一级")
        choice.addSubview(b8)
        b8.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.left.equalTo(b7.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height/2-10))
        }
        
        let width = (UIScreen.main.bounds.width-70)/5
        let flow = UICollectionViewFlowLayout()
        flow.itemSize = CGSize(width: width, height: width+20)
        collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        collection.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        collection.register(HeroCell.self, forCellWithReuseIdentifier: "MingCell")
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(show.snp.bottom).offset(5)
            $0.left.equalTo(view).offset(5)
            $0.right.bottom.equalTo(view).offset(-5)
        }
        
        clearUpChoice()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    func updateData() {
        if mings.isEmpty {
            let request = Net.GetMing(fail: {
                DispatchQueue.main.async {
                    BWHUD.infoHUD(msg: "无法获取！")
                }
            }) { value in
                self.storeMings = value
                self.mings = value
                DispatchQueue.main.async {
                    self.collection.reloadData()
                }
            }
            if let req = request {
                BWHUD.showHUD(msg: "获取铭文列表...") {
                    print("获取超时，取消请求")
                    req.cancel()
                }
            }
        }
    }
    func clearUpChoice() {
        choiceButtons.filter { $0.isSelected }.forEach {
            $0.isSelected = false
            $0.backgroundColor = CustomColor.backgroundColor
        }
        [choiceButtons[currentUpChoice], choiceButtons[currentDownChoice+4]].forEach {
                $0.isSelected = true
                $0.backgroundColor = CustomColor.mainColor
        }
        switch currentUpChoice {
        case 1:
            mings = storeMings.filter { $0.type=="red" }
        case 2:
            mings = storeMings.filter { $0.type=="yellow" }
        case 3:
            mings = storeMings.filter { $0.type=="blue" }
        default:
            mings = storeMings
        }
        switch currentDownChoice {
        case 1:
            mings = mings.filter { $0.grade=="5" }
        case 2:
            mings = mings.filter { $0.grade=="4" }
        case 3:
            mings = mings.filter { $0.grade=="3" }
        case 4:
            mings = mings.filter { $0.grade=="2" }
        case 5:
            mings = mings.filter { $0.grade=="1" }
        default:
            break
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
        let index = choiceButtons.firstIndex(of: btn)!
        if index <= 3 {
            currentUpChoice = index
        } else {
            currentDownChoice = index-4
        }
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


extension MingVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mings.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MingCell", for: indexPath) as! HeroCell
        let ming = mings[indexPath.row]
        cell.heroImage.image = nil
        cell.heroImage.kf.setImage(with: URL(string: ming.imageUrl), placeholder: CustomCreate.createActivity())
        cell.heroName.text = "\(ming.name)(\(ming.grade))"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let ming = mings[indexPath.row]
        CustomCreate.showMingTips(ming: ming)
    }
}
