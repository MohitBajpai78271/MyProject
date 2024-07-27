//
//  MessageCell.swift
//  COP
//
//  Created by Mac on 23/07/24.
//

import UIKit

class MessageCell: UITableViewCell {
    
    var nameLabel: UILabel!
    var phoneNumberLabel: UILabel!
    var placeLabel: UILabel!
    var startTimeLabel: UILabel!
    var endTimeLabel: UILabel!
    
    private var backgroundviw :  UIView!
    
    private var activeLabel: UILabel!
//    private var timeLabelsStack: UIStackView!
    
    private let backgroundShapeLayer = CAShapeLayer()
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return super.hitTest(point, with: event)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

            // Create name label
            nameLabel = UILabel()
            nameLabel.translatesAutoresizingMaskIntoConstraints = false // Disables autoresizing
            nameLabel.font = UIFont.systemFont(ofSize: 20) // Set desired font
            contentView.addSubview(nameLabel)
            
            // Create phone number label
            phoneNumberLabel = UILabel()
            phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
            phoneNumberLabel.font = UIFont.systemFont(ofSize: 18) // Set desired font
            contentView.addSubview(phoneNumberLabel)
        
              backgroundviw = UIView()
              backgroundviw.translatesAutoresizingMaskIntoConstraints = false
              if let prototypeCellColor = UIColor(named: "PrototypeCellColor") {
                  backgroundviw.backgroundColor = prototypeCellColor
              } else {
                  backgroundviw.backgroundColor = UIColor.systemBackground // Fallback color
              }
              contentView.insertSubview(backgroundviw, at: 0)
              
              backgroundShapeLayer.fillColor = UIColor.white.cgColor
              contentView.layer.insertSublayer(backgroundShapeLayer, at: 0)
            
            // Create place label
            placeLabel = UILabel()
            placeLabel.translatesAutoresizingMaskIntoConstraints = false
            placeLabel.font = UIFont.systemFont(ofSize: 18) // Set desired font
            contentView.addSubview(placeLabel)
        
           activeLabel = UILabel()
           activeLabel.translatesAutoresizingMaskIntoConstraints = false
           activeLabel.text = "Active" // Set the text
           activeLabel.textColor = UIColor.white // Set text color to white
           activeLabel.backgroundColor = UIColor.systemGreen // Set background color to green
           contentView.addSubview(activeLabel)
        
        startTimeLabel = UILabel()
        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        startTimeLabel.text = "Start Time:" // Set the text
        startTimeLabel.font = UIFont.systemFont(ofSize: 12) // Set desired font size (optional)
        contentView.addSubview(startTimeLabel)

        endTimeLabel = UILabel()
        endTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        endTimeLabel.text = "End Time:" // Set the text
        endTimeLabel.font = UIFont.systemFont(ofSize: 12) // Set desired font size (optional)
        contentView.addSubview(endTimeLabel)
        
            setupConstraints() // Call method to define layout constraints
        }
    override func layoutSubviews() {
      super.layoutSubviews()

      let path = createCustomPath(in: bounds) // Replace with your custom path creation logic
      backgroundShapeLayer.path = path
    }

    private func createCustomPath(in rect: CGRect) -> CGPath {
      // Implement your custom path creation logic here based on the desired shape
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 5) // Adjust corner radius as needed
        return path.cgPath
    }
    
    private func setupConstraints() {
      NSLayoutConstraint.activate([
        
        backgroundviw.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
        backgroundviw.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
        backgroundviw.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
        backgroundviw.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        nameLabel.trailingAnchor.constraint(equalTo: activeLabel.leadingAnchor, constant: -8), // Adjust spacing as needed

        phoneNumberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
        phoneNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        phoneNumberLabel.trailingAnchor.constraint(equalTo: activeLabel.leadingAnchor, constant: -8), // Adjust spacing as needed

        placeLabel.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 4),
        placeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        placeLabel.trailingAnchor.constraint(equalTo: activeLabel.leadingAnchor, constant: -8), // Adjust spacing as needed

        placeLabel.bottomAnchor.constraint(equalTo: startTimeLabel.topAnchor, constant: -4), // Adjust spacing as needed

        activeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8), // Adjust vertical position as needed
        activeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16), // Adjust spacing from right side
        activeLabel.widthAnchor.constraint(equalToConstant: 50), // Set desired width
        activeLabel.heightAnchor.constraint(equalToConstant: 20), // Set desired height

        startTimeLabel.topAnchor.constraint(equalTo: placeLabel.bottomAnchor, constant: 4), // Adjust spacing as needed
        startTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        startTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16), // Adjust spacing from sides as needed

        endTimeLabel.topAnchor.constraint(equalTo: startTimeLabel.bottomAnchor, constant: 4), // Adjust spacing as needed
        endTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        endTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16), // Adjust spacing from sides as needed

        contentView.bottomAnchor.constraint(equalTo: endTimeLabel.bottomAnchor, constant: 8),

      ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//      fatalError("init(coder:) is not supported")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
