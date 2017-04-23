//
//  MainPageImagesTableViewCell.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/12.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class MainPageImagesTableViewCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpScrollView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = scrollView.frame.width
        let currentPage: CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        self.pageControl.currentPage = Int(currentPage)

    }

    func setUpScrollView() {
//        self.scrollView.frame = CGRect(x: 0, y: 0, width: 375, height: 240)
        let scrollViewWidth: CGFloat = self.scrollView.frame.width
        let scrollViewHeight: CGFloat = self.scrollView.frame.height

        let imageUrlRef = FIRDatabase.database().reference().child("homePageImages")
        imageUrlRef.observe(.value, with: { (snapshot) in

            if let snap = snapshot.value as? [String: Any] {

                guard
                    let urlOne = snap["image1Url"] as? String,
                    let urlTwo = snap["image2Url"] as? String,
                    let urlThree = snap["image3Url"] as? String,
                    let urlFour = snap["image4Url"] as? String else { return }

                let imgOne = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight))
//                imgOne.image = UIImage(named: "MBLogo")
                imgOne.loadImageUsingCacheWithUrlString(urlString: urlOne)
                imgOne.contentMode = .scaleAspectFill

                let imgTwo = UIImageView(frame: CGRect(x: scrollViewWidth, y: 0, width: scrollViewWidth, height: scrollViewHeight))
                imgTwo.loadImageUsingCacheWithUrlString(urlString: urlTwo)
                imgTwo.contentMode = .scaleAspectFill

                let imgThree = UIImageView(frame: CGRect(x: scrollViewWidth * 2, y: 0, width: scrollViewWidth, height: scrollViewHeight))
                imgThree.loadImageUsingCacheWithUrlString(urlString: urlThree)
                imgThree.contentMode = .scaleAspectFill

                let imgFour = UIImageView(frame: CGRect(x:scrollViewWidth * 3, y:0, width:scrollViewWidth, height:scrollViewHeight))
                imgFour.loadImageUsingCacheWithUrlString(urlString: urlFour)
                imgFour.contentMode = .scaleAspectFill

                self.scrollView.addSubview(imgOne)
                self.scrollView.addSubview(imgTwo)
                self.scrollView.addSubview(imgThree)
                self.scrollView.addSubview(imgFour)

            }

        })

        self.scrollView.isPagingEnabled = true
        //4
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * 4, height: self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(changePage(sender:)), for: .valueChanged)
    }

    func changePage(sender: AnyObject) {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        let point: CGPoint = CGPoint(x: x, y: 0)
        scrollView.setContentOffset(point, animated: true)
    }

}
