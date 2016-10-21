# assembly-projects

My old university projects in assembly. 

I wrote them during my studies at Military University of Technology, Warsaw, Poland.

Projects were written to two processor architectures: x86 (32bit) and x51 (8bit).

x51 (or 8051) is basically microcontroller. Currently it is used in SIM cards and sometimes in industry.

x86 (or 8086) processor is fairly common, i wrote for it in DOS standard and in PE standard (which is more interesting). 

In PE standard the programmer is allowed to use FPU, SSE and vector extensions, so it is easier to write precise and fast code. 
It runs on 32bit processors - I had plans to write some 64bit assembly, but I did not realize it.

In DOS standard, the programmer is stuck with BIOS interrupts and other anachronisms, so it is not nice.



Some of them I wrote for myself but vast majority of them I wrote to teach others.

Repository tree:

```
.
├── README.md
├── x51
│   ├── 1s50ms
│   │   ├── 1s50ms.asm
│   │   └── 1s50ms.hex
│   ├── 1z8_na_bcd.asm
│   ├── (a-b)c
│   │   └── (a-b)c.asm
│   ├── chlodziarka
│   │   └── chlodziarka.asm
│   ├── chlodziarka.asm
│   ├── LCD 60znkow
│   │   └── wysylkadlugichkomunikatow.asm
│   ├── miernik.asm
│   ├── miernik_napiecia.asm
│   ├── miernik_napiecia_poprawiony.asm
│   ├── miernik_napiecia_ze_znakiem_LCD
│   │   ├── abcdefgh.png
│   │   ├── ascii_digit.png
│   │   ├── ascii.png
│   │   ├── przebieg_bez_przesuniecia.png
│   │   ├── przebieg.png
│   │   ├── przebieg - opis.png
│   │   ├── przebieg - opis_rzutowanie.png
│   │   ├── przeksztalcenie.ods
│   │   ├── symulacja_uklad_w_LTspice-IV.asc
│   │   ├── symulacja_uklad_w_LTspice-IV.op.raw
│   │   ├── symulacja_uklad_w_LTspice-IV.raw
│   │   ├── uklad.png
│   │   └── woltomierz_ze_znakiem.asm
│   ├── napiecie na oscyloskopie
│   │   ├── keypad.png
│   │   └── nastawa napiecia na oscyloskop.asm
│   ├── nastawa napiecia2.asm
│   ├── nastawa napiecia edsim.asm
│   ├── Odczyt z danych z klawiatury na wyświetlaczu
│   │   ├── Odczyt z danych z klawiatury na wyświetlaczu.asm
│   │   └── Odczyt z danych z klawiatury na wyświetlaczuv.2.asm
│   ├── petla nieskonczona
│   │   ├── liczenie_czasu.ods
│   │   └── petla_nieskonczona.asm
│   ├── pierwiastek_3
│   │   └── pierw.asm
│   ├── porownanie_edsim2.asm
│   ├── porownanie_edsim.asm
│   ├── pralka
│   │   └── pralka.asm
│   ├── przebieg sinusoidalny
│   │   ├── liczenie sinusa.ods
│   │   ├── przebieg_w_przyblizeniu_sinusidalny_tmr.asm
│   │   ├── Zrzut ekranu 2014-02-02 16.43.53.png
│   │   └── Zrzut ekranu 2014-02-02 16.46.35.png
│   ├── przykladowy kod do LCD.asm
│   ├── serce
│   │   └── serce.asm
│   ├── silniczek
│   │   ├── motor.png
│   │   ├── Opis.txt
│   │   └── Sterownik silnika.asm
│   ├── swiatla_uliczne
│   │   └── swiatla.asm
│   ├── szeregowaa0.asm
│   ├── szeregowa.asm
│   ├── terma
│   │   └── terma.asm
│   ├── transmisja szeregowa
│   │   ├── trszerklaw.asm
│   │   └── tr_szer-pomocnicza.asm
│   ├── trojkat
│   │   └── trojkat_stary.asm
│   ├── trojkat2
│   │   └── gen_syg_troj.asm
│   ├── trojkat3
│   │   └── gen_syg_troj.asm
│   ├── tr_szer
│   │   └── tr_szer.asm
│   ├── wersja_dopakowana_diody.asm
│   ├── wersja_dopakowana_miernik_diody.asm
│   ├── wezyk.asm
│   ├── winda
│   │   ├── obrazki
│   │   │   ├── schemat edsima.png
│   │   │   ├── step1.png
│   │   │   ├── step2.png
│   │   │   ├── step3.png
│   │   │   └── ustawienia edsima.png
│   │   ├── winda.asm
│   │   └── winda.ods
│   ├── wysylka liter na lcd
│   │   └── Wysyłka szeregowa  3-ch kolejnych komunikatów min 20 znaków na moduł LCD.asm
│   ├── wysylka trzech kom na lcd
│   │   ├── 3komnaLCD.asm
│   │   ├── wysylka trzech kom na lcd.asm
│   │   └── Wysyłka szeregowa  3-ch kolejnych komunikatów min 20 znaków na moduł LCD.asm
│   ├── xy+-xy
│   │   └── xyxy.asm
│   └── zcwiczen.asm
└── x86
    ├── dos
    │   ├── arytm
    │   │   ├── arytm_.asm
    │   │   ├── arytm_.com
    │   │   └── screen.png
    │   ├── dl_odc
    │   │   ├── dl_odc2.asm
    │   │   ├── dl_odc2.com
    │   │   ├── dl_odc.com
    │   │   ├── screen1.png
    │   │   └── screen2.png
    │   ├── fibo
    │   │   ├── fbnacci.asm
    │   │   ├── fbnacci.com
    │   │   └── screen.png
    │   ├── p_3_9
    │   │   ├── podz39.asm
    │   │   ├── podz39.com
    │   │   └── screen.png
    │   ├── pole
    │   │   ├── pole2.asm
    │   │   ├── pole2.com
    │   │   └── screen.png
    │   ├── silnia
    │   │   └── silnia.asm
    │   ├── stozek
    │   │   ├── screen.png
    │   │   ├── stozek.asm
    │   │   └── stozek.com
    │   ├── szereg arytmetyczny
    │   │   └── arytm_.asm
    │   ├── tetranacci
    │   │   └── tetra.com
    │   ├── wycinek
    │   │   ├── screen.png
    │   │   ├── wycinek.asm
    │   │   └── wycinek.com
    │   ├── wycinek2
    │   │   ├── screen.png
    │   │   ├── wycinek2.asm
    │   │   └── wycinek2.com
    │   ├── wycinek kola
    │   │   └── wycinek.asm
    │   └── wysw alfanumeryczny
    │       ├── screen1.png
    │       ├── screen2.png
    │       ├── symul_wysw_alfanumer_poprawione_michal_bokiniec.pdf
    │       ├── wyswalfa.ASM
    │       └── wyswalfa.COM
    └── pe
        ├── kol_elip
        │   ├── kol_elip.asm
        │   ├── kol_elip.exe
        │   └── screen.png
        ├── kwadrat_w_kole
        │   ├── 0120_01.gif
        │   ├── pole_kw_w_kole.asm
        │   ├── pole_kw_w_kole.exe
        │   └── screen.png
        ├── macierze
        │   ├── ma_b_wc2.asm
        │   ├── ma_b_wc2.exe
        │   ├── ma_b_wcz.asm
        │   ├── ma_b_wcz.exe
        │   ├── screen1.png
        │   └── screen2.png
        ├── matr
        │   ├── ilo_maci.asm
        │   └── opis.txt
        ├── pi
        │   ├── pi_.asm
        │   ├── pi_.exe
        │   └── screen.png
        ├── precyzja
        │   ├── por_l_pr.asm
        │   ├── por_l_pr.exe
        │   └── screen.png
        ├── prime_
        │   ├── prime.asm
        │   ├── prime.exe
        │   └── screen.png
        ├── rzut
        │   └── rzut.asm
        ├── rzut_ukosny
        │   ├── rzut.asm
        │   ├── rzut.exe
        │   └── screen.png
        ├── silnia
        │   └── silnia_2.asm
        ├── silnia_
        │   └── silnia_2.asm
        ├── stozek2
        │   ├── objetosc_stozka_scietego.asm
        │   ├── objetosc_stozka_scietego.exe
        │   ├── screen.png
        │   └── Trunctated_cone-schematic.png
        ├── sum_hex
        │   ├── screen1.png
        │   ├── screen2.png
        │   ├── sum_hex.asm
        │   └── sum_hex.exe
        ├── szablon_pe_console.asm
        ├── szablon_pe_console.exe
        ├── wycinek3
        │   ├── screen.png
        │   ├── wycinek.asm
        │   └── wycinek.exe
        ├── wym_il
        │   └── wym_il.asm
        └── x_2_y_2
            ├── screen1.png
            ├── screen2.png
            ├── suma_3_kw.asm
            └── xy_kw.exe
```
