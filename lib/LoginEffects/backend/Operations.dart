class Operations{

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

  static int getElementalSubtraction(int number1,
      int number2,
      bool allowNegative,
      [bool keepMasterNumbers = true]){

    int subtraction = getElementalNumber(number1 - number2, keepMasterNumbers);

    return subtraction < 0 ? (allowNegative ? subtraction : subtraction * -1) : subtraction;
  }

  static int getElementalSum(int number1, int number2, [bool keepMasterNumbers = true]){
    return getElementalNumber(number1 + number2, keepMasterNumbers);
  }

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

  static List<int> getMissingNumbers(List<int> originSet){
    List<int> missingNumbers = [];

    for(int n = 1; n <= 9; n++){
      if(!originSet.contains(n)){
        missingNumbers.add(n);
      }
    }

    return missingNumbers;
  }

  static List<int> getTriplets(List<int> originSet){
    Map<int, int> repetitions = {1:0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0, 8:0, 9:0};
    List<int> triplets = [];

    originSet.forEach((n) => (n != 0 && n != 11 && n != 22) ? repetitions.update(n, (value) => repetitions[n] + 1) : null);
    repetitions.forEach((k,v) => v == 3 ? triplets.add(k): null);

    return triplets;
  }

}