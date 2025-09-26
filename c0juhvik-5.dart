import 'dart:io';

void main() {
  print("irjon be egy szamot: ");
  int szam1 = int.parse(stdin.readLineSync()!);

  print("irjon be egy szamot: ");
  int szam2 = int.parse(stdin.readLineSync()!);

  if (szam1 > szam2) {
    print("a szamok novekvo sorrendben: ${szam2}, ${szam1}");
  }
  if (szam2 > szam1) {
    print("a szamok novekvo sorrendben: ${szam1}, ${szam2}");
  }

  if (szam1 == szam2) {
    print("a ket szam egyenlo.");
  } else {
    print("a szamok erteke ertelmezhetetlen!");
  }

  //

  List<String> uefa2024euro = [
    "spain",
    "germany",
    "portugal",
    "france",
    "netherlands",
    "turkey",
    "england",
    "switzerland"
  ];

  for (int i = 0; i < uefa2024euro.length; i++) {
    for (int j = i + 1; j < uefa2024euro.length; j++) {
      print("${uefa2024euro[i]} - ${uefa2024euro[j]}");
    }
  }

//
  print("irjon be egy szamot: ");
  int szam = int.parse(stdin.readLineSync()!);
  int osszeg = 0;
  String strszam = '$szam';
  for (int i = 0; i < strszam.length; i++) {
    osszeg += int.parse(strszam[i]);
  }
  double atl = osszeg / strszam.length;
  print('a megadott szam szamjegyeinek atlaga: ${atl.toStringAsFixed(2)}');

  for (int i = 0; i < strszam.length; i++) {
    int szamjegy = int.parse(strszam[i]);
    print('${szamjegy * szamjegy}');
  }

// 1.
void removeVowels() {
  print("adjon meg egy szoveget:");
  String input = stdin.readLineSync()!;
  String result = input.replaceAll(RegExp(r'[aeiouáéíóöőúüűAEIOUÁÉÍÓÖŐÚÜŰ]'), '');
  print("Magánhangzók nélküli szöveg: $result");
}

// 2.
void printCharAndAscii() {
  print("adjon meg egy szoveget:");
  String input = stdin.readLineSync()!;
  for (var char in input.split('')) {
    print("($char, ${char.codeUnitAt(0)})");
  }
}

// 3. 
  void fizzBuzz() {
    print("adjon meg egy szamot:");
    int num = int.parse(stdin.readLineSync()!);

    for (int i = 1; i <= num; i++) {
      if (i % 3 == 0 && i % 5 == 0) {
        print("FizzBuzz");
      } else if (i % 3 == 0) {
        print("Fizz");
      } else if (i % 5 == 0) {
        print("Buzz");
      } else {
        print(i);
      }
    }
  }

// 9.
  void nestedLoopBreakInner() {
    for (int i = 1; i <= 6; i++) {
      for (int j = 1; j <= 6; j++) {
        if (i * j == 9) {
          print("belso ciklus kilepes, i: $i, j: $j");
          break;
        }
      }
    }
  }

//10
  void nestedLoopBreakOuter() {
    outerLoop:
    for (int i = 1; i <= 6; i++) {
      for (int j = 1; j <= 6; j++) {
        if (i * j == 9) {
          print("kulso ciklus kilepes, i: $i, j: $j");
          break outerLoop;
        }
      }
    }
  }

//11

    removeVowels();
    print("");
    printCharAndAscii();
    print(""); 
    fizzBuzz();
    print(""); 
    nestedLoopBreakInner();
    print("");
    nestedLoopBreakOuter();
}