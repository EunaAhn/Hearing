//
//  LineChart1ViewController.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

import UIKit
import Charts

class LineChart1ViewController: DemoBaseViewController {

    @IBOutlet var chartView: LineChartView!
    @IBOutlet var sliderX: UISlider!
    @IBOutlet var sliderY: UISlider!
    @IBOutlet var sliderTextX: UITextField!
    @IBOutlet var sliderTextY: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Line Chart 1"
        self.options = [.toggleValues,
                        .toggleFilled,
                        .toggleCircles,
                        .toggleCubic,
                        .toggleHorizontalCubic,
                        .toggleIcons,
                        .toggleStepped,
                        .toggleHighlight,
                        .toggleGradientLine,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .saveToGallery,
                        .togglePinchZoom,
                        .toggleAutoScaleMinMax,
                        .toggleData]

        chartView.delegate = self

        chartView.chartDescription.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        let l = chartView.legend
        l.form = .line
        l.font = UIFont.roboto(size: 10, family: .Medium)
        l.textColor = .white
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        // x-axis limit line
//        let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
//        llXAxis.lineWidth = 4
//        llXAxis.lineDashLengths = [10, 10, 0]
//        llXAxis.labelPosition = .rightBottom
//        llXAxis.valueFont = .systemFont(ofSize: 10)
//
//        chartView.xAxis.gridLineDashLengths = [10, 10]
//        chartView.xAxis.gridLineDashPhase = 0
//
//        let ll1 = ChartLimitLine(limit: 150, label: "Upper Limit")
//        ll1.lineWidth = 4
//        ll1.lineDashLengths = [5, 5]
//        ll1.labelPosition = .rightTop
//        ll1.valueFont = .systemFont(ofSize: 10)
//
//        let ll2 = ChartLimitLine(limit: -30, label: "Lower Limit")
//        ll2.lineWidth = 4
//        ll2.lineDashLengths = [5,5]
//        ll2.labelPosition = .rightBottom
//        ll2.valueFont = .systemFont(ofSize: 10)

//        let leftAxis = chartView.leftAxis
//        leftAxis.removeAllLimitLines()
//        //leftAxis.addLimitLine(ll1)
//        //leftAxis.addLimitLine(ll2)
//        leftAxis.axisMaximum = 110
//        leftAxis.axisMinimum = -10
//        leftAxis.gridLineDashLengths = [5, 5]
//        leftAxis.drawLimitLinesBehindDataEnabled = true

        chartView.rightAxis.enabled = false

        //[_chartView.viewPortHandler setMaximumScaleY: 2.f];
        //[_chartView.viewPortHandler setMaximumScaleX: 2.f];

        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
        chartView.legend.form = .line
        
        chartView.xAxis.labelTextColor = UIColor.white
        chartView.leftAxis.labelTextColor = UIColor.white
        chartView.backgroundColor = UIColor.black
        chartView.noDataTextColor = UIColor.white
        
        chartView.pinchZoomEnabled = false
        chartView.chartDescription.enabled = false
        
        
        sliderX.value = 9
        sliderY.value = 100
        slidersValueChanged(nil)

