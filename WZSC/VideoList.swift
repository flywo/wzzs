//
//  VideoList.swift
//  WZSC
//
//  Created by yuhua on 2019/5/31.
//  Copyright © 2019 余华. All rights reserved.
//

import UIKit
import SQLite
import AVKit

class VideoList: UIViewController {

    var hero: Hero!
    var videos = [Video]()
    var table: UITableView!
    
    var playerController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        edgesForExtendedLayout = .init(rawValue: 0)
        title = hero.name+"视频"
        
        table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(VideoCell.self, forCellReuseIdentifier: "VideoCell")
        table.tableFooterView = UIView()
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        getVideoList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playerController.player = nil
    }
    
    func play(url: String) {
        if let link = URL(string: url) {
            let item = AVPlayerItem(url: link)
            playerController.player = AVPlayer(playerItem: item)
            navigationController?.present(playerController, animated: true) { [weak self] in
                self?.playerController.player?.play()
            }
        }
    }
    
    func getVideoList() {
        do {
            let result = try Video.db?.prepare(Video.video.where(Video.heroName == hero.name).order(Video.time.desc))
            if let ment = result {
                for row in ment {
                    let video = Video()
                    video.id = row[Video.id]
                    video.title = row[Video.title]
                    video.author = row[Video.author]
                    video.desc = row[Video.desc]
                    video.img = row[Video.img]
                    video.time = row[Video.time]
                    video.totalPlay = row[Video.totalPlay]
                    video.heroName = row[Video.heroName]
                    video.playTime = row[Video.playTime]
                    videos.append(video)
                }
            }
        } catch {
            print("查询视频数据库发生错误")
        }
        if videos.isEmpty {
            BWHUD.infoHUD(msg: "没有视频数据！")
        }
        table.reloadData()
    }
    
    deinit {
        print("\(type(of: self))销毁了")
    }
}

extension VideoList: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        let video = videos[indexPath.row]
        cell.videoImage.image = nil
        cell.videoImage.kf.setImage(with: URL(string: video.img ?? ""), placeholder: CustomCreate.createActivity())
        cell.videoTitle.text = video.title
        cell.videoDesc.text = video.desc
        cell.videoDetail.text = "播放量:\(video.totalPlay ?? "")  创建:\(video.time ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let video = videos[indexPath.row]
        
        Net.GetVideoUrl(videoID: video.id ?? "") { url in
            DispatchQueue.main.async {
                BWHUD.dismissHUD()
                self.play(url: url)
            }
        }
        BWHUD.showHUD(msg: "获取视频中...") {
            print("获取超时，取消请求")
        }
    }
}
