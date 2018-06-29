//
//  EvaluateCheckInShareView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 14/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

protocol EvaluateCheckInShareViewStyle {
    var shareCheckInDataStreetFont: UIFont { get }
    var shareCheckInDataStreetColor: UIColor { get }
    var shareCheckInDataOtherAddressFont: UIFont { get }
    var shareCheckInDataOtherAddressColor: UIColor { get }
    var shareCheckInDataCoordinatesFont: UIFont { get }
    var shareCheckInDataCoordinatesColor: UIColor { get }
    var shareCheckInDataMapTintColor: UIColor { get }
    var shareCheckInNoDataFont: UIFont { get }
    var shareCheckInNoDataColor: UIColor { get }
}

class EvaluateCheckInShareView: UIView {
    // MARK: - UI
    var imageView = UIImageView()
    var title = UILabel()
    var subtitle = UILabel()
    var dateLabel = UILabel()
    
    // MARK: - Init
    init(places: [LocationValue], title: String, subtitle: String, date: Date) {
        super.init(frame: CGRect.zero)
        
        let style = Themes.manager.shareViewStyle
        
        self.backgroundColor = style.cardShareBackground
        
        self.imageView.image = Sources.image(forType: .checkIn)
        self.imageView.contentMode = .scaleAspectFit
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.width.equalTo(30.0)
            make.height.equalTo(30.0)
            make.top.equalToSuperview().offset(10.0)
            make.leading.equalToSuperview().offset(10.0)
        }
        
        self.title.text = title
        self.title.textColor = style.cardShareTitleColor
        self.title.font = style.cardShareTitleFont
        self.title.numberOfLines = 0
        self.addSubview(self.title)
        self.title.snp.makeConstraints { (make) in
            make.leading.equalTo(self.imageView.snp.trailing).offset(5.0)
            make.top.equalToSuperview().offset(10.0)
            make.trailing.equalToSuperview().offset(-10.0)
        }
        
        self.subtitle.text = subtitle
        self.subtitle.textColor = style.cardShareSubtitleColor
        self.subtitle.font = style.cardShareSubtitleFont
        self.subtitle.numberOfLines = 0
        self.addSubview(self.subtitle)
        self.subtitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.title.snp.bottom)
            make.leading.equalTo(self.imageView.snp.trailing).offset(5.0)
            make.trailing.equalToSuperview().offset(-10.0)
        }
        
        self.dateLabel.text = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        self.dateLabel.textColor = style.cardShareDateColor
        self.dateLabel.font = style.cardShareDateFont
        self.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.subtitle.snp.bottom).offset(5.0)
            make.top.greaterThanOrEqualTo(self.imageView.snp.bottom).offset(5.0)
            make.trailing.equalToSuperview().offset(-10.0)
            make.leading.equalToSuperview().offset(10.0)
        }
        
        if places.isEmpty {
            let messageLabel = UILabel()
            messageLabel.text = Localizations.share.noCheckIns
            messageLabel.font = style.shareCheckInNoDataFont
            messageLabel.textColor = style.shareCheckInNoDataColor
            messageLabel.numberOfLines = 0
            self.addSubview(messageLabel)
            messageLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(dateLabel.snp.bottom).offset(5.0)
                make.trailing.equalToSuperview().offset(-10.0)
                make.leading.equalToSuperview().offset(10.0)
                make.bottom.equalToSuperview().offset(-20.0)
                make.width.equalTo(280.0)
            })
            
        } else {
            var stack = [UIView]()
            for place in places {
                let placeView = UIView()
                let mapImage = UIImageView()
                mapImage.image = #imageLiteral(resourceName: "map")
                mapImage.contentMode = .scaleAspectFit
                placeView.addSubview(mapImage)
                mapImage.snp.makeConstraints({ (make) in
                    make.width.equalTo(20.0)
                    make.height.equalTo(20.0)
                    make.centerY.equalToSuperview()
                    make.leading.equalToSuperview().offset(15.0)
                })
                
                let streetLabel = UILabel()
                streetLabel.text = place.street
                streetLabel.textColor = style.shareCheckInDataStreetColor
                streetLabel.font = style.shareCheckInDataStreetFont
                streetLabel.numberOfLines = 0
                placeView.addSubview(streetLabel)
                streetLabel.snp.makeConstraints({ (make) in
                    make.top.equalToSuperview().offset(10.0)
                    make.leading.equalToSuperview().offset(50.0)
                    make.trailing.equalToSuperview().offset(10.0)
                })
                
                let addressLabel = UILabel()
                addressLabel.text = place.otherAddressString
                addressLabel.textColor = style.shareCheckInDataOtherAddressColor
                addressLabel.font = style.shareCheckInDataOtherAddressFont
                addressLabel.numberOfLines = 0
                placeView.addSubview(addressLabel)
                addressLabel.snp.makeConstraints({ (make) in
                    make.top.equalTo(streetLabel.snp.bottom)
                    make.leading.equalToSuperview().offset(50.0)
                    make.trailing.equalToSuperview().offset(10.0)
                })
                
                let coordinateLabel = UILabel()
                coordinateLabel.text = place.coordinatesString
                coordinateLabel.textColor = style.shareCheckInDataCoordinatesColor
                coordinateLabel.font = style.shareCheckInDataCoordinatesFont
                coordinateLabel.numberOfLines = 0
                placeView.addSubview(coordinateLabel)
                coordinateLabel.snp.makeConstraints({ (make) in
                    make.top.equalTo(addressLabel.snp.bottom)
                    make.leading.equalToSuperview().offset(50.0)
                    make.trailing.equalToSuperview().offset(10.0)
                    make.bottom.equalToSuperview().offset(-10.0)
                })
                
                stack.append(placeView)
            }
            let stackView = UIStackView(arrangedSubviews: stack)
            stackView.axis = .vertical
            stackView.spacing = 5.0
            self.addSubview(stackView)
            stackView.snp.makeConstraints { (make) in
                make.top.equalTo(dateLabel.snp.bottom).offset(5.0)
                make.trailing.equalToSuperview().offset(-10.0)
                make.leading.equalToSuperview().offset(10.0)
                make.bottom.equalToSuperview().offset(-20.0)
                make.width.equalTo(280.0)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