        chartView.animate(xAxisDuration: 0.5)
    }

    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }

        self.setDataCount(Int(sliderX.value), range: UInt32(sliderY.value))
    }

    func setDataCount(_ count: Int, range: UInt32) {
        
        //let colors = ChartColorTemplates.vordiplom()[0...2]
        let colors = [UIColor.blue, UIColor.red]
        let linelabels = ["Left", "Right"]
        
        let block: (Int) -> ChartDataEntry = { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        let dataSets = (0..<2).map { i -> LineChartDataSet in
            let yVals = (0..<count).map(block)
            let set = LineChartDataSet(entries: yVals, label: linelabels[i])
            set.lineWidth = 2.5
            set.circleRadius = 4
            set.circleHoleRadius = 2
            let color = colors[i % colors.count]
            set.setColor(color)
            set.setCircleColor(color)
            set.valueTextColor = UIColor.white
            set.circleHoleColor = color
                        
            set.mode = .horizontalBezier
            
            let gradientColors = [ChartColorTemplates.colorFromString("#00000000").cgColor,
                                  color.cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
    
            set.fillAlpha = 0.8
            set.fill = LinearGradientFill(gradient: gradient, angle: 90)
            set.drawFilledEnabled = true
            
            return set
        }
        
        //dataSets[0].lineDashLengths = [5, 5]
        //dataSets[0].colors = ChartColorTemplates.vordiplom()
        //dataSets[0].circleColors = ChartColorTemplates.vordiplom()
        
        let data = LineChartData(dataSets: dataSets)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        chartView.data = data
        
//        let values1 = (0..<count).map { (i) -> ChartDataEntry in
//            let val = Double(arc4random_uniform(range) + 3)
//            return ChartDataEntry(x: Double(i), y: val, icon: nil)
//        }
//
//        let set1 = LineChartDataSet(entries: values1, label: "DataSet 1")
//        set1.drawIconsEnabled = false
//        setup(set1)
//
//        //let value = ChartDataEntry(x: Double(3), y: 3)
//        //set1.addEntryOrdered(value)
//        //let gradientColors1 = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
//        //                      ChartColorTemplates.colorFromString("#ffff0000").cgColor]
//        //let gradient1 = CGGradient(colorsSpace: nil, colors: gradientColors1 as CFArray, locations: nil)!
//
//        //set1.fillAlpha = 1
//        //set1.fill = LinearGradientFill(gradient: gradient1, angle: 90)
//        //set1.drawFilledEnabled = true
//
//        let values2 = (0..<count).map { (i) -> ChartDataEntry in
//            let val = Double(arc4random_uniform(range) + 3)
//            return ChartDataEntry(x: Double(i), y: val, icon: nil)
//        }
//
//        let set2 = LineChartDataSet(entries: values2, label: "DataSet 2")
//        set2.drawIconsEnabled = false
//        setup(set2)
//
//        //let value = ChartDataEntry(x: Double(3), y: 3)
//        //set2.addEntryOrdered(value)
//        //let gradientColors2 = [ChartColorTemplates.colorFromString("#0000ff00").cgColor,
//        //                      ChartColorTemplates.colorFromString("#00ffff00").cgColor]
//        //let gradient2 = CGGradient(colorsSpace: nil, colors: gradientColors2 as CFArray, locations: nil)!
//
//        //set2.fillAlpha = 1
//        //set2.fill = LinearGradientFill(gradient: gradient2, angle: 90)
//        //set2.drawFilledEnabled = true
//
//        let data = LineChartData(dataSet: set2)
//
//        chartView.data = data
    }

    private func setup(_ dataSet: LineChartDataSet) {
        if dataSet.isDrawLineWithGradientEnabled {
            dataSet.lineDashLengths = nil
            dataSet.highlightLineDashLengths = nil
            dataSet.setColors(.black, .red, .white)
            dataSet.setCircleColor(.black)
            dataSet.gradientPositions = [0, 40, 100]
            dataSet.lineWidth = 1
            dataSet.circleRadius = 3
            dataSet.drawCircleHoleEnabled = false
            dataSet.valueFont = .systemFont(ofSize: 9)
            dataSet.formLineDashLengths = nil
            dataSet.formLineWidth = 1
            dataSet.formSize = 15
        } else {
            dataSet.lineDashLengths = [5, 2.5]
            dataSet.highlightLineDashLengths = [5, 2.5]
            dataSet.setColor(.black)
            dataSet.setCircleColor(.black)
            dataSet.gradientPositions = nil
            dataSet.lineWidth = 1
            dataSet.circleRadius = 3
            dataSet.drawCircleHoleEnabled = false
            dataSet.valueFont = .systemFont(ofSize: 9)
            dataSet.formLineDashLengths = [5, 2.5]
            dataSet.formLineWidth = 1
            dataSet.formSize = 15
        }
    }

    override func optionTapped(_ option: Option) {
        guard let data = chartView.data else { return }

        switch option {
        case .toggleFilled:
            for case let set as LineChartDataSet in data {
                set.drawFilledEnabled = !set.drawFilledEnabled
            }
            chartView.setNeedsDisplay()

        case .toggleCircles:
            for case let set as LineChartDataSet in data {
                set.drawCirclesEnabled = !set.drawCirclesEnabled
            }
            chartView.setNeedsDisplay()

        case .toggleCubic:
            for case let set as LineChartDataSet in data {
                set.mode = (set.mode == .cubicBezier) ? .linear : .cubicBezier
            }
            chartView.setNeedsDisplay()

        case .toggleStepped:
            for case let set as LineChartDataSet in data {
                set.mode = (set.mode == .stepped) ? .linear : .stepped
            }
            chartView.setNeedsDisplay()

        case .toggleHorizontalCubic:
            for case let set as LineChartDataSet in data {
                set.mode = (set.mode == .cubicBezier) ? .horizontalBezier : .cubicBezier
            }
            chartView.setNeedsDisplay()
        case .toggleGradientLine:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.isDrawLineWithGradientEnabled = !set.isDrawLineWithGradientEnabled
                setup(set)
            }
            chartView.setNeedsDisplay()
        default:
            super.handleOption(option, forChartView: chartView)
        }
    }

    @IBAction func slidersValueChanged(_ sender: Any?) {
        sliderTextX.text = "\(Int(sliderX.value))"
        sliderTextY.text = "\(Int(sliderY.value))"

        self.updateChartData()
    }
}
