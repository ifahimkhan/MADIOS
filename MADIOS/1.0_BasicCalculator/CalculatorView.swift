//
//  CalculatorView.swift
//  MADIOS
//
//  Created by apple on 8/16/25.
//


import SwiftUI

struct CalculatorView: View {
    @State private var input1: String = ""
    @State private var input2: String = ""
    @State private var operation: String = "+"
    @State private var result: String = ""
    
    let operations = ["+", "-", "*", "/"]
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Enter first number", text: $input1)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Enter second number", text: $input2)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Picker("Operation", selection: $operation) {
                ForEach(operations, id: \.self) { op in
                    Text(op)
                }
            }
            .pickerStyle(WheelPickerStyle())
            
            Button("Calculate") {
                calculateResult()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Text(result)
                .disabled(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
    }
    
    func calculateResult() {
        guard let num1 = Double(input1), let num2 = Double(input2) else {
            result = "Invalid input"
            return
        }
        switch operation {
        case "+":
            result = String(num1 + num2)
        case "-":
            result = String(num1 - num2)
        case "*":
            result = String(num1 * num2)
        case "/":
            result = num2 != 0 ? String(num1 / num2) : "Error: Division by zero"
        default:
            result = "Unknown operation"
        }
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
