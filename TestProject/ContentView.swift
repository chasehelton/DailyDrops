//
//  ContentView.swift
//  TestProject
//
//  Created by Joshua Chase Helton on 7/31/20.
//  Copyright © 2020 chasehelton. All rights reserved.
//

import SwiftUI

//let nc = NotificationCenter.default
//nc.addObserver(
//    self,
//    selector:#selector({
//        self.progressValue = 0
//    }),
//    name: NSNotification.Name("Reset"),
//    object:nil
//)


//func reset() {
//    progressValue = 0
//    mL = 0
//}

let date = NSCalendar.current.startOfDay(for: Date())

struct ContentView: View {
    @State var progressValue: Float = 0
    @State var mL: Float = 0
    @State var userDefaults = UserDefaults.standard
//    @State var currentStreak: Int = 0
    @State private var isPresented = false
    
    @ViewBuilder
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .white]),
                startPoint: UnitPoint(x: min(1.0, CGFloat(self.progressValue / 2500.0)), y: min(1.0, CGFloat(self.progressValue  / 2500.0))),
                endPoint: .bottomTrailing
            ).animation(.linear).opacity(0.9)
            
            if (isPresented) {
                FullScreenModalView(back: $isPresented)
            }
            
            if (!isPresented) {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {self.isPresented.toggle()})
                            {Image(systemName: "info.circle")}
                    }
                    
                    Text("Daily Drops")
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                    
                    HStack {
                        Text("Amount (mL):").font(.body).bold()
                        TextField("mL", value: $mL, formatter: NumberFormatter(), onCommit: {
                            self.incrementProgress(self.mL)
                            self.mL = 0
                        }).textFieldStyle(RoundedBorderTextFieldStyle()).foregroundColor(Color.blue)
                            
                    }
                    .frame(width: 250)
                    
                    if (self.progressValue >= 2500.0) {
                        VStack {
                            ProgressBar(progress: self.$progressValue)
                                .frame(width: 150, height: 150)
                                .padding(40)
                            Text("Daily Goal Reached!").padding()
                            Spacer()
                            Button(action: {self.reset()}) {Text("Reset Progress").font(.body).bold().foregroundColor(Color.orange)}
                            Spacer()
                        }
                    } else {
                        ProgressBar(progress: self.$progressValue)
                            .frame(width: 150, height: 150)
                            .padding(40)
                    }
                    Spacer()
                }
                .padding()
                .foregroundColor(Color.white)
            }
        }
        .onAppear {
//            self.handlingStreak(self.userDefaults)
//            let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(reset), userInfo: nil, repeats: false)
//            RunLoop.main.add(timer, forMode: .common)
        }
    }
    func incrementProgress(_ mL: Float) {
        self.progressValue += mL
    }
    func reset() {
        self.progressValue = 0
    }
}

struct ProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8.0)
                .opacity(0.3)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 2500.0) / 2500))
                .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            Text(String(format: "%.0f / 2500%", self.progress))
                .font(.largeTitle)
                .bold()
        }.foregroundColor(Color.white)
    }
}

struct FullScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var back: Bool

    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                Button(action: {self.back.toggle()}) {Image(systemName: "xmark.circle")}
            }
            Text("Drink More Water!").font(.largeTitle).bold()
            Spacer()
            Text("Humans typically do not drink enough water each day, which leads to tiredness and lack of energy. This app is designed to make drinking water more enjoyable for you and to motivate you to drink the recommended amount of water each day!").font(.body)
            Spacer()
            Text("Every time you drink water throughout the day, keep track of the approximate mL (milliliters) that you drink, and input that into the app. The circle will slowly fill up and the page will turn blue with the more water you drink. Get to 2500 mL every day to know you are getting the water you need. Stay healthy and get drinking!").font(.body)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .padding()
        .foregroundColor(Color.white)
        .background(Color.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: midnight)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
    }
    var midnight: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
