//import 'dart:io';
void main() {
  //print("a barack forditottja: ${reverseString("barack")}");
  //print("a 24351 forditottja: ${reverseinteger(24351)}");
  //print("a 3.14159268385 forditottja: ${reversenumber(3.14159268385)}");
  //print("a 324153 szamk novekvo sorrendben: ${sortNumberAsc(324153)}");
  //print("a 324153 szamk csokkeno sorrendben: ${sortNumberDesc(324153)}");
  //print("a 6 megfeleloje: ${fizzbuzz(6)}"); print("a 10 megfeleloje: ${fizzbuzz(10)}"); print("a 15 megfeleloje: ${fizzbuzz(15)}"); print("a 17 megfeleloje: ${fizzbuzz(17)}");
  //print("a 2, 3, 4 oldalak haromszoget alkothatnak-e? ${istrianglebysides(2, 3, 4)}");
  //print("a 2, 3, 6 oldalak haromszoget alkothatnak-e? ${istrianglebysides(2, 3, 6)}");
}

String reverseString(txt) {
  List<String> lista = txt.split('');
  lista = lista.reversed.toList();
  return lista.join();
}

int reverseinteger(int number) {
  String szam = reverseString("$number");
  return int.parse(szam);
}

int reversenumber(num number) {
  String str = "$number".replaceAll(".", "");
  str = reverseString(str);
  return int.parse(str);
}

int sortNumberAsc(int number) {
  List<String> strlista = "$number".split('');
  List<int> intlista = strlista.map((e) => int.parse(e)).toList();
  intlista.sort((a, b) => a - b);
  print(intlista);
  return int.parse(intlista.map((e) => "$e").join());
}

int sortNumberDesc(num number) {
  List<String> strlista = "$number".split('');
  List<int> intlista = strlista.map((e) => int.parse(e)).toList();
  intlista.sort((a, b) => b - a);
  print(intlista);
  return int.parse(intlista.map((e) => "$e").join());
}

dynamic fizzbuzz(int number) {
  if (number % 3 == 0 && number % 5 == 0) {
    return "fizzbuzz";
  }
  if (number % 3 == 0) {
    return "fizz";
  }
  if (number % 5 == 0) {
    return "buzz";
  }
  return number;
}

bool istrianglebysides(int a, int b, int c) {
  //if(a+b > c && a+c > b && b+c > a){return true;}
  //return false;

  return (a + b > c && a + c > b && b + c > a);
}
