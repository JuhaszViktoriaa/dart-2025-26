import 'dart:io';

void main(){
    //1. "Happy birthday!" \n "Happy birthday to you!"

  print("irja be hanyszor szeretne ismetelni: ");
  int ismetles = int.parse(stdin.readLineSync()!);
  String? szoveg="Happy birthday! \n Happy birthday to you!";
  
  int i=1;
  do {
    print(szoveg);
    i++;
  } while (i <= ismetles);
    

  //2. whileInnerLoop.dart
  print("irjon be egy szamot: ");
  int szam = int.parse(stdin.readLineSync()!);

  if(szam >=3 && szam <=9){
  for (int i = 0; i <= 10; i++) {
    for (int j = 0; j <= 10; j++) {
      print('kulso ciklus: $i, belso ciklus: $j');
      
      if (j == szam) {
        print('a belso ciklus elerte a megadott szamot');
        break;
      }
    }
    if (i == szam) {
      print('a kulso ciklus elerte a megadott szamot');
      break;
    }
  }
}
  else print("ervenytelen ertek!");

//3. whileFibonacci.dart 100ig

  int a = 0;
  int b = 1;
  print(a);

  while (b <= 100) {
    print(b);

    int next = a + b;
    a = b;
    b = next;
  }

//4. noFizzBuzzNumbers.dart Ha a szám nem osztható sem 3-mal, sem 5-tel, akkor írasd ki a számot. Ha a szám osztható 3-mal vagy 5-tel, akkor ne írjon ki semmit.
  int fizzszam =0;
  
  do {
    print(fizzszam);
  } while (fizzszam%3 >0 && fizzszam%5 >0);

  do {
    print(fizzszam);
  } while (fizzszam%3 == 0 || fizzszam%5 == 0);
}