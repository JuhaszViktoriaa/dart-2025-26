import 'dart:io';

void main() {
  print("falvedo: ");
  String? falvedo = "Mindenki. Igaza. Sajatja. SZUBJEKTIV. IGAZSAG. Objektiv. Nincs is az.";

  String lowercase =falvedo.toLowerCase();
  String uppercase =falvedo.toUpperCase();
  String trimmelve =falvedo.trim();

  print("eredetiben:  ${falvedo}");
  print("lowercase:  ${lowercase}");
  print("uppercase:  ${uppercase}");
  print("trimmelve:  ${trimmelve}");

//vagy:

  print("trimmelve:  ${falvedo.toLowerCase()}");
  print("trimmelve:  ${falvedo.toUpperCase()}");
  print("trimmelve:  ${falvedo.trim()}");

//SZOKOZOKET KOTOJELLEL HELYETTESITVE:
//AZ ELSO 3 KARAKTER UTF-16 KODJA:
//A TIZEDIK KARAKTERTOL A VEGEIG, AHOL " ..." VAN

  String text = "volt egy leany - neve: Lebbencs, meg egy fiu - neve: Hebrencs, szerelmuk lett - neve: Heblencs";

  // 1.
  String kotojellel = text.replaceAll(' ', '-');
  print("1. szokoz helyett kotojelek: $kotojellel");

  // 2.
  String otostol = "... " + text.substring(4);
  print("2. az 5. karaktertol '... ': $otostol");

  // 3.
  List<int> tizenhatos = text.substring(0, 3).codeUnits;
  print("3. a harom elso utf-16 kodja: $tizenhatos");

  // 4.
  String tizestol = text.substring(9) + " ...";
  print("4. a tizedik karaktertol a vegeig ' ...': $tizestol");

}