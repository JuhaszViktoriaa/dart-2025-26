import 'dart:io';

void main() {

//szambekeres, paros-e?

  stdout.write("irjon be egy szamot: ");
  int szam = int.parse(stdin.readLineSync()!);

  if (szam % 2 == 0) {
    print("a szam paros.");
  } else {
    print("a szam paratlan.");
  }

  //szam osztalyzata if-fel

  if(szam == 1){print("elegtelen.");}
  if(szam == 2){print("elegseges.");}
  if(szam == 3){print("kozepes.");}
  if(szam == 4){print("jo.");} 
  if(szam == 5){print("jeles.");}
  else{print("ertelmezhetetlen ertek!");}

  //szam osztalyzata switch-el

  var osztalyzat;
  switch (osztalyzat) {
    case 1: print("egyes.");
      break;
    case 2: print("kettes.");
      break;
    case 3: print("harmas.");
      break;
    case 4: print("negyes.");
      break;
    case 5: print("otos.");
      break;
  }

assert((osztalyzat >=1) && (osztalyzat >=5));

//2. Kérj be két számot és írsd ki a nagyobb számot, valamint, hogy mekkora az eltérés a két szám között!

}