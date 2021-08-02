//
//  ReactionViewController.swift
//  bottomCard
//
//  Created by 장혜령 on 2021/08/01.
//  Copyright © 2021 fluffy. All rights reserved.
//

import UIKit
import SnapKit
import Charts

class ReactionViewController: UIViewController {

    //MARK: State
    enum CardViewState {
          case expanded
          case normal
    }
    
    var cardViewState : CardViewState = .normal
    // to store the card view top constraint value before the dragging start
    // default is 30 pt from safe area top
    var cardPanStartingTopConstant : CGFloat = 30.0
    
    //MARK: Chart Data
    var numbers: [Double] = [3.0, 2.5, 3.3, 5.5, 2.7, 1.0, 4.2]
    let dayOfWeek: [String] = ["SUN", "MON", "TUE", "WED", "THu", "FRI", "SAT"]
    var lineChartView = LineChartView()
    
    //MARK: UIComponent
    private var backgroundImageView = UIImageView()
    public var backgroundImage : UIImage?
    
    private var dimmerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private var cardView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        setupDesignIncardView()
        setupActions()
        setupGesture()
        changeLineChartdata()
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        showCard()
        lineChartView.animate(yAxisDuration: 2.0, easingOption: .easeInOutQuint)
    }

    
    private func setupConstraint(){
        view.addSubview(backgroundImageView)
       // backgroundImageView.image = backgroundImage
        backgroundImageView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        view.addSubview(dimmerView)
        dimmerView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        view.addSubview(cardView)
        cardView.backgroundColor = .white
        cardView.snp.makeConstraints{
            $0.top.equalToSuperview()
            self.cardPanStartingTopConstant = 30
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        cardView.addSubview(lineChartView)
        lineChartView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(300)
        }
    }
    
    private func setupDesignIncardView(){
        // round the top left and top right corner of card view
        
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 10.0
        cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // hide the card view at the bottom when the View first load
        if let safeAreaHeight = self.view?.safeAreaLayoutGuide.layoutFrame.size.height,
           let bottomPadding = self.view?.safeAreaInsets.bottom {
            changeCardViewHeight(height: safeAreaHeight+bottomPadding)
            self.cardPanStartingTopConstant = safeAreaHeight+bottomPadding
            
        }else {
            print("이부분이 안됐나?")
        }
        
        // set dimmerview to transparent
        dimmerView.alpha = 0.0
    }
    
    private func changeCardViewHeight(height: CGFloat){
        cardView.snp.updateConstraints{
            $0.top.equalTo(view.snp.top).offset(height)
        }
    }
}

//MARK: Animation
extension ReactionViewController{
    
