class KeyNumbers{
/*
  final int _cabalistic = 36;
  int _stage;         //E=cabalístico - D
  int _stage2;        //F=E+9
  int _stage3;        //G=F+9
  int _stage4;        //H=G+9
  int _eventYear;     //año de consulta o evento
  int _eventMonth;    //mes de consulta o evento
  int _personalYear;  //suma directa año evento+mes nac.+día nac. y luego reducido a 1
*/

  //todo definir cuál es el que se usará en los cálculos en module_home
  final int A;  //Karma
  final int B;  //Personal
  final int C;  //Vida pasada
  final int D;  //Personalidad
  final int E;
  final int F;
  final int G;
  final int H;
  final int I;
  final int J;
  final int K;
  final int L;
  final int M;
  final int N;
  final int O;
  final int P;
  final int Q;
  final int R;
  final int S;
  final List<int> T;
  final int U;
  final int V;
  final List<int> W;
  final int X;
  final int Y;
  final int Z;

  KeyNumbers({
    this.A, //mes
    this.B, //día
    this.C, //año
    this.D, //A+B+C
    this.E, //A+B
    this.F, //B+C
    this.G, //E+F
    this.H, //A+C
    this.I, //E+F+G
    this.J, //H+D
    this.K, //|A-B|
    this.L, //|B-C|
    this.M, //|K-L|
    this.N,
    this.O, //K+L+M
    this.P, //D+O
    this.Q, //K+M
    this.R, //L+M
    this.S, //Q+R
    this.T, //números de 1-9 que no aparecen, excepto X,Y,Z
    this.U,
    this.V,
    this.W, //números que aparecen 3 veces entre K y S
    this.X, //B+D
    this.Y, //A+B+C+D+X
    this.Z, //año a un dígito, comenzando por los últimos si no son 0
  });

  factory KeyNumbers.fromMap(Map<String, dynamic> json) => KeyNumbers(
    A: json["A"],
    B: json["B"],
    C: json["C"],
    D: json["D"],
    E: json["E"],
    F: json["F"],
    G: json["G"],
    H: json["H"],
    I: json["I"],
    J: json["J"],
    K: json["K"],
    L: json["L"],
    M: json["M"],
    N: json["N"],
    O: json["O"],
    P: json["P"],
    Q: json["Q"],
    R: json["R"],
    S: json["S"],
    T: json["T"],
    U: json["U"],
    V: json["V"],
    W: json["W"],
    X: json["X"],
    Y: json["Y"],
    Z: json["Z"],  );

  Map<String, dynamic> toMap() => {
    "A": A,
    "B": B,
    "C": C,
    "D": D,
    "E": E,
    "F": F,
    "G": G,
    "H": H,
    "I": I,
    "J": J,
    "K": K,
    "L": L,
    "M": M,
    "N": N,
    "O": O,
    "P": P,
    "Q": Q,
    "R": R,
    "S": S,
    "T": T,
    "U": U,
    "V": V,
    "W": W,
    "X": X,
    "Y": Y,
    "Z": Z,
  };

  int get mainNumber => B ?? 0;

