//
//  ViewController.swift
//  OpenQuizz
//
//  Created by Clément Malonda on 05/06/2019.
//  Copyright © 2019 Clément Malonda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var newGameButton: UIButton!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet weak var questionView: QuestionView!
	
	var game = Game()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let name = Notification.Name(rawValue: "QuestionsLoaded")
		NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: name, object: nil)
		
		startNewGame()
		
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
		questionView.addGestureRecognizer(panGestureRecognizer)
	}

	@objc func questionsLoaded(){
		activityIndicator.isHidden = true
		newGameButton.isHidden = false
		
		questionView.title = game.currentQuestion.title
	}
	
	@IBAction func didTapeNewGameButton() {
		startNewGame()
	}
	
	private func startNewGame(){
		activityIndicator.isHidden = false
		newGameButton.isHidden = true
		
		questionView.title = "Loading..."
		questionView.style = .standard
		
		scoreLabel.text = "0 / 10"
		
		game.refresh()
	}
	
	@objc func dragQuestionView(_ sender: UIPanGestureRecognizer){
		if game.state == .ongoing{
			switch sender.state {
			case .began, .changed:
				transformQuestionViewWith(gesture: sender)
			case .cancelled, .ended:
				answerQuestion()
			default:
				break
			}
		}
	}
	
	private func transformQuestionViewWith(gesture: UIPanGestureRecognizer){
		let translation = gesture.translation(in: questionView) //ici on récupère les information sur la translation
		let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)//puis les informations de translations sur x et y
		
		let screenWidth = UIScreen.main.bounds.width
		let translationPercent = translation.x/(screenWidth/2)
		let rotationAngle = (CGFloat.pi/6) * translationPercent //on fait en sorte que la vue tourne en fonction de son éloigement du centre
		
		let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
		
		let transform = translationTransform.concatenating(rotationTransform)//on combine la translation et la rotation pour obtenir le mouvement total de la vue
		
		questionView.transform = transform //on applique ici la transformation calculée plus tôt puis le changement de style
		
		if translation.x > 0 {
			questionView.style = .correct
		}else if translation.x < 0{
			questionView.style = .incorrect
		}
	}
	
	private func answerQuestion(){
		switch questionView.style {
		case .correct:
			game.answerCurrentQuestion(with: true)
		case .incorrect:
			game.answerCurrentQuestion(with: false)
		case .standard:
			break
		}
		scoreLabel.text = "\(game.score) / 10"
		
		questionView.transform = .identity
		questionView.style = .standard
		
		switch game.state {
		case .ongoing:
			questionView.title = game.currentQuestion.title
		case .over:
			questionView.title = "Game Over"
		}
	}
}