    private func showCard() {
       print("showCard")
      // ensure there's no pending layout changes before animation runs
      self.view.layoutIfNeeded()
      
      // set the new top constraint value for card view
      // card view won't move up just yet, we need to call layoutIfNeeded()
      // to tell the app to refresh the frame/position of card view
        if let safeAreaHeight = UIWindow.key?.safeAreaLayoutGuide.layoutFrame.size.height,
        let bottomPadding = UIWindow.key?.safeAreaInsets.bottom {
        
        // when card state is normal, its top distance to safe area is
        // (safe area height + bottom inset) / 2.0
        
        changeCardViewHeight(height: (safeAreaHeight + bottomPadding) / 2.0)
        self.cardPanStartingTopConstant = (safeAreaHeight + bottomPadding) / 2.0
      }
      
      // move card up from bottom by telling the app to refresh the frame/position of view
      // create a new property animator
      let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
        self.view.layoutIfNeeded()
      })
      
      // show dimmer view
      // this will animate the dimmerView alpha together with the card move up animation
      showCard.addAnimations({
        self.dimmerView.alpha = 0.7
      })
      
      // run the animation
      showCard.startAnimation()
    }
    
    private func setupActions(){
        // dimmerViewTapped() will be called when user tap on the dimmer view
        let dimmerTap = UITapGestureRecognizer(target: self, action: #selector(dimmerViewTapped(_:)))
        dimmerView.addGestureRecognizer(dimmerTap)
        dimmerView.isUserInteractionEnabled = true
        
    }

    // @IBAction is required in front of the function name due to how selector works
    @objc func dimmerViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
      hideCardAndGoBack()
    }

    private func hideCardAndGoBack() {
        // ensure there's no pending layout changes before animation runs
         self.view.layoutIfNeeded()
         
         // set the new top constraint value for card view
         // card view won't move down just yet, we need to call layoutIfNeeded()
         // to tell the app to refresh the frame/position of card view
         if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
           let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            changeCardViewHeight(height: safeAreaHeight + bottomPadding)
           // move the card view to bottom of screen
         }
         
         // move card down to bottom
         // create a new property animator
         let hideCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
           self.view.layoutIfNeeded()
         })
         
         // hide dimmer view
         // this will animate the dimmerView alpha together with the card move down animation
         hideCard.addAnimations {
           self.dimmerView.alpha = 0.0
         }
         
         // when the animation completes, (position == .end means the animation has ended)
         // dismiss this view controller (if there is a presenting view controller)
         hideCard.addCompletion({ position in
           if position == .end {
             if(self.presentingViewController != nil) {
               self.dismiss(animated: false, completion: nil)
             }
           }
         })
         
         // run the animation
         hideCard.startAnimation()
    }
    
    private func setupGesture(){
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        
        // by default iOS will delay the touch before recording the drag/pan information
        // we want the drag gesture to be recorded down immediately, hence setting no delay
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        
        self.view.addGestureRecognizer(viewPan)
    }
    
    // this function will be called when user pan/drag the view
      @objc func viewPanned(_ panRecognizer: UIPanGestureRecognizer) {
        // how much distance has user dragged the card view
        let translation = panRecognizer.translation(in: self.view)
        
        // 위로 드래그하면 음수
        // 아래도 드래그하면 양수
        switch panRecognizer.state {
          case .began:
            print("drag start")
          case .changed :
            if self.cardPanStartingTopConstant + translation.y > 30.0 {
                print("user has dragged \(translation.y) point vertically")
                print("바꿀 크기 = \( self.cardPanStartingTopConstant + translation.y)")
                changeCardViewHeight(height: self.cardPanStartingTopConstant + translation.y)
            }else {
                print("30보다 작아짐")
            }
          case .ended :
            print("drag ended")
            self.cardPanStartingTopConstant = self.cardPanStartingTopConstant + translation.y
            // we will do other stuff here later on
          default:
            break
          }
      }
    
}


//MARK: Charts
extension ReactionViewController{
    
    func changeLineChartdata(){
        var lineChartEntry = [ChartDataEntry]() // graph 에 보여줄 data array
         // chart data array 에 데이터 추가
         for i in 0..<numbers.count {
                let value = ChartDataEntry(x: Double(i), y: numbers[i])
                lineChartEntry.append(value)
         }
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "수영거리")
        line1.colors = [.gray]
        line1.circleColors = [NSUIColor.lightGray]
        line1.circleHoleColor = NSUIColor.systemTeal
        print("line1.circleRadius = \(line1.circleRadius)")
        line1.circleRadius = 3.0
        line1.circleHoleRadius = 3.0
        print("line1.lineWidth = \(line1.lineWidth)")
        line1.lineWidth = 3.0
        
        
        line1.mode = .cubicBezier
        
        let data = LineChartData(dataSet: line1)
            
        lineChartView.data = data
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dayOfWeek)
        lineChartView.xAxis.setLabelCount(dayOfWeek.count, force: true)
        lineChartView.xAxis.avoidFirstLastClippingEnabled = true
        lineChartView.xAxis.axisLineWidth = 1.0
        lineChartView.xAxis.gridColor = .clear // X절편? 라인 색
//        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.axisLineWidth = 10.0
        lineChartView.leftAxis.enabled = false
        
    }
}
