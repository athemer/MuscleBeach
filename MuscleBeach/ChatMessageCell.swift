//
//  ChatMessageCell.swift
//  NewMessenger
//
//  Created by Farukh IQBAL on 23/03/2017.
//  Copyright © 2017 Farukh. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {

    
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.font = .systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.textColor = .white
        tv.isEditable = false

        return tv
    }()

    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0/255, green: 137/255, blue: 249/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true

        return view
    } ()

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MBLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(profileImageView)
        addSubview(bubbleView)
        addSubview(textView)


        // Constraint anchors: x, y, width, height
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true

        // Constraint anchors: x, y, width, height
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)

        bubbleViewRightAnchor?.isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true

        // Constraint anchors: x, y, width, height
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        

        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