  //todo para pruebas locales
  static KeyNumbers getKeyNumbers(DateTime dateOfBirth){
    int A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, U, V, X, Y, Z;
    List<int> T, W;

    A = KeyNumbers.getElementalNumber(dateOfBirth.month);
    B = KeyNumbers.getElementalNumber(dateOfBirth.day);
    C = KeyNumbers.getElementalNumber(dateOfBirth.year);
    D = KeyNumbers.getElementalNumber(A + B + C);
    E = KeyNumbers.getElementalNumber(A + B);
    F = KeyNumbers.getElementalNumber(B + C);
    G = KeyNumbers.getElementalNumber(E + F);
    H = KeyNumbers.getElementalNumber(A + C);
    I = KeyNumbers.getElementalNumber(E + F + G);
    J = KeyNumbers.getElementalNumber(H + D);
    K = KeyNumbers.getElementalSubtraction(A, B, false);
    L = KeyNumbers.getElementalSubtraction(B, C, false);
    M = KeyNumbers.getElementalSubtraction(K, L, false);
    N = 0;
    O = KeyNumbers.getElementalNumber(K.abs() + L.abs() + M.abs());
    P = KeyNumbers.getElementalNumber(D + O);
    Q = KeyNumbers.getElementalNumber(K.abs() + M.abs());
    R = KeyNumbers.getElementalNumber(L.abs() + M.abs());
    S = KeyNumbers.getElementalNumber(Q + R);
    U = 0;
    V = 0;
    T = KeyNumbers.getMissingNumbers([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, U, V]);
    W = KeyNumbers.getTriplets([K, L, M, N, O, P, Q, R, S]);
    X = KeyNumbers.getElementalNumber(B + D);
    Y = KeyNumbers.getElementalNumber(A + B + C + D + X);
    Z = KeyNumbers.getZ(dateOfBirth.year);

    return KeyNumbers(A: A, B: B, C: C, D: D, E: E, F: F, G: G, H: H, I: I, J: J, K: K, L: L, M: M,
      N: N, O: O, P: P, Q: Q, R: R, S: S, T: T, U: U, V: V, W: W, X: X, Y: Y, Z: Z, );
  }

  //narrow a number to one digit
  static int getElementalNumber(int number, [bool keepMasterNumbers = true]){
    if(number == null){
      return null;
    }

    int factor;
    if(number < 0){
      factor = -1;
    } else {
      factor = 1;
    }

    String strNumber = number.abs().toString();
    int sum = 0;
    for(int i=0; i < strNumber.length; i++) {
      sum += int.parse(strNumber[i]);
    }

    if(sum > 9){
      if(sum == 11 && !keepMasterNumbers){
        sum = 2;
      } else if(sum == 22 && !keepMasterNumbers){
        sum = 4;
      } else if(sum != 11 && sum != 22){
        sum = getElementalNumber(sum, keepMasterNumbers);
      }
    }

    return sum * factor;
  }

  //narrow a subtraction to one digit
  static int getElementalSubtraction(int number1,
      int number2,
      bool allowNegative,
      [bool keepMasterNumbers = true]){

    int substraction = getElementalNumber(number1 - number2, keepMasterNumbers);

    return substraction < 0 ? (allowNegative ? substraction : substraction * -1) : substraction;
  }

  //narrow a sum to one digit
  static int getElementalSum(int number1, int number2, [bool keepMasterNumbers = true]){
    return getElementalNumber(number1 + number2, keepMasterNumbers);
  }

  //get number Z: birth year to digit with sum of last non-zero digits
  static int getZ(int year){
    if(year == null){
      return null;
    }

    String strNumber = year.abs().toString();
    int num1, num2;
    int currentIndex = strNumber.length -1;

    while(num1 == null && currentIndex >= 0){
      if(int.parse(strNumber[currentIndex]) > 0){
        num1 = int.parse(strNumber[currentIndex]);
      }

      currentIndex -= 1;
    }

    while(num2 == null && currentIndex >= 0){
      if(int.parse(strNumber[currentIndex]) > 0){
        num2 = int.parse(strNumber[currentIndex]);
      }

      currentIndex -= 1;
    }

    if(num1 == null || num2 == null){
      return null;
    }

    return getElementalNumber(num1 + num2);
  }

  //list of missing number (1-9, 11 or 22) in a given set
  static List<int> getMissingNumbers(List<int> originSet){
    List<int> missingNumbers = [];

    for(int n = 1; n <= 9; n++){
      if(!originSet.contains(n)){
        missingNumbers.add(n);
      }
    }

    return missingNumbers;
  }

  //list of numbers that appear three times in a given set
  static List<int> getTriplets(List<int> originSet){
    Map<int, int> repetitions = {1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0, 8:0, 9:0};
    List<int> triplets = [];

    originSet.forEach((n) => (n != 0 && n != 11 && n != 22) ? repetitions.update(n, (value) => repetitions[n] + 1) : null);
    repetitions.forEach((k,v) => v == 3 ? triplets.add(k): null);

    return triplets;
  }
}