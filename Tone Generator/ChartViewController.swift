//
//  ChartViewController.swift
//  Tone Generator
//
//  Created by Siseong Ahn on 2022/11/13.
//

import UIKit
import Charts

class ChartViewController: UIViewController {

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var hearingResult: UILabel!
    @IBOutlet weak var hearingText: UILabel!
    var diff = 0.0
    var sum = 0.0
    
    //var TestViewController: TestViewController?
    
    //TestViewController?.Reply(Data)
    
    var valueLeftArray: [Double] = []
    let valueRightArray: [Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUIControls()
        self.setDataCount()
        let hearing = valueLeftArray.allSatisfy { $0 >= 50 }
        
        let hearing1 = valueLeftArray[5...8].allSatisfy { $0 < 50.0 }
        let hearing2 = valueLeftArray[0...1].allSatisfy{ $0 < 50.0 }
        let hearing3 = valueLeftArray[2...4].allSatisfy{ $0 >= 50.0 }
        
        let hearing4 = valueLeftArray[0...3].allSatisfy{ $0 < 50.0 }
        let hearing5 = valueLeftArray[0...5].allSatisfy{ $0 < 50.0 }
        let hearing6 = valueLeftArray[7...8].allSatisfy{ $0 < 50.0 }
        let hearing7 = valueLeftArray[0...8].allSatisfy{ $0 <= 40.0 }
        
        if (hearing1 && hearing2 && hearing3){
            hearingResult.text = "접시형"
            hearingText.text = "전음성 난청이 의심됩니다.\n 병원에서 검사를 받아보길 권장합니다."
        }
        if (hearing4 && hearing1 && valueLeftArray[4]>=50 ){
            hearingResult.text = "톱니형"
            hearingText.text = "이경화증이 의심됩니다.\n 병원에서 검사를 받아보길 권장합니다."
        }
        if (hearing5 && hearing6 && valueLeftArray[6]>=50 ){
            hearingResult.text = "톱니형"
            hearingText.text = "소음성난청이 의심됩니다.\n 병원에서 검사를 받아보길 권장합니다."
        }
        if (hearing7){
            hearingResult.text = "수평형"
            hearingText.text = "일반적인 청력 형태입니다.\n 50db이상일 때만 들릴 시에 혼합성 난청을 주의해주세요."
        }

        for i in 0...7 {
            diff = valueLeftArray[i+1]-valueLeftArray[i]
            sum += diff
        }
            
        if (sum>=40 && sum<=60){
            hearingResult.text = "경사형"
            hearingText.text = "노인성 난청이 의심됩니다.\n 병원에서 검사를 받아보길 권장합니다."
        }
        if (sum>60 && sum<=90){
            hearingResult.text = "급경사형"
            hearingText.text = "감각신경성 난청이 의심됩니다.\n 병원에서 검사를 받아보길 권장합니다."
        }
        if (sum >= -60 && sum <= -40 ){
            hearingResult.text = "경사형"
            hearingText.text = "노인성 난청이 의심됩니다.\n 병원에서 검사를 받아보길 권장합니다."
        }
        if (sum >= -90 && sum < -60){
            hearingResult.text = "급경사형"
            hearingText.text = "감각신경성 난청이 의심됩니다.\n 병원에서 검사를 받아보길 권장합니다."
        }

        else{
            if (hearing){
                hearingResult.text = "중증 난청이 의심됩니다."
                hearingText.text = "병원에서 검사를 받아보길 권장합니다."
            }
        }
    }

    func setUIControls() {
        chartView.chartDescription.enabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false

        chartView.legend.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = true
        chartView.highlightPerTapEnabled = false
        chartView.highlightPerDragEnabled = false

        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker

        let axisColor = UIColor(red: 69/255, green: 69/255, blue: 74/255, alpha: 1.0)

        let xAxis = chartView.xAxis
        xAxis.valueFormatter = FreqValueFormatter()
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.labelTextColor = axisColor
        xAxis.labelWidth = 100
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.gridColor = axisColor

        let rightAxisFormatter = NumberFormatter()
        rightAxisFormatter.minimumFractionDigits = 0
        rightAxisFormatter.maximumFractionDigits = 1
        rightAxisFormatter.negativeSuffix = ""
        rightAxisFormatter.positiveSuffix = ""

        let rightAxis = chartView.rightAxis
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.valueFormatter = ReverseAxisValueFormatter(formatter: rightAxisFormatter)
        rightAxis.labelPosition = .outsideChart
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        rightAxis.axisMaximum = 100
        rightAxis.labelCount = 6
        rightAxis.labelAlignment = .right
        rightAxis.labelTextColor = axisColor
        rightAxis.drawAxisLineEnabled = false
        rightAxis.gridColor = axisColor
    }
    
    func setDataCount() {
        let count: Int = 9
        let colors = [UIColor(named: "azure"), UIColor(named: "reddishPink")]
        let linelabels = ["Left", "Right"]
        
        let freq : [Double] = [0,1,2,3,4,5,6,7,8]
        
        let valueLeft = valueLeftArray
        let valueRight = valueRightArray
        
        var valL : Array<Double> = []
        var valR : Array<Double> = []

        for tmpVal in valueLeft {
            valL.append(100 - tmpVal)
        }

        for tmpVal in valueRight {
            valR.append(100 - tmpVal)
        }
        
        let blockL: (Int) -> ChartDataEntry = { (i) -> ChartDataEntry in
            return ChartDataEntry(x: freq[i], y: valL[i], icon: UIImage(named: "ic_test_result_left"))
        }
        let blockR: (Int) -> ChartDataEntry = { (i) -> ChartDataEntry in
            return ChartDataEntry(x: freq[i], y: valR[i], icon: UIImage(named: "ic_test_result_right"))
        }
        
        let blocks = [blockL, blockR]
        
        var lrIndex = 0
        let dataSets = (0..<1).map { i -> LineChartDataSet in
            let yVals = (0..<count).map(blocks[lrIndex])
            lrIndex = lrIndex + 1
            let set = LineChartDataSet(entries: yVals, label: linelabels[i])
            set.lineWidth = 1
            set.axisDependency = .right
            let color = colors[i % colors.count]
            set.setColor(color!)
            set.drawCirclesEnabled = false
            set.drawIconsEnabled = true
            set.drawValuesEnabled = false
            set.mode = .linear
            return set
        }
        let data = LineChartData(dataSets: [dataSets[0]])
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        chartView.data = data
    }

    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
