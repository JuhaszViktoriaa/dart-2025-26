void main() {
  //1
  String nev = "vasvari";
  print("az iskola neve: $nev");
  
  //2
  String iranyitoszam = "1234";
  String utca = "gogol utca";
  String telepules = "szeged";
  String hazszam = "1";

print("az iskola ir.szama, utcaja, telepulese, hazszama: $iranyitoszam, $utca, $telepules, $hazszam");

  //3
  int atlfo = 28;
  
  int kilencedikosztalyokszama = 4;
  int kilencedikesekglobalisan = kilencedikosztalyokszama * atlfo;
  
  int masosztalyok = 3;
  int tizedikesek = masosztalyok * atlfo;
  int tizenegyedikesek = masosztalyok * atlfo;
  int tizenkettedikesek = masosztalyok * atlfo;
  int osszesen = kilencedikesekglobalisan + tizedikesek + tizenegyedikesek + tizenkettedikesek;
  
  print("9. évfolyam diákjai: $kilencedikesekglobalisan fő");
  print("10. évfolyam diákjai: $tizedikesek fő");
  print("11. évfolyam diákjai: $tizenegyedikesek fő");
  print("12. évfolyam diákjai: $tizenkettedikesek fő");
  print("az összes diáklétszám: $osszesen fő.");
}
