# matlab_project


Tento projekt MATLAB implementuje grafické používateľské rozhranie (GUI) na prácu s údajmi, štatistickú analýzu, matice a grafy. 
Projekt pozostáva z ponuky, ktorá umožňuje používateľovi vybrať jednu zo štyroch hlavných funkcií:

📋 Menu (SVP_Menu_f)
Okno hlavného menu, ktoré obsahuje tlačidlá:
- Statistics (Štatistika) - štatistická analýza vstupného súboru programu Excel.
- Matice - generuje náhodné matice a počíta charakteristiky.
- Grafy - vykresľovanie funkcií a priebehov.
- Zavrieť program - zatvorí aplikáciu.

📊 Štatistika (SVP_Statistika)
Tento modul:
- Vymaže hárky ZakladneInfo, VystupneData a Charakteristiky.
- Vypíše všeobecné informácie o tíme a programe.
- Číta súbor SVP-Statistika.xlsx z hárku VystneData.
- Filtruje sídla podľa počtu obyvateľov, nadmorskej výšky a vzdialenosti.
- Vypočíta priemerné teploty a zrážky pre mestá a obce.
- Zostaví tabuľku frekvencií, vypočíta:
  - aritmetický priemer,
  - modus,
  - medián,
  - rozptyl,
  - štandardnú odchýlku.
- Uloží všetko do súboru Excel na príslušné listy.

🧮 Matice (SVP_Matice)
Tento modul:
- Generuje náhodnú maticu A veľkosti m × n s hodnotami z náhodného rozsahu.
- Vypočíta maticu B = A * A'.
- Výsledky vypíše do súboru Matice.txt.
- Voliteľne:
  - vypočíta hodnosť, determinant a inverznú hodnotu matice B.
  - Výsledky zapíše do súboru MaticeVysledky.txt.

📈 Grafy (SVP_Grafy)
Tento modul:
- Prijíma koeficienty kvadratickej funkcie ax^2 + bx + c.
- Akceptuje parametre geometrickej progresie (a0, q, m1, m2).
- Vypočíta súčet prvých n členov progresie, súčet od am1 po am2 a nekonečný súčet.
- Vytvorí graf funkcie a stĺpcový graf prvých 10 členov progresie.
- Všetky výpočty vypíše do súboru VystupPostupnisti.txt.


📁 SVP_Menu.m

📂 DataInput
    SVP-Statistika.xlsx      main Excel file for working with statistics
    Matice.txt               generated matrices
    
📂 DataOutput
    MaticeVysledky.txt       results of matrix operations
    VystupPostupnisti.txt    calculations for graphs



👥 Authors:
Florence Team:
