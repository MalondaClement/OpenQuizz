//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by Clément Malonda on 06/06/2019.
//  Copyright © 2019 Clément Malonda. All rights reserved.
//

import UIKit

class QuestionView: UIView {
	
	@IBOutlet private var label: UILabel!
	@IBOutlet private var icon: UIImageView!
	
	enum Style {
		case correct, incorrect, standard
	}
	var style: Style = .standard{
		didSet{
			setStyle(style)
		}
	}
	
	private func setStyle(_ style: Style){
		switch style {
		case .correct:
			backgroundColor = #colorLiteral(red: 0.7842472196, green: 0.9260502458, blue: 0.6268314719, alpha: 1)
			icon.image = UIImage(named: "Icon Correct")
			icon.isHidden = false
		case .incorrect:
			backgroundColor = #colorLiteral(red: 0.9313799739, green: 0.5266035199, blue: 0.5792709589, alpha: 1)
			icon.image = UIImage(named: "Icon Error")
			icon.isHidden = false
		case .standard:
			backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
			icon.isHidden = true
			
		}
	}
	
	var title = "" {
		didSet {
			label.text = title
		}
	}
}
