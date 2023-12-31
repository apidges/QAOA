// Intro to Quantum Software Development
// Lab 1: Setting up the Development Environment
// Copyright 2023 The MITRE Corporation. All Rights Reserved.

namespace QAOA {

//     open Microsoft.Quantum.Canon;
//     open Microsoft.Quantum.Intrinsic;


//     @EntryPoint()
//     operation HelloQ() : Unit {
//         Message("Hello quantum world!");
//     }
// }

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Preparation;
    open Microsoft.Quantum.Diagnostics;

    // //Hello World equivalent
    // @EntryPoint()
    // operation messageTest () : Unit {
    //     use target = Qubit();
    //     H(target);
    //     //Message(IntAsString((M(target) == One ? 1 | 0)));
    //     DumpMachine();
    //     Reset(target);
    // }


    //QAOA circuit loop
    @EntryPoint()
    operation QAOA ( lengthRegister:Int, p:Int, beta:Double[], gamma:Double[]) : Int[]{

        //input qubits
        use register = Qubit[lengthRegister];

        //prepare qubits by creating uniform superposition
        ApplyToEach(H, register);

        //repeat cost and mixer steps p times
        //I think that we might need a new gamma and beta for each p
        for i in 1..p{
            costHamiltonianFlexible(register, gamma[p-1]);
            mixerHamiltonian(register, beta[p-1]);
        }

        //Read the results as a boolean array (true==1, false==0)
        mutable res = new Int[Length(register)];
        for i in 0..Length(register){
            set res w/= i <- (M(register[i]) == One ? 1 | 0);
        }

        //return the results
        return res;
     }

     operation costHamiltonianLength5 (register:Qubit[], gamma:Double):Unit{
        //Assuming lenght of register is 5
        //I aint commenting this sheet
        let (q0, q1, q2, q3, q4, q5)= (register[0], register[1], register[2], register[3], register[4], register[5]);
        CNOT(q1, q0);
        Rz(gamma, q0);
        CNOT(q1, q0);
        CNOT(q2, q0);
        CNOT(q2, q0);
        Rz(gamma, q0);
        CNOT(q2, q0);
        CNOT(q2, q1);
        CNOT(q3, q0);
        Rz(5.*gamma, q0);
        Rz(2.*gamma, q1);
        CNOT(q2, q1);
        CNOT(q3, q0);
        CNOT(q3, q1);
        CNOT(q4, q0);
        Rz(5.*gamma, q0);
        Rz(gamma, q1);
        CNOT(q3, q1);
        CNOT(q4, q0);
        CNOT(q3, q2);
        CNOT(q4, q1);
        Rz(3.*gamma, q1);
        Rz(5.*gamma, q2);
        CNOT(q3, q2);
        CNOT(q4, q1);
        CNOT(q4, q2);
        Rz(gamma, q2);
        CNOT(q4, q2);
        CNOT(q4, q3);
        Rz(5.*gamma, q3);
        CNOT(q4, q3);
     }

     //Flexible cost hamiltonian layer
     //Misssing weights
     operation costHamiltonianFlexible (register : Qubit[], gamma:Double):Unit{         
         ApplyToEach(Rx(gamma, _), register);
         for i in 0..Length(register){
             for j in i+1..Length(register){
                 Rzz(gamma, register[i], register[j]);
             }
         }
	 }

     operation mixerHamiltonian (register:Qubit[], beta:Double):Unit{
         //uhhh yeah you just like do this
         ApplyToEach(Rx(2.*beta, _), register);
     }

     //To be implemented
    operation cost (x:Int):Double{
        return 0.0;
    }
    
    operation meanCost(x:Int[]):Double{
        mutable res = 0.0;
        for i in 0..Length(x){
            set res += cost(x[i]);
        }
        return res/IntAsDouble(Length(x));
    }

    // operation classicalOptimizerBasic(meanCostRes:Double, gamma:Double, beta:Double, p:Int, length:Int, learnignRate: Double):(Double, Double){
    //     mutable g = gamma;
    //     mutable b = beta;
    //     mutable min = [gamma, beta];
    //     for i in -1..1{
    //         if i !=0{
    //             for j in -1..1{
    //                 if j!= 0{
    //                     set g = gamma + IntAsDouble(i)*learnignRate;
    //                     set b = beta + IntAsDouble(j)*learnignRate;
    //                     if meanCostRes < meanCost(QAOA(length, p, g, b)){
    //                         set min = [g, b];
    //                     } 
    //                 }
    //             }
    //         }
    //     }
    //     return (min[0], min[1]);
    // }
}