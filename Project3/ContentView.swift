//
//  ContentView.swift
//  Project3
//
//  Created by Liam Propst on 4/12/22.
//

import SwiftUI

struct ContentView: View {
    
    @GestureState private var offset: CGSize = .zero
    @State private var dragEnabled: Bool = false
    
    @State private var magnification: CGFloat = 1.0
    
    @State private var selection = 1
    var body: some View{
        //HexagonParameters()
        TabView(selection: $selection) {
            let longPressBeforeDrag = LongPressGesture(minimumDuration: 1.0)
                .onEnded( { _ in
                    self.dragEnabled = true
                })
                .sequenced(before: DragGesture())
                .updating($offset) { value, state, transaction in switch value {
                case .first(true):
                    print("Long press in progress")
                case .second(true, let drag):
                    state = drag?.translation ?? .zero
                default: break
                }
                }
                .onEnded { value in
                    self.dragEnabled = false
                }
            let magnificationGesture =
            MagnificationGesture(minimumScaleDelta: 0)
                .onChanged({ value in
                    self.magnification = value })
                .onEnded({ _ in
                    print("Gesture Ended") })
            
            BadgeBackground()
                .foregroundColor(dragEnabled ? Color.green : Color.blue)
                .font(.largeTitle)
                .offset(offset)
                .gesture(longPressBeforeDrag)
                .animation(.easeInOut)
            
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }.tag(1)
                
            MyShape()
                .frame(width: 100, height: 100)
                .scaleEffect(magnification)
                .gesture(magnificationGesture)
                
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }.tag(2)
                .animation(.interactiveSpring())
            MyShape2()
                .foregroundColor(dragEnabled ? Color.green : Color.blue)
                .font(.largeTitle)
                .offset(offset)
                .gesture(longPressBeforeDrag)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }.tag(3)
                .animation(.linear)
        }.font(.largeTitle)
    }
    
}

struct MyShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY), control: CGPoint(x: rect.midX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct MyShape2: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY), control: CGPoint(x: rect.midX, y: rect.midY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY), control: CGPoint(x: rect.midX, y: rect.midY))
        //path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY), control: CGPoint(x: rect.midX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
