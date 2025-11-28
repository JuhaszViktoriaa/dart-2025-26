void main(){
    //1.
    List<int> fizzBuzzList = [];

    for (int i = 1; i <= 100; i++) {
        if (i % 3 == 0 && i % 5 == 0) {fizzBuzzList.add('FizzBuzz');}

        else if (i % 3 == 0) {fizzBuzzList.add('Fizz');}

        else if (i % 5 == 0) {fizzBuzzList.add('Buzz');}
    
        else {
        fizzBuzzList.add(i.toInt());
        }
    }
    for (var szam in fizzBuzzList) {
        print(szam);
    }

    //2.
    List<int> oddEven = [];

    for (int i = 1; i <= 100; i++) {

        if (i % 2 == 0) {oddEven.toString('even');}

        else {oddEven.add(oddEven.toString('odd'));}
    }
    print(oddEven);

    //3.
    for (int i = 1; i <= 100; i++) {
      if (i % 3 == 0 && i % 5 == 0) {fizzBuzzList.add('FizzBuzz'); }
      else if (i % 3 == 0) {fizzBuzzList.add('Fizz'); }
      else if (i % 5 == 0) {fizzBuzzList.add('Buzz'); }
      else {fizzBuzzList.add(i.toString()); }
  }

  List<int> oddSet = [];

  for (int i = 1; i <= 100; i++) {
    if (i % 2 != 0) { 
      oddSet.add(i);
    }
  }
  print(oddSet);

    //4.

  Map<int, List<String>> fizzBuzzMap = {};

  for (int i = 1; i <= 100; i++) {
    List<String> values = [i.toString()]; 

    if (i % 3 == 0 && i % 5 == 0) {values.add('FizzBuzz');}
    
    else if (i % 3 == 0) { values.add('Fizz');}
    else if (i % 5 == 0) { values.add('Buzz');}

    if (i % 2 == 0) { values.add('even');}
    else { values.add('odd');}

    fizzBuzzMap[i] = values;
  }

  print('FizzBuzz Map:');
  fizzBuzzMap.forEach((key, value) {print('$key: $value');});
}