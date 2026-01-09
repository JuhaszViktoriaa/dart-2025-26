import 'dart:io';
import 'dart:math';

void main(){
    List<Map<String, Object>> kraterek = [];
    File file = File('j:/13c/mobil/dart masodik felev/felszin/felszin_tpont.txt');
    List<String> adatok = file.readAsLinesSync();

    for(var sor in adatok){
        List<String> adat = sor.trim().split('\t');
        kraterek.add({
            'x': double.tryParse(adat[0])!,
            'y': double.tryParse(adat[1])!,
            'r': double.tryParse(adat[2])!,
            'nev': adat[3],
        });
    }
    print(kraterek.toString());
    print('a kraterek szama: ${kraterek.length}');

    //3.
    print('kerem egy krater nevet: ');
    String nev = stdin.readLineSync()!;
    String keresett = 'nincs ilyen nevu krater';

    for(var krater in kraterek){
        if(nev == krater['nev']){
            keresett = 'a(z) ${krater['nev']} kozeppontja x=${krater['x']}, y=${krater['y']}, r=${krater['r']}.';
            break;
        }
    }
    print(keresett);

    //4.
    Map<String, Object> max = kraterek[0];
    for(var krater in kraterek){
      if((max['r'] as double) < (krater['r'] as double)){
        max = krater;
      }
    }
    print('a legnagyobb krater neve és sugara: \n a(z) ${max['nev']}, r=${max['r']}');

    //5.
    double tavolsag(double x1, double x2, double y1, double y2) => sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));

    //6.
    print('kerem egy krater nevet: ');
    nev = stdin.readLineSync()!;
    Map<String, Object> adottkrater = {};

    for(var krater in kraterek){
        if(nev == krater['nev']){
          adottkrater = krater;
          break;
        }
    }

  print('nincs kozos resz');

  List<String> nemkozos=[];

  double x1 = adottkrater['x'] as double;
  double y1 = adottkrater['y'] as double;

  for(var krater in kraterek){
    double x2 = krater['x'] as double;
    double y2 = krater['y'] as double;

    if(tavolsag(x1, x2, y1, y2) > (adottkrater['r'] as double) + (adottkrater['r'] as double)){
      nemkozos.add(krater['nev'] as String);
      }
  }
  print('${nemkozos.join(', ')}.');

  //7.

  for(int i=0; i <kraterek.length; i++){
    for(int j=0; j < kraterek.length; j++){
      var nagyobb;
      var kisebb;

      if((kraterek[i]['r'] as double) > (kraterek[j]['r'] as double)){
        nagyobb = kraterek[i];
        kisebb = kraterek[j];
      }
      else{
        nagyobb = kraterek[j];
        kisebb = kraterek[i]; 
      }

      double x1 = nagyobb['x1'] as double;
      double y1 = nagyobb['y1'] as double;
      double x2 = kisebb['x2'] as double;
      double y2 = kisebb['y2'] as double;
      double r1 = nagyobb['r'] as double;
      double r2 = kisebb['r'] as double;

      if(tavolsag(x1, x2, y1, y2) < r1 - r2){
        print('az ${nagyobb['nev']} krater tartalmazza a ${kisebb['nev']} kratert.');
      }
    }
  }

  //8.
  
}