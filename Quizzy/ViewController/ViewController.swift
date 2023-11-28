//
//  ViewController.swift
//  Quizzy
//
//  Created by #include tech. on 24/11/23.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private lazy var viewModel: QuizViewModel = {
        return QuizViewModel()
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var questionLabel: UILabel = {
       let lbl = UILabel()
        lbl.textColor = .black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .qFont(weight: .semibold, size: 20)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var questionNumberLabel: UILabel = {
       let lbl = UILabel()
        lbl.textColor = .black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .qFont(weight: .medium, size: 14)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .qFont(weight: .regular, size: 18)
        label.text = "Loading..."
        return label
    }()
    
    private lazy var feedbackLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .qFont(weight: .regular, size: 18)
        label.numberOfLines = 0
        label.isAccessibilityElement = true
        return label
    }()
    
    private lazy var retryButton: UIButton = {
       let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Play Again!", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 20
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.titleLabel?.font = .qFont(weight: .regular, size: 18)
        let titleSize = btn.titleLabel?.intrinsicContentSize.height ?? 0
        btn.heightAnchor.constraint(equalToConstant: titleSize + 20).isActive = true
        btn.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var answerButtons: [UIButton] = {
        var buttons: [UIButton] = []
        for _ in 0..<4 {
            let btn = UIButton()
            btn.backgroundColor = .clear
            btn.setTitleColor(.black, for: .normal)
            btn.layer.cornerRadius = 20
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.gray.cgColor
            btn.alpha = 0

            btn.titleLabel?.font = .qFont(weight: .regular, size: 18)
            let titleSize = btn.titleLabel?.intrinsicContentSize.height ?? 0
            btn.heightAnchor.constraint(equalToConstant: titleSize + 20).isActive = true
            buttons.append(btn)
        }
        return buttons
    }()

    private var currentQuestionIndex = 0
    var quizData: [QuizQuestion] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingUI()
        viewModel.fetchQuizData()
        setupBindings()
        view.backgroundColor = .white
    }

    private func showLoadingUI() {
        view.addSubview(activityIndicator)
        view.addSubview(loadingLabel)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 10),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        activityIndicator.startAnimating()
    }
    
    private func hideLoadingUI() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        loadingLabel.removeFromSuperview()
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: answerButtons)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        view.addSubview(questionNumberLabel)
        view.addSubview(questionLabel)
        view.addSubview(feedbackLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            questionNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionNumberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            questionLabel.topAnchor.constraint(equalTo: questionNumberLabel.bottomAnchor, constant: 100),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            feedbackLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            feedbackLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            feedbackLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
        ])
    }
    
    private func setupBindings() {
        viewModel.$quizData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] quizData in
                if !quizData.isEmpty {
                    self?.quizData = quizData
                    self?.hideLoadingUI()
                    self?.setupUI()
                    self?.displayQuestion()
                }
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.showLoadingUI()
                }
            }
            .store(in: &cancellables)

        viewModel.$showAlert
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showAlert in
                if showAlert {
                    self?.showAlert(with: self?.viewModel.alertTitle ?? "", message: self?.viewModel.alertMessage ?? "")
                }
            }
            .store(in: &cancellables)
    }
    
    private func hideQuestionsView() {
        questionLabel.removeFromSuperview()
        questionNumberLabel.removeFromSuperview()
        answerButtons.forEach { btn in
            btn.removeFromSuperview()
        }
    }
    
    private func playAgainView() {
        view.addSubview(retryButton)
        NSLayoutConstraint.activate([
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            retryButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2)
        ])
    }
    
    private func showAlert(with title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

    private func displayQuestion() {
        guard currentQuestionIndex < quizData.count else {
            return
        }
        let currentQuestion = quizData[currentQuestionIndex]
        questionLabel.text = currentQuestion.question
        questionNumberLabel.text = "Question No: \(currentQuestionIndex + 1)"
        
        questionLabel.accessibilityLabel = "Question \(currentQuestion.question)"
        for (index, button) in answerButtons.enumerated() {
            button.isAccessibilityElement = true
            button.accessibilityLabel = "Answer \(index + 1)"
        }
        
        let allAnswers = currentQuestion.incorrect_answers + [currentQuestion.correct_answer]
        let shuffledAnswers = allAnswers.shuffled()

        for (index, button) in answerButtons.enumerated() {
            button.setTitle(shuffledAnswers[index], for: .normal)
            button.tag = index
            button.alpha = 1
            button.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
            button.accessibilityLabel = "Answer \(index + 1): \(shuffledAnswers[index])"
        }
    }
    
    private func resetFeedbacks() {
        feedbackLabel.text = ""
    }

    private func resetButtonColors() {
        for button in answerButtons {
            button.backgroundColor = .clear
        }
    }
}

//Button Actions
extension ViewController {
    @objc private func retryButtonTapped() {
        retryButton.removeFromSuperview()
        feedbackLabel.removeFromSuperview()
        quizData = []
        currentQuestionIndex = 0
        showLoadingUI()
        viewModel.fetchQuizData()
        resetButtonColors()
        resetFeedbacks()
        print("Retry button tapped!")
    }

    @objc private func answerButtonTapped(_ sender: UIButton) {
        guard currentQuestionIndex < quizData.count else {
            print("Quiz completed!")
            return
        }
        let selectedAnswer = answerButtons[sender.tag].currentTitle!
        let correctAnswer = quizData[currentQuestionIndex].correct_answer
        if selectedAnswer == correctAnswer {
            answerButtons[sender.tag].backgroundColor = .tertiary
            print("Correct!")
            feedbackLabel.text = "Correct!"
            feedbackLabel.textColor = .accent
            feedbackLabel.accessibilityLabel = "Correct Answer"
        } else {
            answerButtons[sender.tag].backgroundColor = .red.withAlphaComponent(0.3)
            print("Wrong! Correct answer is: \(correctAnswer)")
            feedbackLabel.text = "Wrong! Correct answer is: \(correctAnswer)"
            feedbackLabel.accessibilityLabel = "Wrong Answer, correct answer is \(correctAnswer)"
            feedbackLabel.textColor = .red
        }

        currentQuestionIndex += 1
        if currentQuestionIndex < quizData.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.resetButtonColors()
                self?.resetFeedbacks()
                self?.displayQuestion()
            }
        } else {
            print("Quiz completed!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.hideQuestionsView()
                self?.playAgainView()
                self?.resetFeedbacks()
            }
        }
    }
}
