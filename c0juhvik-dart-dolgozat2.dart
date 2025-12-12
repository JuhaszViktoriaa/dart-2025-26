//import dart from 'dart:io';

void main(){

  //1. osszegzes
  num sum(List<num> arr) {

    num osszeg=0;

    for(num szam in arr){
      if(sum != []){
        osszeg = osszeg+szam;
      }
    }
    return osszeg;
  }

  //2. Odd Ones Out - Páratlanszor előfordulók kihagyása
  List<int> oddOnesOut(List<int> nums) {

    List<int> lista = [];

    for(int szamok in lista.length){

      if(lista.contains(szamok)){

        lista.remove(szamok);
        oddOnesOut() = lista(szamok);

      }
    }
    return oddOnesOut(nums);
  }

  //3. Flatten and sort an array - Lapít és sorbarendez

  List<int> flattenAndSort(List<List<int>> nums) {

    int db = 0;
    String betu ="";
    String lower = betu.toLowerCase();
    
    for(lower in flattenAndSort.length){
      if(lower.contains(betu)){
        db++;
      }
    }

    return flattenAndSort().sort(betu);
  }

  //4. Counting Duplicates - Többször előfordulók száma

  int duplicateCount(String text){

    String betuu ="";
    String lower = betu.toLowerCase();

    Map<duplicateCount> lista = { betuu };

    lista.removeWhere(lower.contains(betuu));
    return ;
  }
}