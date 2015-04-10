;=============================================================================;
;                                                                             ;
; Plik           : zadanie2.asm                                               ;
; Format         : COM                                                        ;
; Cwiczenie      : Kod U2                                                     ;
; Autorzy        : Joanna Dyczka, Michał Sobczak, gr 2, pon., 10:30           ;
; Data zaliczenia: DD.MM.ROK                                                  ;
; Uwagi          : Wczytuje dwie liczby całkowite z przedziału [-32768..32767];
; i dodaje je do siebie, a otrzymany wynik wyświetla na ekranie.              ;
;                                                                             ;
;=============================================================================;

                .MODEL	TINY

Kod             SEGMENT

                ORG		100h
                ASSUME	CS:Kod, DS:Kod, SS:Kod
Start:
                jmp     Pierwsza

        tablica      db     5 dup (?)
        dl_tab       =      5
        minus        db     0
        ile          db     ?
        liczba1      dw     0
        liczba2      dw     0
        napis1       db     "Wprowadz pierwsza liczbe: $"
        napis2       db     13,10,"Wprowadz druga liczbe: $"
        wyswietl     db     13,10,"Suma:         $"
        dziesiec     =      000Ah


;WCZYTANIE PIERWSZEJ LICZBY
Pierwsza:
                mov     ah, 09h                         ;wyswietlenie napisu
                mov     dx, OFFSET napis1
                int     21h

                mov     bx, OFFSET tablica              ;bx - adres aktualnej komorki tablicy
                xor     cx, cx                          ;cx - ile cyfr w liczbie
                mov     dx, OFFSET tablica + dl_tab     ;dx - jeden adres po ostatniej komorce tablicy

                mov     ah, 01h                         ;odczytanie pierwszego wprowadzonego znaku
                int     21h
                cmp     al, 45                          ;sprawdzenie czy nie wprowadzono -
                jne     Dodatnia
                inc     minus                           ;jesli wprowadzono -, to zmiana flagi minus=1
                jmp     Liczba                          ;i omijamy rozkazy dla dodatniej
Dodatnia:
                mov     [bx], al                        ;jesli nie wprowadzono -, wpisujemy wprowadzona
                inc     cx                              ;wartosc do tablicy
                inc     bx
Liczba:
                mov     ah, 01h                         ;odczytanie kolejnego znaku
                int     21h
                cmp     al, 13                          ;sprawdzany czy to nie Enter
                je      Dalej                           ;jesli tak, to konczmy wprowadzanie 1. liczby
                mov     [bx], al                        ;jesli nie, to wpisujemy wprowadzony znak do tablicy
                inc     cx
                inc     bx
                cmp     bx, dx                          ;sprawdzamy, czy nadal miescimy sie w tablicy
                jb      Liczba
Dalej:
                mov     ile, cl                         ;ile - ilu cyfrowa jest liczba
                xor     bx, bx                          ;bx - adres aktualnej komorki tablicy
Mnozenie0:                                              ;ZAMIANA ZNAKOW ASCII NA LICZBE PIERWSZA
                xor     cx, cx
                add     cl, ile
                sub     cl, 1
                xor     ax, ax
                mov     al, tablica[bx]                 ;zamiana kodu cyfry na cyfre
                sub     al, 48
                cmp     bx, cx                          ;sprawdzamy czy trzeba mnozyc
                je      Gotowa
                mov     si, 10
Mnozenie:
                mul     si                              ;mnożymy ax razy 10
                dec     cl
                cmp     cl, bl
                ja      Mnozenie
                add     liczba1, ax                     ;dodanie wyniku mnozenia do liczby
                inc     bx
                jmp     Mnozenie0
Gotowa:
                add     liczba1, ax

                cmp     minus, 1
                jne     Druga
                neg     liczba1





;WCZYTANIE DRUGIEJ LICZBY
Druga:
                mov     minus, 0
                mov     ah, 09h                         ;wyswietlenie napisu
                mov     dx, OFFSET napis2
                int     21h

                mov     bx, OFFSET tablica              ;bx - adres aktualnej komorki tablicy
                xor     cx, cx                          ;cx - ile cyfr w liczbie
                mov     dx, OFFSET tablica + dl_tab     ;dx - jeden adres po ostatniej komorce tablicy

                mov     ah, 01h                         ;odczytanie pierwszego wprowadzonego znaku
                int     21h
                cmp     al, 45                          ;sprawdzenie czy nie wprowadzono -
                jne     Dodatnia2
                inc     minus                           ;jesli wprowadzono -, to zmiana flagi minus=1
                jmp     Liczba_2                         ;i omijamy rozkazy dla dodatniej
Dodatnia2:
                mov     [bx], al                        ;jesli nie wprowadzono -, wpisujemy wprowadzonej
                inc     cx                              ;wartosci do tablicy
                inc     bx
Liczba_2:
                mov     ah, 01h                         ;odczytanie kolejnego znaku
                int     21h
                cmp     al, 13                          ;sprawdzany czy to nie Enter
                je      Dalej_2                         ;jesli tak, to konczmy wprowadzanie 1. liczby
                mov     [bx], al                        ;jesli nie, to wpisujemy wprowadzony znak do tablicy
                inc     cx
                inc     bx
                cmp     bx, dx                          ;sprawdzamy, czy nadal miescimy sie w tablicy
                jb      Liczba_2
Dalej_2:
                mov     ile, cl                         ;ile - ilu cyfrowa jest liczba
                xor     bx, bx                          ;bx - adres aktualnej komorki tablicy
Mnozenie1:                                              ;ZAMIANA ZNAKOW ASCII NA LICZBE PIERWSZA
                xor     cx, cx
                add     cl, ile
                sub     cl, 1
                xor     ax, ax
                mov     al, tablica[bx]                 ;zamiana kodu cyfry na cyfre
                sub     al, 48
                cmp     bx, cx                          ;sprawdzamy czy trzeba mnozyc
                je      Gotowa_2
                mov     si, 10
Mnozenie2:
                mul     si                              ;mnożymy ax razy 10
                dec     cl
                cmp     cl, bl
                ja      Mnozenie2
                add     liczba2, ax                     ;dodanie wyniku mnozenia do liczby
                inc     bx
                jmp     Mnozenie1
Gotowa_2:
                add     liczba2, ax

                cmp     minus, 1
                jne     Dodawanie
                neg     liczba2




;DODAWANIE LICZB
Dodawanie:
                mov     ax, liczba1
                add     ax, liczba2




;WYSWIETLANIE WYNIKU
                jns     Dodatni
                neg     ax
                mov     wyswietl[10], 45
Dodatni:
                mov     bx, 15
                mov     cx, dziesiec
Dzielenie:
                xor     dx, dx
                div     cx
                add     dl, 48
                mov     wyswietl[bx], dl
                dec     bx
                cmp     ax, 0
                jne     Dzielenie

                mov     ah, 09h
                mov     dx, OFFSET wyswietl
                int     21h



                mov     ax, 4C00h
                int     21h

Kod				ENDS

                END		Start

